import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";

const Medicines = () => {
  const [cart, setCart] = useState([]);

  const medicineList = [
    { id: 1, name: "Paracetamol", price: 50 },
    { id: 2, name: "Ibuprofen", price: 120 },
    { id: 3, name: "Amoxicillin", price: 200 },
  ];

  // Load cart from localStorage
  useEffect(() => {
    const storedCart = JSON.parse(localStorage.getItem("cart")) || [];
    setCart(storedCart);
  }, []);

  const addToCart = (medicine) => {
    const existing = cart.find((item) => item.id === medicine.id);
    let updatedCart;
    if (existing) {
      // increase quantity if already in cart
      updatedCart = cart.map((item) =>
        item.id === medicine.id
          ? { ...item, quantity: (item.quantity || 1) + 1 }
          : item
      );
    } else {
      updatedCart = [...cart, { ...medicine, quantity: 1 }];
    }
    setCart(updatedCart);
    localStorage.setItem("cart", JSON.stringify(updatedCart));
    alert(`${medicine.name} added to cart!`);
  };

  const buyNow = (medicine) => {
    alert(`Proceeding to buy ${medicine.name} for ₹${medicine.price}`);
  };

  const getTotal = () => {
    return cart.reduce((acc, item) => acc + item.price * (item.quantity || 1), 0);
  };

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <h1 className="text-4xl font-bold text-center mb-8 text-gray-800">
        Available Medicines
      </h1>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {medicineList.map((med) => (
          <div
            key={med.id}
            className="bg-white shadow-lg rounded-2xl p-6 flex flex-col items-center text-center hover:shadow-xl transition duration-300"
          >
            <Link
              to={`/medicines/${med.id}`}
              className="text-xl font-semibold text-gray-700 mb-2 hover:text-blue-600 transition"
            >
              {med.name}
            </Link>

            <p className="text-lg font-bold text-green-600 mb-4">
              ₹{med.price}
            </p>

            <div className="flex gap-3">
              <button
                onClick={() => addToCart(med)}
                className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
              >
                Add to Cart
              </button>
              <button
                onClick={() => buyNow(med)}
                className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition"
              >
                Buy Now
              </button>
            </div>
          </div>
        ))}
      </div>

      {cart.length > 0 && (
        <div className="mt-10 bg-white shadow-lg p-6 rounded-xl max-w-lg mx-auto">
          <h2 className="text-2xl font-bold mb-4 text-gray-800">Your Cart</h2>
          <ul className="space-y-2">
            {cart.map((item, idx) => (
              <li
                key={idx}
                className="flex justify-between text-gray-700 border-b pb-2"
              >
                <span>{item.name} x {item.quantity}</span>
                <span>₹{item.price * item.quantity}</span>
              </li>
            ))}
          </ul>
          <p className="mt-4 font-semibold text-lg text-gray-800">
            Total: ₹{getTotal()}
          </p>
        </div>
      )}
    </div>
  );
};

export default Medicines;
