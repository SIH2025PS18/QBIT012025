import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import { HospitalProvider } from "./context/HospitalContext.jsx";
import { AuthProvider } from "./context/AuthContext.jsx";
import "antd/dist/reset.css";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    {/* ✅ HospitalProvider must wrap AuthProvider */}
    <HospitalProvider>
      <AuthProvider>
        <App />
      </AuthProvider>
    </HospitalProvider>
  </React.StrictMode>
);
