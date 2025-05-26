const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { protect, isAdmin } = require('../middleware/authMiddleware');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/users', protect, isAdmin, authController.getAllUsers);

module.exports = router;
