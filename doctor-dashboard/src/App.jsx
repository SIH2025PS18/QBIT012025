import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { useAuth } from "./context/AuthContext.jsx";
import { Spin } from "antd";
import Login from "./pages/Login.jsx";
import AdminPortal from "./pages/AdminPortal.jsx";
import DoctorDashboard from "./pages/DoctorDashboard.jsx";
import PatientDashboard from "./pages/PatientDashboard.jsx"; // ✅ new

export default function App() {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100vh',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
      }}>
        <div style={{ textAlign: 'center', color: 'white' }}>
          <Spin size="large" />
          <div style={{ marginTop: 20, fontSize: 16 }}>Loading TeleMed Dashboard...</div>
        </div>
      </div>
    );
  }

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />

        <Route
          path="/admin"
          element={user?.role === "admin" ? <AdminPortal /> : <Navigate to="/" />}
        />

        <Route
          path="/doctor"
          element={user?.role === "doctor" ? <DoctorDashboard /> : <Navigate to="/" />}
        />

        <Route
          path="/patient"
          element={user?.role === "patient" ? <PatientDashboard /> : <Navigate to="/" />}
        />

        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </BrowserRouter>
  );
}
