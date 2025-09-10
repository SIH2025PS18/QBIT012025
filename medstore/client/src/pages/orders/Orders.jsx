import React, { useState, useEffect } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  Legend,
} from "recharts";

const Orders = () => {
  // Sample order data
  const [orders, setOrders] = useState([
    { id: 1, medicine: "Paracetamol", quantity: 2, price: 100 },
    { id: 2, medicine: "Ibuprofen", quantity: 1, price: 120 },
    { id: 3, medicine: "Amoxicillin", quantity: 3, price: 600 },
  ]);

  // Calculate total per medicine
  const orderSummary = orders.reduce((acc, order) => {
    const existing = acc.find((o) => o.medicine === order.medicine);
    if (existing) {
      existing.quantity += order.quantity;
      existing.price += order.price;
    } else {
      acc.push({ ...order });
    }
    return acc;
  }, []);

  // Prepare chart data
  const chartData = orderSummary.map((o) => ({
    name: o.medicine,
    Quantity: o.quantity,
    Total: o.price,
  }));

  // Total spent
  const totalSpent = orders.reduce((acc, order) => acc + order.price, 0);

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <h1 className="text-4xl font-bold text-center mb-8 text-gray-800">
        Order History
      </h1>

      {/* Orders Table */}
      <div className="max-w-4xl mx-auto bg-white shadow-lg rounded-xl p-6 mb-10">
        <h2 className="text-2xl font-bold mb-4 text-gray-800 text-center">
          Your Orders
        </h2>
        <table className="w-full border">
          <thead className="bg-gray-200">
            <tr>
              <th className="p-2 border">Medicine</th>
              <th className="p-2 border">Quantity</th>
              <th className="p-2 border">Price (₹)</th>
            </tr>
          </thead>
          <tbody>
            {orders.length === 0 ? (
              <tr>
                <td colSpan="3" className="p-2 text-center">
                  No orders yet
                </td>
              </tr>
            ) : (
              orders.map((order) => (
                <tr key={order.id}>
                  <td className="p-2 border">{order.medicine}</td>
                  <td className="p-2 border">{order.quantity}</td>
                  <td className="p-2 border">{order.price}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
        <p className="mt-4 font-semibold text-lg text-gray-800 text-right">
          Total Spent: ₹{totalSpent}
        </p>
      </div>

      {/* Charts */}
      <div className="max-w-4xl mx-auto">
        <h2 className="text-2xl font-bold mb-4 text-gray-800 text-center">
          Orders Analytics
        </h2>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart
            data={chartData}
            margin={{ top: 20, right: 30, left: 0, bottom: 5 }}
          >
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="name" />
            <YAxis />
            <Tooltip />
            <Legend />
            <Bar dataKey="Quantity" fill="#8884d8" />
            <Bar dataKey="Total" fill="#82ca9d" />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
};

export default Orders;
