# 🔧 Authentication Troubleshooting Guide

## 🚨 Current Issue: Registration and Login Not Working

Since you've successfully run the SQL setup, let's check the most likely causes:

---

## ✅ **Step 1: Verify Supabase Project Settings**

### **Check Email Confirmation Settings:**

1. Go to [Supabase Dashboard](https://supabase.com/dashboard/project/szrxgxvypusvkkyykrjz)
2. Navigate to **Authentication** → **Settings**
3. Look for **"Email confirmation"** setting

**If Email Confirmation is ENABLED:**

- Users must confirm their email before they can sign in
- Check your email inbox for confirmation emails

**If Email Confirmation is DISABLED:**

- Users can sign in immediately after registration

### **Recommended Setting for Testing:**

**Turn OFF email confirmation** for easier testing:

1. Go to Authentication → Settings
2. Find "Enable email confirmations"
3. **Turn it OFF**
4. Save settings

---

## ✅ **Step 2: Check RLS (Row Level Security) Policies**

The profiles table might be blocking inserts. Let's verify:

### **Run this SQL in Supabase SQL Editor:**

```sql
-- Check if the profiles table exists and has proper policies
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'profiles';

-- Check RLS policies for profiles table
SELECT policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'profiles';
```

### **If policies are too restrictive, run this:**

```sql
-- Temporarily allow all operations on profiles (for testing)
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Allow profile creation during signup"
    ON public.profiles FOR INSERT
    WITH CHECK (true);
```

---

## ✅ **Step 3: Test Direct Database Access**

Run this SQL to test if manual insertion works:

```sql
-- Test inserting a profile manually
INSERT INTO public.profiles (id, email, full_name, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'test@example.com',
    'Test User',
    NOW(),
    NOW()
);

-- Check if it was inserted
SELECT * FROM public.profiles WHERE email = 'test@example.com';

-- Clean up test data
DELETE FROM public.profiles WHERE email = 'test@example.com';
```

---

## ✅ **Step 4: Check Supabase Configuration**

Verify your project details are correct:

- **Project URL:** `https://szrxgxvypusvkkyykrjz.supabase.co`
- **Project ID:** `szrxgxvypusvkkyykrjz`

### **Test API Access:**

Visit this URL in your browser:

```
https://szrxgxvypusvkkyykrjz.supabase.co/rest/v1/profiles?select=*
```

Add this header: `apikey: YOUR_ANON_KEY`

You should see either:

- Empty array `[]` (good - table exists but empty)
- Authentication error (check API key)
- 404 error (table doesn't exist)

---

## ✅ **Step 5: Simplify Registration Flow**

Let's modify the registration to not create profiles immediately:

```dart
// Simplified registration - just create auth user
final response = await _supabase.auth.signUp(
  email: trimmedEmail,
  password: password,
  data: {'full_name': trimmedName},
);

// Don't create profile here - let the user sign in first
```

---

## ✅ **Step 6: Enable Debug Logging**

Check the app logs for detailed error messages:

1. Run `flutter run` in terminal
2. Watch for Supabase logs and error messages
3. Look for network errors, authentication errors, or database errors

---

## ✅ **Step 7: Test with Simple Email/Password**

Try registering with:

- **Email:** `test@test.com`
- **Password:** `123456789`
- **Name:** `Test User`

---

## 🎯 **Most Likely Solutions:**

### **Solution 1: Disable Email Confirmation**

This is the #1 most common issue. Email confirmation prevents immediate sign-in.

### **Solution 2: Fix RLS Policies**

Row Level Security might be blocking profile creation.

### **Solution 3: Check API Key**

Verify your anon key is correct and has proper permissions.

---

## 📝 **Next Steps:**

1. **First, check email confirmation settings**
2. **Run the RLS policy check SQL**
3. **Test with simplified registration**
4. **Check debug logs for specific error messages**

Please try these steps and let me know what you find!
