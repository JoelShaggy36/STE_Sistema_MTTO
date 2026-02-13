// models/Bus.js
const pool = require('../config/db');

class Bus {
    // Registrar nuevo bus (trigger genera número)
    static async registrar(datos) {
        const { placa, generacion_id, modelo_id, deposito_base_id, km_actual, fecha_ingreso, estado, kilometros_entre_mantenimientos, observaciones } = datos;

        const [result] = await pool.query(
            `INSERT INTO buses (placa, generacion_id, modelo_id, deposito_base_id, deposito_actual_id, km_actual, fecha_ingreso, estado, kilometros_entre_mantenimientos, observaciones) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [placa, generacion_id, modelo_id, deposito_base_id, deposito_base_id, km_actual || 0, fecha_ingreso, estado || 'activo', kilometros_entre_mantenimientos || 0, observaciones]
        );

        return result.insertId;
    }

    // Lista de todos los buses
    static async listar() {
        const [rows] = await pool.query(`
            SELECT b.id, b.numero_identificador, b.placa, g.codigo AS generacion, m.nombre AS modelo, d.nombre AS deposito_base, b.km_actual, b.fecha_ingreso, b.estado, b.observaciones 
            FROM buses b
            JOIN generaciones g ON b.generacion_id = g.id
            JOIN modelos m ON b.modelo_id = m.id
            JOIN depositos d ON b.deposito_base_id = d.id
            ORDER BY b.numero_identificador DESC
        `);
        return rows;
    }

    // Obtener un bus para editar
    static async getById(id) {
        const [rows] = await pool.query(`
            SELECT * FROM buses WHERE id = ?
        `, [id]);
        return rows[0];
    }

    // Editar bus
    static async editar(id, datos) {
        const { placa, generacion_id, modelo_id, deposito_base_id, deposito_actual_id, km_actual, fecha_ingreso, estado, kilometros_entre_mantenimientos, observaciones } = datos;

        await pool.query(
            `UPDATE buses SET placa = ?, generacion_id = ?, modelo_id = ?, deposito_base_id = ?, deposito_actual_id = ?, km_actual = ?, fecha_ingreso = ?, estado = ?, kilometros_entre_mantenimientos = ?, observaciones = ? WHERE id = ?`,
            [placa, generacion_id, modelo_id, deposito_base_id, deposito_actual_id, km_actual, fecha_ingreso, estado, kilometros_entre_mantenimientos, observaciones, id]
        );
    }

    // Eliminar bus
    static async eliminar(id) {
        await pool.query('DELETE FROM buses WHERE id = ?', [id]);
    }

    // Para autocomplete: listas de generaciones, modelos, depósitos
    static async getGeneraciones() {
        const [rows] = await pool.query('SELECT id, codigo FROM generaciones');
        return rows;
    }

    static async getModelos() {
        const [rows] = await pool.query('SELECT id, nombre FROM modelos');
        return rows;
    }

    static async getDepositos() {
        const [rows] = await pool.query('SELECT id, nombre FROM depositos');
        return rows;
    }
}

module.exports = Bus;