// controllers/AuthController.js
const User = require('../models/User');

exports.getLogin = (req, res) => {
    res.render('auth/login', { title: 'Login', error: null });
};

exports.postLogin = async (req, res) => {
    const { username, password } = req.body;
    const user = await User.findByUsername(username);
    if (!user || !await User.verifyPassword(password, user.password)) {
        return res.render('auth/login', { title: 'Login', error: 'Usuario o contraseña incorrecta' });
    }
    // Crea sesión
    req.session.user = { id: user.id, username: user.username, rol: user.rol };
    if (user.rol === 'admin') {
        res.redirect('/admin/dashboard');
    } else {
        res.redirect('/user/dashboard');
    }
};

exports.logout = (req, res) => {
    req.session.destroy();
    res.redirect('/login');
};