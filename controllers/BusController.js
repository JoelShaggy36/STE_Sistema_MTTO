// controllers/BusController.js
const Bus = require('../models/bus');

exports.listar = async (req, res) => {
    const buses = await Bus.listar();
    const generaciones = await Bus.getGeneraciones();
    const modelos = await Bus.getModelos();
    const depositos = await Bus.getDepositos();
    res.render('admin/buses', { buses, generaciones, modelos, depositos, title: 'Autobuses', user: req.session.user });
};

exports.registrar = async (req, res) => {
    try {
        await Bus.registrar(req.body);
        req.session.message = 'Bus registrado correctamente';
        res.redirect('/admin/buses');
    } catch (err) {
        req.session.error = 'Error al registrar bus';
        res.redirect('/admin/buses');
    }
};

exports.editar = async (req, res) => {
    try {
        await Bus.editar(req.params.id, req.body);
        req.session.message = 'Bus actualizado correctamente';
        res.redirect('/admin/buses');
    } catch (err) {
        req.session.error = 'Error al editar bus';
        res.redirect('/admin/buses');
    }
};

exports.eliminar = async (req, res) => {
    try {
        await Bus.eliminar(req.params.id);
        req.session.message = 'Bus eliminado correctamente';
        res.redirect('/admin/buses');
    } catch (err) {
        req.session.error = 'Error al eliminar bus';
        res.redirect('/admin/buses');
    }
};