import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { useAuth } from "./context/AuthContext.jsx";
import Login from "./pages/Login.jsx";
import AdminPortal from "./pages/AdminPortal.jsx";
import DoctorDashboard from "./pages/DoctorDashboard.jsx";
import PatientDashboard from "./pages/PatientDashboard.jsx"; // ✅ new

export default function App() {
  const { user } = useAuth();

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
