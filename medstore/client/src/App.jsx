import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext.jsx';
import Navbar from './components/layout/Navbar.jsx';
import Footer from './components/layout/Footer.jsx';
import Home from './pages/Home.jsx';
import Login from './pages/auth/Login.jsx';
import Register from './pages/auth/Register.jsx';
import Profile from './pages/users/Profile.jsx';
import Medicines from './pages/medicines/Medicines.jsx';
import MedicineDetails from './pages/medicines/MedicineDetails.jsx';
import Cart from './pages/orders/Cart.jsx';
import Orders from './pages/orders/Orders.jsx';
import PharmacyDashboard from './pages/pharmacy/Dashboard.jsx';
import AdminDashboard from './pages/admin/Dashboard.jsx';

// Protected Route Component
const ProtectedRoute = ({ children, requiredRoles }) => {
  const { user, logout } = useAuth();

  // Redirect if not logged in
  if (!user) return <Navigate to="/login" />;

  // If token is invalid/expired, auto-logout
  if (!user.token || user.token.split('.').length !== 3) {
    logout();
    return <Navigate to="/login" />;
  }

  // Redirect if role is not allowed
  if (requiredRoles && !requiredRoles.includes(user.role)) return <Navigate to="/" />;

  return children;
};

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="min-h-screen bg-gray-50 flex flex-col">
          <Navbar />
          <main className="flex-grow">
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/login" element={<Login />} />
              <Route path="/register" element={<Register />} />
              <Route path="/medicines" element={<Medicines />} />
              <Route path="/medicines/:id" element={<MedicineDetails />} />

              {/* Protected Routes */}
              <Route path="/profile" element={
                <ProtectedRoute>
                  <Profile />
                </ProtectedRoute>
              } />
              <Route path="/cart" element={
                <ProtectedRoute>
                  <Cart />
                </ProtectedRoute>
              } />
              <Route path="/orders" element={
                <ProtectedRoute>
                  <Orders />
                </ProtectedRoute>
              } />
              <Route path="/pharmacy/dashboard" element={
                <ProtectedRoute requiredRoles={['pharmacy', 'admin']}>
                  <PharmacyDashboard />
                </ProtectedRoute>
              } />
              <Route path="/admin/dashboard" element={
                <ProtectedRoute requiredRoles={['admin']}>
                  <AdminDashboard />
                </ProtectedRoute>
              } />
            </Routes>
          </main>
          <Footer />
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
