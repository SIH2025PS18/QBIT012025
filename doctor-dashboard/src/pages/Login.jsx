import React, { useState } from "react";
import { Card, Form, Input, Button, Select, message, Layout, Row, Col, Divider } from "antd";
import { useAuth } from "../context/AuthContext.jsx";
import { useNavigate } from "react-router-dom";
import {
  HeartOutlined,
  MedicineBoxOutlined,
  TeamOutlined,
  UserOutlined,
  LockOutlined,
  SafetyCertificateOutlined,
  PhoneOutlined,
  MailOutlined,
  EnvironmentOutlined
} from '@ant-design/icons';
import './Login.css';

const { Header, Footer, Content } = Layout;

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);

  async function onFinish(values) {
    setLoading(true);
    try {
      const success = await login({
        role: values.role,
        email: values.id, // Using id as email for now
        password: values.password
      });
      
      if (success) {
        message.success("Login successful");
        if (values.role === "admin") navigate("/admin");
        else if (values.role === "doctor") navigate("/doctor");
        else if (values.role === "patient") navigate("/patient");
      } else {
        message.error("Invalid credentials");
      }
    } catch (error) {
      console.error('Login error:', error);
      message.error("Login failed. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <Layout className="login-layout">
      <Header className="login-header">
        <div className="header-content">
          <div className="logo">
            <MedicineBoxOutlined className="logo-icon" />
            <span className="clinic-name">MediCare Hospital</span>
          </div>
          <nav className="nav-links">
            <a href="#about">About</a>
            <a href="#services">Services</a>
            <a href="#contact">Contact</a>
          </nav>
        </div>
      </Header>

      <Content className="login-content">
        <Row className="full-height" gutter={0}>
          <Col xs={0} md={12} className="login-graphics">
            <div className="graphics-content">
              <div className="graphics-text">
                <h2>Advanced Healthcare Management System</h2>
                <Divider className="divider" />
                <div className="feature-list">
                  <div className="feature-item">
                    <MedicineBoxOutlined />
                    <span>Electronic Health Records</span>
                  </div>
                  <div className="feature-item">
                    <TeamOutlined />
                    <span>Staff & Patient Management</span>
                  </div>
                  <div className="feature-item">
                    <SafetyCertificateOutlined />
                    <span>Secure & HIPAA Compliant</span>
                  </div>
                </div>
              </div>
            </div>
          </Col>
          <Col xs={24} md={12} className="login-form-col">
            <div className="form-container">
              <Card className="login-card">
                <div className="card-header">
                  <div className="welcome-text">
                    <h1>Welcome Back</h1>
                    <p>Sign in to access the hospital management system</p>
                  </div>
                  <div className="medical-graphic">
                    <div className="heart-pulse">
                      <HeartOutlined className="pulse-icon" />
                    </div>
                  </div>
                </div>

                <Form layout="vertical" onFinish={onFinish} className="login-form">
                  <Form.Item 
                    name="role" 
                    label="Select Your Role" 
                    rules={[{ required: true, message: 'Please select your role' }]}
                  >
                    <Select 
                      placeholder="Choose your role" 
                      suffixIcon={<UserOutlined />}
                      className="role-selector"
                    >
                      <Select.Option value="admin">
                        <TeamOutlined /> Administrator
                      </Select.Option>
                      <Select.Option value="doctor">
                        <MedicineBoxOutlined /> Doctor
                      </Select.Option>
                      <Select.Option value="patient">
                        <UserOutlined /> Patient
                      </Select.Option>
                    </Select>
                  </Form.Item>

                  <Form.Item
                    name="id"
                    label="User ID"
                    rules={[{ required: true, message: 'Please enter your user ID' }]}
                  >
                    <Input 
                      prefix={<UserOutlined className="input-icon" />} 
                      placeholder="Try: admin, d1, d2, p1, p2" 
                      className="login-input"
                    />
                  </Form.Item>

                  <Form.Item
                    name="password"
                    label="Password"
                    rules={[{ required: true, message: 'Please enter your password' }]}
                  >
                    <Input.Password 
                      prefix={<LockOutlined className="input-icon" />} 
                      placeholder="Default password: password" 
                      className="login-input"
                    />
                  </Form.Item>

                  <Button 
                    type="primary" 
                    htmlType="submit" 
                    block 
                    loading={loading}
                    className="login-button"
                    icon={<SafetyCertificateOutlined />}
                  >
                    Sign In
                  </Button>
                </Form>

                <div className="login-help">
                  <p><strong>Demo Credentials:</strong></p>
                  <p>Admin: admin / password</p>
                  <p>Doctor: d1 or d2 / password</p>
                  <p>Patient: p1 or p2 / password</p>
                  <p style={{ marginTop: 15, fontSize: 12, opacity: 0.7 }}>Need help? Contact hospital administration at extension 1000</p>
                </div>
              </Card>
            </div>
          </Col>
        </Row>
      </Content>

      <Footer className="login-footer">
        <div className="footer-content">
          <div className="footer-section">
            <h3>MediCare Hospital</h3>
            <p>Providing quality healthcare since 1985</p>
            <div className="contact-info">
              <p><EnvironmentOutlined /> 123 Medical Drive, Health City, HC 12345</p>
              <p><PhoneOutlined /> (555) 123-HELP</p>
              <p><MailOutlined /> info@medicare-hospital.com</p>
            </div>
          </div>
          <div className="footer-section">
            <h4>Quick Links</h4>
            <a href="#privacy">Privacy Policy</a>
            <a href="#terms">Terms of Service</a>
            <a href="#support">Support</a>
            <a href="#careers">Careers</a>
            <a href="#news">News & Events</a>
          </div>
          <div className="footer-section">
            <h4>Medical Services</h4>
            <a href="#emergency">Emergency Care</a>
            <a href="#surgery">Surgery</a>
            <a href="#pediatrics">Pediatrics</a>
            <a href="#cardiology">Cardiology</a>
            <a href="#oncology">Oncology</a>
          </div>
        </div>
        <div className="footer-bottom">
          <p>&copy; 2023 MediCare Hospital. All rights reserved. | HIPAA Compliant</p>
        </div>
      </Footer>
    </Layout>
  );
}