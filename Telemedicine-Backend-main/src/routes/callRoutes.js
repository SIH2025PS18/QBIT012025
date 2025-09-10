import express from 'express';
import { generateToken, endCall } from '../controllers/callController.js';
// import { authMiddleware } from '../middleware/authMiddleware.js'; // Temporarily disabled for testing

const router = express.Router();

// Generate Agora token for video call
router.post('/generate-token', /* authMiddleware, */ generateToken);

// End call and clean up
router.post('/end-call', /* authMiddleware, */ endCall);

export default router;