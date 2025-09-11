import axios from "axios";

// Unified API Configuration
const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:5001/api";

class ApiService {
  constructor() {
    this.api = axios.create({
      baseURL: BASE_URL,
      timeout: 10000,
      headers: {
        "Content-Type": "application/json",
      },
    });

    // Request interceptor to add auth token
    this.api.interceptors.request.use(
      (config) => {
        const token = localStorage.getItem("auth_token");
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
    this.api.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          localStorage.removeItem("auth_token");
          localStorage.removeItem("user_data");
          // Don't redirect automatically in dev mode
          if (import.meta.env.PROD) {
            window.location.href = "/";
          }
        }
        return Promise.reject(error);
      }
    );
  }

  // Authentication methods
  async login({ loginId, email, password, userType }) {
    try {
      const response = await this.api.post("/auth/login", {
        loginId: loginId || email, // Support both loginId and email
        password,
        userType,
      });

      if (response.data.success) {
        const { token, user } = response.data.data;
        localStorage.setItem("auth_token", token);
        localStorage.setItem("user_data", JSON.stringify(user));
      }

      return response.data;
    } catch (error) {
      throw new Error(this.getErrorMessage(error));
    }
  }

  async logout() {
    try {
      await this.api.post("/auth/logout");
    } catch (error) {
      console.warn("Logout API call failed:", error.message);
    } finally {
      localStorage.removeItem("auth_token");
      localStorage.removeItem("user_data");
    }
  }

  async getProfile() {
    try {
      const response = await this.api.get("/auth/profile");
      return response.data;
    } catch (error) {
      throw new Error(this.getErrorMessage(error));
    }
  }

  // Utility methods
  isAuthenticated() {
    const token = localStorage.getItem("auth_token");
    const user = localStorage.getItem("user_data");
    return !!(token && user);
  }

  getCurrentUser() {
    try {
      const userData = localStorage.getItem("user_data");
      return userData ? JSON.parse(userData) : null;
    } catch (error) {
      console.error("Error parsing user data:", error);
      return null;
    }
  }

  getAuthToken() {
    return localStorage.getItem("auth_token");
  }

  // Doctor API methods
  async getDoctors(params = {}) {
    const response = await this.api.get("/doctors", { params });
    return response.data;
  }

  async getAvailableDoctors() {
    const response = await this.api.get("/doctors/available");
    return response.data;
  }

  async updateDoctorStatus(status, isAvailable) {
    const response = await this.api.put("/doctors/status", {
      status,
      isAvailable,
    });
    return response.data;
  }

  // Patient API methods
  async getPatients(params = {}) {
    const response = await this.api.get("/patients", { params });
    return response.data;
  }

  async getPatientProfile() {
    const response = await this.api.get("/patients/profile");
    return response.data;
  }

  // Consultation API methods
  async getConsultations(params = {}) {
    const response = await this.api.get("/consultations", { params });
    return response.data;
  }

  async bookConsultation(consultationData) {
    const response = await this.api.post(
      "/consultations/book",
      consultationData
    );
    return response.data;
  }

  async startConsultation(consultationId) {
    const response = await this.api.put(
      `/consultations/${consultationId}/start`
    );
    return response.data;
  }

  async endConsultation(consultationId) {
    const response = await this.api.put(`/consultations/${consultationId}/end`);
    return response.data;
  }

  // Queue API methods
  async getQueue() {
    const response = await this.api.get("/queue");
    return response.data;
  }

  // Chat API methods
  async getChatHistory(consultationId) {
    const response = await this.api.get(`/chat/${consultationId}`);
    return response.data;
  }

  async sendChatMessage(consultationId, message) {
    const response = await this.api.post(`/chat/${consultationId}`, {
      message,
    });
    return response.data;
  }

  // Pharmacy API methods (from medstore backend)
  async getMedicines(params = {}) {
    const response = await this.api.get("/medicines", { params });
    return response.data;
  }

  async getOrders(params = {}) {
    const response = await this.api.get("/orders", { params });
    return response.data;
  }

  async getPharmacies(params = {}) {
    const response = await this.api.get("/pharmacies", { params });
    return response.data;
  }

  // Error handling
  getErrorMessage(error) {
    if (error.response) {
      return error.response.data.message || "Server error occurred";
    } else if (error.request) {
      return "Network error. Please check your connection.";
    } else {
      return error.message || "An unexpected error occurred";
    }
  }

  // Health check
  async healthCheck() {
    try {
      const response = await this.api.get("/health");
      return response.data;
    } catch (error) {
      console.error("Backend health check failed:", error.message);
      return { success: false, message: "Backend not available" };
    }
  }
}

// Create and export a singleton instance
const apiService = new ApiService();
export default apiService;
