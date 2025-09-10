import React, { createContext, useContext, useState } from "react";

const HospitalContext = createContext();

export function HospitalProvider({ children }) {
  // ✅ Doctors/Staff list
  const [staff, setStaff] = useState([
    {
      id: "d1",
      name: "Dr. Arjun Mehta",
      speciality: "Cardiologist",
      status: "online",
    },
    {
      id: "d2",
      name: "Dr. Riya Kapoor",
      speciality: "Dermatologist",
      status: "offline",
    },
    {
      id: "d3",
      name: "Dr. Mehta Roy",
      speciality: "Child Specialist",
      status: "online",
    },
    {
      id: "d4",
      name: "Dr. Sneha Sharma",
      speciality: "Pediatrician",
      status: "offline",
    },
    {
      id: "d5",
      name: "Dr. Karan Singh",
      speciality: "Neurologist",
      status: "online",
    },
    {
      id: "d6",
      name: "Dr. Priya Nair",
      speciality: "Gynecologist",
      status: "offline",
    },
    {
      id: "d7",
      name: "Dr. Rahul Verma",
      speciality: "Orthopedic",
      status: "online",
    },
    {
      id: "d8",
      name: "Dr. Ananya Iyer",
      speciality: "Oncologist",
      status: "offline",
    },
    {
      id: "d9",
      name: "Dr. Vivek Malhotra",
      speciality: "Psychiatrist",
      status: "online",
    },
    {
      id: "d10",
      name: "Dr. Neha Kulkarni",
      speciality: "Dermatologist",
      status: "offline",
    },
  ]);

  // ✅ Patients list
  const [patients, setPatients] = useState([
    {
      id: "p1",
      name: "John Doe",
      age: 35,
      condition: "Heart Pain",
      status: "waiting",
      assignedTo: "d1",
    },
    {
      id: "p2",
      name: "Priya Sharma",
      age: 28,
      condition: "Skin Allergy",
      status: "waiting",
      assignedTo: "d2",
    },
    {
      id: "p3",
      name: "Amit Verma",
      age: 42,
      condition: "General Checkup",
      status: "waiting",
      assignedTo: null,
    },
    {
      id: "p4",
      name: "Rohit Mehra",
      age: 50,
      condition: "High Blood Pressure",
      status: "under treatment",
      assignedTo: "d3",
    },
    {
      id: "p5",
      name: "Anjali Nair",
      age: 31,
      condition: "Migraine",
      status: "waiting",
      assignedTo: "d5",
    },
    {
      id: "p6",
      name: "Suresh Patel",
      age: 60,
      condition: "Diabetes",
      status: "recovered",
      assignedTo: "d4",
    },
    {
      id: "p7",
      name: "Meena Gupta",
      age: 24,
      condition: "Skin Rash",
      status: "waiting",
      assignedTo: "d10",
    },
    {
      id: "p8",
      name: "Arjun Malhotra",
      age: 37,
      condition: "Asthma",
      status: "under treatment",
      assignedTo: "d7",
    },
    {
      id: "p9",
      name: "Ritika Sen",
      age: 29,
      condition: "Thyroid",
      status: "waiting",
      assignedTo: "d6",
    },
    {
      id: "p10",
      name: "Vikram Chauhan",
      age: 55,
      condition: "Chest Pain",
      status: "waiting",
      assignedTo: "d3",
    },
    {
      id: "p11",
      name: "Neeraj Yadav",
      age: 45,
      condition: "Back Pain",
      status: "under treatment",
      assignedTo: "d7",
    },
    {
      id: "p12",
      name: "Pooja Reddy",
      age: 33,
      condition: "Fever",
      status: "waiting",
      assignedTo: "d2",
    },
    {
      id: "p13",
      name: "Kabir Khan",
      age: 48,
      condition: "Kidney Stone",
      status: "waiting",
      assignedTo: "d8",
    },
    {
      id: "p14",
      name: "Sonia Bansal",
      age: 27,
      condition: "Anxiety",
      status: "under treatment",
      assignedTo: "d9",
    },
    {
      id: "p15",
      name: "Rahul Deshmukh",
      age: 52,
      condition: "Arthritis",
      status: "waiting",
      assignedTo: "d7",
    },
    {
      id: "p16",
      name: "Divya Iyer",
      age: 36,
      condition: "Pregnancy Checkup",
      status: "waiting",
      assignedTo: "d6",
    },
    {
      id: "p17",
      name: "Sameer Arora",
      age: 40,
      condition: "Liver Problem",
      status: "under treatment",
      assignedTo: "d8",
    },
    {
      id: "p18",
      name: "Nidhi Kapoor",
      age: 22,
      condition: "Acne",
      status: "waiting",
      assignedTo: "d10",
    },
    {
      id: "p19",
      name: "Ramesh Kumar",
      age: 58,
      condition: "Stroke Recovery",
      status: "under treatment",
      assignedTo: "d5",
    },
    {
      id: "p20",
      name: "Alok Tiwari",
      age: 46,
      condition: "Obesity",
      status: "waiting",
      assignedTo: "d4",
    },
    {
      id: "p21",
      name: "Isha Jain",
      age: 30,
      condition: "Eye Infection",
      status: "waiting",
      assignedTo: "d1",
    },
    {
      id: "p22",
      name: "Deepak Singh",
      age: 39,
      condition: "Depression",
      status: "under treatment",
      assignedTo: "d9",
    },
    {
      id: "p23",
      name: "Manisha Choudhary",
      age: 41,
      condition: "Gallstones",
      status: "waiting",
      assignedTo: "d8",
    },
  ]);

  return (
    <HospitalContext.Provider
      value={{ staff, setStaff, patients, setPatients }}
    >
      {children}
    </HospitalContext.Provider>
  );
}

export function useHospital() {
  return useContext(HospitalContext);
}
