import React, { useEffect, useState } from "react";

const Cart = () => {
  const [cart, setCart] = useState([]);

  useEffect(() => {
    const storedCart = JSON.parse(localStorage.getItem("cart")) || [];
    setCart(storedCart);
  }, []);

  const removeItem = (id) => {
    const updatedCart = cart.filter((item) => item.id !== id);
    setCart(updatedCart);
    localStorage.setItem("cart", JSON.stringify(updatedCart));
  };

  const getTotal = () => {
    return cart.reduce((acc, item) => acc + item.price * (item.quantity || 1), 0);
  };

  return (
    <div className="p-8 bg-gray-50 min-h-screen">
      <h1 className="text-4xl font-bold text-center mb-8 text-gray-800">
        Your Cart
      </h1>

      {cart.length === 0 ? (
        <p className="text-center text-gray-600 text-xl">Your cart is empty.</p>
      ) : (
        <div className="max-w-3xl mx-auto bg-white shadow-lg rounded-2xl p-6">
          <ul className="divide-y divide-gray-200">
            {cart.map((item, index) => (
              <li
                key={index}
                className="flex justify-between items-center py-4"
              >
                <div>
                  <h2 className="text-lg font-semibold text-gray-700">
                    {item.name}
                  </h2>
                  <p className="text-gray-500">Price: ₹{item.price}</p>
                  <p className="text-gray-500">Qty: {item.quantity}</p>
                </div>
                <button
                  onClick={() => removeItem(item.id)}
                  className="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition"
                >
                  Remove
                </button>
              </li>
            ))}
          </ul>

          <div className="mt-6 text-right">
            <p className="text-xl font-bold text-gray-800">
              Total: ₹{getTotal()}
            </p>
            <button className="mt-4 bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-700 transition">
              Proceed to Checkout
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default Cart;
