-- COMPREHENSIVE SUPABASE DATABASE SETUP FOR TELEMED APPLICATION
-- This file consolidates all database requirements for patients, doctors, appointments, and prescriptions
-- Run this in your Supabase SQL editor

-- =============================================
-- 1. EXTENSIONS AND INITIAL SETUP
-- =============================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- 2. STORAGE BUCKETS CONFIGURATION
-- =============================================

-- Create storage buckets (if not already created)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES 
  ('profile-photos', 'profile-photos', true, 5242880, '{"image/jpeg","image/png","image/gif","image/webp"}'),
  ('medical-documents', 'medical-documents', false, 10485760, '{"image/jpeg","image/png","application/pdf","image/webp"}'),
  ('prescriptions', 'prescriptions', false, 10485760, '{"image/jpeg","image/png","application/pdf"}'),
  ('appointment-attachments', 'appointment-attachments', false, 5242880, '{"image/jpeg","image/png","application/pdf"}')
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- 3. STORAGE POLICIES
-- =============================================

-- Profile photos policies (public access)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'storage' 
        AND tablename = 'objects' 
        AND policyname = 'Allow public read access to profile photos'
    ) THEN
        CREATE POLICY "Allow public read access to profile photos" 
        ON storage.objects FOR SELECT 
        USING (bucket_id = 'profile-photos');
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'storage' 
        AND tablename = 'objects' 
        AND policyname = 'Allow authenticated users to upload profile photos'
    ) THEN
        CREATE POLICY "Allow authenticated users to upload profile photos" 
        ON storage.objects FOR INSERT 
        WITH CHECK (bucket_id = 'profile-photos' AND auth.role() = 'authenticated');
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'storage' 
        AND tablename = 'objects' 
        AND policyname = 'Allow users to update profile photos'
    ) THEN
        CREATE POLICY "Allow users to update profile photos" 
        ON storage.objects FOR UPDATE 
        USING (bucket_id = 'profile-photos' AND auth.role() = 'authenticated');
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'storage' 
        AND tablename = 'objects' 
        AND policyname = 'Allow users to delete profile photos'
    ) THEN
        CREATE POLICY "Allow users to delete profile photos" 
        ON storage.objects FOR DELETE 
        USING (bucket_id = 'profile-photos' AND auth.role() = 'authenticated');
    END IF;
END $$;

-- Medical documents policies (private access)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'storage' 
        AND tablename = 'objects' 
        AND policyname = 'Allow users to upload medical documents'
    ) THEN
        CREATE POLICY "Allow users to upload medical documents" 
        ON storage.objects FOR INSERT 
        WITH CHECK (bucket_id = 'medical-documents' AND auth.role() = 'authenticated');
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'storage' 
        AND tablename = 'objects' 
        AND policyname = 'Allow users to view medical documents'
    ) THEN
        CREATE POLICY "Allow users to view medical documents" 
        ON storage.objects FOR SELECT 
        USING (bucket_id = 'medical-documents' AND auth.role() = 'authenticated');
    END IF;
END $$;

-- =============================================
-- 4. ENHANCE EXISTING PROFILES TABLE (PATIENTS)
-- =============================================

-- Add comprehensive medical fields to profiles table if they don't exist
DO $$
BEGIN
    -- Basic patient information
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'date_of_birth') THEN
        ALTER TABLE public.profiles ADD COLUMN date_of_birth DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'gender') THEN
        ALTER TABLE public.profiles ADD COLUMN gender TEXT CHECK (gender IN ('male', 'female', 'other', 'prefer_not_to_say'));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'blood_group') THEN
        ALTER TABLE public.profiles ADD COLUMN blood_group TEXT CHECK (blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'));
    END IF;
    
    -- Emergency contact information
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'emergency_contact_name') THEN
        ALTER TABLE public.profiles ADD COLUMN emergency_contact_name TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'emergency_contact_phone') THEN
        ALTER TABLE public.profiles ADD COLUMN emergency_contact_phone TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'emergency_contact_relation') THEN
        ALTER TABLE public.profiles ADD COLUMN emergency_contact_relation TEXT;
    END IF;
    
    -- Medical information arrays
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'medical_history') THEN
        ALTER TABLE public.profiles ADD COLUMN medical_history JSONB DEFAULT '{}';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'current_medications') THEN
        ALTER TABLE public.profiles ADD COLUMN current_medications TEXT[] DEFAULT '{}';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'allergies') THEN
        ALTER TABLE public.profiles ADD COLUMN allergies TEXT[] DEFAULT '{}';
    END IF;
    
    -- Location and preferences
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'preferred_language') THEN
        ALTER TABLE public.profiles ADD COLUMN preferred_language TEXT DEFAULT 'en' CHECK (preferred_language IN ('en', 'hi', 'pa'));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'address') THEN
        ALTER TABLE public.profiles ADD COLUMN address TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'city') THEN
        ALTER TABLE public.profiles ADD COLUMN city TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'state') THEN
        ALTER TABLE public.profiles ADD COLUMN state TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'pincode') THEN
        ALTER TABLE public.profiles ADD COLUMN pincode TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'is_active') THEN
        ALTER TABLE public.profiles ADD COLUMN is_active BOOLEAN DEFAULT true;
    END IF;
    
    -- Profile photo URL (using consistent naming)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'profile_photo_url') THEN
        ALTER TABLE public.profiles ADD COLUMN profile_photo_url TEXT;
    END IF;
END $$;

-- =============================================
-- 5. CREATE DOCTORS TABLE
-- =============================================

CREATE TABLE IF NOT EXISTS public.doctors (
    id TEXT PRIMARY KEY DEFAULT ('doc_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone_number TEXT,
    specialization TEXT NOT NULL,
    qualification TEXT NOT NULL,
    license_number TEXT UNIQUE NOT NULL,
    experience_years INTEGER DEFAULT 0,
    consultation_fee DECIMAL(10,2) DEFAULT 0.00,
    languages TEXT[] DEFAULT '{"en"}',
    is_available BOOLEAN DEFAULT true,
    is_online BOOLEAN DEFAULT false,
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_reviews INTEGER DEFAULT 0,
    hospital_affiliation TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    pincode TEXT,
    profile_photo_url TEXT,
    bio TEXT,
    working_hours JSONB DEFAULT '{"monday": {"start": "09:00", "end": "17:00"}, "tuesday": {"start": "09:00", "end": "17:00"}, "wednesday": {"start": "09:00", "end": "17:00"}, "thursday": {"start": "09:00", "end": "17:00"}, "friday": {"start": "09:00", "end": "17:00"}, "saturday": {"start": "09:00", "end": "13:00"}, "sunday": null}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- 6. CREATE APPOINTMENTS TABLE
-- =============================================

CREATE TABLE IF NOT EXISTS public.appointments (
    id TEXT PRIMARY KEY DEFAULT ('apt_' || substr(gen_random_uuid()::text, 1, 8)),
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    doctor_id TEXT NOT NULL, -- Reference to doctors table, but no FK constraint to avoid type issues
    doctor_name TEXT NOT NULL,
    doctor_specialization TEXT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'in_progress', 'rescheduled')),
    notes TEXT,
    patient_symptoms TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    meeting_link TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- 7. CREATE PRESCRIPTIONS TABLE
-- =============================================

CREATE TABLE IF NOT EXISTS public.prescriptions (
    id TEXT PRIMARY KEY DEFAULT ('prs_' || substr(gen_random_uuid()::text, 1, 8)),
    appointment_id TEXT, -- Reference to appointments table
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    doctor_id TEXT NOT NULL, -- Reference to doctors table
    doctor_name TEXT NOT NULL,
    medications JSONB NOT NULL DEFAULT '[]', -- Array of medication objects
    instructions TEXT,
    diagnosis TEXT,
    symptoms TEXT,
    follow_up_date DATE,
    is_active BOOLEAN DEFAULT true,
    prescription_url TEXT, -- URL to uploaded prescription document
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- 8. CREATE HEALTH RECORDS TABLE
-- =============================================

CREATE TABLE IF NOT EXISTS public.health_records (
    id TEXT PRIMARY KEY DEFAULT ('rec_' || substr(gen_random_uuid()::text, 1, 8)),
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    record_type TEXT NOT NULL CHECK (record_type IN ('prescription', 'lab_report', 'imaging', 'consultation', 'vaccination', 'surgery', 'allergy', 'chronic_condition', 'other')),
    document_url TEXT,
    doctor_name TEXT,
    hospital_name TEXT,
    record_date DATE NOT NULL,
    is_critical BOOLEAN DEFAULT false,
    tags TEXT[] DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- 9. CREATE NOTIFICATIONS TABLE
-- =============================================

CREATE TABLE IF NOT EXISTS public.notifications (
    id TEXT PRIMARY KEY DEFAULT ('ntf_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('appointment', 'prescription', 'reminder', 'emergency', 'system', 'marketing')),
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    is_sent BOOLEAN DEFAULT false,
    scheduled_at TIMESTAMP WITH TIME ZONE,
    sent_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- 10. CREATE APP SETTINGS TABLE
-- =============================================

CREATE TABLE IF NOT EXISTS public.app_settings (
    id TEXT PRIMARY KEY DEFAULT ('set_' || substr(gen_random_uuid()::text, 1, 8)),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    notifications_enabled BOOLEAN DEFAULT true,
    email_notifications BOOLEAN DEFAULT true,
    sms_notifications BOOLEAN DEFAULT true,
    appointment_reminders BOOLEAN DEFAULT true,
    prescription_reminders BOOLEAN DEFAULT true,
    language_preference TEXT DEFAULT 'en' CHECK (language_preference IN ('en', 'hi', 'pa')),
    theme_preference TEXT DEFAULT 'light' CHECK (theme_preference IN ('light', 'dark', 'system')),
    data_sharing_consent BOOLEAN DEFAULT false,
    marketing_consent BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- =============================================
-- 11. CREATE PERFORMANCE INDEXES
-- =============================================

-- Profiles table indexes
CREATE INDEX IF NOT EXISTS idx_profiles_phone ON public.profiles(phone_number);
CREATE INDEX IF NOT EXISTS idx_profiles_city ON public.profiles(city);
CREATE INDEX IF NOT EXISTS idx_profiles_active ON public.profiles(is_active);

-- Doctors table indexes
CREATE INDEX IF NOT EXISTS idx_doctors_specialization ON public.doctors(specialization);
CREATE INDEX IF NOT EXISTS idx_doctors_city ON public.doctors(city);
CREATE INDEX IF NOT EXISTS idx_doctors_availability ON public.doctors(is_available, is_online);
CREATE INDEX IF NOT EXISTS idx_doctors_rating ON public.doctors(rating DESC);
CREATE INDEX IF NOT EXISTS idx_doctors_email ON public.doctors(email);

-- Appointments table indexes
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON public.appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON public.appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON public.appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON public.appointments(status);
CREATE INDEX IF NOT EXISTS idx_appointments_date_time ON public.appointments(appointment_date, appointment_time);

-- Prescriptions table indexes
CREATE INDEX IF NOT EXISTS idx_prescriptions_patient ON public.prescriptions(patient_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_doctor ON public.prescriptions(doctor_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_appointment ON public.prescriptions(appointment_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_active ON public.prescriptions(is_active);

-- Health records table indexes
CREATE INDEX IF NOT EXISTS idx_health_records_patient ON public.health_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_health_records_type ON public.health_records(record_type);
CREATE INDEX IF NOT EXISTS idx_health_records_date ON public.health_records(record_date DESC);
CREATE INDEX IF NOT EXISTS idx_health_records_critical ON public.health_records(patient_id, is_critical);

-- Notifications table indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON public.notifications(user_id, is_read) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_notifications_scheduled ON public.notifications(scheduled_at) WHERE scheduled_at IS NOT NULL;

-- =============================================
-- 12. ENABLE ROW LEVEL SECURITY
-- =============================================

-- Enable RLS on all tables
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prescriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- =============================================
-- 13. CREATE ROW LEVEL SECURITY POLICIES
-- =============================================

-- Doctors table policies
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'doctors' 
        AND policyname = 'Public can view doctor profiles'
    ) THEN
        CREATE POLICY "Public can view doctor profiles" ON public.doctors
            FOR SELECT USING (true);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'doctors' 
        AND policyname = 'Doctors can update their own profile'
    ) THEN
        CREATE POLICY "Doctors can update their own profile" ON public.doctors
            FOR UPDATE USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'doctors' 
        AND policyname = 'Doctors can insert their own profile'
    ) THEN
        CREATE POLICY "Doctors can insert their own profile" ON public.doctors
            FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
END $$;

-- Appointments table policies
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'appointments' 
        AND policyname = 'Users can view their own appointments'
    ) THEN
        CREATE POLICY "Users can view their own appointments" ON public.appointments
            FOR SELECT USING (auth.uid() = patient_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'appointments' 
        AND policyname = 'Users can insert their own appointments'
    ) THEN
        CREATE POLICY "Users can insert their own appointments" ON public.appointments
            FOR INSERT WITH CHECK (auth.uid() = patient_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'appointments' 
        AND policyname = 'Users can update their own appointments'
    ) THEN
        CREATE POLICY "Users can update their own appointments" ON public.appointments
            FOR UPDATE USING (auth.uid() = patient_id);
    END IF;
END $$;

-- Prescriptions table policies
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'prescriptions' 
        AND policyname = 'Patients can view their own prescriptions'
    ) THEN
        CREATE POLICY "Patients can view their own prescriptions" ON public.prescriptions
            FOR SELECT USING (auth.uid() = patient_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'prescriptions' 
        AND policyname = 'Authenticated users can insert prescriptions'
    ) THEN
        CREATE POLICY "Authenticated users can insert prescriptions" ON public.prescriptions
            FOR INSERT WITH CHECK (auth.role() = 'authenticated');
    END IF;
END $$;

-- Health records table policies
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'health_records' 
        AND policyname = 'Users can view their own health records'
    ) THEN
        CREATE POLICY "Users can view their own health records" ON public.health_records
            FOR SELECT USING (auth.uid() = patient_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'health_records' 
        AND policyname = 'Users can insert their own health records'
    ) THEN
        CREATE POLICY "Users can insert their own health records" ON public.health_records
            FOR INSERT WITH CHECK (auth.uid() = patient_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'health_records' 
        AND policyname = 'Users can update their own health records'
    ) THEN
        CREATE POLICY "Users can update their own health records" ON public.health_records
            FOR UPDATE USING (auth.uid() = patient_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'health_records' 
        AND policyname = 'Users can delete their own health records'
    ) THEN
        CREATE POLICY "Users can delete their own health records" ON public.health_records
            FOR DELETE USING (auth.uid() = patient_id);
    END IF;
END $$;

-- Notifications table policies
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'notifications' 
        AND policyname = 'Users can view their own notifications'
    ) THEN
        CREATE POLICY "Users can view their own notifications" ON public.notifications
            FOR SELECT USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'notifications' 
        AND policyname = 'Users can update their own notifications'
    ) THEN
        CREATE POLICY "Users can update their own notifications" ON public.notifications
            FOR UPDATE USING (auth.uid() = user_id);
    END IF;
END $$;

-- App settings table policies
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'app_settings' 
        AND policyname = 'Users can view their own settings'
    ) THEN
        CREATE POLICY "Users can view their own settings" ON public.app_settings
            FOR SELECT USING (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'app_settings' 
        AND policyname = 'Users can insert their own settings'
    ) THEN
        CREATE POLICY "Users can insert their own settings" ON public.app_settings
            FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = 'app_settings' 
        AND policyname = 'Users can update their own settings'
    ) THEN
        CREATE POLICY "Users can update their own settings" ON public.app_settings
            FOR UPDATE USING (auth.uid() = user_id);
    END IF;
END $$;

-- =============================================
-- 14. CREATE AUTOMATIC TIMESTAMP UPDATE FUNCTIONS AND TRIGGERS
-- =============================================

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for automatic timestamp updates
DROP TRIGGER IF EXISTS update_doctors_updated_at ON public.doctors;
CREATE TRIGGER update_doctors_updated_at 
    BEFORE UPDATE ON public.doctors 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_appointments_updated_at ON public.appointments;
CREATE TRIGGER update_appointments_updated_at 
    BEFORE UPDATE ON public.appointments 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_prescriptions_updated_at ON public.prescriptions;
CREATE TRIGGER update_prescriptions_updated_at 
    BEFORE UPDATE ON public.prescriptions 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_health_records_updated_at ON public.health_records;
CREATE TRIGGER update_health_records_updated_at 
    BEFORE UPDATE ON public.health_records 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_app_settings_updated_at ON public.app_settings;
CREATE TRIGGER update_app_settings_updated_at 
    BEFORE UPDATE ON public.app_settings 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 15. INSERT SAMPLE DATA FOR TESTING
-- =============================================

-- Insert sample doctors (only if they don't already exist)
DO $$
BEGIN
    -- Insert Dr. Rajesh Kumar if not exists
    IF NOT EXISTS (SELECT 1 FROM public.doctors WHERE license_number = 'MED001' OR email = 'dr.rajesh@telemed.com') THEN
        INSERT INTO public.doctors (id, full_name, email, phone_number, specialization, qualification, license_number, experience_years, consultation_fee, bio, city, state)
        VALUES (
            'doc_sample001',
            'Dr. Rajesh Kumar',
            'dr.rajesh@telemed.com',
            '+91-9876543210',
            'General Medicine',
            'MBBS, MD',
            'MED001',
            15,
            500.00,
            'Experienced general physician with 15+ years of practice in rural healthcare.',
            'Nabha',
            'Punjab'
        );
        RAISE NOTICE 'Sample doctor Dr. Rajesh Kumar inserted successfully.';
    ELSE
        RAISE NOTICE 'Sample doctor Dr. Rajesh Kumar already exists, skipping.';
    END IF;
    
    -- Insert Dr. Priya Sharma if not exists
    IF NOT EXISTS (SELECT 1 FROM public.doctors WHERE license_number = 'PED001' OR email = 'dr.priya@telemed.com') THEN
        INSERT INTO public.doctors (id, full_name, email, phone_number, specialization, qualification, license_number, experience_years, consultation_fee, bio, city, state)
        VALUES (
            'doc_sample002',
            'Dr. Priya Sharma',
            'dr.priya@telemed.com',
            '+91-9876543211',
            'Pediatrics',
            'MBBS, MD (Pediatrics)',
            'PED001',
            10,
            600.00,
            'Specialized in child healthcare and vaccination programs.',
            'Patiala',
            'Punjab'
        );
        RAISE NOTICE 'Sample doctor Dr. Priya Sharma inserted successfully.';
    ELSE
        RAISE NOTICE 'Sample doctor Dr. Priya Sharma already exists, skipping.';
    END IF;
    
    -- Insert Dr. Amit Singh if not exists
    IF NOT EXISTS (SELECT 1 FROM public.doctors WHERE license_number = 'CAR001' OR email = 'dr.amit@telemed.com') THEN
        INSERT INTO public.doctors (id, full_name, email, phone_number, specialization, qualification, license_number, experience_years, consultation_fee, bio, city, state)
        VALUES (
            'doc_sample003',
            'Dr. Amit Singh',
            'dr.amit@telemed.com',
            '+91-9876543212',
            'Cardiology',
            'MBBS, DM (Cardiology)',
            'CAR001',
            12,
            800.00,
            'Heart specialist with expertise in rural cardiac care.',
            'Ludhiana',
            'Punjab'
        );
        RAISE NOTICE 'Sample doctor Dr. Amit Singh inserted successfully.';
    ELSE
        RAISE NOTICE 'Sample doctor Dr. Amit Singh already exists, skipping.';
    END IF;
END $$;

-- =============================================
-- 16. FINAL SETUP VALIDATION
-- =============================================

-- Add table comments for documentation
COMMENT ON TABLE public.doctors IS 'Table storing doctor profiles and information';
COMMENT ON TABLE public.appointments IS 'Table storing patient appointments with doctors';
COMMENT ON TABLE public.prescriptions IS 'Table storing prescriptions given by doctors';
COMMENT ON TABLE public.health_records IS 'Table storing patient health records and medical documents';
COMMENT ON TABLE public.notifications IS 'Table storing system notifications for users';
COMMENT ON TABLE public.app_settings IS 'Table storing user application preferences and settings';

-- Display completion message
DO $$
BEGIN
    RAISE NOTICE 'TeleMed Supabase database setup completed successfully!';
    RAISE NOTICE 'Tables created: profiles (enhanced), doctors, appointments, prescriptions, health_records, notifications, app_settings';
    RAISE NOTICE 'Storage buckets configured: profile-photos, medical-documents, prescriptions, appointment-attachments';
    RAISE NOTICE 'RLS policies enabled for data security';
    RAISE NOTICE 'Performance indexes created';
    RAISE NOTICE 'Sample doctors data inserted for testing';
END $$;