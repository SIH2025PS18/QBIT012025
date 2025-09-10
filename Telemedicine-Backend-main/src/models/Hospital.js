import mongoose from "mongoose";

const hospitalSchema = new mongoose.Schema({
  // Hospital Info
  name: { type: String, required: true },
  address: { type: String },
  phone: { type: String },

  // Admin Credentials
  adminName: { type: String, required: true },
  adminEmail: { type: String, required: true, unique: true },
  adminPassword: { type: String, required: true },

  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

const Hospital=mongoose.model('Hospital',hospitalSchema);
export default Hospital;