import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

// roles: array of allowed roles, e.g., ['admin'], ['pharmacy', 'admin']
const PrivateRoute = ({ roles }) => {
  const { user } = useAuth();

  if (!user) {
    // Not logged in
    return <Navigate to="/login" replace />;
  }

  if (roles && !roles.includes(user.role)) {
    // Logged in but role not allowed
    return <Navigate to="/" replace />;
  }

  // Authorized
  return <Outlet />;
};

export default PrivateRoute;
