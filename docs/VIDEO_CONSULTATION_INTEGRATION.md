# Telemedicine Video Consultation Integration Guide

## Overview

This integration connects the Flutter mobile app with a web-based doctor dashboard for seamless video consultations using WebRTC and socket.io for real-time communication.

## Architecture

```
┌─────────────────┐    WebSocket    ┌─────────────────┐    HTTP/WebSocket    ┌─────────────────┐
│                 │ ◄──────────────► │                 │ ◄──────────────────► │                 │
│  Flutter App    │                 │  Signal Server  │                     │ Doctor Dashboard│
│   (Patient)     │                 │   (Node.js)     │                     │    (React)      │
│                 │                 │                 │                     │                 │
└─────────────────┘                 └─────────────────┘                     └─────────────────┘
        │                                   │                                         │
        │                             ┌─────▼─────┐                                 │
        │                             │           │                                 │
        └─────────────────────────────► Agora SDK ◄─────────────────────────────────┘
                                      │           │
                                      └───────────┘
```

## Components

### 1. WebRTC Signaling Server (Node.js + Express + Socket.io)

- **Location**: `web_dashboards/webrtc-signal/`
- **Port**: 4000
- **Features**:
  - Real-time signaling for WebRTC connections
  - User registration and role management
  - Consultation room management
  - Prescription and chat message forwarding
  - Call recording event coordination

### 2. Doctor Dashboard (React + Vite + Ant Design)

- **Location**: `web_dashboards/doctor-dashboard/`
- **Port**: 5173
- **Features**:
  - Patient queue management
  - Video call initiation and controls
  - Prescription writing and submission
  - Real-time patient notifications
  - Call recording controls

### 3. Flutter Mobile App (Patient Side)

- **Main Integration Files**:
  - `lib/services/socket_service.dart` - Socket.io client service
  - `lib/screens/video_call_request_screen.dart` - Incoming call handling
  - `lib/screens/video_call_screen.dart` - Enhanced video call with socket integration
  - `lib/widgets/video_consultation_widget.dart` - Quick access widget

## Setup Instructions

### Prerequisites

- Node.js (v18+)
- Flutter SDK
- Android/iOS device or emulator
- Camera and microphone permissions

### 1. Start Backend Services

#### Option A: Using the batch script (Windows)

```bash
# Run from project root
start_services.bat
```

#### Option B: Manual startup

```bash
# Terminal 1: Start signaling server
cd web_dashboards/webrtc-signal
npm install
node server/index.js

# Terminal 2: Start doctor dashboard
cd web_dashboards/doctor-dashboard
npm install
npm run dev
```

### 2. Configure Flutter App

Add the video consultation widget to your main app screen and ensure patient bookings sync with doctor dashboard:

```dart
import 'package:flutter/material.dart';
import 'widgets/telemedicine_integration_widget.dart';

class HomeScreen extends StatelessWidget {
  final String patientId = 'p1'; // Replace with actual patient ID
  final String patientName = 'John Doe'; // Replace with actual patient name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Telemedicine App')),
      body: Column(
        children: [
          // Your existing widgets...

          // Comprehensive telemedicine integration widget
          TeleMedicineIntegrationWidget(
            patientId: patientId,
            patientName: patientName,
          ),

          // More widgets...
        ],
      ),
    );
  }
}
```

#### Features of the Integration Widget:

- **Real-time Connection Status**: Shows if connected to doctor dashboard
- **Appointment Booking**: Book appointments that appear immediately in doctor dashboard
- **Video Call Ready**: Notify doctors when ready for consultation
- **Automatic Call Handling**: Receives and handles incoming video calls from doctors
- **Appointment Management**: View and manage existing appointments

### 3. Patient Booking to Doctor Dashboard Flow

The integration ensures that when a patient books an appointment in the Flutter app:

1. **Local Storage**: Appointment is saved locally using existing `AppointmentService`
2. **Doctor Dashboard Sync**: Appointment is sent to the signaling server via `AppointmentBookingService`
3. **Real-time Updates**: Doctor dashboard receives instant notification via WebSocket
4. **Queue Management**: Patient appears in doctor's queue with all relevant information
5. **Status Updates**: Both patient and doctor see real-time status changes

````

### 3. Test the Integration

#### Step 1: Launch Doctor Dashboard
1. Open browser to `http://localhost:5173`
2. Navigate to `/doctor` route
3. You should see the doctor dashboard with patient queue

#### Step 2: Launch Flutter App
1. Run `flutter run` to start the mobile app
2. Navigate to the video consultation widget
3. Tap "Join Video Consultation"
4. You should see "Connected" status

#### Step 3: Initiate Video Call
1. In doctor dashboard, select a patient from queue
2. Click "Start Consultation" button
3. The Flutter app should automatically receive the call request
4. Accept the call to start video consultation

## Features

### Real-time Communication
- **Patient Registration**: Automatic registration when app opens
- **Call Notifications**: Instant notifications when doctor starts consultation
- **Status Updates**: Real-time connection status updates

### Video Call Features
- **Auto-accept**: Patient app automatically joins when doctor starts call
- **Controls**: Mute/unmute, video on/off, speaker toggle
- **Recording**: Call recording with consent (coordinated between platforms)
- **Chat**: Real-time text chat during consultation

### Prescription System
- **Digital Prescriptions**: Doctors can write and send prescriptions
- **Real-time Delivery**: Prescriptions appear immediately in patient app
- **Quick Templates**: Common medications for faster prescription writing

## Testing Scenarios

### Scenario 1: Basic Video Call
1. Start both services
2. Open doctor dashboard and Flutter app
3. Doctor selects patient and starts consultation
4. Patient accepts call
5. Verify video/audio connection
6. End call from either side

### Scenario 2: Prescription Flow
1. During video call, doctor opens prescription form
2. Doctor adds medications and notes
3. Doctor submits prescription
4. Verify prescription appears in patient app

### Scenario 3: Recording Features
1. Start video call
2. Doctor enables recording
3. Verify recording indicators on both sides
4. Stop recording
5. Verify recording stopped notifications

## Configuration

### Environment Variables

#### Doctor Dashboard (.env)
```env
VITE_API_URL=http://localhost:4000
VITE_DOCTOR_ID=doctor-1
VITE_DOCTOR_NAME=Dr. Sarah Wilson
VITE_VIDEO_ENABLED=true
VITE_AUDIO_ENABLED=true
VITE_RECORDING_ENABLED=true
````

#### Flutter App

Update socket service URL in `socket_service.dart`:

```dart
await _socketService.initialize(
  serverUrl: 'http://your-server-url:4000', // Change for production
  userId: widget.userId,
  userRole: widget.isDoctor ? 'doctor' : 'patient',
);
```

## Troubleshooting

### Common Issues

#### 1. Connection Failed

- **Symptom**: "Failed to connect" in Flutter app
- **Solution**: Ensure signaling server is running on port 4000
- **Check**: `http://localhost:4000/queue` should return JSON

#### 2. Video Call Not Starting

- **Symptom**: No call notification in Flutter app
- **Solution**: Check browser console and Flutter debug logs
- **Verify**: Socket connections are established

#### 3. No Audio/Video

- **Symptom**: Black screen or no audio
- **Solution**: Check camera/microphone permissions
- **Verify**: Agora SDK is properly initialized

### Debug Tools

#### Flutter Debug Commands

```bash
# Check socket connection
flutter logs | grep -i socket

# Check Agora status
flutter logs | grep -i agora
```

#### Browser Debug

1. Open developer tools (F12)
2. Check console for socket connection status
3. Network tab to verify API calls

## Production Deployment

### 1. Update URLs

Replace `localhost:4000` with your production server URL in:

- `socket_service.dart`
- `.env` file in doctor dashboard

### 2. Security Considerations

- Enable HTTPS for production
- Add authentication for doctor dashboard
- Implement proper token validation
- Set up CORS properly for production domains

### 3. Scaling

- Use Redis for socket session management
- Implement load balancing for multiple servers
- Add database persistence for prescriptions and call logs

## API Endpoints

### Signaling Server (Port 4000)

#### REST Endpoints

- `GET /queue` - Get patient queue
- `GET /patients/:id` - Get patient details
- `POST /prescriptions` - Submit prescription

#### Socket Events

- `register` - Register user with role
- `join_consultation` - Join consultation room
- `start_video_call` - Initiate video call
- `patient_ready` - Patient ready notification
- `webrtc-signal` - WebRTC signaling data
- `webrtc-end` - End video call
- `prescription_submitted` - Prescription data
- `recording_started/stopped` - Recording events
- `chat_message` - Chat messages

## Support

For issues or questions:

1. Check Flutter debug logs
2. Check browser console logs
3. Verify all services are running
4. Test network connectivity
5. Check permissions (camera/microphone)

## Next Steps

Future enhancements:

1. Patient authentication system
2. Appointment scheduling integration
3. Electronic health records (EHR) integration
4. Multi-language support
5. Offline mode capabilities
6. Advanced recording features
7. AI-powered diagnosis assistance
