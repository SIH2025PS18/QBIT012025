const Order = require('../models/Order');
const Medicine = require('../models/Medicine');

// Get user orders
const getOrders = async (req, res) => {
  try {
    let query = {};
    
    if (req.user.role === 'user') {
      query.userId = req.user._id;
    } else if (req.user.role === 'pharmacy') {
      // For pharmacy users, get orders that include their medicines
      const pharmacyMedicines = await Medicine.find({ pharmacyId: req.user.pharmacyId });
      const medicineIds = pharmacyMedicines.map(med => med._id);
      query['items.medicineId'] = { $in: medicineIds };
    }
    
    const orders = await Order.find(query)
      .populate('userId', 'name email')
      .populate('items.medicineId')
      .sort({ createdAt: -1 });
    
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get single order
const getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('userId', 'name email')
      .populate('items.medicineId');
    
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }
    
    // Check if user has access to this order
    if (req.user.role === 'user' && order.userId._id.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Not authorized to view this order' });
    }
    
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create new order
const createOrder = async (req, res) => {
  try {
    const { items, shippingAddress, paymentMethod } = req.body;
    
    // Calculate total amount and validate items
    let totalAmount = 0;
    for (const item of items) {
      const medicine = await Medicine.findById(item.medicineId);
      if (!medicine) {
        return res.status(404).json({ message: `Medicine with ID ${item.medicineId} not found` });
      }
      if (medicine.stockQuantity < item.quantity) {
        return res.status(400).json({ message: `Not enough stock for ${medicine.name}` });
      }
      totalAmount += medicine.price * item.quantity;
    }
    
    const order = new Order({
      userId: req.user._id,
      items: items.map(item => ({
        medicineId: item.medicineId,
        quantity: item.quantity,
        price: item.price
      })),
      totalAmount,
      shippingAddress,
      paymentMethod,
      status: 'pending'
    });
    
    const createdOrder = await order.save();
    
    // Update stock quantities
    for (const item of items) {
      await Medicine.findByIdAndUpdate(
        item.medicineId,
        { $inc: { stockQuantity: -item.quantity } }
      );
    }
    
    await createdOrder.populate('items.medicineId');
    await createdOrder.populate('userId', 'name email');
    
    res.status(201).json(createdOrder);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update order status
const updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const order = await Order.findById(req.params.id);
    
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }
    
    // Check authorization
    if (req.user.role === 'user' && order.userId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Not authorized to update this order' });
    }
    
    order.status = status;
    const updatedOrder = await order.save();
    
    res.json(updatedOrder);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Cancel order
const cancelOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('items.medicineId');
    
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }
    
    // Check authorization
    if (req.user.role === 'user' && order.userId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Not authorized to cancel this order' });
    }
    
    // Restore stock if order is cancelled
    if (order.status !== 'cancelled') {
      for (const item of order.items) {
        await Medicine.findByIdAndUpdate(
          item.medicineId,
          { $inc: { stockQuantity: item.quantity } }
        );
      }
    }
    
    order.status = 'cancelled';
    await order.save();
    
    res.json({ message: 'Order cancelled successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getOrders,
  getOrderById,
  createOrder,
  updateOrderStatus,
  cancelOrder
};