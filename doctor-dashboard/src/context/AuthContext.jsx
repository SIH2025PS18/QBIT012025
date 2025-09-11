import React, { createContext, useContext, useState, useEffect } from "react";
import apiService from "../lib/apiService.js";
import { socketService } from "../lib/socket.js";

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Check for existing auth on app load
  useEffect(() => {
    const initializeAuth = async () => {
      console.log('🔄 Initializing authentication...');
      try {
        if (apiService.isAuthenticated()) {
          console.log('📱 Found existing auth token');
          const userData = apiService.getCurrentUser();
          console.log('👤 User data:', userData);
          setUser(userData);
          
          // Initialize socket connection
          console.log('🔌 Connecting to socket...');
          socketService.connect(userData);
          
          // Verify token is still valid
          try {
            console.log('✅ Verifying token...');
            await apiService.getProfile();
            console.log('✅ Token is valid');
          } catch (profileError) {
            console.warn('⚠️ Token expired, logging out:', profileError.message);
            await logout();
          }
        } else {
          console.log('🚫 No existing auth found');
        }
      } catch (error) {
        console.error('❌ Auth initialization error:', error);
        setError('Failed to initialize authentication');
      } finally {
        console.log('✅ Auth initialization complete, setting loading to false');
        setLoading(false);
      }
    };

    initializeAuth();
  }, []);

  // Login function using real backend API with fallback
  async function login({ role, email, password }) {
    try {
      setError(null);
      setLoading(true);
      console.log('🚀 Starting login process...', { role, email: email?.slice(0, 3) + '***' });
      
      // Try backend API first
      try {
        console.log('🌐 Attempting backend API login...');
        const response = await apiService.login({
          loginId: email, // Use loginId instead of email for mobile support
          password,
          userType: role,
        });

        console.log('📊 Backend response:', response?.success ? 'SUCCESS' : 'FAILED');

        if (response.success && response.data.user) {
          const userData = response.data.user;
          console.log('✅ Login successful, setting user data');
          setUser(userData);
          
          // Initialize socket connection
          socketService.connect(userData);
          
          return true;
        } else {
          console.log('❌ Backend login failed:', response.message);
          setError(response.message || 'Login failed');
          return false;
        }
      } catch (apiError) {
        console.warn('⚠️ Backend API not available, using fallback login. Error:', apiError.message);
        
        // Enhanced fallback login for development
        const mockUsers = {
          // Simple ID format
          'admin': { userId: 'admin', name: 'Hospital Admin', role: 'admin', userType: 'admin' },
          'd1': { userId: 'd1', name: 'Dr. Arjun Mehta', role: 'doctor', userType: 'doctor', speciality: 'Cardiologist' },
          'd2': { userId: 'd2', name: 'Dr. Riya Kapoor', role: 'doctor', userType: 'doctor', speciality: 'Dermatologist' },
          'p1': { userId: 'p1', name: 'John Doe', role: 'patient', userType: 'patient', age: 35 },
          'p2': { userId: 'p2', name: 'Priya Sharma', role: 'patient', userType: 'patient', age: 28 },
          // Email format
          'admin@telemed.com': { userId: 'admin', name: 'System Admin', role: 'admin', userType: 'admin' },
          'arjun.mehta@telemed.com': { userId: 'd1', name: 'Dr. Arjun Mehta', role: 'doctor', userType: 'doctor', speciality: 'Cardiologist' },
          'riya.kapoor@telemed.com': { userId: 'd2', name: 'Dr. Riya Kapoor', role: 'doctor', userType: 'doctor', speciality: 'Dermatologist' },
          'john.doe@example.com': { userId: 'p1', name: 'John Doe', role: 'patient', userType: 'patient', age: 35 },
          'priya.sharma@example.com': { userId: 'p2', name: 'Priya Sharma', role: 'patient', userType: 'patient', age: 28 },
        };
        
        console.log('🔍 Looking for user:', email, 'with role:', role);
        const user = mockUsers[email];
        console.log('👤 Found user:', user ? 'YES' : 'NO', user);
        
        if (user && user.role === role && password === 'password') {
          console.log('✅ Fallback login successful for:', user.name);
          setUser(user);
          
          // Store mock auth data
          localStorage.setItem('auth_token', 'mock-token-' + Date.now());
          localStorage.setItem('user_data', JSON.stringify(user));
          
          return true;
        } else {
          console.log('❌ Fallback login failed - invalid credentials');
          console.log('   Available users:', Object.keys(mockUsers));
          setError(`Invalid credentials. Try: admin/password (role: admin)`);
          return false;
        }
      }
    } catch (error) {
      console.error('❌ Login error:', error);
      setError(error.message || 'Login failed');
      return false;
    } finally {
      console.log('🏁 Login process complete, setting loading to false');
      setLoading(false);
    }
  }

  // Logout function
  async function logout() {
    try {
      setLoading(true);
      
      // Disconnect socket
      socketService.disconnect();
      
      // Call logout API
      await apiService.logout();
      
      setUser(null);
      setError(null);
    } catch (error) {
      console.error('Logout error:', error);
      // Clear local state even if API call fails
      setUser(null);
      setError(null);
    } finally {
      setLoading(false);
    }
  }

  // Update user data
  function updateUser(userData) {
    setUser(userData);
    // Update localStorage
    localStorage.setItem('user_data', JSON.stringify(userData));
  }

  const value = {
    user,
    loading,
    error,
    login,
    logout,
    updateUser,
    isAuthenticated: !!user,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
