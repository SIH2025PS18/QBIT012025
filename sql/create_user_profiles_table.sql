-- Create user_profiles table for phone-based authentication
-- This table will replace the dependency on Supabase auth for phone numbers

CREATE TABLE IF NOT EXISTS user_profiles (
    id TEXT PRIMARY KEY,
    phone_number TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT NULL,
    date_of_birth DATE NULL,
    gender TEXT NULL,
    blood_group TEXT NULL,
    address TEXT NULL,
    emergency_contact TEXT NULL,
    emergency_contact_phone TEXT NULL,
    profile_image_url TEXT NULL,
    medical_history TEXT NULL,
    allergies TEXT[] DEFAULT '{}',
    current_medications TEXT[] DEFAULT '{}',
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster phone number lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_phone ON user_profiles(phone_number);
CREATE INDEX IF NOT EXISTS idx_user_profiles_active ON user_profiles(is_active);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_user_profiles_updated_at ON user_profiles;
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add Row Level Security (RLS)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to read their own data
CREATE POLICY "Users can read own profile" ON user_profiles
    FOR SELECT USING (true); -- Allow read for now, can be restricted later

-- Create policy to allow users to update their own data
CREATE POLICY "Users can update own profile" ON user_profiles
    FOR UPDATE USING (true); -- Allow update for now, can be restricted later

-- Create policy to allow user registration
CREATE POLICY "Allow user registration" ON user_profiles
    FOR INSERT WITH CHECK (true); -- Allow insert for registration
