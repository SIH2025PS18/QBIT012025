import React from "react";
import { Card, Descriptions, Button } from "antd";

export default function PatientCard({ patient: consultation, onOpenVideo }) {
  if (!consultation) {
    return (
      <div className="card">
        <em>Select a patient to view details</em>
      </div>
    );
  }

  const patient = consultation.patient || {};
  
  // Safe defaults
  const {
    name = "Unknown",
    gender = "—",
    age = "—",
  } = patient;
  
  const symptoms = consultation.symptoms?.chief_complaint || "N/A";
  const additionalSymptoms = consultation.symptoms?.additional_symptoms?.join(', ') || "None";
  const duration = consultation.symptoms?.duration || "Not specified";
  const severity = consultation.symptoms?.severity || "Not specified";

  return (
    <Card className="card">
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "start",
          gap: 12,
        }}
      >
        <div style={{ flex: 1 }}>
          <h2>
            {name} <small>({gender})</small>
          </h2>
          <Descriptions column={1} size="small">
            <Descriptions.Item label="Age">{age}</Descriptions.Item>
            <Descriptions.Item label="Chief Complaint">{symptoms}</Descriptions.Item>
            <Descriptions.Item label="Additional Symptoms">{additionalSymptoms}</Descriptions.Item>
            <Descriptions.Item label="Duration">{duration}</Descriptions.Item>
            <Descriptions.Item label="Severity">{severity}</Descriptions.Item>
            <Descriptions.Item label="Consultation ID">{consultation.consultationId}</Descriptions.Item>
            <Descriptions.Item label="Status">{consultation.status}</Descriptions.Item>
          </Descriptions>
        </div>
        <div style={{ minWidth: 200, textAlign: "right" }}>
          <Button 
            type="primary" 
            onClick={() => onOpenVideo && onOpenVideo(consultation)}
            disabled={consultation.status === 'completed'}
          >
            {consultation.status === 'waiting' ? 'Start Consultation' : 'Open Video'}
          </Button>
        </div>
      </div>
    </Card>
  );
}
