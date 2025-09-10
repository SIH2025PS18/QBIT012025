-- =================================================================================
-- SUPABASE DATABASE SETUP FOR TELEMED PROJECT
-- Project: telemed
-- Project ID: szrxgxvypusvkkyykrjz
-- =================================================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =================================================================================
-- 1. PROFILES TABLE (User information)
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    phone_number TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    last_sign_in TIMESTAMPTZ
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profiles RLS Policies
CREATE POLICY "Users can view own profile" 
    ON public.profiles FOR SELECT 
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
    ON public.profiles FOR UPDATE 
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" 
    ON public.profiles FOR INSERT 
    WITH CHECK (auth.uid() = id);

-- =================================================================================
-- 2. PATIENT PROFILES TABLE (Medical information)
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.patient_profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone_number TEXT DEFAULT '',
    date_of_birth DATE NOT NULL,
    gender TEXT DEFAULT '',
    blood_group TEXT DEFAULT '',
    address TEXT DEFAULT '',
    emergency_contact TEXT DEFAULT '',
    emergency_contact_phone TEXT DEFAULT '',
    allergies JSONB DEFAULT '[]'::jsonb,
    medications JSONB DEFAULT '[]'::jsonb,
    medical_history JSONB DEFAULT '{}'::jsonb,
    last_visit TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.patient_profiles ENABLE ROW LEVEL SECURITY;

-- Patient Profiles RLS Policies
CREATE POLICY "Users can view own patient profile" 
    ON public.patient_profiles FOR SELECT 
    USING (auth.uid() = id);

CREATE POLICY "Users can update own patient profile" 
    ON public.patient_profiles FOR UPDATE 
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own patient profile" 
    ON public.patient_profiles FOR INSERT 
    WITH CHECK (auth.uid() = id);

-- =================================================================================
-- 3. DOCTORS TABLE (Doctor information)
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.doctors (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone_number TEXT,
    specialization TEXT NOT NULL,
    qualification TEXT NOT NULL,
    experience_years INTEGER DEFAULT 0,
    consultation_fee DECIMAL(10,2) DEFAULT 0.00,
    languages JSONB DEFAULT '["English"]'::jsonb,
    availability JSONB DEFAULT '{}'::jsonb,
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_consultations INTEGER DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;

-- Doctors RLS Policies
CREATE POLICY "Anyone can view available doctors" 
    ON public.doctors FOR SELECT 
    USING (is_available = true);

CREATE POLICY "Doctor can update own profile" 
    ON public.doctors FOR UPDATE 
    USING (auth.uid() = user_id);

-- =================================================================================
-- 4. APPOINTMENTS TABLE (Appointment booking)
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.appointments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    patient_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES public.doctors(id) ON DELETE CASCADE NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    duration_minutes INTEGER DEFAULT 30,
    status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'confirmed', 'in_progress', 'completed', 'cancelled')),
    consultation_type TEXT DEFAULT 'video' CHECK (consultation_type IN ('video', 'voice', 'chat')),
    symptoms TEXT,
    notes TEXT,
    prescription TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- Appointments RLS Policies
CREATE POLICY "Users can view own appointments" 
    ON public.appointments FOR SELECT 
    USING (auth.uid() = patient_id);

CREATE POLICY "Users can create own appointments" 
    ON public.appointments FOR INSERT 
    WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Users can update own appointments" 
    ON public.appointments FOR UPDATE 
    USING (auth.uid() = patient_id);

-- Doctors can view and update appointments assigned to them
CREATE POLICY "Doctors can view assigned appointments" 
    ON public.appointments FOR SELECT 
    USING (doctor_id IN (SELECT id FROM public.doctors WHERE user_id = auth.uid()));

CREATE POLICY "Doctors can update assigned appointments" 
    ON public.appointments FOR UPDATE 
    USING (doctor_id IN (SELECT id FROM public.doctors WHERE user_id = auth.uid()));

-- =================================================================================
-- 5. HEALTH RECORDS TABLE (Patient health records)
-- =================================================================================

CREATE TABLE IF NOT EXISTS public.health_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    patient_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    appointment_id UUID REFERENCES public.appointments(id) ON DELETE CASCADE,
    record_type TEXT NOT NULL CHECK (record_type IN ('diagnosis', 'prescription', 'lab_result', 'symptom_report', 'general')),
    title TEXT NOT NULL,
    description TEXT,
    data JSONB DEFAULT '{}'::jsonb,
    attachments JSONB DEFAULT '[]'::jsonb,
    created_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.health_records ENABLE ROW LEVEL SECURITY;

-- Health Records RLS Policies
CREATE POLICY "Users can view own health records" 
    ON public.health_records FOR SELECT 
    USING (auth.uid() = patient_id);

CREATE POLICY "Users can create own health records" 
    ON public.health_records FOR INSERT 
    WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Doctors can view and create health records for their patients" 
    ON public.health_records FOR ALL 
    USING (
        appointment_id IN (
            SELECT id FROM public.appointments 
            WHERE doctor_id IN (
                SELECT id FROM public.doctors WHERE user_id = auth.uid()
            )
        )
    );

-- =================================================================================
-- 6. TRIGGER FUNCTIONS (Auto-update timestamps)
-- =================================================================================

-- Function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for auto-updating updated_at
CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON public.profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patient_profiles_updated_at 
    BEFORE UPDATE ON public.patient_profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_doctors_updated_at 
    BEFORE UPDATE ON public.doctors 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_appointments_updated_at 
    BEFORE UPDATE ON public.appointments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_health_records_updated_at 
    BEFORE UPDATE ON public.health_records 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =================================================================================
-- 7. INDEXES FOR PERFORMANCE
-- =================================================================================

-- Profiles indexes
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- Patient profiles indexes  
CREATE INDEX IF NOT EXISTS idx_patient_profiles_email ON public.patient_profiles(email);

-- Doctors indexes
CREATE INDEX IF NOT EXISTS idx_doctors_specialization ON public.doctors(specialization);
CREATE INDEX IF NOT EXISTS idx_doctors_availability ON public.doctors(is_available);

-- Appointments indexes
CREATE INDEX IF NOT EXISTS idx_appointments_patient ON public.appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor ON public.appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON public.appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON public.appointments(status);

-- Health records indexes
CREATE INDEX IF NOT EXISTS idx_health_records_patient ON public.health_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_health_records_type ON public.health_records(record_type);

-- =================================================================================
-- 8. SAMPLE DATA (Optional for testing)
-- =================================================================================

-- Insert sample doctors (uncomment if needed for testing)
/*
INSERT INTO public.doctors (full_name, email, phone_number, specialization, qualification, experience_years, consultation_fee, languages) VALUES
('Dr. Rajesh Kumar', 'rajesh.kumar@telemed.com', '+91-9876543210', 'General Medicine', 'MBBS, MD', 10, 500.00, '["English", "Hindi"]'),
('Dr. Priya Sharma', 'priya.sharma@telemed.com', '+91-9876543211', 'Pediatrics', 'MBBS, DCH', 8, 600.00, '["English", "Hindi", "Punjabi"]'),
('Dr. Amit Singh', 'amit.singh@telemed.com', '+91-9876543212', 'Cardiology', 'MBBS, DM Cardiology', 15, 1000.00, '["English", "Hindi"]');
*/

-- =================================================================================
-- SETUP COMPLETE!
-- =================================================================================

-- To execute these commands:
-- 1. Go to https://supabase.com/dashboard/project/szrxgxvypusvkkyykrjz
-- 2. Navigate to SQL Editor
-- 3. Paste and run these commands
-- 4. Verify tables are created with proper RLS policies
-- =================================================================================