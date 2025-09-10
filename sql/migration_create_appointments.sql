-- Migration: Create appointments table
-- Run this in your Supabase SQL editor

-- Create appointments table
CREATE TABLE IF NOT EXISTS public.appointments (
    id TEXT PRIMARY KEY,
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    doctor_id TEXT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'in_progress')),
    notes TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add missing columns if they don't exist
DO $$
BEGIN
    -- Add doctor_name column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'appointments' 
                   AND column_name = 'doctor_name') THEN
        ALTER TABLE public.appointments ADD COLUMN doctor_name TEXT NOT NULL DEFAULT '';
    END IF;
    
    -- Add doctor_specialization column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'appointments' 
                   AND column_name = 'doctor_specialization') THEN
        ALTER TABLE public.appointments ADD COLUMN doctor_specialization TEXT NOT NULL DEFAULT '';
    END IF;
    
    -- Add consultation_fee column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'appointments' 
                   AND column_name = 'consultation_fee') THEN
        ALTER TABLE public.appointments ADD COLUMN consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00;
    END IF;
    
    -- Add notes column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'appointments' 
                   AND column_name = 'notes') THEN
        ALTER TABLE public.appointments ADD COLUMN notes TEXT;
    END IF;
END $$;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON public.appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON public.appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON public.appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON public.appointments(status);

-- Enable Row Level Security (RLS)
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own appointments" ON public.appointments
    FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Users can insert their own appointments" ON public.appointments
    FOR INSERT WITH CHECK (auth.uid() = patient_id);

CREATE POLICY "Users can update their own appointments" ON public.appointments
    FOR UPDATE USING (auth.uid() = patient_id);

CREATE POLICY "Users can delete their own appointments" ON public.appointments
    FOR DELETE USING (auth.uid() = patient_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_appointments_updated_at ON public.appointments;
CREATE TRIGGER update_appointments_updated_at 
    BEFORE UPDATE ON public.appointments 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE public.appointments IS 'Table storing patient appointments with doctors';
COMMENT ON COLUMN public.appointments.id IS 'Unique appointment identifier';
COMMENT ON COLUMN public.appointments.patient_id IS 'Reference to the patient user';
COMMENT ON COLUMN public.appointments.doctor_id IS 'Reference to the doctor';
COMMENT ON COLUMN public.appointments.doctor_name IS 'Doctor name for quick access';
COMMENT ON COLUMN public.appointments.doctor_specialization IS 'Doctor specialization for quick access';
COMMENT ON COLUMN public.appointments.appointment_date IS 'Date of the appointment';
COMMENT ON COLUMN public.appointments.appointment_time IS 'Time of the appointment';
COMMENT ON COLUMN public.appointments.status IS 'Appointment status (scheduled, completed, cancelled, in_progress)';
COMMENT ON COLUMN public.appointments.notes IS 'Optional notes from patient';
COMMENT ON COLUMN public.appointments.consultation_fee IS 'Fee for the consultation';