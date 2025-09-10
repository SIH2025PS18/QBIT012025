import mongoose from "mongoose";
const doctorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  phone: { type: String },
  email: { type: String ,required:true},
  password:{type:String,required:true},

  hospitalId: { type: String , required: true },
  specialization: { type: String, required: true },
  languages: [{ type: String ,required: true}],
  yearsOfExperience: { type: Number },

  isOnline: { type: Boolean, default: false },
  isInCall: { type: Boolean, default: false },
  currentPatient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient' },
  queueActive: { type: Boolean, default: false },
  availableSlots: [{ date: Date, startTime: String, endTime: String }],
  currentQueueCount: { type: Number, default: 0 },

  videoCallEnabled: { type: Boolean, default: true },
  chatEnabled: { type: Boolean, default: true },

  patientsServed: { type: Number, default: 0 },

  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

const Doctor=mongoose.model('Doctor',doctorSchema);
export default Doctor;