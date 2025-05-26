const jwt = require('jsonwebtoken');
const User = require('../models/User');

exports.protect = async (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ message: 'Non autorisé' });

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = await User.findById(decoded.id);
        next();
    } catch (err) {
        res.status(401).json({ message: 'Token invalide' });
    }
};

exports.isAdmin = (req, res, next) => {    
    if (req.user && req.user.role === 'admin') next();
    else res.status(403).json({ message: 'Accès refusé' });
};
