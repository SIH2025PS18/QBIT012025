# Video Consultation Platform - Complete Setup Guide

## 🏗️ Architecture Overview

### Recommended Approach:

1. **Patient Mobile App** (Flutter) - Android/iOS for patients
2. **Doctor Web Dashboard** (Flutter Web) - Browser-based for doctors
3. **Video SDK Integration** - Agora, Jitsi Meet, or WebRTC
4. **Backend** - Supabase with real-time features

---

## 📱 1. Mobile App Setup (Patients)

### Dependencies (pubspec.yaml):

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  supabase_flutter: ^2.5.6
  uuid: ^4.4.0

  # Choose one video SDK:
  agora_rtc_engine: ^6.3.2 # Recommended
  # jitsi_meet_flutter_sdk: ^10.2.0   # Alternative
  # flutter_webrtc: ^0.9.48           # WebRTC
```

### Android Permissions (android/app/src/main/AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS Permissions (ios/Runner/Info.plist):

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for video consultations</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for video consultations</string>
```

---

## 🌐 2. Web Dashboard Setup (Doctors)

### Build for Web:

```bash
flutter build web --release
```

### Web-specific considerations:

- Ensure HTTPS for camera/microphone access
- Test on Chrome, Firefox, Safari
- Optimize for desktop screen sizes
- Add responsive breakpoints

### Deploy to hosting:

```bash
# Firebase Hosting
firebase deploy --only hosting

# Vercel
vercel --prod

# Netlify
netlify deploy --prod --dir build/web
```

---

## 🎥 3. Video SDK Integration

### Option A: Agora (Recommended)

```dart
// Add to pubspec.yaml
agora_rtc_engine: ^6.3.2

// Initialize in video_call_screen.dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: 'YOUR_AGORA_APP_ID',
    ));

    await _engine.joinChannel(
      token: widget.consultation.sessionToken,
      channelId: widget.consultation.roomId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }
}
```

### Option B: Jitsi Meet

```dart
// Add to pubspec.yaml
jitsi_meet_flutter_sdk: ^10.2.0

// Use in video_call_screen.dart
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

final jitsiMeet = JitsiMeet();

await jitsiMeet.join(JitsiMeetConferenceOptions(
  serverURL: "https://meet.jit.si",
  room: widget.consultation.roomId,
  configOverrides: {
    "startWithAudioMuted": false,
    "startWithVideoMuted": false,
  },
));
```

---

## 🗄️ 4. Database Setup (Supabase)

### Create Tables:

```sql
-- Video consultations table
CREATE TABLE video_consultations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id VARCHAR NOT NULL,
  patient_id VARCHAR NOT NULL,
  doctor_id VARCHAR NOT NULL,
  patient_name VARCHAR NOT NULL,
  doctor_name VARCHAR NOT NULL,
  patient_avatar_url VARCHAR,
  doctor_avatar_url VARCHAR,
  status VARCHAR NOT NULL DEFAULT 'scheduled',
  priority VARCHAR NOT NULL DEFAULT 'normal',
  scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
  started_at TIMESTAMP WITH TIME ZONE,
  ended_at TIMESTAMP WITH TIME ZONE,
  duration INTERVAL,
  room_id VARCHAR,
  session_token VARCHAR,
  participants JSONB DEFAULT '[]'::jsonb,
  queue_position JSONB,
  rating JSONB,
  feedback TEXT,
  prescription TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Chat messages table
CREATE TABLE consultation_chat (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  consultation_id UUID REFERENCES video_consultations(id),
  sender_id VARCHAR NOT NULL,
  sender_name VARCHAR NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_video_consultations_patient ON video_consultations(patient_id);
CREATE INDEX idx_video_consultations_doctor ON video_consultations(doctor_id);
CREATE INDEX idx_video_consultations_status ON video_consultations(status);
CREATE INDEX idx_consultation_chat_consultation ON consultation_chat(consultation_id);
```

### Enable Real-time:

```sql
-- Enable real-time for live updates
ALTER PUBLICATION supabase_realtime ADD TABLE video_consultations;
ALTER PUBLICATION supabase_realtime ADD TABLE consultation_chat;
```

### Row Level Security:

```sql
-- Enable RLS
ALTER TABLE video_consultations ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultation_chat ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their consultations" ON video_consultations
  FOR SELECT USING (auth.uid()::text = patient_id OR auth.uid()::text = doctor_id);

CREATE POLICY "Users can update their consultations" ON video_consultations
  FOR UPDATE USING (auth.uid()::text = patient_id OR auth.uid()::text = doctor_id);
```

---

## 🚀 5. Deployment Strategy

### Mobile App (Flutter):

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
# Then archive and upload via Xcode
```

### Web Dashboard:

```bash
# Build
flutter build web --release --web-renderer canvaskit

# Deploy to Firebase
firebase init hosting
firebase deploy

# Or deploy to Vercel/Netlify
```

### Backend (Supabase):

- Set up production Supabase project
- Configure authentication
- Set up database tables and policies
- Configure storage for file uploads

---

## 🔧 6. Configuration

### Environment Variables:

```dart
// lib/config/app_config.dart
class AppConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const String agoraAppId = 'YOUR_AGORA_APP_ID';

  // Different configs for dev/prod
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
}
```

### Build Flavors:

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

---

## 📋 7. Testing Strategy

### Unit Tests:

```dart
// test/services/video_consultation_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:telemed/services/video_consultation_service.dart';

void main() {
  group('VideoConsultationService', () {
    test('should create consultation', () async {
      // Test consultation creation
    });

    test('should manage queue properly', () async {
      // Test queue management
    });
  });
}
```

### Integration Tests:

```dart
// integration_test/video_consultation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete video consultation flow', (tester) async {
    // Test full consultation workflow
  });
}
```

---

## 🔒 8. Security Considerations

### Video Security:

- Use secure tokens for room access
- Implement room expiration
- Add participant validation
- Enable end-to-end encryption (if supported by SDK)

### Data Security:

- HTTPS for all API calls
- Encrypt sensitive data at rest
- Implement proper authentication
- Follow HIPAA compliance (for healthcare)

### Privacy:

- Clear data retention policies
- User consent for recording
- Secure file storage
- Regular security audits

---

## 📊 9. Monitoring & Analytics

### Performance Monitoring:

```dart
// Add to pubspec.yaml
firebase_crashlytics: ^3.4.18
firebase_analytics: ^10.8.9

// Track video call quality
FirebaseAnalytics.instance.logEvent(
  name: 'video_call_ended',
  parameters: {
    'duration': callDuration.inMinutes,
    'quality_rating': qualityRating,
    'connection_issues': connectionIssues,
  },
);
```

### Error Tracking:

```dart
// Report errors to Crashlytics
FirebaseCrashlytics.instance.recordError(
  exception,
  stackTrace,
  reason: 'Video call error',
);
```

---

## 🚀 10. Production Checklist

### Before Launch:

- [ ] Video SDK properly integrated and tested
- [ ] Database tables created with proper indexes
- [ ] Real-time subscriptions working
- [ ] Authentication flow completed
- [ ] Push notifications configured
- [ ] Error handling implemented
- [ ] Performance optimized
- [ ] Security measures in place
- [ ] HIPAA compliance (if required)
- [ ] Load testing completed

### Post Launch:

- [ ] Monitor crash reports
- [ ] Track video call quality metrics
- [ ] Monitor database performance
- [ ] User feedback collection
- [ ] Regular security updates
- [ ] Backup and disaster recovery plan

---

## 📞 Support & Resources

### Video SDK Documentation:

- [Agora Flutter SDK](https://docs.agora.io/en/video-calling/develop/get-started-sdk?platform=flutter)
- [Jitsi Meet Flutter](https://pub.dev/packages/jitsi_meet_flutter_sdk)
- [WebRTC Flutter](https://pub.dev/packages/flutter_webrtc)

### Backend Resources:

- [Supabase Docs](https://supabase.com/docs)
- [Real-time Subscriptions](https://supabase.com/docs/guides/realtime)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

This setup provides a complete, production-ready video consultation platform with queue management, waiting rooms, and doctor dashboards. The architecture is scalable and can handle multiple concurrent consultations.
