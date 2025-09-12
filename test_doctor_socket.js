const io = require('socket.io-client');

// Test the doctor login by connecting to socket
const socket = io('https://telemed18.onrender.com', {
  transports: ['websocket', 'polling']
});

socket.on('connect', () => {
  console.log('🔌 Connected to backend socket');
  
  // Emit doctor login event (this simulates what happens when doctor logs in)
  socket.emit('doctor_login', {
    doctorId: 'test-doctor-id-123',
    name: 'Dr. Test Doctor',
    specialization: 'General Practitioner',
    status: 'online'
  });
  
  console.log('📤 Emitted doctor_login event for test doctor');
});

socket.on('doctor_login', (data) => {
  console.log('📥 Received doctor_login event:', data);
});

socket.on('doctor_logout', (data) => {
  console.log('📥 Received doctor_logout event:', data);
});

socket.on('disconnect', () => {
  console.log('🔌 Disconnected from socket');
});

socket.on('connect_error', (error) => {
  console.log('❌ Socket connection error:', error.message);
});

// Keep the script running for 10 seconds to test
setTimeout(() => {
  console.log('🏁 Test completed, disconnecting...');
  socket.disconnect();
  process.exit(0);
}, 10000);