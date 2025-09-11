import axios from "axios";

// Unified API Configuration - pointing to our unified backend
const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:5001/api";
const SOCKET_URL = import.meta.env.VITE_SOCKET_URL || "http://localhost:5001";

// Legacy API instance (for backward compatibility)
const API = axios.create({
  baseURL: BASE_URL,
  withCredentials: true,
});

export async function fetchQueue() {
  const res = await API.get("/queue");
  return res.data;
}

export async function fetchPatient(patientId) {
  const res = await API.get(`/patients/${patientId}`);
  return res.data;
}

export async function submitPrescription(payload) {
  const res = await API.post("/prescriptions", payload);
  return res.data;
}

// Main API instance with proper configuration
const api = axios.create({
  baseURL: BASE_URL,
  timeout: 10000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      window.location.href = "/login";
    }
    return Promise.reject(error);
  }
);

// Doctor API endpoints
export const doctorAPI = {
  // Get all doctors
  getAll: (params = {}) => api.get("/doctors", { params }),

  // Get doctor by ID
  getById: (doctorId) => api.get(`/doctors/${doctorId}`),

  // Create new doctor
  create: (doctorData) => api.post("/doctors", doctorData),

  // Update doctor
  update: (doctorId, doctorData) => api.put(`/doctors/${doctorId}`, doctorData),

  // Update doctor status
  updateStatus: (doctorId, status) =>
    api.patch(`/doctors/${doctorId}/status`, { status }),

  // Delete doctor
  delete: (doctorId) => api.delete(`/doctors/${doctorId}`),

  // Get available doctors
  getAvailable: () => api.get("/doctors/available/now"),

  // Get doctor statistics
  getStats: (doctorId) => api.get(`/doctors/${doctorId}/stats`),
};

// Patient API endpoints
export const patientAPI = {
  // Get all patients
  getAll: (params = {}) => api.get("/patients", { params }),

  // Get patient by ID
  getById: (patientId) => api.get(`/patients/${patientId}`),

  // Create new patient
  create: (patientData) => api.post("/patients", patientData),

  // Update patient
  update: (patientId, patientData) =>
    api.put(`/patients/${patientId}`, patientData),

  // Update patient status
  updateStatus: (patientId, status) =>
    api.patch(`/patients/${patientId}/status`, { status }),

  // Assign patient to doctor
  assignToDoctor: (patientId, doctorId) =>
    api.patch(`/patients/${patientId}/assign`, { doctorId }),

  // Get doctor's queue
  getDoctorQueue: (doctorId) => api.get(`/patients/queue/${doctorId}`),

  // Delete patient
  delete: (patientId) => api.delete(`/patients/${patientId}`),
};

// Consultation API endpoints
export const consultationAPI = {
  // Get all consultations
  getAll: (params = {}) => api.get("/consultations", { params }),

  // Get consultation by ID
  getById: (consultationId) => api.get(`/consultations/${consultationId}`),

  // Create new consultation
  create: (consultationData) => api.post("/consultations", consultationData),

  // Start consultation
  start: (consultationId, roomData) =>
    api.patch(`/consultations/${consultationId}/start`, roomData),

  // End consultation
  end: (consultationId, consultationData) =>
    api.patch(`/consultations/${consultationId}/end`, consultationData),

  // Get doctor's queue
  getDoctorQueue: (doctorId) => api.get(`/consultations/queue/${doctorId}`),

  // Get active consultations
  getActive: () => api.get("/consultations/active/all"),

  // Add chat message
  addChatMessage: (consultationId, messageData) =>
    api.post(`/consultations/${consultationId}/chat`, messageData),

  // Update consultation status
  updateStatus: (consultationId, status) =>
    api.patch(`/consultations/${consultationId}/status`, { status }),
};

// Authentication API endpoints
export const authAPI = {
  // Login
  login: (credentials) => api.post("/auth/login", credentials),

  // Register
  register: (userData) => api.post("/auth/register", userData),

  // Get profile
  getProfile: () => api.get("/auth/profile"),

  // Update profile
  updateProfile: (profileData) => api.put("/auth/profile", profileData),
};

// Real-time events (for socket.io integration)
export const socketEvents = {
  // Doctor events
  DOCTOR_ADDED: "doctor_added",
  DOCTOR_UPDATED: "doctor_updated",
  DOCTOR_DELETED: "doctor_deleted",
  DOCTOR_STATUS_CHANGED: "doctor_status_changed",

  // Patient events
  PATIENT_ADDED: "patient_added",
  PATIENT_UPDATED: "patient_updated",
  PATIENT_DELETED: "patient_deleted",
  PATIENT_STATUS_CHANGED: "patient_status_changed",
  PATIENT_ASSIGNED: "patient_assigned",

  // Consultation events
  CONSULTATION_CREATED: "consultation_created",
  CONSULTATION_STARTED: "consultation_started",
  CONSULTATION_ENDED: "consultation_ended",
  CONSULTATION_STATUS_CHANGED: "consultation_status_changed",

  // Queue events
  QUEUE_UPDATED: "queue_updated",

  // Notification events
  NOTIFICATION: "notification",
};

// Utility functions
export const apiUtils = {
  // Handle API errors
  handleError: (error) => {
    if (error.response) {
      // Server responded with error status
      return error.response.data.message || "An error occurred";
    } else if (error.request) {
      // Request was made but no response received
      return "Network error. Please check your connection.";
    } else {
      // Something else happened
      return "An unexpected error occurred";
    }
  },

  // Format date for API
  formatDate: (date) => {
    return new Date(date).toISOString();
  },

  // Parse API date
  parseDate: (dateString) => {
    return new Date(dateString);
  },

  // Validate required fields
  validateRequired: (data, requiredFields) => {
    const missing = requiredFields.filter((field) => !data[field]);
    if (missing.length > 0) {
      throw new Error(`Missing required fields: ${missing.join(", ")}`);
    }
  },
};

export { SOCKET_URL };
export default API;
