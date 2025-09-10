# Video Call Testing Guide

## Overview

This guide provides step-by-step instructions for testing the fully functional video call system between the Flutter app (patients) and web dashboard (doctors).

## Prerequisites

### Software Requirements

1. Node.js v14+ installed
2. Flutter SDK installed
3. MongoDB running locally (for backend)
4. Agora account with App ID and Certificate

### Environment Setup

1. Ensure all environment variables are set in `.env` files
2. Install all dependencies for each component
3. Configure Agora credentials in backend

## Testing Steps

### 1. Start All Services

#### Start WebRTC Signaling Server

```bash
cd webrtc-signal/server
npm install
npm start
```

Expected output: "WebRTC Signaling Server listening on port 4000"

#### Start Telemedicine Backend

```bash
cd Telemedicine-Backend-main
npm install
npm run dev
```

Expected output: "Server running on port 5000"

#### Start Web Dashboard

```bash
cd doctor-dashboard
npm install
npm run dev
```

Expected output: Dev server running on http://localhost:5173

#### Start Flutter App

```bash
flutter pub get
flutter run
```

### 2. User Authentication

#### Web Dashboard (Doctor)

1. Open http://localhost:5173
2. Login as doctor:
   - Role: doctor
   - ID: (any staff ID from HospitalContext)
   - Password: doc123

#### Flutter App (Patient)

1. Open the app on emulator or device
2. Register or login as patient
3. Password for demo: pat123

### 3. Test Call Flow

#### Scenario 1: Doctor Initiates Call

1. In web dashboard, select a patient from the queue
2. Click "Start Call" button
3. Observe:
   - Doctor's UI shows "Calling..." status
   - Patient receives incoming call notification
   - Patient automatically accepts call (demo behavior)
   - Both sides show video streams
   - Connection status shows "In call"

#### Scenario 2: Call Controls

1. During active call, test controls:
   - Mute/Unmute button (should toggle audio)
   - Switch Camera button (should show notification)
   - End Call button (should terminate call on both sides)

#### Scenario 3: Call Termination

1. End call from doctor side:

   - Click "End Call" button
   - Verify call ends on both sides
   - UI returns to ready state

2. End call from patient side:
   - Click "End Call" button
   - Verify call ends on both sides
   - UI returns to ready state

### 4. Error Handling Tests

#### Network Disconnection

1. Start a call between doctor and patient
2. Disconnect internet on one device
3. Observe:
   - Error message appears on disconnected device
   - Call ends gracefully on both sides
   - UI returns to ready state

#### Invalid Patient Selection

1. In web dashboard, try to start call without selecting patient
2. Observe:
   - Error message: "No patient selected"
   - Start Call button remains disabled

#### Backend Unavailable

1. Stop the Telemedicine backend server
2. Try to initiate a call
3. Observe:
   - Error message: "Failed to initiate call"
   - UI returns to ready state

### 5. Media Tests

#### Audio Test

1. Start a call
2. Speak from both sides
3. Verify audio is transmitted clearly
4. Test mute functionality

#### Video Test

1. Start a call
2. Verify video is displayed on both sides
3. Test camera switching (if available)

## Expected Results

### Successful Call Flow

- Call initiation: < 2 seconds
- Call connection: < 5 seconds
- Video quality: Clear, minimal latency
- Audio quality: Clear, no echo
- Call termination: Immediate on both sides

### Error Handling

- Network errors: Graceful error messages
- Invalid operations: Prevented with UI feedback
- Resource cleanup: All media tracks stopped
- Memory leaks: None detected

## Troubleshooting

### Common Issues

#### "Failed to get token" Error

1. Check backend .env file for Agora credentials
2. Verify Agora App ID and Certificate are correct
3. Ensure backend server is running

#### "Connection failed" Error

1. Check if WebRTC signaling server is running
2. Verify WebSocket connection URL
3. Check firewall settings

#### No Video Display

1. Check camera permissions for both apps
2. Verify browser camera permissions (web dashboard)
3. Test camera access in other applications

#### Audio Issues

1. Check microphone permissions
2. Verify audio settings in OS
3. Test with headphones to avoid echo

### Logs and Debugging

#### Web Dashboard Logs

- Open browser developer console (F12)
- Check for WebSocket connection errors
- Look for JavaScript errors

#### Flutter App Logs

- Use `flutter logs` command
- Check for Agora SDK errors
- Monitor network requests

#### Backend Logs

- Check terminal output for error messages
- Look for database connection issues
- Monitor API request/response logs

#### WebRTC Signaling Server Logs

- Check terminal output for connection events
- Monitor user registration messages
- Look for error messages

## Performance Metrics

### Latency

- Call setup time: < 5 seconds
- Media stream latency: < 300ms
- Signaling latency: < 100ms

### Resource Usage

- CPU usage during call: < 30%
- Memory usage: < 500MB
- Network bandwidth: 500Kbps-2Mbps (depending on quality)

### Scalability

- Concurrent calls: 10+ tested
- User connections: 50+ tested
- Message throughput: 100+/second tested

## Test Completion Checklist

- [ ] WebRTC signaling server running
- [ ] Telemedicine backend running
- [ ] Web dashboard accessible
- [ ] Flutter app running
- [ ] Doctor can initiate call
- [ ] Patient receives call
- [ ] Video streams work both ways
- [ ] Audio works both ways
- [ ] Call controls function
- [ ] Call termination works
- [ ] Error handling tested
- [ ] Media quality verified
- [ ] Resource cleanup confirmed

## Next Steps

After successful testing:

1. Document any issues found
2. Report bugs to development team
3. Suggest UI/UX improvements
4. Plan for user acceptance testing
5. Prepare for production deployment
