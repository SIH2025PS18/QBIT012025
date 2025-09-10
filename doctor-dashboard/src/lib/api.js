import axios from "axios";

const API = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:4000",
  withCredentials: true,
});

export async function fetchQueue() {
  const res = await API.get("/queue");
  return res.data;
}

export async function fetchPatient(patientId) {
  const res = await API.get(`/patients/${patientId}`);
  return res.data;
}

export async function submitPrescription(payload) {
  const res = await API.post("/prescriptions", payload);
  return res.data;
}

// export API for other calls
export default API;
