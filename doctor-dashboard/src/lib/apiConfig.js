// API Configuration for Doctor Dashboard
export const API_CONFIG = {
  // Base URL for the telemedicine backend
  BASE_URL: "http://localhost:5000/api",

  // Socket URL for real-time features
  SOCKET_URL: "http://localhost:5000",

  // API Endpoints
  ENDPOINTS: {
    // Authentication
    AUTH: {
      LOGIN: "/auth/login",
      LOGOUT: "/auth/logout",
      PROFILE: "/auth/profile",
      CHANGE_PASSWORD: "/auth/change-password",
    },

    // Doctors
    DOCTORS: {
      PROFILE: "/doctors/profile",
      STATUS: "/doctors/status",
      CONSULTATIONS: "/doctors/consultations/my",
      SCHEDULE: "/doctors/schedule/today",
      STATS: "/doctors/stats/dashboard",
    },

    // Patients
    PATIENTS: {
      PROFILE: "/patients/profile",
      CONSULTATIONS: "/patients/consultations",
      QUEUE: "/patients/queue/status",
    },

    // Consultations
    CONSULTATIONS: {
      BOOK: "/consultations/book",
      START: (id) => `/consultations/${id}/start`,
      END: (id) => `/consultations/${id}/end`,
      CANCEL: (id) => `/consultations/${id}/cancel`,
      CHAT: (id) => `/consultations/${id}/chat`,
      FEEDBACK: (id) => `/consultations/${id}/feedback`,
      QUEUE: (doctorId) => `/consultations/queue/doctor/${doctorId}`,
    },

    // Admin (for admin portal)
    ADMIN: {
      DOCTORS: "/doctors/admin/all",
      PATIENTS: "/patients/admin/all",
      VERIFY_DOCTOR: (id) => `/doctors/admin/${id}/verify`,
      DEACTIVATE_DOCTOR: (id) => `/doctors/admin/${id}/deactivate`,
    },
  },
};

// Helper function to get full URL
export const getApiUrl = (endpoint) => {
  return `${API_CONFIG.BASE_URL}${endpoint}`;
};

// HTTP request timeout
export const REQUEST_TIMEOUT = 30000; // 30 seconds

// Retry configuration
export const RETRY_CONFIG = {
  maxRetries: 3,
  retryDelay: 2000, // 2 seconds
};
