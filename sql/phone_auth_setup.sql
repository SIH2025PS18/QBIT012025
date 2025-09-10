-- Phone Authentication Setup for TeleMed Application
-- Run this in your Supabase SQL editor

-- Enable phone authentication in Supabase (this is done in the dashboard, but we can prepare the database)
-- This script adds necessary fields and indexes for phone authentication

-- Ensure phone_number field exists in profiles table
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS phone_number TEXT UNIQUE;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS phone_verified BOOLEAN DEFAULT false;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS otp_secret TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS otp_expires_at TIMESTAMPTZ;

-- Add password field for phone-based authentication
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS phone_password TEXT;

-- Ensure phone_number field exists in patient_profiles table
ALTER TABLE public.patient_profiles ADD COLUMN IF NOT EXISTS phone_verified BOOLEAN DEFAULT false;
ALTER TABLE public.patient_profiles ADD COLUMN IF NOT EXISTS otp_secret TEXT;
ALTER TABLE public.patient_profiles ADD COLUMN IF NOT EXISTS otp_expires_at TIMESTAMPTZ;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_profiles_phone_number ON public.profiles(phone_number);
CREATE INDEX IF NOT EXISTS idx_profiles_phone_verified ON public.profiles(phone_verified);
CREATE INDEX IF NOT EXISTS idx_patient_profiles_phone_verified ON public.patient_profiles(phone_verified);

-- Create a table to store OTP attempts for security
CREATE TABLE IF NOT EXISTS public.otp_attempts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    phone_number TEXT NOT NULL,
    otp_hash TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    attempts INTEGER DEFAULT 0,
    is_used BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable Row Level Security (this might show a notice if already enabled, which is fine)
ALTER TABLE public.otp_attempts ENABLE ROW LEVEL SECURITY;

-- OTP Attempts RLS Policies
-- First drop policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Users can insert OTP attempts" ON public.otp_attempts;
DROP POLICY IF EXISTS "System can update OTP attempts" ON public.otp_attempts;

-- Create the policies
CREATE POLICY "Users can insert OTP attempts" 
    ON public.otp_attempts FOR INSERT 
    WITH CHECK (true);

CREATE POLICY "System can update OTP attempts" 
    ON public.otp_attempts FOR UPDATE 
    USING (true);

-- Add a function to clean up expired OTPs (can be run as a cron job)
CREATE OR REPLACE FUNCTION cleanup_expired_otps()
RETURNS void AS $$
BEGIN
    DELETE FROM public.otp_attempts 
    WHERE expires_at < NOW() - INTERVAL '1 hour';
END;
$$ LANGUAGE plpgsql;

-- Comments for documentation
COMMENT ON TABLE public.otp_attempts IS 'Stores OTP attempts for phone authentication security';
COMMENT ON COLUMN public.profiles.phone_verified IS 'Indicates if the phone number has been verified';
COMMENT ON COLUMN public.profiles.otp_secret IS 'Stores the OTP secret for verification';
COMMENT ON COLUMN public.profiles.otp_expires_at IS 'Expiration time for the OTP';
COMMENT ON COLUMN public.profiles.phone_password IS 'Password for phone-based authentication';
COMMENT ON COLUMN public.otp_attempts.attempts IS 'Number of attempts made with this OTP';
COMMENT ON COLUMN public.otp_attempts.is_used IS 'Whether this OTP has been successfully used';

-- Grant necessary permissions
GRANT ALL ON public.otp_attempts TO authenticated;

-- Final success message
SELECT 'Phone authentication schema updated successfully!' AS status;