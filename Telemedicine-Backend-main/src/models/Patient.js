import mongoose from "mongoose";

const patientSchema = new mongoose.Schema({
  name: { type: String, required: true },
  phone: { type: String },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  age: { type: Number },
  gender: { type: String },

  applanguage: { type: String, required: true },
  languagesknown: [{ type: String, required: true }],

  currentQueueStatus: { type: String, enum: ['waiting', 'in_consultation', 'completed'], default: null },
  assignedDoctorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', default: null },
  isInCall: { type: Boolean, default: false },
  currentDoctor: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', default: null },
  videoCallActive: { type: Boolean, default: false },

  requestedAt: { type: Date },

  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

const Patient = mongoose.model('Patient', patientSchema);
export default Patient;
