import React, { useState } from "react";
import {
  Card,
  Table,
  Tag,
  Button,
  Modal,
  Form,
  Input,
  Select,
  Space,
  Popconfirm,
} from "antd";
import { useHospital } from "../context/HospitalContext.jsx";
import {
  UserAddOutlined,
  EditOutlined,
  DeleteOutlined,
  TeamOutlined,
  MedicineBoxOutlined,
  HeartOutlined,
  LogoutOutlined
} from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import './AdminPortal.css';

export default function AdminPortal() {
  const { staff, setStaff, patients, setPatients } = useHospital();
  const navigate = useNavigate();

  // =================== Doctor Modal ===================
  const [isStaffModalOpen, setStaffModalOpen] = useState(false);
  const [editingStaff, setEditingStaff] = useState(null);
  const [staffForm] = Form.useForm();

  // ✅ Add/Edit Doctor
  const handleStaffSubmit = (values) => {
    if (editingStaff) {
      setStaff((prev) =>
        prev.map((s) =>
          s.id === editingStaff.id ? { ...editingStaff, ...values } : s
        )
      );
    } else {
      setStaff((prev) => [...prev, { id: values.id, ...values }]);
    }
    setStaffModalOpen(false);
    setEditingStaff(null);
    staffForm.resetFields();
  };

  const handleDeleteStaff = (id) => {
    setStaff((prev) => prev.filter((s) => s.id !== id));
  };

  // ✅ Staff Table Columns - UPDATED TO INCLUDE SPECIALITY
  const staffColumns = [
    { 
      title: <span className="table-header">DOCTOR ID</span>, 
      dataIndex: "id",
      render: (text) => <span className="doctor-id">{text}</span>
    },
    { 
      title: <span className="table-header">NAME</span>, 
      dataIndex: "name",
      render: (text) => <span className="staff-name">{text}</span>
    },
    { 
      title: <span className="table-header">SPECIALITY</span>, 
      dataIndex: "speciality", // This was likely missing or incorrect
      render: (text) => <span className="doctor-speciality-tag">{text}</span>
    },
    {
      title: <span className="table-header">STATUS</span>,
      dataIndex: "status",
      render: (status) =>
        status === "online" ? (
          <Tag color="green" className="status-tag">
            <span className="status-indicator online"></span>
            Online
          </Tag>
        ) : (
          <Tag color="red" className="status-tag">
            <span className="status-indicator offline"></span>
            Offline
          </Tag>
        ),
    },
    {
      title: <span className="table-header">ACTIONS</span>,
      render: (_, record) => (
        <Space>
          <Button
            size="small"
            className="edit-btn"
            icon={<EditOutlined />}
            onClick={() => {
              setEditingStaff(record);
              staffForm.setFieldsValue(record);
              setStaffModalOpen(true);
            }}
          >
            Edit
          </Button>
          <Popconfirm
            title="Delete doctor?"
            onConfirm={() => handleDeleteStaff(record.id)}
          >
            <Button size="small" danger className="delete-btn" icon={<DeleteOutlined />}>
              Delete
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  // =================== Patient Modal ===================
  const [isPatientModalOpen, setPatientModalOpen] = useState(false);
  const [editingPatient, setEditingPatient] = useState(null);
  const [patientForm] = Form.useForm();

  const handlePatientSubmit = (values) => {
    if (editingPatient) {
      setPatients((prev) =>
        prev.map((p) =>
          p.id === editingPatient.id ? { ...editingPatient, ...values } : p
        )
      );
    } else {
      setPatients((prev) => [
        ...prev,
        { id: Date.now().toString(), ...values },
      ]);
    }
    setPatientModalOpen(false);
    setEditingPatient(null);
    patientForm.resetFields();
  };

  const handleDeletePatient = (id) => {
    setPatients((prev) => prev.filter((p) => p.id !== id));
  };

  const patientColumns = [
    { 
      title: <span className="table-header">NAME</span>, 
      dataIndex: "name",
      render: (text) => <span className="patient-name">{text}</span>
    },
    { 
      title: <span className="table-header">AGE</span>, 
      dataIndex: "age",
      render: (text) => <span className="patient-age">{text}</span>
    },
    { 
      title: <span className="table-header">CONDITION</span>, 
      dataIndex: "condition",
      render: (text) => <span className="patient-condition">{text}</span>
    },
    {
      title: <span className="table-header">ASSIGNED TO</span>,
      dataIndex: "assignedTo",
      render: (docId) => {
        const doc = staff.find((d) => d.id === docId);
        return doc ? (
          <span className="assigned-doctor">{doc.name}</span>
        ) : (
          <Tag color="red" className="unassigned-tag">Unassigned</Tag>
        );
      },
    },
    { 
      title: <span className="table-header">STATUS</span>, 
      dataIndex: "status",
      render: (status) => {
        let color = 'default';
        if (status === 'waiting') color = 'orange';
        if (status === 'in consultation') color = 'blue';
        if (status === 'discharged') color = 'green';
        
        return <Tag color={color} className="patient-status">{status}</Tag>;
      }
    },
    {
      title: <span className="table-header">ACTIONS</span>,
      render: (_, record) => (
        <Space>
          <Button
            size="small"
            className="edit-btn"
            icon={<EditOutlined />}
            onClick={() => {
              setEditingPatient(record);
              patientForm.setFieldsValue(record);
              setPatientModalOpen(true);
            }}
          >
            Edit
          </Button>
          <Popconfirm
            title="Delete patient?"
            onConfirm={() => handleDeletePatient(record.id)}
          >
            <Button size="small" danger className="delete-btn" icon={<DeleteOutlined />}>
              Delete
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  // Logout function with redirection
  const handleLogout = () => {
    // In a real app, this would clear authentication tokens, etc.
    console.log("Logging out...");
    alert("You have been logged out successfully!");
    
    // Redirect to home page after alert
    setTimeout(() => {
      navigate("/");
    }, 100); // Small delay to ensure alert is shown
  };

  return (
    <div className="medical-admin-portal">
      <div className="medical-header">
        <div className="header-content">
          <div className="clinic-info">
            <h1>
              <MedicineBoxOutlined className="clinic-icon" />
              MediCare Hospital Admin Portal
            </h1>
            <p>Manage medical staff and patient records</p>
          </div>
          <div className="header-right-section">
            <div className="stats-overview">
              <div className="stat-card">
                <TeamOutlined />
                <div className="stat-details">
                  <span className="stat-number">{staff.length}</span>
                  <span className="stat-label">Medical Staff</span>
                </div>
              </div>
              <div className="stat-card">
                <HeartOutlined />
                <div className="stat-details">
                  <span className="stat-number">{patients.length}</span>
                  <span className="stat-label">Patients</span>
                </div>
              </div>
            </div>
            <Button 
              className="logout-btn"
              icon={<LogoutOutlined />}
              onClick={handleLogout}
            >
              Logout
            </Button>
          </div>
        </div>
      </div>

      {/* ===== Staff Management ===== */}
      <Card
        className="medical-card staff-card"
        title={
          <div className="card-title">
            <TeamOutlined />
            <span>Medical Staff Management</span>
          </div>
        }
        extra={
          <Button 
            type="primary" 
            className="add-btn"
            icon={<UserAddOutlined />}
            onClick={() => setStaffModalOpen(true)}
          >
            Add Doctor
          </Button>
        }
      >
        <Table
          rowKey="id"
          columns={staffColumns}
          dataSource={staff}
          pagination={false}
          className="medical-table"
        />
      </Card>

      {/* ===== Patient Management ===== */}
      <Card
        className="medical-card patient-card"
        title={
          <div className="card-title">
            <HeartOutlined />
            <span>Patient Management</span>
          </div>
        }
        extra={
          <Button 
            type="primary" 
            className="add-btn"
            icon={<UserAddOutlined />}
            onClick={() => setPatientModalOpen(true)}
          >
            Add Patient
          </Button>
        }
      >
        <Table
          rowKey="id"
          columns={patientColumns}
          dataSource={patients}
          pagination={false}
          className="medical-table"
        />
      </Card>

      {/* Staff Modal */}
      <Modal
        className="medical-modal"
        title={
          <div className="modal-title">
            {editingStaff ? <EditOutlined /> : <UserAddOutlined />}
            <span>{editingStaff ? "Edit Doctor" : "Add Doctor"}</span>
          </div>
        }
        open={isStaffModalOpen}
        onCancel={() => {
          setStaffModalOpen(false);
          setEditingStaff(null);
          staffForm.resetFields();
        }}
        onOk={() => staffForm.submit()}
      >
        <Form form={staffForm} layout="vertical" onFinish={handleStaffSubmit}>
          <Form.Item name="id" label="Doctor ID" rules={[{ required: true }]}>
            <Input prefix={<span className="input-prefix">MD-</span>} />
          </Form.Item>
          <Form.Item name="name" label="Name" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item
            name="speciality"
            label="Speciality"
            rules={[{ required: true }]}
          >
            <Input />
          </Form.Item>
          <Form.Item name="status" label="Status" rules={[{ required: true }]}>
            <Select>
              <Select.Option value="online">Online</Select.Option>
              <Select.Option value="offline">Offline</Select.Option>
            </Select>
          </Form.Item>
        </Form>
      </Modal>

      {/* Patient Modal */}
      <Modal
        className="medical-modal"
        title={
          <div className="modal-title">
            {editingPatient ? <EditOutlined /> : <UserAddOutlined />}
            <span>{editingPatient ? "Edit Patient" : "Add Patient"}</span>
          </div>
        }
        open={isPatientModalOpen}
        onCancel={() => {
          setPatientModalOpen(false);
          setEditingPatient(null);
          patientForm.resetFields();
        }}
        onOk={() => patientForm.submit()}
      >
        <Form
          form={patientForm}
          layout="vertical"
          onFinish={handlePatientSubmit}
        >
          <Form.Item name="name" label="Name" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="age" label="Age" rules={[{ required: true }]}>
            <Input type="number" />
          </Form.Item>
          <Form.Item
            name="condition"
            label="Condition"
            rules={[{ required: true }]}
          >
            <Input />
          </Form.Item>
          <Form.Item name="status" label="Status" rules={[{ required: true }]}>
            <Select>
              <Select.Option value="waiting">Waiting</Select.Option>
              <Select.Option value="in consultation">
                In Consultation
              </Select.Option>
              <Select.Option value="discharged">Discharged</Select.Option>
            </Select>
          </Form.Item>
          <Form.Item name="assignedTo" label="Assign to Doctor">
            <Select allowClear placeholder="Select an online doctor">
              {staff
                .filter((doc) => doc.status === "online") // ✅ only online doctors
                .map((doc) => (
                  <Select.Option key={doc.id} value={doc.id}>
                    {doc.name} ({doc.speciality})
                  </Select.Option>
                ))}
            </Select>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}