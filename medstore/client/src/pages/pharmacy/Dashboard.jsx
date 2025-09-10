import React, { useEffect, useState, useRef } from 'react';
import { Html5Qrcode } from 'html5-qrcode';
import axios from 'axios';

const PharmacyDashboard = () => {
  const [medicines, setMedicines] = useState([]);
  const [loading, setLoading] = useState(false);
  const [newMedicine, setNewMedicine] = useState({
    name: '',
    description: '',
    price: '',
    stockQuantity: '',
    category: '',
    manufacturer: '',
  });
  const qrCodeRegionId = "qr-reader";

  const fetchMedicines = async () => {
    setLoading(true);
    try {
      const token = localStorage.getItem('token'); // JWT token from login
      const { data } = await axios.get('http://localhost:5000/api/medicines', {
        headers: { Authorization: `Bearer ${token}` },
      });
      setMedicines(data.medicines);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMedicines();
  }, []);

  const handleInputChange = (e) => {
    setNewMedicine({ ...newMedicine, [e.target.name]: e.target.value });
  };

  const handleAddMedicine = async () => {
    try {
      const token = localStorage.getItem('token');
      const { data } = await axios.post(
        'http://localhost:5000/api/medicines',
        newMedicine,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setMedicines([data, ...medicines]);
      setNewMedicine({
        name: '',
        description: '',
        price: '',
        stockQuantity: '',
        category: '',
        manufacturer: '',
      });
    } catch (error) {
      console.error(error);
    }
  };

  const handleDelete = async (id) => {
    try {
      const token = localStorage.getItem('token');
      await axios.delete(`http://localhost:5000/api/medicines/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setMedicines(medicines.filter((m) => m._id !== id));
    } catch (error) {
      console.error(error);
    }
  };

  const startScanner = () => {
    const html5QrcodeScanner = new Html5Qrcode(qrCodeRegionId);
    html5QrcodeScanner
      .start(
        { facingMode: "environment" },
        { fps: 10, qrbox: 250 },
        (decodedText) => {
          console.log("QR Code scanned:", decodedText);
          // Example: auto-fill medicine name from barcode scan
          setNewMedicine({ ...newMedicine, name: decodedText });
          html5QrcodeScanner.stop();
        },
        (errorMessage) => {
          console.warn(errorMessage);
        }
      )
      .catch((err) => console.error("QR start error:", err));
  };

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <h1 className="text-3xl font-bold text-center mb-8">Pharmacy Dashboard</h1>

      <div className="mb-6 space-y-4 max-w-xl mx-auto">
        <input
          type="text"
          placeholder="Name"
          name="name"
          value={newMedicine.name}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
        />
        <input
          type="text"
          placeholder="Description"
          name="description"
          value={newMedicine.description}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
        />
        <input
          type="number"
          placeholder="Price"
          name="price"
          value={newMedicine.price}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
        />
        <input
          type="number"
          placeholder="Stock Quantity"
          name="stockQuantity"
          value={newMedicine.stockQuantity}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
        />
        <input
          type="text"
          placeholder="Category"
          name="category"
          value={newMedicine.category}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
        />
        <input
          type="text"
          placeholder="Manufacturer"
          name="manufacturer"
          value={newMedicine.manufacturer}
          onChange={handleInputChange}
          className="w-full p-2 border rounded"
        />
        <div className="flex gap-4">
          <button
            onClick={handleAddMedicine}
            className="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700"
          >
            Add Medicine
          </button>
          <button
            onClick={startScanner}
            className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
          >
            Scan Barcode
          </button>
        </div>
      </div>

      <div id={qrCodeRegionId} className="mb-6 mx-auto" />

      <div className="max-w-3xl mx-auto">
        {loading ? (
          <p>Loading medicines...</p>
        ) : (
          <ul className="divide-y divide-gray-200">
            {medicines.map((med) => (
              <li key={med._id} className="flex justify-between items-center py-3">
                <div>
                  <p className="font-semibold">{med.name}</p>
                  <p className="text-gray-500">₹{med.price}</p>
                  <p className="text-gray-500">Stock: {med.stockQuantity}</p>
                </div>
                <button
                  onClick={() => handleDelete(med._id)}
                  className="bg-red-600 text-white px-4 py-1 rounded hover:bg-red-700"
                >
                  Delete
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};

export default PharmacyDashboard;
