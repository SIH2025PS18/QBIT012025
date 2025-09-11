import React, { useState, useEffect } from "react";
import Queue from "../components/Queue";
import PatientCard from "../components/PatientCard";
import PrescriptionForm from "../components/PrescriptionForm";
import VideoCall from "../components/VideoCall";
import { Row, Col, Card, Statistic, Tag, Spin, message } from "antd";
import { useAuth } from "../context/AuthContext.jsx";
import apiService from "../lib/apiService.js";
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
  const { user } = useAuth(); // current doctor
  const [patientDetails, setPatientDetails] = useState(null);
  const [consultations, setConsultations] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  // Fetch today's schedule and stats
  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        setLoading(true);
        const [scheduleResponse, statsResponse] = await Promise.all([
          apiService.getTodaySchedule(),
          apiService.getDoctorStats()
        ]);

        if (scheduleResponse.success) {
          setConsultations(scheduleResponse.data.consultations.all || []);
        }
        
        if (statsResponse.success) {
          setStats(statsResponse.data);
        }
      } catch (error) {
        console.error('Error fetching dashboard data:', error);
        message.error('Failed to load dashboard data');
      } finally {
        setLoading(false);
      }
    };

    if (user) {
      fetchDashboardData();
    }
  }, [user]);

  // Filter consultations by status
  const waitingConsultations = consultations.filter(c => c.status === 'waiting');
  const inProgressConsultations = consultations.filter(c => c.status === 'in_progress');
  const completedConsultations = consultations.filter(c => c.status === 'completed');

  function onSelectPatient(consultation) {
    setPatientDetails(consultation);
  }

  if (loading) {
    return (
      <div className="doctor-dashboard" style={{ textAlign: 'center', padding: '50px' }}>
        <Spin size="large" />
        <p>Loading dashboard...</p>
      </div>
    );
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
            <Tag color="blue" className="speciality-tag">{user?.specialization}</Tag>
          </div>
          <div className="stats-overview">
            <div className="stat-card">
              <TeamOutlined />
              <div className="stat-details">
                <span className="stat-number">{consultations.length}</span>
                <span className="stat-label">Total Today</span>
              </div>
            </div>
            <div className="stat-card">
              <ClockCircleOutlined />
              <div className="stat-details">
                <span className="stat-number">{waitingConsultations.length}</span>
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
                <Tag className="queue-count">{waitingConsultations.length}</Tag>
              </div>
            }
          >
            <Queue onSelectPatient={onSelectPatient} patients={waitingConsultations} />
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
                  value={waitingConsultations.length}
                  valueStyle={{ color: '#fa8c16' }}
                  prefix={<ClockCircleOutlined />}
                />
              </Col>
              <Col xs={8}>
                <Statistic
                  title="In Progress"
                  value={inProgressConsultations.length}
                  valueStyle={{ color: '#1890ff' }}
                  prefix={<UserOutlined />}
                />
              </Col>
              <Col xs={8}>
                <Statistic
                  title="Completed"
                  value={completedConsultations.length}
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
                      patientDetails.status === 'in_progress' ? 'blue' : 'green'
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