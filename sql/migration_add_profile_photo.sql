-- Migration: Add profile_photo_url column to patient_profiles table
-- Run this in your Supabase SQL editor

-- Add profile_photo_url column to patient_profiles table
ALTER TABLE public.patient_profiles 
ADD COLUMN IF NOT EXISTS profile_photo_url TEXT DEFAULT '';

-- Update the updated_at timestamp
UPDATE public.patient_profiles 
SET updated_at = NOW() 
WHERE profile_photo_url IS NULL;

-- Create a storage bucket for profile photos if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('profile-photos', 'profile-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Set up storage policies for profile photos
CREATE POLICY "Users can upload their own profile photos" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'profile-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own profile photos" ON storage.objects
FOR SELECT USING (bucket_id = 'profile-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can update their own profile photos" ON storage.objects
FOR UPDATE USING (bucket_id = 'profile-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete their own profile photos" ON storage.objects
FOR DELETE USING (bucket_id = 'profile-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow public access to profile photos
CREATE POLICY "Public can view profile photos" ON storage.objects
FOR SELECT USING (bucket_id = 'profile-photos');

COMMENT ON COLUMN public.patient_profiles.profile_photo_url IS 'URL to the patient profile photo in Supabase storage';