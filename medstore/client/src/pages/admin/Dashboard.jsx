import React, { useEffect, useState } from "react";
import axios from "axios";

const AdminDashboard = () => {
  const [pharmacies, setPharmacies] = useState([]);
  const [userCount, setUserCount] = useState(0);
  const [formData, setFormData] = useState({ name: "", city: "", email: "" });
  const [editId, setEditId] = useState(null);
  const [editData, setEditData] = useState({ name: "", city: "", email: "" });

  const token = localStorage.getItem("token") || "";

  const fetchData = async () => {
    try {
      const phRes = await axios.get(
        "http://localhost:5000/api/superadmin/pharmacies",
        { headers: { Authorization: `Bearer ${token}` } }
      );
      const userRes = await axios.get(
        "http://localhost:5000/api/superadmin/users/count",
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setPharmacies(phRes.data || []);
      setUserCount(userRes.data.count || 0);
    } catch (err) {
      console.error("Error fetching admin data:", err);
    }
  };

  useEffect(() => {
    if (token) fetchData();
  }, [token]);

  // Add pharmacy
  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log("Adding pharmacy:", formData); // Debug log
    try {
      await axios.post(
        "http://localhost:5000/api/superadmin/pharmacies",
        formData,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setFormData({ name: "", city: "", email: "" });
      fetchData();
    } catch (err) {
      console.error("Error adding pharmacy:", err);
    }
  };

  // Delete pharmacy
  const deletePharmacy = async (id) => {
    try {
      await axios.delete(
        `http://localhost:5000/api/superadmin/pharmacies/${id}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setPharmacies(pharmacies.filter((ph) => ph._id !== id));
    } catch (err) {
      console.error("Error deleting pharmacy:", err);
    }
  };

  // Start editing
  const startEdit = (ph) => {
    setEditId(ph._id);
    setEditData({ name: ph.name, city: ph.city, email: ph.email });
  };

  const cancelEdit = () => {
    setEditId(null);
    setEditData({ name: "", city: "", email: "" });
  };

  const saveEdit = async (id) => {
    try {
      await axios.put(
        `http://localhost:5000/api/superadmin/pharmacies/${id}`,
        editData,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setEditId(null);
      fetchData();
    } catch (err) {
      console.error("Error updating pharmacy:", err);
    }
  };

  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-6">Admin Dashboard</h1>

      <div className="mb-6">
        <h2 className="text-xl font-semibold mb-2">
          Total Users: <span className="text-blue-600">{userCount}</span>
        </h2>
      </div>

      {/* Add Pharmacy Form */}
      <div className="mb-8">
        <h2 className="text-xl font-semibold mb-2">Add Pharmacy</h2>
        <form
          onSubmit={handleSubmit}
          className="flex flex-col md:flex-row gap-4"
        >
          <input
            type="text"
            placeholder="Name"
            className="border p-2 rounded flex-1"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            required
          />
          <input
            type="text"
            placeholder="City"
            className="border p-2 rounded flex-1"
            value={formData.city}
            onChange={(e) => setFormData({ ...formData, city: e.target.value })}
            required
          />
          <input
            type="email"
            placeholder="Email"
            className="border p-2 rounded flex-1"
            value={formData.email}
            onChange={(e) =>
              setFormData({ ...formData, email: e.target.value })
            }
            required
          />
          <button
            type="submit"
            className="bg-green-600 text-white px-4 py-2 rounded cursor-pointer"
          >
            Add
          </button>
        </form>
      </div>

      {/* Pharmacies List */}
      <div>
        <h2 className="text-xl font-semibold mb-2">Pharmacies</h2>
        <table className="w-full border">
          <thead className="bg-gray-200">
            <tr>
              <th className="p-2 border">Name</th>
              <th className="p-2 border">City</th>
              <th className="p-2 border">Email</th>
              <th className="p-2 border">Actions</th>
            </tr>
          </thead>
          <tbody>
            {pharmacies.length === 0 ? (
              <tr>
                <td colSpan="4" className="p-2 text-center">
                  No pharmacies found
                </td>
              </tr>
            ) : (
              pharmacies.map((ph) => (
                <tr key={ph._id}>
                  <td className="p-2 border">
                    {editId === ph._id ? (
                      <input
                        className="border p-1 rounded"
                        value={editData.name}
                        onChange={(e) =>
                          setEditData({ ...editData, name: e.target.value })
                        }
                      />
                    ) : (
                      ph.name
                    )}
                  </td>
                  <td className="p-2 border">
                    {editId === ph._id ? (
                      <input
                        className="border p-1 rounded"
                        value={editData.city}
                        onChange={(e) =>
                          setEditData({ ...editData, city: e.target.value })
                        }
                      />
                    ) : (
                      ph.city
                    )}
                  </td>
                  <td className="p-2 border">
                    {editId === ph._id ? (
                      <input
                        className="border p-1 rounded"
                        value={editData.email}
                        onChange={(e) =>
                          setEditData({ ...editData, email: e.target.value })
                        }
                      />
                    ) : (
                      ph.email
                    )}
                  </td>
                  <td className="p-2 border space-x-2">
                    {editId === ph._id ? (
                      <>
                        <button
                          onClick={() => saveEdit(ph._id)}
                          className="bg-blue-600 text-white px-3 py-1 rounded cursor-pointer"
                        >
                          Save
                        </button>
                        <button
                          onClick={cancelEdit}
                          className="bg-gray-500 text-white px-3 py-1 rounded cursor-pointer"
                        >
                          Cancel
                        </button>
                      </>
                    ) : (
                      <>
                        <button
                          onClick={() => startEdit(ph)}
                          className="bg-yellow-500 text-white px-3 py-1 rounded cursor-pointer"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => deletePharmacy(ph._id)}
                          className="bg-red-600 text-white px-3 py-1 rounded cursor-pointer"
                        >
                          Delete
                        </button>
                      </>
                    )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminDashboard;
