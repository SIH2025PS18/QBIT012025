# 🚀 Quick Start - Agora Video Consultation Platform

## ✅ READY TO RUN!

Your complete video consultation platform is now **fully integrated with Agora SDK**. Here's how to get started in 5 minutes:

---

## 🎯 Step 1: Get Agora Credentials (2 minutes)

1. **Sign up at [Agora Console](https://console.agora.io/)**
2. **Create a new project**
3. **Copy your App ID**
4. **Update configuration:**

```dart
// lib/config/agora_config.dart
static const String appId = 'PASTE_YOUR_AGORA_APP_ID_HERE';
```

---

## 🛠️ Step 2: Setup Backend (1 minute)

1. **Create Supabase project** at [supabase.com](https://supabase.com)
2. **Update credentials:**

```dart
// lib/main.dart
await Supabase.initialize(
  url: 'PASTE_YOUR_SUPABASE_URL_HERE',
  anonKey: 'PASTE_YOUR_SUPABASE_ANON_KEY_HERE',
);
```

3. **Create database tables** (copy from [SETUP_GUIDE.md](SETUP_GUIDE.md))

---

## 📱 Step 3: Install & Run (2 minutes)

```bash
# Install dependencies
flutter pub get

# Run on mobile (patients)
flutter run

# Run on web (doctors)
flutter run -d chrome --web-renderer canvaskit
```

---

## 🎉 You're Done!

### **What Works:**

- ✅ **HD Video Calls** powered by Agora
- ✅ **Queue Management** with priority system
- ✅ **Virtual Waiting Rooms** with real-time updates
- ✅ **Doctor Dashboard** (web-optimized)
- ✅ **Patient Mobile App** (Android/iOS)
- ✅ **Multi-participant Support** (up to 17 users)
- ✅ **Real-time Chat** during consultations
- ✅ **Audio/Video Controls** (mute, camera, speaker)

### **How to Test:**

1. **Open two devices/browsers**
2. **One as Doctor** (`/doctor` route)
3. **One as Patient** (`/patient` route)
4. **Patient joins queue** → **Doctor starts consultation** → **Video call begins!**

---

## 🔧 Optional Customizations

### **Change Video Quality:**

```dart
// lib/config/agora_config.dart
static const VideoDimensions videoDimensions = VideoDimensions(width: 1280, height: 720); // HD
static const int videoBitrate = 1000; // High quality
```

### **Customize UI Colors:**

```dart
// lib/main.dart - Update MaterialApp theme
theme: ThemeData(
  primarySwatch: Colors.green, // Your brand color
  useMaterial3: true,
),
```

### **Add Your Branding:**

- Update app name in `pubspec.yaml`
- Replace icons in `android/app/src/main/res/` and `ios/Runner/Assets.xcassets/`
- Update display names in `AndroidManifest.xml` and `Info.plist`

---

## 📊 Production Deployment

### **Mobile Apps:**

```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release
# Then archive in Xcode
```

### **Web Dashboard:**

```bash
flutter build web --release --web-renderer canvaskit
# Deploy to Firebase/Vercel/Netlify
```

---

## 🆘 Need Help?

### **Common Issues:**

- **"App ID not found"** → Update `agora_config.dart`
- **"Permission denied"** → Check camera/mic permissions
- **"Cannot connect"** → Verify internet connection
- **Database errors** → Check Supabase setup

### **Documentation:**

- [Full Setup Guide](SETUP_GUIDE.md)
- [Agora Integration Details](AGORA_INTEGRATION.md)
- [API Documentation](https://docs.agora.io/en/)

---

## 🎊 Congratulations!

You now have a **professional-grade telemedicine platform** with:

- **Enterprise video quality** (Agora-powered)
- **Scalable architecture** (Flutter + Supabase)
- **Cross-platform support** (Mobile + Web)
- **Production-ready features**

**Start connecting patients and doctors today! 🏥👩‍⚕️👨‍⚕️**
