// app.js
import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';

import morgan from 'morgan';
import http from 'http';
import cookieParser from 'cookie-parser';
import { Server } from 'socket.io';
import { connectDB } from './config/db.js';
import Doctor from './models/Doctor.js';
import Patient from './models/Patient.js';

// Import routes
import hospitalRoutes from './routes/hospitalRoutes.js';
import doctorRoutes from './routes/doctorRoutes.js';
import callRoutes from './routes/callRoutes.js';
// import userRoutes from './routes/userRoutes.js';
// import queueRoutes from './routes/queueRoutes.js';
// import chatRoutes from './routes/chatRoutes.js';
// import reportRoutes from './routes/reportRoutes.js';
// import aiRoutes from './routes/aiRoutes.js';

// Import middlewares
// import { authMiddleware } from './middlewares/authMiddleware.js';
// import { errorHandler } from './middlewares/errorHandler.js';

// Config
dotenv.config();
const app = express();
const server = http.createServer(app);

// Socket.IO (optional)
const io = new Server(server, { cors: { origin: '*' } });

// --- Middleware ---
app.use(cors({
  origin: '*',
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(morgan('dev'));

// --- Database Connection ---
connectDB();

// Make io accessible to routes
app.set('socketio', io);

// --- Socket.IO Real-time Notifications ---
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);
  
  // Handle doctor connection
  socket.on('doctorOnline', async (doctorId) => {
    socket.join(`doctor_${doctorId}`);
    await Doctor.findByIdAndUpdate(doctorId, { isOnline: true });
    io.emit('doctorStatusChanged', { doctorId, isOnline: true });
  });

  socket.on('doctorOffline', async (doctorId) => {
    await Doctor.findByIdAndUpdate(doctorId, { 
      isOnline: false,
      isInCall: false,
      currentPatient: null
    });
    io.emit('doctorStatusChanged', { doctorId, isOnline: false });
  });

  // Handle patient connection
  socket.on('patientOnline', async (patientId) => {
    socket.join(`patient_${patientId}`);
  });

  // Handle call initiation
  socket.on('initiateCall', async ({ doctorId, patientId }) => {
    try {
      // Update doctor and patient status
      await Promise.all([
        Doctor.findByIdAndUpdate(doctorId, { 
          isInCall: true,
          currentPatient: patientId 
        }),
        Patient.findByIdAndUpdate(patientId, {
          isInCall: true,
          currentDoctor: doctorId,
          videoCallActive: true
        })
      ]);
      
      // Notify patient about incoming call
      io.to(`patient_${patientId}`).emit('incomingCall', { doctorId });
    } catch (error) {
      console.error('Error initiating call:', error);
    }
  });

  // Handle call acceptance
  socket.on('callAccepted', async ({ doctorId, patientId }) => {
    io.to(`doctor_${doctorId}`).emit('callStarted', { patientId });
  });

  // Handle call rejection
  socket.on('callRejected', ({ doctorId, patientId }) => {
    io.to(`doctor_${doctorId}`).emit('callRejected', { patientId });
  });

  // Handle queue events
  socket.on('joinQueue', ({ doctorId }) => {
    io.emit('queueUpdated', { doctorId });
  });

  socket.on('leaveQueue', ({ doctorId }) => {
    io.emit('queueUpdated', { doctorId });
  });

  // Handle disconnection
  socket.on('disconnect', async () => {
    console.log('User disconnected:', socket.id);
  });
});

//................................
// testing k liye banaya hai
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Serve static files from the test-client directory
app.use(express.static(path.join(__dirname, '../../test-client')));



//....................................

// --- Routes ---
app.use('/api/hospital', hospitalRoutes);
app.use('/api/doctor', doctorRoutes);
app.use('/api/call', callRoutes);
// app.use('/api/user', userRoutes);
// app.use('/api/queue',queueRoutes);
// app.use('/api/chat', chatRoutes);
// app.use('/api/report', reportRoutes);
// app.use('/api/ai', aiRoutes);

// --- 404 Handler ---
app.use((req, res, next) => {
  res.status(404).json({ message: 'Route not found' });
});

// --- Global Error Handler ---
// app.use(errorHandler);

// --- Start Server ---
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
