import React, { useState } from "react";
import Queue from "../components/Queue";
import PatientCard from "../components/PatientCard";
import PrescriptionForm from "../components/PrescriptionForm";
import VideoCall from "../components/VideoCall";
import { Row, Col, Card, Statistic, Tag, Divider } from "antd";
import { useHospital } from "../context/HospitalContext.jsx";
import { useAuth } from "../context/AuthContext.jsx";
import {
  UserOutlined,
  TeamOutlined,
  HeartOutlined,
  MedicineBoxOutlined,
  VideoCameraOutlined,
  FileTextOutlined,
  ClockCircleOutlined
} from '@ant-design/icons';
import './DoctorDashboard.css';

export default function DoctorDashboard() {
  const { patients, staff } = useHospital();
  const { user } = useAuth(); // current doctor
  const [patientDetails, setPatientDetails] = useState(null);

  // ✅ Only patients assigned to this doctor
  const myPatients = patients.filter((p) => p.assignedTo === user?.id);
  
  // Count patients by status
  const waitingCount = myPatients.filter(p => p.status === 'waiting').length;
  const inConsultationCount = myPatients.filter(p => p.status === 'in consultation').length;
  const dischargedCount = myPatients.filter(p => p.status === 'discharged').length;

  function onSelectPatient(p) {
    setPatientDetails(p);
  }

  return (
    <div className="doctor-dashboard">
      <div className="dashboard-header">
        <div className="header-content">
          <div className="doctor-info">
            <h1>
              <UserOutlined className="header-icon" />
              Doctor Portal
            </h1>
            <p>Welcome back, <span className="doctor-name">Dr. {user?.name}</span></p>
            <Tag color="blue" className="speciality-tag">{user?.speciality}</Tag>
          </div>
          <div className="stats-overview">
            <div className="stat-card">
              <TeamOutlined />
              <div className="stat-details">
                <span className="stat-number">{myPatients.length}</span>
                <span className="stat-label">Total Patients</span>
              </div>
            </div>
            <div className="stat-card">
              <ClockCircleOutlined />
              <div className="stat-details">
                <span className="stat-number">{waitingCount}</span>
                <span className="stat-label">Waiting</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Row gutter={[16, 16]} className="dashboard-content">
        <Col xs={24} lg={8}>
          <Card 
            className="queue-card" 
            title={
              <div className="card-title">
                <TeamOutlined />
                <span>Patient Queue</span>
                <Tag className="queue-count">{myPatients.length}</Tag>
              </div>
            }
          >
            <Queue onSelectPatient={onSelectPatient} patients={myPatients} />
          </Card>
          
          <Card 
            className="stats-card" 
            title={
              <div className="card-title">
                <HeartOutlined />
                <span>Today's Statistics</span>
              </div>
            }
            style={{ marginTop: 16 }}
          >
            <Row gutter={[16, 16]}>
              <Col xs={8}>
                <Statistic
                  title="Waiting"
                  value={waitingCount}
                  valueStyle={{ color: '#fa8c16' }}
                  prefix={<ClockCircleOutlined />}
                />
              </Col>
              <Col xs={8}>
                <Statistic
                  title="In Consultation"
                  value={inConsultationCount}
                  valueStyle={{ color: '#1890ff' }}
                  prefix={<UserOutlined />}
                />
              </Col>
              <Col xs={8}>
                <Statistic
                  title="Discharged"
                  value={dischargedCount}
                  valueStyle={{ color: '#52c41a' }}
                  prefix={<MedicineBoxOutlined />}
                />
              </Col>
            </Row>
          </Card>
        </Col>

        <Col xs={24} lg={16}>
          {patientDetails ? (
            <>
              <Card 
                className="patient-card" 
                title={
                  <div className="card-title">
                    <UserOutlined />
                    <span>Patient Details</span>
                    <Tag color={
                      patientDetails.status === 'waiting' ? 'orange' : 
                      patientDetails.status === 'in consultation' ? 'blue' : 'green'
                    }>
                      {patientDetails.status.toUpperCase()}
                    </Tag>
                  </div>
                }
              >
                <PatientCard patient={patientDetails} />
              </Card>
              
              <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
                <Col xs={24} lg={12}>
                  <Card 
                    className="action-card" 
                    title={
                      <div className="card-title">
                        <VideoCameraOutlined />
                        <span>Video Consultation</span>
                      </div>
                    }
                  >
                    <VideoCall patient={patientDetails} doctorId={user?.id} />
                  </Card>
                </Col>
                
                <Col xs={24} lg={12}>
                  <Card 
                    className="action-card" 
                    title={
                      <div className="card-title">
                        <FileTextOutlined />
                        <span>Prescription</span>
                      </div>
                    }
                  >
                    <PrescriptionForm patientId={patientDetails?.id} />
                  </Card>
                </Col>
              </Row>
            </>
          ) : (
            <Card className="placeholder-card">
              <div className="placeholder-content">
                <UserOutlined className="placeholder-icon" />
                <h3>Select a Patient</h3>
                <p>Choose a patient from the queue to view details and begin consultation</p>
              </div>
            </Card>
          )}
        </Col>
      </Row>
    </div>
  );
}