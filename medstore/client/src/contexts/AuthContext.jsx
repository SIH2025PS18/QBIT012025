import { createContext, useContext, useReducer, useEffect } from 'react';
import axios from 'axios';

const AuthContext = createContext();

const authReducer = (state, action) => {
  switch (action.type) {
    case 'LOGIN_START':
      return { ...state, loading: true, error: null };
    case 'LOGIN_SUCCESS':
      return { ...state, loading: false, user: action.payload, error: null };
    case 'LOGIN_FAILURE':
      return { ...state, loading: false, user: null, error: action.payload };
    case 'LOGOUT':
      return { ...state, user: null, error: null };
    case 'CLEAR_ERROR':
      return { ...state, error: null };
    case 'UPDATE_USER':
      return { ...state, user: { ...state.user, ...action.payload } };
    default:
      return state;
  }
};

export const AuthProvider = ({ children }) => {
  const [state, dispatch] = useReducer(authReducer, {
    user: null,
    loading: false,
    error: null
  });

  // ✅ On app load, restore user from localStorage and set axios header
  useEffect(() => {
  const storedUser = localStorage.getItem('user');
  if (storedUser) {
    try {
      const user = JSON.parse(storedUser);
      if (user.token && typeof user.token === 'string' && user.token.split('.').length === 3) {
        dispatch({ type: 'LOGIN_SUCCESS', payload: user });
        axios.defaults.headers.common['Authorization'] = `Bearer ${user.token}`;
      } else {
        console.warn('Invalid JWT found in localStorage, clearing...');
        localStorage.removeItem('user');
      }
    } catch (err) {
      console.error('Failed to parse user from localStorage', err);
      localStorage.removeItem('user');
    }
  }
}, []);



  const login = async (email, password) => {
    dispatch({ type: 'LOGIN_START' });
    try {
      const response = await axios.post('http://localhost:5000/api/auth/login', { email, password });
      const user = response.data;

      // ✅ Store user & token
      localStorage.setItem('user', JSON.stringify(user));
      axios.defaults.headers.common['Authorization'] = `Bearer ${user.token}`;

      dispatch({ type: 'LOGIN_SUCCESS', payload: user });
      return { success: true, data: user }; // ✅ return user data for role-based redirect
    } catch (error) {
      const message = error.response?.data?.message || 'Login failed';
      dispatch({ type: 'LOGIN_FAILURE', payload: message });
      return { success: false, error: message };
    }
  };

  const logout = () => {
    localStorage.removeItem('user');
    delete axios.defaults.headers.common['Authorization'];
    dispatch({ type: 'LOGOUT' });
  };

  const clearError = () => dispatch({ type: 'CLEAR_ERROR' });

  const updateUser = (userData) => {
    const updatedUser = { ...state.user, ...userData };
    localStorage.setItem('user', JSON.stringify(updatedUser));
    dispatch({ type: 'UPDATE_USER', payload: userData });
  };
  // Inside AuthContext.jsx

const register = async (userData) => {
  dispatch({ type: 'LOGIN_START' });
  try {
    // Call backend register endpoint
    const response = await axios.post('http://localhost:5000/api/auth/register', userData);
    const user = response.data;

    // Save user in localStorage
    localStorage.setItem('user', JSON.stringify(user));

    // Set axios default auth header
    axios.defaults.headers.common['Authorization'] = `Bearer ${user.token}`;

    dispatch({ type: 'LOGIN_SUCCESS', payload: user });
    return { success: true, data: user };
  } catch (error) {
    const message = error.response?.data?.message || 'Registration failed';
    dispatch({ type: 'LOGIN_FAILURE', payload: message });
    return { success: false, error: message };
  }
};



  return (
    <AuthContext.Provider value={{
      user: state.user,
      loading: state.loading,
      error: state.error,
      login,
      logout,
      clearError,
      updateUser,
      register
    }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within an AuthProvider');
  return context;
};
