# Telemedicine Integration Test Guide

## Complete Patient-to-Doctor Dashboard Integration

This guide demonstrates how patient bookings from the Flutter app appear in real-time on the doctor dashboard.

## 🚀 Quick Start Test

### 1. Services Running

- ✅ Signaling Server: http://localhost:4000
- ✅ Doctor Dashboard: http://localhost:5175/doctor

### 2. Test Scenario: Patient Books Appointment

#### Step 1: Open Doctor Dashboard

1. Go to http://localhost:5175/doctor
2. You should see the enhanced doctor dashboard
3. Check the "Patient Queue" - initially shows mock patients

#### Step 2: Simulate Patient Booking

Test the appointment booking API directly:

```bash
curl -X POST http://localhost:4000/appointments \
  -H "Content-Type: application/json" \
  -d '{
    "id": "apt_12345",
    "patientId": "p_test_001",
    "patientName": "John Smith",
    "patientAge": "35",
    "patientGender": "Male",
    "symptoms": "Fever and headache",
    "medicalHistory": "No significant history",
    "preferredTime": "10:00 AM - 11:00 AM",
    "priority": "normal",
    "status": "waiting",
    "createdAt": 1651234567890
  }'
```

#### Step 3: Verify Real-time Update

1. Watch the doctor dashboard
2. The new patient should appear in the queue immediately
3. Patient details should be accessible

### 3. Test Video Consultation Flow

#### Step 1: Select Patient

1. In doctor dashboard, click "Select" for any patient
2. Patient details card should populate
3. "Start Consultation" button should be enabled

#### Step 2: Start Video Call

1. Click "Start Consultation"
2. Video call component should activate
3. Console should log the video call initiation

#### Step 3: Patient Response Simulation

Simulate patient readiness:

```bash
curl -X POST http://localhost:4000 \
  -H "Content-Type: application/json" \
  -d '{
    "type": "patient_ready",
    "patientId": "p_test_001",
    "consultationId": "consultation_p_test_001_doctor-1"
  }'
```

## 🔧 Testing with Flutter App

### 1. Add Integration Widget

Add to your main screen:

```dart
TeleMedicineIntegrationWidget(
  patientId: 'p_test_${DateTime.now().millisecondsSinceEpoch}',
  patientName: 'Test Patient',
)
```

### 2. Test Flow

1. **Connection**: Widget should show "Connected to Doctor Dashboard"
2. **Book Appointment**: Click "Book Appointment" button
3. **Real-time Sync**: Check doctor dashboard for new appointment
4. **Video Ready**: Click "Video Call" when ready for consultation

## 📊 Expected Results

### Doctor Dashboard Features

- ✅ Real-time patient queue updates
- ✅ Patient connection status indicators
- ✅ Video call initiation
- ✅ Prescription writing and submission
- ✅ Call recording controls

### Flutter App Features

- ✅ Real-time connection status
- ✅ Appointment booking with dashboard sync
- ✅ Incoming video call notifications
- ✅ Automatic call acceptance
- ✅ Prescription reception

## 🐛 Troubleshooting

### Issue: No Queue Updates

**Solution**: Check signaling server logs and WebSocket connection

### Issue: Video Call Not Starting

**Solution**: Verify both services are running and check browser permissions

### Issue: Appointments Not Syncing

**Solution**: Check network requests in browser dev tools

## 📋 API Endpoints for Testing

### Signaling Server (Port 4000)

#### Get Queue

```bash
curl http://localhost:4000/queue
```

#### Book Appointment

```bash
curl -X POST http://localhost:4000/appointments \
  -H "Content-Type: application/json" \
  -d '{"patientId":"test","patientName":"Test","symptoms":"Test"}'
```

#### Get Patient Details

```bash
curl http://localhost:4000/patients/p_test_001
```

### Real-time Events (WebSocket)

- `new_appointment` - New appointment booked
- `patient_joined_queue` - Patient ready for consultation
- `video_call_started` - Doctor starts video call
- `patient_ready` - Patient accepts video call

## 🎯 Success Criteria

✅ Patient bookings appear instantly in doctor dashboard
✅ Doctor can start video calls from dashboard
✅ Patient receives real-time call notifications
✅ Video calls establish successfully
✅ Prescriptions sync between platforms
✅ Call recording works on both sides

## 📝 Production Deployment Notes

1. **Update URLs**: Replace localhost with production server
2. **SSL/HTTPS**: Enable secure connections
3. **Authentication**: Add proper user authentication
4. **Database**: Replace in-memory storage with persistent database
5. **Error Handling**: Add comprehensive error handling
6. **Monitoring**: Add logging and monitoring

## 🔐 Security Considerations

- Enable CORS properly for production domains
- Add authentication tokens for API access
- Implement rate limiting for booking endpoints
- Use HTTPS for all communications
- Validate and sanitize all user inputs
