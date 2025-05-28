const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');
const { protect } = require('../middleware/authMiddleware');

router.post('/', protect, orderController.createOrder);
router.get('/', protect, orderController.getAllOrders);
router.get('/:id/invoice',protect,orderController.generateInvoice);
module.exports = router;
