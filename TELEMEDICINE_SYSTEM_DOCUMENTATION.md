# Telemedicine System with Video Calling Integration

## Project Overview

This is a complete telemedicine system with Flutter admin panel, video calling capabilities using Agora SDK, and comprehensive patient management features.

## Features Implemented

### 1. Admin Panel (`admin_panel` folder)

- **Hospital Admin Dashboard**: Real-time statistics and doctor management
- **Doctor Management**: Add, edit, delete doctors with real-time updates
- **Doctor Dashboard**: Complete video consultation interface for doctors
- **Real-time Synchronization**: Socket.IO integration for live updates
- **Video Call Integration**: Agora SDK for doctor-patient video consultations

### 2. Video Calling System

- **Agora SDK Integration**: Professional video calling infrastructure
- **Doctor Dashboard**: Patient queue with video call initiation
- **Patient Record Sidebar**: Real-time access to patient information during calls
- **Call Controls**: Video/audio toggle, call end functionality
- **Session Management**: Complete video call session tracking

### 3. Patient Management

- **Patient Records**: Comprehensive medical history and information
- **Appointment System**: Scheduling and management
- **Video Consultation**: Patient-side video calling interface
- **Medical History**: Previous consultations and prescriptions

## Architecture

### Backend API

- **Base URL**: `https://telemed18.onrender.com/api`
- **Real-time Updates**: Socket.IO for live synchronization
- **Video Session Management**: Agora token generation and session handling

### Frontend Structure

```
admin_panel/
├── lib/
│   ├── models/
│   │   ├── video_call.dart           # Video call data models
│   │   ├── doctor.dart               # Doctor model
│   │   └── patient.dart              # Patient model
│   ├── services/
│   │   ├── agora_service.dart        # Agora SDK integration
│   │   ├── video_call_service.dart   # Video call management
│   │   ├── admin_service.dart        # Admin panel API calls
│   │   └── websocket_service.dart    # Real-time communication
│   ├── screens/
│   │   ├── doctor_dashboard_screen.dart # Main doctor interface
│   │   ├── admin_dashboard_screen.dart  # Admin panel
│   │   └── doctor_management_screen.dart # Doctor CRUD operations
│   └── widgets/
│       ├── video_call_widget.dart    # Video calling interface
│       └── sidebar.dart              # Navigation sidebar
```

## Video Calling Features

### Doctor Dashboard

- **Patient Queue**: Today's appointments with real-time status
- **Video Call Interface**: Full-screen video with patient record sidebar
- **Patient Information**: Complete medical history, allergies, medications
- **Call Controls**: Professional video calling interface
- **Consultation Recording**: Session tracking and notes

### Patient Side (Mobile App)

- **Video Call Interface**: Patient-side video calling
- **Medical Record Access**: View own medical history
- **Appointment Scheduling**: Book consultations with doctors
- **Real-time Notifications**: Appointment reminders and updates

## Technical Implementation

### Video Call Models

```dart
// VideoCallSession - Main video call session
class VideoCallSession {
  final String sessionId;
  final String channelName;
  final String token;
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final VideoCallStatus status;
  final DateTime startTime;
  final DateTime? endTime;
}

// Appointment - Patient appointment data
class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String patientName;
  final String doctorName;
  final DateTime scheduledTime;
  final AppointmentStatus status;
  final String reason;
  final String? symptoms;
}

// PatientRecord - Complete medical information
class PatientRecord {
  final String id;
  final String patientId;
  final String patientName;
  final int age;
  final String gender;
  final List<String> allergies;
  final List<String> medications;
  final List<String> medicalHistory;
  final List<Consultation> consultations;
}
```

### Video Call Service

```dart
class VideoCallService {
  // Initialize video call session
  Future<VideoCallSession?> initializeCall({
    required String appointmentId,
    required String doctorId,
    required String patientId,
  });

  // Start video call with Agora
  Future<bool> startCall({
    required VideoCallSession session,
    required bool isDoctor,
    required int uid,
  });

  // End video call and update backend
  Future<bool> endCall(String sessionId);

  // Get doctor appointments
  Future<List<Appointment>> getDoctorAppointments(String doctorId);

  // Get patient medical record
  Future<PatientRecord?> getPatientRecord(String patientId);
}
```

### Agora Integration

```dart
class AgoraVideoService {
  // Initialize Agora SDK
  Future<bool> initialize();

  // Join video channel
  Future<bool> joinChannel({
    required String channelName,
    required String token,
    required int uid,
    bool isDoctor = true,
  });

  // Video/audio controls
  Future<void> toggleVideo(bool enabled);
  Future<void> toggleAudio(bool enabled);

  // Leave channel and cleanup
  Future<void> leaveChannel();
}
```

## Setup Instructions

### 1. Admin Panel Setup

```bash
cd admin_panel
flutter pub get
flutter run -d chrome
```

### 2. Agora Configuration

1. Get Agora App ID from [Agora Console](https://console.agora.io/)
2. Update `lib/services/agora_service.dart`:
   ```dart
   static const String appId = 'YOUR_AGORA_APP_ID';
   ```

### 3. Backend Integration

Update API endpoints in services to match your backend:

- `admin_service.dart` - Admin panel APIs
- `video_call_service.dart` - Video calling APIs

### 4. Dependencies

Key dependencies in `pubspec.yaml`:

```yaml
dependencies:
  agora_rtc_engine: ^6.5.2
  permission_handler: ^11.4.0
  socket_io_client: ^2.0.3+1
  http: ^1.1.0
  provider: ^6.1.2
  fl_chart: ^0.65.0
  file_picker: ^6.2.1
  image_picker: ^1.0.7
```

## Usage Workflow

### Doctor Workflow

1. **Login**: Access doctor dashboard from admin panel
2. **View Queue**: See today's appointments and patient list
3. **Start Video Call**: Click "Start Call" for scheduled appointments
4. **Consultation**: Video call with patient record sidebar
5. **Record Notes**: Add consultation notes and prescriptions
6. **End Call**: Complete session and update patient record

### Patient Workflow (Mobile App)

1. **Schedule Appointment**: Book consultation with available doctor
2. **Join Video Call**: Connect when doctor initiates call
3. **Consultation**: Video consultation with doctor
4. **View Records**: Access medical history and prescriptions
5. **Follow-up**: Schedule follow-up appointments

### Admin Workflow

1. **Manage Doctors**: Add/edit doctor profiles and specializations
2. **Monitor System**: View real-time statistics and usage
3. **Patient Management**: Access patient records and history
4. **System Configuration**: Manage departments and settings

## API Endpoints

### Video Calling

- `POST /video-calls/initialize` - Initialize video session
- `PATCH /video-calls/{id}/status` - Update call status
- `PATCH /video-calls/{id}/end` - End video call
- `POST /agora/token` - Generate Agora token

### Appointments

- `GET /appointments/doctor/{doctorId}` - Get doctor appointments
- `POST /appointments` - Create new appointment
- `PATCH /appointments/{id}` - Update appointment

### Patient Records

- `GET /patients/{id}/record` - Get patient medical record
- `POST /consultations` - Create consultation record
- `GET /consultations/patient/{id}` - Get patient consultations

## Development Notes

### Current Status

- ✅ Admin panel with real-time doctor management
- ✅ Video call models and data structures
- ✅ Agora SDK integration (service layer)
- ✅ Doctor dashboard with patient queue
- ✅ Video calling interface with patient records
- ✅ Backend service integration
- 🔄 Agora SDK web compatibility (in progress)
- ⏳ Mobile app video calling integration
- ⏳ Complete backend API implementation

### Known Issues

1. **Agora Web Support**: Agora SDK has limitations on web browsers
2. **Permission Handling**: Camera/microphone permissions need proper handling
3. **Mobile Integration**: Patient-side mobile app needs video calling implementation

### Next Steps

1. **Complete Agora Web Integration**: Implement web-compatible video calling
2. **Mobile App Integration**: Add video calling to patient mobile app
3. **Backend Development**: Complete API implementation for video sessions
4. **Testing**: Comprehensive testing of video calling functionality
5. **Deployment**: Deploy admin panel and configure production environment

## Security Considerations

### Video Calling Security

- Agora token-based authentication
- Session-based access control
- Encrypted video/audio streams
- Time-limited video sessions

### Data Protection

- Patient medical data encryption
- HIPAA compliance considerations
- Secure API communication
- Access logging and monitoring

## Performance Optimization

### Video Quality

- Adaptive bitrate based on network conditions
- Video resolution optimization
- Audio quality enhancement
- Network connectivity handling

### System Performance

- Real-time updates optimization
- Database query optimization
- Frontend state management
- Caching strategies

This telemedicine system provides a complete foundation for video-based medical consultations with comprehensive patient management and real-time synchronization between admin panel and patient applications.
