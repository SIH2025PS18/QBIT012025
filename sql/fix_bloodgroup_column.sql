-- Fix for missing bloodGroup column in patient_profiles table
-- Run this in your Supabase SQL editor

-- Ensure the patient_profiles table exists with the blood_group column
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
    profile_photo_url TEXT DEFAULT '',
    allergies JSONB DEFAULT '[]'::jsonb,
    medications JSONB DEFAULT '[]'::jsonb,
    medical_history JSONB DEFAULT '{}'::jsonb,
    last_visit TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Add blood_group column if it doesn't exist
ALTER TABLE public.patient_profiles 
ADD COLUMN IF NOT EXISTS blood_group TEXT DEFAULT '';

-- Add profile_photo_url column if it doesn't exist
ALTER TABLE public.patient_profiles 
ADD COLUMN IF NOT EXISTS profile_photo_url TEXT DEFAULT '';

-- Enable Row Level Security
ALTER TABLE public.patient_profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies and recreate them
DROP POLICY IF EXISTS "Users can view own patient profile" ON public.patient_profiles;
DROP POLICY IF EXISTS "Users can update own patient profile" ON public.patient_profiles;
DROP POLICY IF EXISTS "Users can insert own patient profile" ON public.patient_profiles;

-- Create policies for patient profiles
CREATE POLICY "Users can view own patient profile" 
    ON public.patient_profiles FOR SELECT 
    USING (auth.uid() = id);

CREATE POLICY "Users can update own patient profile" 
    ON public.patient_profiles FOR UPDATE 
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own patient profile" 
    ON public.patient_profiles FOR INSERT 
    WITH CHECK (auth.uid() = id);

-- Create trigger for auto-updating updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Drop existing trigger and recreate it
DROP TRIGGER IF EXISTS update_patient_profiles_updated_at ON public.patient_profiles;
CREATE TRIGGER update_patient_profiles_updated_at 
    BEFORE UPDATE ON public.patient_profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Display success message
SELECT 'Patient profiles table fixed successfully! blood_group column added.' AS status;