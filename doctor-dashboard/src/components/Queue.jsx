import React from "react";
import { Card, List, Button, Tag } from "antd";

export default function Queue({ onSelectPatient, patients }) {
  return (
    <Card title="Patient Queue" style={{ minHeight: "300px" }}>
      <List
        dataSource={patients}
        locale={{ emptyText: "No patients in queue" }}
        renderItem={(consultation) => {
          const patient = consultation.patient;
          return (
            <List.Item
              actions={[
                <Button 
                  type="primary" 
                  size="small" 
                  onClick={() => onSelectPatient(consultation)}
                  disabled={consultation.status === 'in_progress'}
                >
                  {consultation.status === 'waiting' ? 'Start' : 'View'}
                </Button>,
              ]}
            >
              <List.Item.Meta
                title={
                  <>
                    {patient?.name || 'Unknown Patient'} ({patient?.age || 'N/A'}y){" "}
                    {consultation.priority === "urgent" && <Tag color="red">Urgent</Tag>}
                    {consultation.priority === "high" && <Tag color="orange">High</Tag>}
                  </>
                }
                description={
                  `Condition: ${consultation.symptoms?.chief_complaint || 'Not specified'} | Status: ${consultation.status}`
                }
              />
            </List.Item>
          );
        }}
      />
    </Card>
  );
}
