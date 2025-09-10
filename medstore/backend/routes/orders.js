const express = require('express');
const { getOrders, getOrderById, createOrder, updateOrderStatus, cancelOrder } = require('../controllers/orderController');
const { protect } = require('../middleware/auth');
const router = express.Router();

router.route('/')
  .get(protect, getOrders)
  .post(protect, createOrder);

router.route('/:id')
  .get(protect, getOrderById)
  .put(protect, updateOrderStatus)
  .delete(protect, cancelOrder);

module.exports = router;