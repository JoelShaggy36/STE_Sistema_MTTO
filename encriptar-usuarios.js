// encriptar-usuarios.js (ejecuta esto UNA SOLA VEZ)
require('dotenv').config();
const pool = require('./config/db');
const bcrypt = require('bcrypt');

async function encriptarTodos() {
    try {
        // Cambia 'contraseña' por el nombre real de tu columna
        const [usuarios] = await pool.query('SELECT id, username, password FROM users');

        for (let user of usuarios) {
            const passwordActual = user.password;
            if (passwordActual && passwordActual.length < 60) { // si no está hasheada (bcrypt da ~60 chars)
                const hash = await bcrypt.hash(passwordActual, 10);
                await pool.query('UPDATE users SET password = ? WHERE id = ?', [hash, user.id]);
                console.log(`Encriptado: ${user.username}`);
            } else {
                console.log(`Ya encriptado: ${user.username}`);
            }
        }
        console.log('¡TODOS LOS USUARIOS ENCRIPTADOS!');
        process.exit();
    } catch (err) {
        console.error('Error:', err);
    }
}

encriptarTodos();