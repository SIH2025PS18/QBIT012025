-- Enhanced Supabase Schema Setup for TeleMed Application
-- Run this in your Supabase SQL editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create storage buckets (if not already created)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES 
  ('profile-photos', 'profile-photos', true, 5242880, '{"image/jpeg","image/png","image/gif","image/webp"}'),
  ('medical-documents', 'medical-documents', false, 10485760, '{"image/jpeg","image/png","application/pdf","image/webp"}'),
  ('prescriptions', 'prescriptions', false, 10485760, '{"image/jpeg","image/png","application/pdf"}'),
  ('appointment-attachments', 'appointment-attachments', false, 5242880, '{"image/jpeg","image/png","application/pdf"}')
ON CONFLICT (id) DO NOTHING;

-- Create storage policies for profile-photos bucket (public access)
CREATE POLICY "Allow public read access to profile photos" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'profile-photos');

CREATE POLICY "Allow authenticated users to upload profile photos" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'profile-photos' AND auth.role() = 'authenticated');

CREATE POLICY "Allow users to update profile photos" 
ON storage.objects FOR UPDATE 
USING (bucket_id = 'profile-photos' AND auth.role() = 'authenticated');

CREATE POLICY "Allow users to delete profile photos" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'profile-photos' AND auth.role() = 'authenticated');

-- Create storage policies for medical-documents bucket (private access)
CREATE POLICY "Allow users to upload medical documents" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'medical-documents' AND auth.role() = 'authenticated');

CREATE POLICY "Allow users to view medical documents" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'medical-documents' AND auth.role() = 'authenticated');

CREATE POLICY "Allow users to update medical documents" 
ON storage.objects FOR UPDATE 
USING (bucket_id = 'medical-documents' AND auth.role() = 'authenticated');

CREATE POLICY "Allow users to delete medical documents" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'medical-documents' AND auth.role() = 'authenticated');

-- Create storage policies for prescriptions bucket (private access)
CREATE POLICY "Allow users to view prescriptions" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'prescriptions' AND auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to upload prescriptions" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'prescriptions' AND auth.role() = 'authenticated');

-- Create storage policies for appointment-attachments bucket (private access)
CREATE POLICY "Allow users to view appointment attachments" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'appointment-attachments' AND auth.role() = 'authenticated');

CREATE POLICY "Allow users to upload appointment attachments" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'appointment-attachments' AND auth.role() = 'authenticated');

-- Enhance profiles table with additional medical fields
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS date_of_birth DATE;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS gender TEXT CHECK (gender IN ('male', 'female', 'other', 'prefer_not_to_say'));
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS blood_group TEXT CHECK (blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'));
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS emergency_contact_name TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS emergency_contact_phone TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS emergency_contact_relation TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS medical_history TEXT[];
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS current_medications TEXT[];
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS allergies TEXT[];
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS preferred_language TEXT DEFAULT 'en' CHECK (preferred_language IN ('en', 'hi', 'pa'));
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS city TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS state TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS pincode TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- Create appointments table (ensure it exists first)
CREATE TABLE IF NOT EXISTS public.appointments (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    doctor_id TEXT NOT NULL,
    doctor_name TEXT,
    doctor_specialization TEXT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'in_progress')),
    notes TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create doctors table
CREATE TABLE IF NOT EXISTS public.doctors (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
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
    avatar_url TEXT,
    bio TEXT,
    working_hours JSONB DEFAULT '{"monday": {"start": "09:00", "end": "17:00"}, "tuesday": {"start": "09:00", "end": "17:00"}, "wednesday": {"start": "09:00", "end": "17:00"}, "thursday": {"start": "09:00", "end": "17:00"}, "friday": {"start": "09:00", "end": "17:00"}, "saturday": {"start": "09:00", "end": "13:00"}, "sunday": null}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create health records table
CREATE TABLE IF NOT EXISTS public.health_records (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    record_type TEXT NOT NULL CHECK (record_type IN ('prescription', 'lab_report', 'imaging', 'consultation', 'vaccination', 'surgery', 'allergy', 'other')),
    document_url TEXT,
    doctor_name TEXT,
    hospital_name TEXT,
    record_date DATE NOT NULL,
    is_critical BOOLEAN DEFAULT false,
    tags TEXT[],
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create prescriptions table
CREATE TABLE IF NOT EXISTS public.prescriptions (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    appointment_id TEXT, -- Made nullable to avoid foreign key constraint issues
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    doctor_id TEXT NOT NULL REFERENCES public.doctors(id) ON DELETE CASCADE,
    medications JSONB NOT NULL DEFAULT '[]',
    instructions TEXT,
    diagnosis TEXT,
    follow_up_date DATE,
    is_active BOOLEAN DEFAULT true,
    prescription_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
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

-- Create app settings table
CREATE TABLE IF NOT EXISTS public.app_settings (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
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

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON public.appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON public.appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON public.appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON public.appointments(status);

CREATE INDEX IF NOT EXISTS idx_doctors_specialization ON public.doctors(specialization);
CREATE INDEX IF NOT EXISTS idx_doctors_city ON public.doctors(city);
CREATE INDEX IF NOT EXISTS idx_doctors_availability ON public.doctors(is_available, is_online);
CREATE INDEX IF NOT EXISTS idx_doctors_rating ON public.doctors(rating DESC);

CREATE INDEX IF NOT EXISTS idx_health_records_patient ON public.health_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_health_records_type ON public.health_records(record_type);
CREATE INDEX IF NOT EXISTS idx_health_records_date ON public.health_records(record_date DESC);

CREATE INDEX IF NOT EXISTS idx_prescriptions_patient ON public.prescriptions(patient_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_doctor ON public.prescriptions(doctor_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_appointment ON public.prescriptions(appointment_id);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON public.notifications(user_id, is_read) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_notifications_scheduled ON public.notifications(scheduled_at) WHERE scheduled_at IS NOT NULL;

-- Add foreign key constraint for prescriptions after ensuring appointments table exists
DO $$
BEGIN
    -- Add foreign key constraint if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'prescriptions_appointment_id_fkey'
        AND table_name = 'prescriptions'
    ) THEN
        ALTER TABLE public.prescriptions 
        ADD CONSTRAINT prescriptions_appointment_id_fkey 
        FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Enable RLS on all tables
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prescriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for appointments table
CREATE POLICY "Users can view their own appointments" ON public.appointments
    FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Users can insert their own appointments" ON public.appointments
    FOR INSERT WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Users can update their own appointments" ON public.appointments
    FOR UPDATE USING (auth.uid() = patient_id);

CREATE POLICY "Users can delete their own appointments" ON public.appointments
    FOR DELETE USING (auth.uid() = patient_id);

-- Create RLS policies for doctors table
CREATE POLICY "Public can view doctor profiles" ON public.doctors
    FOR SELECT USING (true);

CREATE POLICY "Doctors can update their own profile" ON public.doctors
    FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for health records
CREATE POLICY "Users can view their own health records" ON public.health_records
    FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Users can insert their own health records" ON public.health_records
    FOR INSERT WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Users can update their own health records" ON public.health_records
    FOR UPDATE USING (auth.uid() = patient_id);

CREATE POLICY "Users can delete their own health records" ON public.health_records
    FOR DELETE USING (auth.uid() = patient_id);

-- Create RLS policies for prescriptions
CREATE POLICY "Patients can view their own prescriptions" ON public.prescriptions
    FOR SELECT USING (auth.uid() = patient_id);

-- Create RLS policies for notifications
CREATE POLICY "Users can view their own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for app settings
CREATE POLICY "Users can manage their own app settings" ON public.app_settings
    FOR ALL USING (auth.uid() = user_id);

-- Create triggers for updated_at fields
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers
DROP TRIGGER IF EXISTS update_appointments_updated_at ON public.appointments;
CREATE TRIGGER update_appointments_updated_at 
    BEFORE UPDATE ON public.appointments 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_doctors_updated_at ON public.doctors;
CREATE TRIGGER update_doctors_updated_at 
    BEFORE UPDATE ON public.doctors 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_health_records_updated_at ON public.health_records;
CREATE TRIGGER update_health_records_updated_at 
    BEFORE UPDATE ON public.health_records 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_prescriptions_updated_at ON public.prescriptions;
CREATE TRIGGER update_prescriptions_updated_at 
    BEFORE UPDATE ON public.prescriptions 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_app_settings_updated_at ON public.app_settings;
CREATE TRIGGER update_app_settings_updated_at 
    BEFORE UPDATE ON public.app_settings 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Insert sample doctor data
INSERT INTO public.doctors (id, full_name, email, phone_number, specialization, qualification, license_number, experience_years, consultation_fee, languages, bio) VALUES
('doc1', 'Dr. Rajesh Kumar', 'rajesh.kumar@hospital.com', '+91-9876543210', 'General Medicine', 'MBBS, MD', 'MED001', 15, 500.00, '{"en", "hi"}', 'Experienced general physician with expertise in treating common ailments and preventive care.'),
('doc2', 'Dr. Priya Sharma', 'priya.sharma@hospital.com', '+91-9876543211', 'Cardiology', 'MBBS, DM Cardiology', 'CARD001', 12, 800.00, '{"en", "hi"}', 'Specialist in heart diseases and cardiovascular interventions.'),
('doc3', 'Dr. Amit Singh', 'amit.singh@hospital.com', '+91-9876543212', 'Pediatrics', 'MBBS, MD Pediatrics', 'PED001', 8, 600.00, '{"en", "hi", "pa"}', 'Child specialist with focus on infant and adolescent health.'),
('doc4', 'Dr. Sunita Devi', 'sunita.devi@hospital.com', '+91-9876543213', 'Gynecology', 'MBBS, MS Gynecology', 'GYN001', 10, 700.00, '{"en", "hi", "pa"}', 'Women''s health specialist providing comprehensive gynecological care.'),
('doc5', 'Dr. Harjeet Kaur', 'harjeet.kaur@hospital.com', '+91-9876543214', 'Dermatology', 'MBBS, MD Dermatology', 'DERM001', 6, 550.00, '{"en", "pa"}', 'Skin specialist treating various dermatological conditions.')
ON CONFLICT (id) DO NOTHING;

-- Comments for documentation
COMMENT ON TABLE public.doctors IS 'Doctor profiles and information';
COMMENT ON TABLE public.health_records IS 'Patient health records and medical documents';
COMMENT ON TABLE public.prescriptions IS 'Prescription details from doctor consultations';
COMMENT ON TABLE public.notifications IS 'User notifications and reminders';
COMMENT ON TABLE public.app_settings IS 'User application preferences and settings';

COMMENT ON COLUMN public.profiles.preferred_language IS 'User preferred language: en (English), hi (Hindi), pa (Punjabi)';
COMMENT ON COLUMN public.doctors.working_hours IS 'JSON object containing doctor working hours for each day';
COMMENT ON COLUMN public.health_records.metadata IS 'Additional metadata for health records in JSON format';
COMMENT ON COLUMN public.prescriptions.medications IS 'Array of prescribed medications with dosage and instructions';

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON public.doctors TO anon, authenticated;
GRANT ALL ON public.health_records TO authenticated;
GRANT ALL ON public.prescriptions TO authenticated;
GRANT ALL ON public.notifications TO authenticated;
GRANT ALL ON public.app_settings TO authenticated;