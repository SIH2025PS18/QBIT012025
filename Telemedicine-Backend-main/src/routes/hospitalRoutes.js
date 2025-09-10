import express from 'express';
const router = express.Router();

import  {addDoctor, adminLogin,getDoctors} from '../controllers/hospitalController.js';
// import { authMiddleware } from '../middleware/authMiddleware.js';

// --- Hospital Admin Login (pre-created credentials) ---
router.post('/login', adminLogin);

// --- Add a doctor under this hospital ---
router.post('/add-doctor/:id',addDoctor);

// --- Get all doctors of this hospital ---
router.get('/doctors/:id', getDoctors);

export default router;
