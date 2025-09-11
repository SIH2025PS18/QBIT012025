import React, { createContext, useContext, useState, useEffect } from "react";
import { doctorAPI, patientAPI, apiUtils } from '../lib/api';
import socketService from '../lib/socketService';
import { message } from 'antd';

const HospitalContext = createContext();

export function HospitalProvider({ children }) {
  // State management
  const [staff, setStaff] = useState([]);
  const [patients, setPatients] = useState([]);
  const [loading, setLoading] = useState(false);
  const [connected, setConnected] = useState(false);

  // Initialize socket connection and load data
  useEffect(() => {
    initializeServices();
    loadInitialData();
    
    return () => {
      socketService.destroy();
    };
  }, []);

  // Initialize socket service
  const initializeServices = async () => {
    try {
      await socketService.connect('http://localhost:5001', {
        userId: 'admin-dashboard',
        userType: 'admin',
        name: 'Admin Dashboard'
      });
      
      setConnected(true);
      setupSocketListeners();
    } catch (error) {
      console.error('Failed to connect to socket service:', error);
      message.error('Failed to connect to real-time service');
    }
  };

  // Setup socket event listeners
  const setupSocketListeners = () => {
    // Doctor events
    socketService.on('doctor_added', (data) => {
      setStaff(prevStaff => [...prevStaff, data.doctor]);
      message.success(`Doctor ${data.doctor.name} added successfully`);
    });

    socketService.on('doctor_updated', (data) => {
      setStaff(prevStaff => 
        prevStaff.map(doctor => 
          doctor.doctorId === data.doctor.doctorId ? data.doctor : doctor
        )
      );
      message.info(`Doctor ${data.doctor.name} updated`);
    });

    socketService.on('doctor_deleted', (data) => {
      setStaff(prevStaff => 
        prevStaff.filter(doctor => doctor.doctorId !== data.doctorId)
      );
      message.info('Doctor removed');
    });

    socketService.on('doctor_status_changed', (data) => {
      setStaff(prevStaff => 
        prevStaff.map(doctor => 
          doctor.doctorId === data.doctorId 
            ? { ...doctor, status: data.status, isAvailable: data.isAvailable }
            : doctor
        )
      );
    });

    // Patient events
    socketService.on('patient_added', (data) => {
      setPatients(prevPatients => [...prevPatients, data.patient]);
      message.success(`Patient ${data.patient.name} added successfully`);
    });

    socketService.on('patient_registered', (data) => {
      // Handle new patient registration from mobile app
      const newPatient = {
        ...data.patient,
        id: data.patient.patientId, // Map for compatibility
        assignedTo: null,
        status: 'registered'
      };
      setPatients(prevPatients => [...prevPatients, newPatient]);
      message.success(`New patient ${data.patient.name} registered from mobile app`);
    });

    socketService.on('patient_updated', (data) => {
      setPatients(prevPatients => 
        prevPatients.map(patient => 
          patient.patientId === data.patient.patientId ? data.patient : patient
        )
      );
      message.info(`Patient ${data.patient.name} updated`);
    });

    socketService.on('patient_deleted', (data) => {
      setPatients(prevPatients => 
        prevPatients.filter(patient => patient.patientId !== data.patientId)
      );
      message.info('Patient removed');
    });

    socketService.on('patient_status_changed', (data) => {
      setPatients(prevPatients => 
        prevPatients.map(patient => 
          patient.patientId === data.patientId 
            ? { ...patient, status: data.status }
            : patient
        )
      );
    });

    // Connection events
    socketService.on('connection_lost', () => {
      setConnected(false);
      message.warning('Real-time connection lost. Trying to reconnect...');
    });

    socketService.on('connection_restored', () => {
      setConnected(true);
      message.success('Real-time connection restored');
    });
  };

  // Load initial data from backend
  const loadInitialData = async () => {
    setLoading(true);
    try {
      // Load doctors
      const doctorsResponse = await doctorAPI.getAll();
      if (doctorsResponse.data.success) {
        setStaff(doctorsResponse.data.data);
      }

      // Load patients
      const patientsResponse = await patientAPI.getAll();
      if (patientsResponse.data.success) {
        setPatients(patientsResponse.data.data.map(patient => ({
          ...patient,
          id: patient.patientId, // Map for compatibility
          assignedTo: patient.assignedDoctorId
        })));
      }
    } catch (error) {
      console.error('Failed to load initial data:', error);
      message.error('Failed to load data from server');
      
      // Fallback to mock data if API fails
      loadMockData();
    } finally {
      setLoading(false);
    }
  };

  // Fallback mock data
  const loadMockData = () => {
    setStaff([
      { doctorId: "d1", name: "Dr. Arjun Mehta", speciality: "Cardiologist", status: "online" },
      { doctorId: "d2", name: "Dr. Riya Kapoor", speciality: "Dermatologist", status: "offline" },
      { doctorId: "d3", name: "Dr. Mehta Roy", speciality: "Child Specialist", status: "online" },
    ]);
    
    setPatients([
      { patientId: "p1", id: "p1", name: "John Doe", age: 35, condition: "Heart Pain", status: "waiting", assignedTo: "d1" },
      { patientId: "p2", id: "p2", name: "Priya Sharma", age: 28, condition: "Skin Allergy", status: "waiting", assignedTo: "d2" },
    ]);
  };

  // Enhanced CRUD operations with API integration
  const addDoctor = async (doctorData) => {
    try {
      setLoading(true);
      const response = await doctorAPI.create({
        ...doctorData,
        doctorId: doctorData.id
      });
      
      if (response.data.success) {
        // Socket will handle the UI update
        return response.data.data;
      }
    } catch (error) {
      const errorMessage = apiUtils.handleError(error);
      message.error(`Failed to add doctor: ${errorMessage}`);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const updateDoctor = async (doctorId, doctorData) => {
    try {
      setLoading(true);
      const response = await doctorAPI.update(doctorId, doctorData);
      
      if (response.data.success) {
        // Socket will handle the UI update
        return response.data.data;
      }
    } catch (error) {
      const errorMessage = apiUtils.handleError(error);
      message.error(`Failed to update doctor: ${errorMessage}`);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const deleteDoctor = async (doctorId) => {
    try {
      setLoading(true);
      await doctorAPI.delete(doctorId);
      // Socket will handle the UI update
    } catch (error) {
      const errorMessage = apiUtils.handleError(error);
      message.error(`Failed to delete doctor: ${errorMessage}`);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const addPatient = async (patientData) => {
    try {
      setLoading(true);
      const response = await patientAPI.create({
        ...patientData,
        patientId: patientData.id || `p${Date.now()}`,
        assignedDoctorId: patientData.assignedTo
      });
      
      if (response.data.success) {
        // Socket will handle the UI update
        return response.data.data;
      }
    } catch (error) {
      const errorMessage = apiUtils.handleError(error);
      message.error(`Failed to add patient: ${errorMessage}`);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const updatePatient = async (patientId, patientData) => {
    try {
      setLoading(true);
      const response = await patientAPI.update(patientId, {
        ...patientData,
        assignedDoctorId: patientData.assignedTo
      });
      
      if (response.data.success) {
        // Socket will handle the UI update
        return response.data.data;
      }
    } catch (error) {
      const errorMessage = apiUtils.handleError(error);
      message.error(`Failed to update patient: ${errorMessage}`);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const deletePatient = async (patientId) => {
    try {
      setLoading(true);
      await patientAPI.delete(patientId);
      // Socket will handle the UI update
    } catch (error) {
      const errorMessage = apiUtils.handleError(error);
      message.error(`Failed to delete patient: ${errorMessage}`);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  // Legacy setters for backward compatibility
  const legacySetStaff = (updateFunction) => {
    if (typeof updateFunction === 'function') {
      setStaff(updateFunction);
    } else {
      setStaff(updateFunction);
    }
  };

  const legacySetPatients = (updateFunction) => {
    if (typeof updateFunction === 'function') {
      setPatients(updateFunction);
    } else {
      setPatients(updateFunction);
    }
  };

  const contextValue = {
    // Data
    staff,
    patients,
    loading,
    connected,
    
    // Legacy setters
    setStaff: legacySetStaff,
    setPatients: legacySetPatients,
    
    // Enhanced API methods
    addDoctor,
    updateDoctor,
    deleteDoctor,
    addPatient,
    updatePatient,
    deletePatient,
    
    // Utility methods
    refreshData: loadInitialData,
    getConnectionStatus: () => socketService.getConnectionStatus()
  };

  return (
    <HospitalContext.Provider value={contextValue}>
      {children}
    </HospitalContext.Provider>
  );
}

export function useHospital() {
  return useContext(HospitalContext);
}
