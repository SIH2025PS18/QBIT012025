import express from 'express';
import { doctorLogin,logout} from '../controllers/doctorController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';
const router = express.Router();

// --- Doctor Login ---
router.post('/login', doctorLogin);


// --- Get Current Patient Queue (FIFO) ---
router.get('/queue', async (req, res) => {
    // Logic: Return patients with currentQueueStatus = 'waiting' sorted by request time
});

// --- Accept Topmost Patient From Queue and Start Call ---
router.post('/accept-patient', async (req, res) => {
    // Logic:
    // - Atomically findOneAndUpdate next patient with status 'waiting'
    // - Set currentQueueStatus = 'in_consultation'
    // - Assign doctorId
    // - Set videoCallActive = true
});

// --- End Call and Submit Prescription ---
router.post('/submit-prescription', async (req, res) => {
    // Logic:
    // - Receive { patientId, diagnosis, medicines, notes }
    // - Create a prescription entry
    // - Set patient.currentQueueStatus = 'completed' and videoCallActive = false
});

// logout
router.post('/logout', authMiddleware, logout);

export default router;
