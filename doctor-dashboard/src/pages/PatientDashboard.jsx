import React from "react";
import { Card, Row, Col, Tag, Statistic, Progress, Divider } from "antd";
import { useAuth } from "../context/AuthContext.jsx";
import { useHospital } from "../context/HospitalContext.jsx";
import VideoCall from "../components/VideoCall";
import {
  UserOutlined,
  TeamOutlined,
  HeartOutlined,
  ClockCircleOutlined,
  MedicineBoxOutlined,
  CalendarOutlined,
  PhoneOutlined,
  MessageOutlined,
  VideoCameraOutlined
} from '@ant-design/icons';
import './PatientDashboard.css';

export default function PatientDashboard() {
  const { user } = useAuth();
  const { staff, patients } = useHospital();

  // Always compute doctor dynamically so changes reflect immediately
  const doctor = staff.find((d) => d.id === user?.assignedTo);
  const patientDetails = patients.find((p) => p.id === user?.id);

  // Calculate wait time (example logic)
  const waitTime = patientDetails?.status === 'waiting' ? '15-20 minutes' : '0 minutes';
  
  // Format status text properly
  const formatStatus = (status) => {
    if (!status) return 'UNKNOWN';
    if (status === 'in consultation') return 'IN CONSULTATION';
    return status.toUpperCase();
  };
  
  // Mock health metrics
  const healthMetrics = [
    { name: 'Heart Rate', value: '72 bpm', normalRange: '60-100 bpm' },
    { name: 'Blood Pressure', value: '120/80 mmHg', normalRange: '90/60 - 120/80 mmHg' },
    { name: 'Temperature', value: '98.6°F', normalRange: '97.8-99.1°F' },
  ];

  return (
    <div className="patient-dashboard">
      <div className="dashboard-header">
        <div className="header-content">
          <div className="patient-info">
            <h1>
              <UserOutlined className="header-icon" />
              Patient Portal
            </h1>
            <p>Welcome back, <span className="patient-name">{user?.name}</span></p>
          </div>
          <div className="status-indicator">
            <Tag 
              color={
                patientDetails?.status === 'waiting' ? 'orange' : 
                patientDetails?.status === 'in consultation' ? 'blue' : 'green'
              } 
              className="status-tag"
            >
              {formatStatus(patientDetails?.status)}
            </Tag>
          </div>
        </div>
      </div>

      <Row gutter={[16, 16]} className="dashboard-content">
        <Col xs={24} lg={8}>
          <Card className="info-card" title={
            <div className="card-title">
              <TeamOutlined />
              <span>Your Care Team</span>
            </div>
          }>
            {doctor ? (
              <div className="doctor-info">
                <div className="doctor-avatar">
                  <UserOutlined />
                </div>
                <div className="doctor-details">
                  <h3>{doctor.name}</h3>
                  <p className="speciality">{doctor.speciality}</p>
                  <div className="status-container">
                    <div className={`status-dot ${doctor.status}`}></div>
                    <span className="status-text">{doctor.status}</span>
                  </div>
                  <div className="action-buttons">
                    <button className="action-btn">
                      <MessageOutlined />
                      Message
                    </button>
                    <button className="action-btn">
                      <PhoneOutlined />
                      Call
                    </button>
                  </div>
                </div>
              </div>
            ) : (
              <div className="no-doctor">
                <p>No doctor assigned yet</p>
                <p className="subtext">Please wait for the administrator to assign a doctor to you.</p>
              </div>
            )}
          </Card>

          <Card className="info-card" title={
            <div className="card-title">
              <ClockCircleOutlined />
              <span>Appointment Info</span>
            </div>
          } style={{ marginTop: 16 }}>
            <div className="appointment-info">
              <Statistic
                title="Estimated Wait Time"
                value={waitTime}
                prefix={<ClockCircleOutlined />}
                valueStyle={{ color: waitTime !== '0 minutes' ? '#fa8c16' : '#52c41a' }}
              />
              <Divider className="divider" />
              <div className="next-appointment">
                <CalendarOutlined />
                <div className="appointment-details">
                  <span className="label">Next Appointment</span>
                  <span className="value">Not scheduled</span>
                </div>
              </div>
            </div>
          </Card>
        </Col>

        <Col xs={24} lg={8}>
          <Card className="info-card" title={
            <div className="card-title">
              <HeartOutlined />
              <span>Health Overview</span>
            </div>
          }>
            <div className="health-metrics">
              {healthMetrics.map((metric, index) => (
                <div key={index} className="metric-item">
                  <div className="metric-header">
                    <span className="metric-name">{metric.name}</span>
                    <span className="metric-value">{metric.value}</span>
                  </div>
                  <Progress 
                    percent={85} 
                    showInfo={false} 
                    strokeColor={{
                      '0%': '#108ee9',
                      '100%': '#87d068',
                    }}
                    className="metric-progress"
                  />
                  <div className="metric-range">
                    Normal range: {metric.normalRange}
                  </div>
                </div>
              ))}
            </div>
          </Card>

          <Card className="info-card" title={
            <div className="card-title">
              <MedicineBoxOutlined />
              <span>Medications</span>
            </div>
          } style={{ marginTop: 16 }}>
            <div className="medications-list">
              <div className="no-medications">
                <p>No current medications</p>
                <p className="subtext">Your doctor will prescribe medications after consultation.</p>
              </div>
            </div>
          </Card>
        </Col>

        <Col xs={24} lg={8}>
          <Card className="info-card video-call-card" title={
            <div className="card-title">
              <VideoCameraOutlined />
              <span>Video Consultation</span>
            </div>
          }>
            {doctor ? (
              <div className="video-call-container">
                <VideoCall patient={patientDetails} doctorId={doctor.id} />
                <div className="call-instructions">
                  <h4>Before you call:</h4>
                  <ul>
                    <li>Ensure you have a stable internet connection</li>
                    <li>Find a quiet, private space for your consultation</li>
                    <li>Have your ID and insurance information ready</li>
                  </ul>
                </div>
              </div>
            ) : (
              <div className="no-video-call">
                <p>Video consultation will be available once a doctor is assigned to you.</p>
              </div>
            )}
          </Card>
        </Col>
      </Row>
    </div>
  );
}