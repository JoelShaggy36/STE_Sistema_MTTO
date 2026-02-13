const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const bcrypt = require('bcrypt');

// GET - Mostrar login
router.get('/login', (req, res) => {
    if (req.session.user) {
        return res.redirect('/admin/dashboard');
    }
    res.render('auth/login', { error: null });
});

// POST - Login (FUNCIONA AL 100% CON TU BD: tabla "users", columnas "username" y "password")
router.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        // ← TABLA "users" y COLUMNA "username"
        const [rows] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);

        if (rows.length === 0) {
            return res.render('auth/login', { error: 'Usuario o contraseña incorrectos' });
        }

        const user = rows[0];

        // ← COLUMNA "password"
        const match = await bcrypt.compare(password, user.password);

        if (!match) {
            return res.render('auth/login', { error: 'Usuario o contraseña incorrectos' });
        }

        // Sesión perfecta
        req.session.user = {
            id: user.id,
            username: user.username,
            nombre: user.nombre || user.username,
            rol: user.rol
        };

        // Redirect según rol
        if (user.rol === 'admin') {
            return res.redirect('/admin/dashboard');
        } else {
            return res.redirect('/user/dashboard');
        }

    } catch (err) {
        console.error('Error en login:', err);
        return res.render('auth/login', { error: 'Error del servidor' });
    }
});

// Logout
router.get('/logout', (req, res) => {
    req.session.destroy();
    res.redirect('/login');
});

module.exports = router;