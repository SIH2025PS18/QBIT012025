-- JWT ROLE-BASED ACCESS CONTROL MIGRATION SCRIPT
-- This script adds role-based authentication support to the existing Supabase schema
-- Run this in your Supabase SQL editor after the comprehensive_supabase_setup.sql

-- =============================================
-- 1. ADD USER ROLE SUPPORT TO AUTH SCHEMA
-- =============================================

-- Create user_roles table to manage role assignments
CREATE TABLE IF NOT EXISTS public.user_roles (
    id TEXT PRIMARY KEY DEFAULT ('role_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('patient', 'doctor', 'admin', 'pharmacy')),
    is_verified BOOLEAN DEFAULT false,
    verification_status TEXT DEFAULT 'pending' CHECK (verification_status IN ('pending', 'approved', 'rejected', 'under_review')),
    verification_documents JSONB DEFAULT '[]',
    assigned_by UUID REFERENCES auth.users(id),
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    verified_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, role) -- User can have only one instance of each role
);

-- Create user_permissions table for granular permission management
CREATE TABLE IF NOT EXISTS public.user_permissions (
    id TEXT PRIMARY KEY DEFAULT ('perm_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    permission TEXT NOT NULL,
    granted_by UUID REFERENCES auth.users(id),
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, permission)
);

-- Create JWT tokens table for token management and blacklisting
CREATE TABLE IF NOT EXISTS public.jwt_tokens (
    id TEXT PRIMARY KEY DEFAULT ('jwt_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    token_type TEXT NOT NULL CHECK (token_type IN ('access_token', 'refresh_token')),
    token_hash TEXT NOT NULL, -- Store hash of the token for security
    is_blacklisted BOOLEAN DEFAULT false,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    blacklisted_at TIMESTAMP WITH TIME ZONE,
    blacklisted_reason TEXT
);

-- =============================================
-- 2. ADD ROLE COLUMNS TO EXISTING TABLES
-- =============================================

-- Add role and verification fields to profiles table
DO $$
BEGIN
    -- Add primary role field to profiles table
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'user_role') THEN
        ALTER TABLE public.profiles ADD COLUMN user_role TEXT DEFAULT 'patient' CHECK (user_role IN ('patient', 'doctor', 'admin', 'pharmacy'));
    END IF;
    
    -- Add role verification status
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'role_verified') THEN
        ALTER TABLE public.profiles ADD COLUMN role_verified BOOLEAN DEFAULT false;
    END IF;
    
    -- Add account verification status
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'account_verified') THEN
        ALTER TABLE public.profiles ADD COLUMN account_verified BOOLEAN DEFAULT false;
    END IF;
    
    -- Add verification documents
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'verification_documents') THEN
        ALTER TABLE public.profiles ADD COLUMN verification_documents JSONB DEFAULT '[]';
    END IF;
    
    -- Add last login tracking
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'last_login_at') THEN
        ALTER TABLE public.profiles ADD COLUMN last_login_at TIMESTAMP WITH TIME ZONE;
    END IF;
    
    -- Add session management
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'current_session_id') THEN
        ALTER TABLE public.profiles ADD COLUMN current_session_id TEXT;
    END IF;
END $$;

-- Add role-specific fields to doctors table
DO $$
BEGIN
    -- Add verification status for doctors
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'doctors' AND column_name = 'verification_status') THEN
        ALTER TABLE public.doctors ADD COLUMN verification_status TEXT DEFAULT 'pending' CHECK (verification_status IN ('pending', 'approved', 'rejected', 'under_review'));
    END IF;
    
    -- Add medical license verification
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'doctors' AND column_name = 'license_verified') THEN
        ALTER TABLE public.doctors ADD COLUMN license_verified BOOLEAN DEFAULT false;
    END IF;
    
    -- Add verification documents for doctors
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'doctors' AND column_name = 'verification_documents') THEN
        ALTER TABLE public.doctors ADD COLUMN verification_documents JSONB DEFAULT '{}';
    END IF;
    
    -- Add doctor permissions
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'doctors' AND column_name = 'permissions') THEN
        ALTER TABLE public.doctors ADD COLUMN permissions TEXT[] DEFAULT '{"view_patient_profiles", "view_all_appointments", "create_prescriptions", "update_appointment_status", "access_video_consultation", "view_patient_health_records"}';
    END IF;
END $$;

-- =============================================
-- 3. CREATE ROLE-SPECIFIC TABLES
-- =============================================

-- Create pharmacy_profiles table for pharmacy-specific data
CREATE TABLE IF NOT EXISTS public.pharmacy_profiles (
    id TEXT PRIMARY KEY DEFAULT ('pharmacy_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    pharmacy_name TEXT NOT NULL,
    license_number TEXT UNIQUE NOT NULL,
    drug_license_number TEXT,
    gst_number TEXT,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    pincode TEXT NOT NULL,
    phone_number TEXT,
    email TEXT,
    operating_hours JSONB DEFAULT '{"monday": {"start": "09:00", "end": "21:00"}, "tuesday": {"start": "09:00", "end": "21:00"}, "wednesday": {"start": "09:00", "end": "21:00"}, "thursday": {"start": "09:00", "end": "21:00"}, "friday": {"start": "09:00", "end": "21:00"}, "saturday": {"start": "09:00", "end": "21:00"}, "sunday": {"start": "10:00", "end": "20:00"}}',
    delivery_available BOOLEAN DEFAULT false,
    delivery_radius_km INTEGER DEFAULT 5,
    verification_status TEXT DEFAULT 'pending' CHECK (verification_status IN ('pending', 'approved', 'rejected', 'under_review')),
    license_verified BOOLEAN DEFAULT false,
    verification_documents JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Create admin_profiles table for admin-specific data
CREATE TABLE IF NOT EXISTS public.admin_profiles (
    id TEXT PRIMARY KEY DEFAULT ('admin_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    admin_level TEXT DEFAULT 'standard' CHECK (admin_level IN ('standard', 'super', 'system')),
    department TEXT,
    employee_id TEXT UNIQUE,
    permissions TEXT[] DEFAULT '{"manage_users", "manage_system_settings", "view_system_analytics", "manage_doctors", "manage_pharmacies", "view_all_data"}',
    access_restrictions JSONB DEFAULT '{}',
    last_activity TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- =============================================
-- 4. CREATE INDEXES FOR PERFORMANCE
-- =============================================

-- Indexes for user_roles table
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON public.user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON public.user_roles(role);
CREATE INDEX IF NOT EXISTS idx_user_roles_verified ON public.user_roles(is_verified);
CREATE INDEX IF NOT EXISTS idx_user_roles_status ON public.user_roles(verification_status);

-- Indexes for user_permissions table
CREATE INDEX IF NOT EXISTS idx_user_permissions_user_id ON public.user_permissions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_permissions_permission ON public.user_permissions(permission);
CREATE INDEX IF NOT EXISTS idx_user_permissions_active ON public.user_permissions(is_active);
CREATE INDEX IF NOT EXISTS idx_user_permissions_expires ON public.user_permissions(expires_at);

-- Indexes for JWT tokens table
CREATE INDEX IF NOT EXISTS idx_jwt_tokens_user_id ON public.jwt_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_jwt_tokens_type ON public.jwt_tokens(token_type);
CREATE INDEX IF NOT EXISTS idx_jwt_tokens_blacklisted ON public.jwt_tokens(is_blacklisted);
CREATE INDEX IF NOT EXISTS idx_jwt_tokens_expires ON public.jwt_tokens(expires_at);

-- Indexes for profiles table role fields
CREATE INDEX IF NOT EXISTS idx_profiles_user_role ON public.profiles(user_role);
CREATE INDEX IF NOT EXISTS idx_profiles_role_verified ON public.profiles(role_verified);
CREATE INDEX IF NOT EXISTS idx_profiles_account_verified ON public.profiles(account_verified);

-- Indexes for pharmacy_profiles table
CREATE INDEX IF NOT EXISTS idx_pharmacy_profiles_user_id ON public.pharmacy_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_pharmacy_profiles_license ON public.pharmacy_profiles(license_number);
CREATE INDEX IF NOT EXISTS idx_pharmacy_profiles_city ON public.pharmacy_profiles(city);
CREATE INDEX IF NOT EXISTS idx_pharmacy_profiles_verification ON public.pharmacy_profiles(verification_status);

-- Indexes for admin_profiles table
CREATE INDEX IF NOT EXISTS idx_admin_profiles_user_id ON public.admin_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_admin_profiles_level ON public.admin_profiles(admin_level);
CREATE INDEX IF NOT EXISTS idx_admin_profiles_employee_id ON public.admin_profiles(employee_id);

-- =============================================
-- 5. ENABLE ROW LEVEL SECURITY
-- =============================================

-- Enable RLS on new tables
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jwt_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pharmacy_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_profiles ENABLE ROW LEVEL SECURITY;

-- =============================================
-- 6. CREATE RLS POLICIES
-- =============================================

-- RLS Policies for user_roles table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'user_roles' 
        AND policyname = 'Users can view their own roles'
    ) THEN
        CREATE POLICY "Users can view their own roles" ON public.user_roles
            FOR SELECT USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'user_roles' 
        AND policyname = 'Admins can manage all roles'
    ) THEN
        CREATE POLICY "Admins can manage all roles" ON public.user_roles
            FOR ALL USING (
                EXISTS (
                    SELECT 1 FROM public.user_roles ur 
                    WHERE ur.user_id = auth.uid() 
                    AND ur.role = 'admin' 
                    AND ur.is_verified = true
                )
            );
    END IF;
END $$;

-- RLS Policies for user_permissions table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'user_permissions' 
        AND policyname = 'Users can view their own permissions'
    ) THEN
        CREATE POLICY "Users can view their own permissions" ON public.user_permissions
            FOR SELECT USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'user_permissions' 
        AND policyname = 'Admins can manage all permissions'
    ) THEN
        CREATE POLICY "Admins can manage all permissions" ON public.user_permissions
            FOR ALL USING (
                EXISTS (
                    SELECT 1 FROM public.user_roles ur 
                    WHERE ur.user_id = auth.uid() 
                    AND ur.role = 'admin' 
                    AND ur.is_verified = true
                )
            );
    END IF;
END $$;

-- RLS Policies for jwt_tokens table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'jwt_tokens' 
        AND policyname = 'Users can manage their own tokens'
    ) THEN
        CREATE POLICY "Users can manage their own tokens" ON public.jwt_tokens
            FOR ALL USING (auth.uid() = user_id);
    END IF;
END $$;

-- RLS Policies for pharmacy_profiles table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'pharmacy_profiles' 
        AND policyname = 'Pharmacies can manage their own profiles'
    ) THEN
        CREATE POLICY "Pharmacies can manage their own profiles" ON public.pharmacy_profiles
            FOR ALL USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'pharmacy_profiles' 
        AND policyname = 'Public can view verified pharmacy profiles'
    ) THEN
        CREATE POLICY "Public can view verified pharmacy profiles" ON public.pharmacy_profiles
            FOR SELECT USING (verification_status = 'approved' AND is_active = true);
    END IF;
END $$;

-- RLS Policies for admin_profiles table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'admin_profiles' 
        AND policyname = 'Admins can view their own profiles'
    ) THEN
        CREATE POLICY "Admins can view their own profiles" ON public.admin_profiles
            FOR SELECT USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'admin_profiles' 
        AND policyname = 'Admins can update their own profiles'
    ) THEN
        CREATE POLICY "Admins can update their own profiles" ON public.admin_profiles
            FOR UPDATE USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'admin_profiles' 
        AND policyname = 'Super admins can manage all admin profiles'
    ) THEN
        CREATE POLICY "Super admins can manage all admin profiles" ON public.admin_profiles
            FOR ALL USING (
                EXISTS (
                    SELECT 1 FROM public.admin_profiles ap 
                    WHERE ap.user_id = auth.uid() 
                    AND ap.admin_level IN ('super', 'system')
                )
            );
    END IF;
END $$;

-- =============================================
-- 7. CREATE AUTOMATIC TIMESTAMP UPDATE TRIGGERS
-- =============================================

-- Triggers for user_roles table
DROP TRIGGER IF EXISTS update_user_roles_updated_at ON public.user_roles;
CREATE TRIGGER update_user_roles_updated_at 
    BEFORE UPDATE ON public.user_roles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers for pharmacy_profiles table
DROP TRIGGER IF EXISTS update_pharmacy_profiles_updated_at ON public.pharmacy_profiles;
CREATE TRIGGER update_pharmacy_profiles_updated_at 
    BEFORE UPDATE ON public.pharmacy_profiles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers for admin_profiles table
DROP TRIGGER IF EXISTS update_admin_profiles_updated_at ON public.admin_profiles;
CREATE TRIGGER update_admin_profiles_updated_at 
    BEFORE UPDATE ON public.admin_profiles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 8. CREATE ROLE MANAGEMENT FUNCTIONS
-- =============================================

-- Function to assign role to user
CREATE OR REPLACE FUNCTION assign_user_role(
    target_user_id UUID,
    target_role TEXT,
    assigned_by_user_id UUID DEFAULT auth.uid()
)
RETURNS BOOLEAN AS $$
BEGIN
    -- Check if the assigner has permission (admin or self-assignment for patient role)
    IF target_role != 'patient' THEN
        IF NOT EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = assigned_by_user_id 
            AND role = 'admin' 
            AND is_verified = true
        ) THEN
            RAISE EXCEPTION 'Insufficient permissions to assign role: %', target_role;
        END IF;
    END IF;
    
    -- Insert or update role
    INSERT INTO public.user_roles (user_id, role, assigned_by, is_verified)
    VALUES (target_user_id, target_role, assigned_by_user_id, target_role = 'patient')
    ON CONFLICT (user_id, role) 
    DO UPDATE SET 
        assigned_by = EXCLUDED.assigned_by,
        assigned_at = NOW(),
        updated_at = NOW();
    
    -- Update profiles table
    UPDATE public.profiles 
    SET user_role = target_role, 
        role_verified = (target_role = 'patient'),
        updated_at = NOW()
    WHERE id = target_user_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to verify user role
CREATE OR REPLACE FUNCTION verify_user_role(
    target_user_id UUID,
    target_role TEXT,
    verified_by_user_id UUID DEFAULT auth.uid()
)
RETURNS BOOLEAN AS $$
BEGIN
    -- Check if the verifier has admin permissions
    IF NOT EXISTS (
        SELECT 1 FROM public.user_roles 
        WHERE user_id = verified_by_user_id 
        AND role = 'admin' 
        AND is_verified = true
    ) THEN
        RAISE EXCEPTION 'Insufficient permissions to verify roles';
    END IF;
    
    -- Update role verification
    UPDATE public.user_roles 
    SET is_verified = true,
        verification_status = 'approved',
        verified_at = NOW(),
        updated_at = NOW()
    WHERE user_id = target_user_id AND role = target_role;
    
    -- Update profiles table
    UPDATE public.profiles 
    SET role_verified = true,
        account_verified = true,
        updated_at = NOW()
    WHERE id = target_user_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check user permission
CREATE OR REPLACE FUNCTION has_permission(
    user_id UUID,
    permission_name TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
    user_role TEXT;
    has_perm BOOLEAN := FALSE;
BEGIN
    -- Get user's primary role
    SELECT role INTO user_role 
    FROM public.user_roles 
    WHERE user_roles.user_id = has_permission.user_id 
    AND is_verified = true 
    ORDER BY 
        CASE role 
            WHEN 'admin' THEN 4
            WHEN 'doctor' THEN 3
            WHEN 'pharmacy' THEN 2
            WHEN 'patient' THEN 1
            ELSE 0
        END DESC
    LIMIT 1;
    
    -- Check role-based permissions
    IF user_role IS NOT NULL THEN
        has_perm := CASE user_role
            WHEN 'admin' THEN permission_name IN (
                'manage_users', 'manage_system_settings', 'view_system_analytics',
                'manage_doctors', 'manage_pharmacies', 'view_all_data', 'system_backup',
                'view_own_profile', 'edit_own_profile'
            )
            WHEN 'doctor' THEN permission_name IN (
                'view_own_profile', 'edit_own_profile', 'view_patient_profiles',
                'view_all_appointments', 'create_prescriptions', 'update_appointment_status',
                'access_video_consultation', 'view_patient_health_records'
            )
            WHEN 'pharmacy' THEN permission_name IN (
                'view_own_profile', 'edit_own_profile', 'view_prescriptions',
                'update_prescription_status', 'manage_inventory', 'process_prescription_orders'
            )
            WHEN 'patient' THEN permission_name IN (
                'view_own_profile', 'edit_own_profile', 'book_appointment',
                'view_own_appointments', 'view_own_prescriptions', 'view_own_health_records',
                'upload_health_documents'
            )
            ELSE FALSE
        END;
    END IF;
    
    -- Check explicit permissions
    IF NOT has_perm THEN
        SELECT EXISTS(
            SELECT 1 FROM public.user_permissions 
            WHERE user_permissions.user_id = has_permission.user_id 
            AND permission = permission_name 
            AND is_active = true 
            AND (expires_at IS NULL OR expires_at > NOW())
        ) INTO has_perm;
    END IF;
    
    RETURN has_perm;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- 9. INSERT DEFAULT ADMIN USER (OPTIONAL)
-- =============================================

-- This section creates a default admin user for initial setup
-- Remove or modify this section based on your needs

DO $$
DECLARE
    admin_user_id UUID;
BEGIN
    -- Only create if no admin exists
    IF NOT EXISTS (
        SELECT 1 FROM public.user_roles 
        WHERE role = 'admin' AND is_verified = true
    ) THEN
        RAISE NOTICE 'No admin user found. You can create one manually after setup.';
        -- Uncomment and modify the following to create a default admin:
        
        -- INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
        -- VALUES (
        --     gen_random_uuid(),
        --     '00000000-0000-0000-0000-000000000000',
        --     'admin@telemed.com',
        --     crypt('admin123', gen_salt('bf')),
        --     NOW(),
        --     NOW(),
        --     NOW()
        -- ) RETURNING id INTO admin_user_id;
        
        -- INSERT INTO public.profiles (id, full_name, email, phone_number, user_role, role_verified, account_verified)
        -- VALUES (admin_user_id, 'System Administrator', 'admin@telemed.com', '+91-9999999999', 'admin', true, true);
        
        -- INSERT INTO public.user_roles (user_id, role, is_verified, verification_status, assigned_by)
        -- VALUES (admin_user_id, 'admin', true, 'approved', admin_user_id);
        
        -- INSERT INTO public.admin_profiles (user_id, admin_level, department, employee_id)
        -- VALUES (admin_user_id, 'super', 'System Administration', 'ADMIN001');
    END IF;
END $$;

-- =============================================
-- 10. ADD TABLE COMMENTS FOR DOCUMENTATION
-- =============================================

COMMENT ON TABLE public.user_roles IS 'Table storing user role assignments and verification status';
COMMENT ON TABLE public.user_permissions IS 'Table storing granular user permissions beyond role-based permissions';
COMMENT ON TABLE public.jwt_tokens IS 'Table for JWT token management and blacklisting';
COMMENT ON TABLE public.pharmacy_profiles IS 'Table storing pharmacy-specific profile information';
COMMENT ON TABLE public.admin_profiles IS 'Table storing administrator profile information and permissions';

-- =============================================
-- 11. COMPLETION MESSAGE
-- =============================================

DO $$
BEGIN
    RAISE NOTICE 'JWT Role-Based Access Control migration completed successfully!';
    RAISE NOTICE 'New tables created: user_roles, user_permissions, jwt_tokens, pharmacy_profiles, admin_profiles';
    RAISE NOTICE 'Role fields added to existing tables';
    RAISE NOTICE 'RLS policies configured for role-based security';
    RAISE NOTICE 'Role management functions created';
    RAISE NOTICE 'Ready for JWT authentication implementation';
END $$;