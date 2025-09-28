# 🔐 Dummy Login Credentials - Telemedicine Platform

This file contains test login credentials for demonstrating and testing the Telemedicine Platform.

---

## 📱 Patient Mobile App Credentials

**Phone Number:** `9026508435`  
**Password:** `shaurya`  
**User Type:** Patient

### Login Instructions:

1. Open the patient mobile app (APK available in build folder)
2. Enter phone number: `9026508435`
3. Enter password: `shaurya`
4. Select user type: **Patient**

---

## 👨‍⚕️ Doctor Dashboard Credentials

**Email:** `dr.rahul.sharma@sehatsakhi.com`  
**Password:** `rahul@123`  
**Department:** Cardiology  
**Speciality:** Cardiologist

### Login Instructions:

1. Open doctor dashboard: https://qbit1doctordashboard.vercel.app/
2. Enter email: `dr.rahul.sharma@sehatsakhi.com`
3. Enter password: `rahul@123`
4. Select user type: **Doctor**

### Doctor Profile Details:

- **Name:** Dr. Rahul Sharma
- **Doctor ID:** D000001
- **Phone:** +91-9876543210
- **Qualification:** MBBS, MD (Cardiology)
- **Experience:** 8 years
- **License:** MH/DOC/2024/001
- **Consultation Fee:** ₹1,200
- **Languages:** Hindi, English
- **Status:** Online & Available

---

## 👨‍💼 Admin Panel Credentials

**Note:** Admin credentials may need to be created separately. Contact system administrator for admin access.

**Admin Panel URL:** https://qbit1admin.vercel.app/

---

## 🏥 Pharmacy Dashboard

**Pharmacy Dashboard URL:** https://qbit1pharmacy.vercel.app/

**Note:** Pharmacy credentials may need to be created based on specific pharmacy requirements.

---

## 🌐 Platform URLs

| Service            | URL                                     | Status      |
| ------------------ | --------------------------------------- | ----------- |
| Backend API        | https://telemed18.onrender.com          | ✅ Live     |
| Admin Panel        | https://qbit1admin.vercel.app           | ✅ Deployed |
| Doctor Dashboard   | https://qbit1doctordashboard.vercel.app | ✅ Deployed |
| Pharmacy Dashboard | https://qbit1pharmacy.vercel.app        | ✅ Deployed |

---

## 🔍 Testing Scenarios

### Patient App Testing:

1. **Login:** Use phone `9026508435` and password `shaurya`
2. **Profile:** View and update patient profile
3. **Appointments:** Book appointments with available doctors
4. **Consultations:** Join video calls with doctors
5. **Medical Records:** View prescription history and reports

### Doctor Dashboard Testing:

1. **Login:** Use email `dr.rahul.sharma@sehatsakhi.com` and password `rahul@123`
2. **Profile:** View doctor profile and update availability
3. **Patient Queue:** Manage appointment requests
4. **Consultations:** Conduct video consultations
5. **Prescriptions:** Create and manage patient prescriptions

---

## 📞 Support Information

- **Backend Server:** Hosted on Render.com
- **Database:** MongoDB Atlas (Cloud)
- **Frontend:** Vercel deployment
- **Video Calls:** Agora SDK integration
- **Authentication:** JWT-based secure authentication

---

## ⚠️ Important Notes

1. These are **test credentials** for demonstration purposes only
2. Do not use these credentials in production environment
3. Change all passwords before deploying to production
4. Ensure proper user management and security protocols
5. These credentials are stored in the database with bcrypt encryption

---

## 🛠️ Technical Details

- **Password Encryption:** bcrypt with 12 salt rounds
- **Database:** MongoDB with proper indexing
- **API Security:** JWT tokens with 7-day expiration
- **HTTPS:** All communication secured with SSL/TLS
- **Cross-Platform:** Flutter app supports Android/iOS
- **Real-time:** Socket.IO for instant communication

---

_Last Updated: December 2024_  
_Generated for Telemedicine Platform v1.0_
