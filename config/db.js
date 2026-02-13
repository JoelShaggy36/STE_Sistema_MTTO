const mysql = require('mysql2');
require('dotenv').config();

// Crear el pool de conexiones (mejor que createConnection)
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Para usar promesas (async/await) en vez de callbacks
const promisePool = pool.promise();

// Probar la conexión al iniciar
promisePool.getConnection()
    .then(connection => {
        console.log('Conectado a MySQL como ID ' + connection.threadId);
        connection.release();
    })
    .catch(err => {
        console.error('Error al conectar a MySQL:', err.message);
    });

module.exports = promisePool;