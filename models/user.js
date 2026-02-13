// models/User.js
const pool = require('../config/db');
const bcrypt = require('bcrypt');

class User {
    // Encontrar usuario por username
    static async findByUsername(username) {
        const [rows] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);
        return rows[0];
    }

    // Verificar contraseña (bcrypt)
    static async verifyPassword(candidatePassword, userPassword) {
        return await bcrypt.compare(candidatePassword, userPassword);
    }

    // Crear usuario nuevo (opcional para register)
    static async create(datos) {
        const { username, password, rol, nombre, email } = datos;
        const hashedPassword = await bcrypt.hash(password, 10);  // Hash seguro
        const [result] = await pool.query(
            'INSERT INTO users (username, password, rol, nombre, email) VALUES (?, ?, ?, ?, ?)',
            [username, hashedPassword, rol, nombre, email]
        );
        return result.insertId;
    }
}

module.exports = User;