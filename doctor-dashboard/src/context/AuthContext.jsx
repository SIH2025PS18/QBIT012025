import React, { createContext, useContext, useState } from "react";
import { useHospital } from "./HospitalContext.jsx"; // ✅ important

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const { staff, patients } = useHospital(); // ✅ get both
  const [user, setUser] = useState(null);

  function login({ role, id, password }) {
    if (role === "admin" && id === "admin" && password === "admin123") {
      setUser({ id: "admin", role: "admin", name: "Hospital Admin" });
      return true;
    }

    if (role === "doctor" && password === "doc123") {
      const doctor = staff.find((d) => d.id === id);
      if (doctor) {
        setUser({
          id: doctor.id,
          role: "doctor",
          name: doctor.name,
          speciality: doctor.speciality,
        });
        return true;
      }
    }

    if (role === "patient" && password === "pat123") {
      const patient = patients.find((p) => p.id === id);
      if (patient) {
        setUser({
          id: patient.id,
          role: "patient",
          name: patient.name,
          assignedTo: patient.assignedTo,
        });
        return true;
      }
    }

    return false;
  }

  function logout() {
    setUser(null);
  }

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
