# Phone Authentication Test Guide

## Setup Instructions

1. **Database Setup**:

   - Run the `sql/phone_auth_setup.sql` script in your Supabase SQL editor
   - This will add the necessary fields and tables for phone authentication

2. **Enable Phone Authentication**:

   - Go to your Supabase project dashboard
   - Navigate to Authentication → Providers
   - Enable Phone provider
   - Configure Twilio integration (for production)

3. **For Testing Purposes**:
   - The current implementation uses a simplified approach for demo
   - In a real application, you would integrate with Twilio or similar SMS service

## Test Flow

### 1. Phone Registration

1. Open the app
2. Go to Login Screen
3. Click "Sign Up"
4. Enter phone number and full name
5. Click "Create Account"
6. If successful, you'll be taken to verification dialog
7. Enter OTP (use any 6-digit number for demo)
8. Click "Verify"
9. You should be navigated to NabhaHomeScreen

### 2. Phone Login

1. Open the app
2. Go to Login Screen
3. Click "Sign in with Phone"
4. Enter your registered phone number
5. Click "Send OTP"
6. Enter OTP (use any 6-digit number for demo)
7. Click "Verify OTP"
8. You should be navigated to NabhaHomeScreen

## Test Phone Numbers

- Use a valid format: +91XXXXXXXXXX (for India) or +1XXXXXXXXXX (for US)
- For testing, you can use: +13334445555 or +919876543210

## SQL Queries for Testing

```sql
-- Check if a user exists with a phone number
SELECT * FROM profiles WHERE phone_number = '+13334445555';

-- Manually verify a phone number (for testing)
UPDATE profiles SET phone_verified = true WHERE phone_number = '+13334445555';

-- Check OTP attempts
SELECT * FROM otp_attempts WHERE phone_number = '+13334445555';

-- Clean up expired OTPs
SELECT cleanup_expired_otps();
```

## Troubleshooting

### Common Issues:

1. **"No account found" error**: Make sure you've registered with that phone number first
2. **OTP verification failed**: For demo purposes, any 6-digit number should work
3. **Database errors**: Ensure you've run the phone_auth_setup.sql script

### Debugging Steps:

1. Check Supabase logs in the dashboard
2. Verify database schema matches expected structure
3. Ensure proper RLS policies are in place
4. Check network connectivity to Supabase

## Production Considerations

1. **Twilio Integration**:

   - Set up Twilio account
   - Configure Twilio Message Service SID in Supabase
   - Add Twilio credentials to Supabase Auth settings

2. **Security Enhancements**:

   - Implement rate limiting for OTP requests
   - Add expiration times for OTPs
   - Use proper hashing for OTP storage

3. **User Experience**:
   - Add proper loading states
   - Implement resend OTP functionality
   - Add proper error messaging
