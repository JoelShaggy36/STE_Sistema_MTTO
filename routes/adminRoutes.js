// routes/adminRoutes.js
const express = require('express');
const router = express.Router();
const BusController = require('../controllers/BusController');

// Middleware para verificar admin
const isAdmin = (req, res, next) => {
    if (!req.session.user || req.session.user.rol !== 'admin') return res.redirect('/login');
    next();
};

router.use(isAdmin);

// Autobuses
router.get('/buses', BusController.listar);
router.post('/buses/nuevo', BusController.registrar);
router.post('/buses/editar/:id', BusController.editar);
router.get('/buses/eliminar/:id', BusController.eliminar);

module.exports = router;