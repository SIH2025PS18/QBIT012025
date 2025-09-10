import React, { useState } from "react";
import { Form, Input, Button, message } from "antd";
import { submitPrescription } from "../lib/api";

export default function PrescriptionForm({ patientId, onSubmitted }) {
  const [loading, setLoading] = useState(false);

  async function onFinish(values) {
    setLoading(true);
    try {
      await submitPrescription({ patientId, ...values });
      message.success("Prescription submitted");
      onSubmitted && onSubmitted();
    } catch (err) {
      console.error(err);
      message.error("Failed to submit");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="card">
      <h3>Prescription</h3>
      <Form layout="vertical" onFinish={onFinish}>
        <Form.Item
          name="text"
          label="Medicine & Dosage"
          rules={[{ required: true }]}
        >
          <Input.TextArea
            rows={4}
            placeholder="E.g. Paracetamol 500mg — 1 tablet twice a day"
          />
        </Form.Item>
        <Form.Item name="notes" label="Notes">
          <Input.TextArea rows={2} placeholder="Any additional instructions" />
        </Form.Item>
        <Form.Item>
          <Button type="primary" htmlType="submit" loading={loading}>
            Send to Pharmacy
          </Button>
        </Form.Item>
      </Form>
    </div>
  );
}
