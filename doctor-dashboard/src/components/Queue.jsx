import React from "react";
import { Card, List, Button, Tag } from "antd";

export default function Queue({ onSelectPatient, patients }) {
  return (
    <Card title="Patient Queue" style={{ minHeight: "300px" }}>
      <List
        dataSource={patients}
        locale={{ emptyText: "No patients assigned" }}
        renderItem={(item) => (
          <List.Item
            actions={[
              <Button type="primary" size="small" onClick={() => onSelectPatient(item)}>
                Start
              </Button>,
            ]}
          >
            <List.Item.Meta
              title={
                <>
                  {item.name} ({item.age}y){" "}
                  {item.priority === "critical" && <Tag color="red">Critical</Tag>}
                </>
              }
              description={`Condition: ${item.condition} | Status: ${item.status}`}
            />
          </List.Item>
        )}
      />
    </Card>
  );
}
