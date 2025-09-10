-- TEST SCRIPT FOR SUPABASE DATABASE SETUP
-- Run this to verify all tables and functionality are working correctly

-- Test 1: Check if all tables exist
DO $$
DECLARE
    table_count INTEGER;
BEGIN
    RAISE NOTICE 'Starting TeleMed Database Setup Tests...';
    RAISE NOTICE '==========================================';
    
    -- Check profiles table
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'profiles';
    RAISE NOTICE 'Profiles table exists: %', CASE WHEN table_count > 0 THEN 'YES' ELSE 'NO' END;
    
    -- Check doctors table
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'doctors';
    RAISE NOTICE 'Doctors table exists: %', CASE WHEN table_count > 0 THEN 'YES' ELSE 'NO' END;
    
    -- Check appointments table
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'appointments';
    RAISE NOTICE 'Appointments table exists: %', CASE WHEN table_count > 0 THEN 'YES' ELSE 'NO' END;
    
    -- Check prescriptions table
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'prescriptions';
    RAISE NOTICE 'Prescriptions table exists: %', CASE WHEN table_count > 0 THEN 'YES' ELSE 'NO' END;
    
    -- Check health_records table
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'health_records';
    RAISE NOTICE 'Health records table exists: %', CASE WHEN table_count > 0 THEN 'YES' ELSE 'NO' END;
    
    -- Check notifications table
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'notifications';
    RAISE NOTICE 'Notifications table exists: %', CASE WHEN table_count > 0 THEN 'YES' ELSE 'NO' END;
    
    -- Check app_settings table
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'app_settings';
    RAISE NOTICE 'App settings table exists: %', CASE WHEN table_count > 0 THEN 'YES' ELSE 'NO' END;
END $$;

-- Test 2: Check storage buckets
DO $$
DECLARE
    bucket_count INTEGER;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE 'Storage Buckets Test:';
    RAISE NOTICE '---------------------';
    
    SELECT COUNT(*) INTO bucket_count FROM storage.buckets WHERE id = 'profile-photos';
    RAISE NOTICE 'Profile photos bucket exists: %', CASE WHEN bucket_count > 0 THEN 'YES' ELSE 'NO' END;
    
    SELECT COUNT(*) INTO bucket_count FROM storage.buckets WHERE id = 'medical-documents';
    RAISE NOTICE 'Medical documents bucket exists: %', CASE WHEN bucket_count > 0 THEN 'YES' ELSE 'NO' END;
    
    SELECT COUNT(*) INTO bucket_count FROM storage.buckets WHERE id = 'prescriptions';
    RAISE NOTICE 'Prescriptions bucket exists: %', CASE WHEN bucket_count > 0 THEN 'YES' ELSE 'NO' END;
    
    SELECT COUNT(*) INTO bucket_count FROM storage.buckets WHERE id = 'appointment-attachments';
    RAISE NOTICE 'Appointment attachments bucket exists: %', CASE WHEN bucket_count > 0 THEN 'YES' ELSE 'NO' END;
END $$;

-- Test 3: Check RLS policies
DO $$
DECLARE
    policy_count INTEGER;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE 'Row Level Security (RLS) Test:';
    RAISE NOTICE '-------------------------------';
    
    -- Check if RLS is enabled on key tables
    SELECT COUNT(*) INTO policy_count FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'doctors' AND n.nspname = 'public' AND c.relrowsecurity = true;
    RAISE NOTICE 'RLS enabled on doctors table: %', CASE WHEN policy_count > 0 THEN 'YES' ELSE 'NO' END;
    
    SELECT COUNT(*) INTO policy_count FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'appointments' AND n.nspname = 'public' AND c.relrowsecurity = true;
    RAISE NOTICE 'RLS enabled on appointments table: %', CASE WHEN policy_count > 0 THEN 'YES' ELSE 'NO' END;
    
    SELECT COUNT(*) INTO policy_count FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'prescriptions' AND n.nspname = 'public' AND c.relrowsecurity = true;
    RAISE NOTICE 'RLS enabled on prescriptions table: %', CASE WHEN policy_count > 0 THEN 'YES' ELSE 'NO' END;
END $$;

-- Test 4: Check indexes
DO $$
DECLARE
    index_count INTEGER;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE 'Database Indexes Test:';
    RAISE NOTICE '----------------------';
    
    SELECT COUNT(*) INTO index_count FROM pg_indexes WHERE tablename = 'doctors' AND schemaname = 'public';
    RAISE NOTICE 'Doctors table indexes count: %', index_count;
    
    SELECT COUNT(*) INTO index_count FROM pg_indexes WHERE tablename = 'appointments' AND schemaname = 'public';
    RAISE NOTICE 'Appointments table indexes count: %', index_count;
    
    SELECT COUNT(*) INTO index_count FROM pg_indexes WHERE tablename = 'prescriptions' AND schemaname = 'public';
    RAISE NOTICE 'Prescriptions table indexes count: %', index_count;
END $$;

-- Test 5: Check sample data
DO $$
DECLARE
    doctor_count INTEGER;
    rec RECORD;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE 'Sample Data Test:';
    RAISE NOTICE '-----------------';
    
    SELECT COUNT(*) INTO doctor_count FROM public.doctors;
    RAISE NOTICE 'Sample doctors inserted: %', doctor_count;
    
    IF doctor_count > 0 THEN
        RAISE NOTICE 'Sample doctor specializations:';
        FOR rec IN SELECT DISTINCT specialization FROM public.doctors LOOP
            RAISE NOTICE '  - %', rec.specialization;
        END LOOP;
    END IF;
END $$;

-- Test 6: Verify table structure for key fields
DO $$
DECLARE
    column_count INTEGER;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE 'Table Structure Verification:';
    RAISE NOTICE '-----------------------------';
    
    -- Check profiles table for medical fields
    SELECT COUNT(*) INTO column_count FROM information_schema.columns 
    WHERE table_name = 'profiles' AND column_name IN ('medical_history', 'current_medications', 'allergies', 'blood_group');
    RAISE NOTICE 'Profiles table medical fields: % out of 4', column_count;
    
    -- Check doctors table key fields
    SELECT COUNT(*) INTO column_count FROM information_schema.columns 
    WHERE table_name = 'doctors' AND column_name IN ('specialization', 'license_number', 'consultation_fee', 'working_hours');
    RAISE NOTICE 'Doctors table key fields: % out of 4', column_count;
    
    -- Check appointments table key fields
    SELECT COUNT(*) INTO column_count FROM information_schema.columns 
    WHERE table_name = 'appointments' AND column_name IN ('patient_id', 'doctor_id', 'appointment_date', 'status');
    RAISE NOTICE 'Appointments table key fields: % out of 4', column_count;
    
    -- Check prescriptions table key fields
    SELECT COUNT(*) INTO column_count FROM information_schema.columns 
    WHERE table_name = 'prescriptions' AND column_name IN ('patient_id', 'doctor_id', 'medications', 'diagnosis');
    RAISE NOTICE 'Prescriptions table key fields: % out of 4', column_count;
END $$;

-- Test completion message
DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Database Setup Tests Completed!';
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'If all tests show positive results, your';
    RAISE NOTICE 'TeleMed Supabase database is ready to use.';
    RAISE NOTICE '';
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '1. Run comprehensive_supabase_setup.sql in your Supabase SQL editor';
    RAISE NOTICE '2. Update your Flutter app environment variables';
    RAISE NOTICE '3. Test authentication and basic CRUD operations';
    RAISE NOTICE '4. Verify storage bucket access from your app';
END $$;