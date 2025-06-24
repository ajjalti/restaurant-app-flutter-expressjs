const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const { protect, isAdmin } = require('../middleware/authMiddleware');

router.get('/', protect ,productController.getAllProducts);
router.delete('/:id', protect,isAdmin ,productController.deleteById);
router.post('/', protect, isAdmin, productController.addProduct);

module.exports = router;
