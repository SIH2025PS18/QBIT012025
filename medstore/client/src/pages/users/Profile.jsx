import React, { useState } from "react";
import { useAuth } from "../../contexts/AuthContext";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

const Profile = () => {
  const { user, updateUser } = useAuth();
  const [name, setName] = useState(user?.name || "");
  const [editing, setEditing] = useState(false);

  // Sample random data for charts
  const ordersData = Array.from({ length: 7 }, (_, i) => ({
    day: `Day ${i + 1}`,
    orders: Math.floor(Math.random() * 20 + 1),
    purchases: Math.floor(Math.random() * 1000 + 100),
  }));

  const handleSave = () => {
    if (name.trim() === "") return alert("Name cannot be empty");
    updateUser({ name });
    setEditing(false);
    alert("Profile updated successfully!");
  };

  return (
    <div className="min-h-screen bg-gradient-to-r from-gray-100 to-blue-50 p-6 font-sans">
      <div className="max-w-4xl mx-auto bg-white rounded-2xl shadow-xl p-8">
        <h1 className="text-4xl font-extrabold mb-6 text-center text-gray-800">
          User Profile
        </h1>

        {/* User Info */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <div>
            <label className="block text-gray-600 font-semibold mb-1">
              Email
            </label>
            <input
              type="email"
              value={user?.email || ""}
              disabled
              className="w-full px-4 py-2 border rounded-lg bg-gray-100 cursor-not-allowed"
            />
          </div>

          <div>
            <label className="block text-gray-600 font-semibold mb-1">
              Name
            </label>
            {editing ? (
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            ) : (
              <p className="px-4 py-2 bg-gray-100 rounded-lg text-gray-700">
                {name}
              </p>
            )}
          </div>
        </div>

        <div className="flex justify-between mb-8">
          {editing ? (
            <>
              <button
                onClick={handleSave}
                className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
              >
                Save
              </button>
              <button
                onClick={() => {
                  setName(user?.name || "");
                  setEditing(false);
                }}
                className="bg-gray-400 text-white px-4 py-2 rounded-lg hover:bg-gray-500 transition"
              >
                Cancel
              </button>
            </>
          ) : (
            <button
              onClick={() => setEditing(true)}
              className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition w-full md:w-auto"
            >
              Edit Name
            </button>
          )}
        </div>

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-blue-100 p-6 rounded-xl shadow flex flex-col items-center">
            <h2 className="text-xl font-semibold text-blue-800 mb-2">Orders</h2>
            <p className="text-3xl font-bold text-blue-900">
              {ordersData.reduce((a, d) => a + d.orders, 0)}
            </p>
          </div>
          <div className="bg-green-100 p-6 rounded-xl shadow flex flex-col items-center">
            <h2 className="text-xl font-semibold text-green-800 mb-2">Purchases</h2>
            <p className="text-3xl font-bold text-green-900">
              ₹{ordersData.reduce((a, d) => a + d.purchases, 0)}
            </p>
          </div>
          <div className="bg-purple-100 p-6 rounded-xl shadow flex flex-col items-center">
            <h2 className="text-xl font-semibold text-purple-800 mb-2">Favorites</h2>
            <p className="text-3xl font-bold text-purple-900">{Math.floor(Math.random() * 50 + 1)}</p>
          </div>
        </div>

        {/* Charts */}
        <div className="mb-8">
          <h2 className="text-2xl font-semibold text-gray-700 mb-4">
            Weekly Overview
          </h2>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={ordersData} margin={{ top: 5, right: 30, left: 0, bottom: 5 }}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="day" />
              <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="orders" stroke="#3b82f6" strokeWidth={2} />
              <Line type="monotone" dataKey="purchases" stroke="#10b981" strokeWidth={2} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
};

export default Profile;
