-- QUICK FIX: Essential tables for immediate login functionality
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/szrxgxvypusvkkyykrjz

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES TABLE (Essential for user authentication)
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

-- TEMPORARILY ALLOW ALL OPERATIONS (for testing)
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;

CREATE POLICY "Allow all profile operations for testing"
    ON public.profiles FOR ALL
    USING (true)
    WITH CHECK (true);

-- 2. PATIENT PROFILES TABLE (Essential for app functionality)
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

-- TEMPORARILY ALLOW ALL OPERATIONS (for testing)
DROP POLICY IF EXISTS "Users can view own patient profile" ON public.patient_profiles;
DROP POLICY IF EXISTS "Users can update own patient profile" ON public.patient_profiles;
DROP POLICY IF EXISTS "Users can insert own patient profile" ON public.patient_profiles;

CREATE POLICY "Allow all patient profile operations for testing"
    ON public.patient_profiles FOR ALL
    USING (true)
    WITH CHECK (true);