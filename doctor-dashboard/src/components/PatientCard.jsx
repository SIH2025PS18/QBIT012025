import React from "react";
import { Card, Descriptions, Button } from "antd";

export default function PatientCard({ patient, onOpenVideo }) {
  if (!patient) {
    return (
      <div className="card">
        <em>Select a patient to view details</em>
      </div>
    );
  }

  // Safe defaults
  const {
    name = "Unknown",
    gender = "—",
    age = "—",
    symptoms = "N/A",
    history = "N/A",
  } = patient;

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
            <Descriptions.Item label="Symptoms">{symptoms}</Descriptions.Item>
            <Descriptions.Item label="History">{history}</Descriptions.Item>
          </Descriptions>
        </div>
        <div style={{ minWidth: 200, textAlign: "right" }}>
          <Button type="primary" onClick={() => onOpenVideo(patient)}>
            Open Video
          </Button>
        </div>
      </div>
    </Card>
  );
}
