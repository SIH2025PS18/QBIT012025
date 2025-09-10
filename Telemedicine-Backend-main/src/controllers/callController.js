import { generateRtcToken, generateChannelName } from '../services/agoraService.js';
import Doctor from '../models/Doctor.js';
import Patient from '../models/Patient.js';

// Generate token for video call
export const generateToken = async (req, res) => {
  try {
    const { doctorId, patientId, role } = req.body;
    
    if (!doctorId || !patientId) {
      return res.status(400).json({ error: 'Doctor ID and Patient ID are required' });
    }

    // In a real app, verify the doctor and patient exist and are authorized
    const channelName = generateChannelName(doctorId, patientId);
    
    // For web (doctor), use uid = 0, for mobile (patient), generate a random uid
    const uid = role === 'doctor' ? 0 : Math.floor(Math.random() * 100000);
    
    const tokenData = generateRtcToken(channelName, uid);
    
    res.status(200).json({
      success: true,
      token: tokenData.token,
      channel: tokenData.channel,
      uid: tokenData.uid,
      appId: tokenData.appId
    });
  } catch (error) {
    console.error('Error generating token:', error);
    res.status(500).json({ error: 'Failed to generate token' });
  }
};

// End call and update status
export const endCall = async (req, res) => {
  try {
    const { doctorId, patientId } = req.body;
    
    // Update doctor's status
    await Doctor.findByIdAndUpdate(doctorId, { 
      isInCall: false,
      currentPatient: null
    });
    
    // Update patient's status
    await Patient.findByIdAndUpdate(patientId, {
      isInCall: false,
      currentDoctor: null
    });
    
    // Notify both parties via socket
    const io = req.app.get('socketio');
    io.to(`doctor_${doctorId}`).emit('callEnded');
    io.to(`patient_${patientId}`).emit('callEnded');
    
    res.status(200).json({ success: true, message: 'Call ended successfully' });
  } catch (error) {
    console.error('Error ending call:', error);
    res.status(500).json({ error: 'Failed to end call' });
  }
};
