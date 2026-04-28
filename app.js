const express = require('express');
const session = require('express-session');
const path = require('path');
const pool = require('./config/db');
require('dotenv').config();


const app = express();
const PORT = 3000;
const adminRoutes = require('./routes/adminRoutes');


// Configuración
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static('public'));

app.use(session({
    secret: process.env.SESSION_SECRET || 'flota2025ultra',
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false }
}));

// ====== RUTAS PÚBLICAS (login, logout) ======
app.use('/', require('./routes/authRoutes'));

// ====== DASHBOARD ADMIN ======
app.get('/admin/dashboard', (req, res) => {
    if (!req.session.user || req.session.user.rol !== 'admin') {
        return res.redirect('/login');
    }
    res.render('admin/dashboard', { user: req.session.user });
});

// ====== OTRAS RUTAS ADMIN (buses, etc.) ======
app.get('/admin/buses', async (req, res) => {
    if (!req.session.user || req.session.user.rol !== 'admin') {
        return res.redirect('/login');
    }

    try {
        //Traer datos reales
        const [generacionesResult,
                modelosResult,
                depositosResult,
                busesResult] = await Promise.all([
            pool.query('SELECT * FROM generaciones'),
            pool.query('SELECT * FROM  modelos'),
            pool.query('SELECT * FROM  depositos'),
            pool.query('SELECT * FROM  buses')]);
            
        
        const generaciones = generacionesResult[0];
        const modelos = modelosResult[0];
        const depositos = depositosResult[0];
        const buses = busesResult[0];
    
        res.render('admin/buses', {
            user: req.session.user,
            generaciones,
            modelos,
            depositos,
            buses
        });

    } catch (error) {
        console.error('Error cargando buses:', error);

        res.render('admin/buses', {
            user: req.session.user,
            generaciones: [], 
            modelos: [],
            depositos: [],
            buses: []
        });
    }
});

app.get('/admin/mantenimientos', (req, res) => {
    if (!req.session.user || req.session.user.rol !== 'admin') return res.redirect('/login');
    res.render('admin/mantenimientos', { user: req.session.user });
});

app.get('/admin/personal', (req, res) => {
    if (!req.session.user || req.session.user.rol !== 'admin') return res.redirect('/login');
    res.render('admin/personal', { user: req.session.user });
});

app.get('/admin/rastreo', (req, res) => {
    if (!req.session.user || req.session.user.rol !== 'admin') return res.redirect('/login');
    res.render('admin/rastreo', { user: req.session.user });
});

// ====== DASHBOARD USER (si tienes usuarios normales) ======
app.get('/user/dashboard', (req, res) => {
    if (!req.session.user) return res.redirect('/login');
    res.render('admin/dashboard', { user: req.session.user }); // o tu vista user
});


// API para chat con Grok (xAI)
app.use('/api', express.json());

app.post('/api/chat', async (req, res) => {
    const { message } = req.body;
    const apiKey = process.env.GROK_API_KEY;

    if (!message) {
        return res.json({ reply: 'Escribe una pregunta para Grok.' });
    }

    if (!apiKey || apiKey.includes('tu-clave-aqui')) {
        console.log('API Key no configurada - usando demo');
        return res.json({
            reply: '¡Hola! Soy Grok en modo demo. Tu pregunta: "' + message + '" fue recibida. Configura la API key para respuestas reales.'
        });
    }

    try {
        console.log('🧠 Enviando a Grok:', message);  // Log en consola

        const response = await fetch('https://api.x.ai/v1/chat/completions', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${apiKey}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                model: 'grok-beta',  // O 'grok-1' si usas la nueva
                messages: [
                    {
                        role: 'system',
                        content: 'Eres Grok, asistente útil del sistema Flota STE. Responde en español sobre autobuses, mantenimientos, personal y rastreo. Sé breve, preciso y útil. Si no sabes algo, di "No tengo info específica, pero puedo ayudarte con lo básico".'
                    },
                    { role: 'user', content: message }
                ],
                max_tokens: 200,
                temperature: 0.7
            })
        });

        if (!response.ok) {
            const errorData = await response.json();
            console.error('Error HTTP de Grok:', response.status, errorData);
            return res.json({
                reply: `Error temporal: ${errorData.error?.message || 'Código ' + response.status}. Verifica créditos en console.x.ai.`
            });
        }

        const data = await response.json();
        console.log('📄 Respuesta completa de Grok:', JSON.stringify(data, null, 2));  // Log completo para debug

        // Manejo robusto de la respuesta (arregla el "undefined")
        let reply = 'Grok no pudo responder. Intenta reformular tu pregunta o verifica créditos en console.x.ai.';

        if (data.choices && Array.isArray(data.choices) && data.choices.length > 0) {
            const firstChoice = data.choices[0];
            if (firstChoice.message && firstChoice.message.content) {
                reply = firstChoice.message.content.trim();
            } else if (firstChoice.text) {
                reply = firstChoice.text.trim();  // Para formatos alternos
            } else {
                console.log('Choices[0] sin content/text:', firstChoice);
                reply = 'Respuesta recibida, pero vacía. Prueba otra pregunta.';
            }
        } else if (data.error) {
            console.error('Error de Grok:', data.error);
            reply = `Error de Grok: ${data.error.message || 'No hay detalles'}. Verifica créditos en console.x.ai.`;
        } else {
            console.log('Estructura inesperada:', data);
            reply = 'Grok respondió de forma inesperada. Verifica la consola para detalles.';
        }

        res.json({ reply });

    } catch (err) {
        console.error('❌ Error completo con Grok:', err.message);
        res.json({
            reply: 'No pude conectar con Grok. Revisa tu conexión o API key. Error: ' + err.message
        });
    }
});


app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});