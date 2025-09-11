# Video Call System Testing Guide

## Overview

This guide provides comprehensive testing procedures for the video call system in the Telemed application.

## Prerequisites

1. **Environment Setup**

   - Flutter SDK installed
   - Android/iOS device or emulator
   - Backend server running on `localhost:5001`
   - Agora App ID configured in `lib/config/agora_config.dart`

2. **Test Data**
   - Test doctor account: `d1/password`
   - Test patient account: `p1/password`
   - Valid consultation data

## Test Scenarios

### 1. Video Call Initialization

**Test Case: VCS-001**

```dart
// Test video call manager initialization
await testVideoCallManagerInitialization();

// Expected Results:
- AgoraService initializes successfully
- SocketService connects to backend
- User authentication is verified
- No initialization errors
```

### 2. Video Call Connection

**Test Case: VCS-002**

```dart
// Test video call connection
await testVideoCallConnection();

// Expected Results:
- Successfully joins Agora channel
- Local video appears
- Audio/video controls work
- Connection status shows "Connected"
```

### 3. Audio/Video Controls

**Test Case: VCS-003**

```dart
// Test audio/video controls
await testAudioVideoControls();

// Test Steps:
1. Toggle mute button
2. Toggle video on/off
3. Switch camera
4. Toggle speaker

// Expected Results:
- Mute state changes correctly
- Video feed toggles on/off
- Camera switches between front/back
- Audio routes to speaker/earpiece
```

### 4. Recording Functionality

**Test Case: VCS-004**

```dart
// Test recording functionality (Doctor only)
await testRecordingFunctionality();

// Test Steps:
1. Doctor starts recording
2. Patient consent dialog appears
3. Recording indicator shows
4. Stop recording
5. Recording saved notification

// Expected Results:
- Only doctors can start recording
- Consent dialog works properly
- Recording duration tracks correctly
- Recording stops and saves successfully
```

### 5. Chat Functionality

**Test Case: VCS-005**

```dart
// Test chat functionality
await testChatFunctionality();

// Test Steps:
1. Toggle chat window
2. Send text message
3. Receive message from other participant
4. Send prescription (doctor only)

// Expected Results:
- Chat window toggles correctly
- Messages send and receive in real-time
- Message history persists
- Prescription messages display properly
```

### 6. Network Resilience

**Test Case: VCS-006**

```dart
// Test network resilience
await testNetworkResilience();

// Test Steps:
1. Start video call
2. Simulate network interruption
3. Network restored
4. Check reconnection behavior

// Expected Results:
- Reconnection attempts automatically
- UI shows reconnecting status
- Call resumes after network restoration
- No data loss during reconnection
```

### 7. Multi-participant Support

**Test Case: VCS-007**

```dart
// Test multi-participant support
await testMultiParticipantSupport();

// Test Steps:
1. Start video call with multiple participants
2. Test grid layout
3. Test speaker layout
4. Test video quality optimization

// Expected Results:
- Multiple participants display correctly
- Layout switching works smoothly
- Video quality adapts to bandwidth
- Audio mixing works properly
```

### 8. Error Handling

**Test Case: VCS-008**

```dart
// Test error handling
await testErrorHandling();

// Test Scenarios:
1. Invalid Agora credentials
2. Network failure during call
3. Camera/microphone permissions denied
4. Backend service unavailable

// Expected Results:
- Appropriate error messages displayed
- Graceful degradation of features
- User can retry operations
- No app crashes
```

## Automated Testing

### Unit Tests

```dart
// File: test/video_call_test.dart
void main() {
  group('Video Call System Tests', () {
    testWidgets('VideoControlsWidget functionality', (tester) async {
      // Test video controls widget
      await tester.pumpWidget(VideoControlsWidget(
        isMuted: false,
        isVideoEnabled: true,
        // ... other required parameters
      ));

      // Test mute button
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump();

      // Verify mute state changed
      expect(find.byIcon(Icons.mic_off), findsOneWidget);
    });

    testWidgets('ParticipantGridWidget layout', (tester) async {
      // Test participant grid widget
      await tester.pumpWidget(ParticipantGridWidget(
        agoraService: mockAgoraService,
        remoteUsers: [1, 2, 3],
        showLocalVideo: true,
      ));

      // Verify grid layout
      expect(find.byType(GridView), findsOneWidget);
    });

    test('VideoCallManager state management', () async {
      final manager = VideoCallManager();

      // Test initialization
      await manager.initialize(
        userId: 'test_user',
        isDoctor: false,
        consultationService: mockConsultationService,
      );

      expect(manager.isInitialized, true);
      expect(manager.state, VideoCallState.initialized);
    });
  });
}
```

### Integration Tests

```dart
// File: integration_test/video_call_integration_test.dart
void main() {
  group('Video Call Integration Tests', () {
    testWidgets('Complete video call flow', (tester) async {
      // Start with login
      await tester.pumpAndSettle();

      // Navigate to video call
      await tester.tap(find.text('Start Video Consultation'));
      await tester.pumpAndSettle();

      // Verify video call screen loaded
      expect(find.byType(UnifiedVideoCallScreen), findsOneWidget);

      // Test video controls
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump();

      // Test chat
      await tester.tap(find.byIcon(Icons.chat));
      await tester.pump();

      // Verify chat window opened
      expect(find.byType(ChatWidget), findsOneWidget);

      // End call
      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pump();

      // Confirm end call
      await tester.tap(find.text('End Call'));
      await tester.pumpAndSettle();

      // Verify navigation back
      expect(find.byType(UnifiedVideoCallScreen), findsNothing);
    });
  });
}
```

## Performance Testing

### Memory Usage

```dart
// Monitor memory usage during video calls
void testMemoryUsage() {
  // Start video call
  // Monitor memory usage over time
  // Check for memory leaks
  // Verify cleanup after call ends
}
```

### CPU Usage

```dart
// Monitor CPU usage during video calls
void testCPUUsage() {
  // Start video call with multiple participants
  // Monitor CPU usage
  // Test with different video qualities
  // Verify performance optimizations
}
```

### Network Usage

```dart
// Monitor network usage during video calls
void testNetworkUsage() {
  // Start video call
  // Monitor bandwidth usage
  // Test with poor network conditions
  // Verify quality adaptation
}
```

## Manual Testing Checklist

### Pre-Test Setup

- [ ] Backend server running
- [ ] Test accounts available
- [ ] Device permissions granted
- [ ] Network connectivity verified

### Basic Functionality

- [ ] App launches successfully
- [ ] User can log in
- [ ] Video call can be initiated
- [ ] Audio/video streams work
- [ ] Controls respond correctly

### Advanced Features

- [ ] Recording works (doctor only)
- [ ] Chat messages send/receive
- [ ] Multi-participant calls work
- [ ] Layout switching functions
- [ ] Quality adaptation works

### Error Scenarios

- [ ] Handle network disconnection
- [ ] Recover from Agora errors
- [ ] Handle permission denials
- [ ] Graceful degradation

### Platform-Specific

- [ ] iOS functionality
- [ ] Android functionality
- [ ] Web compatibility (if applicable)
- [ ] Different screen sizes

## Test Data

### Sample Consultation Data

```json
{
  "consultation": {
    "id": "test_consultation_001",
    "appointmentId": "test_appointment_001",
    "patientId": "test_patient_001",
    "doctorId": "test_doctor_001",
    "patientName": "Test Patient",
    "doctorName": "Dr. Test",
    "scheduledAt": "2024-01-15T10:00:00Z",
    "priority": "normal",
    "status": "scheduled"
  }
}
```

## Known Issues and Workarounds

### Issue 1: Agora Token Expiration

**Problem**: Token expires during long calls
**Workaround**: Implement token refresh mechanism
**Status**: Monitored

### Issue 2: iOS Permission Handling

**Problem**: Microphone permission sometimes not requested
**Workaround**: Manually request permissions in app settings
**Status**: Under investigation

## Reporting Issues

When reporting issues, include:

1. Device information
2. App version
3. Steps to reproduce
4. Expected vs actual behavior
5. Screenshots/logs
6. Network conditions

## Continuous Testing

### Automated CI/CD Tests

- Unit tests run on every commit
- Integration tests run on pull requests
- Performance tests run nightly
- Manual testing before releases

### Monitoring

- Real-time error tracking
- Performance metrics collection
- User feedback analysis
- Network quality monitoring
