const io = require('socket.io-client');

console.log('🧪 Simple socket test...');

const socket = io('http://192.168.1.7:5002', {
  query: {
    userRole: 'patient',
    userName: 'Simple Test Patient'
  },
  timeout: 10000
});

socket.on('connect', () => {
  console.log('✅ Connected to backend with socket ID:', socket.id);
  
  socket.emit('join_queue', {
    patientId: 'test_123',
    patientName: 'Test Patient',
    doctorId: '68cd305224aca33a4b59b042'
  });
  console.log('📤 Emitted join_queue event');
  
  socket.emit('patient_start_call', {
    patientId: 'test_123',
    patientName: 'Test Patient',
    doctorId: '68cd305224aca33a4b59b042',
    doctorName: 'Piyushgarg',
    channelName: 'test_call_channel',
    symptoms: 'Test symptoms',
    timestamp: new Date().toISOString()
  });
  console.log('📤 Emitted patient_start_call event');
  
  setTimeout(() => {
    socket.disconnect();
    console.log('🔌 Disconnected');
    process.exit(0);
  }, 3000);
});

socket.on('connect_error', (error) => {
  console.error('❌ Connection error:', error.message);
});

socket.on('disconnect', (reason) => {
  console.log('🔌 Disconnected due to:', reason);
});

// Listen for any responses
socket.onAny((eventName, ...args) => {
  console.log('📨 Received event:', eventName, args);
});