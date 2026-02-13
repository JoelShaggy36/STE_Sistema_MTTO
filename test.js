const express = require('express');
const session = require('express-session');
const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(session({
    secret: 'test123',
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false }
}));

app.get('/login', (req, res) => {
    res.send(`
        <h1 style="text-align:center;margin-top:100px">LOGIN DE PRUEBA</h1>
        <form method="POST" action="/login" style="text-align:center">
            Usuario: <input type="text" name="username"><br><br>
            Contraseña: <input type="password" name="password"><br><br>
            <button type="submit" style="padding:15px 40px;font-size:20px">ENTRAR</button>
        </form>
    `);
});

app.post('/login', (req, res) => {
    req.session.user = { username: 'admin', rol: 'admin' };
    res.redirect('/dashboard');
});

app.get('/dashboard', (req, res) => {
    if (!req.session.user) return res.redirect('/login');
    res.send(`
        <h1 style="color:lime;background:black;padding:200px;text-align:center;font-size:60px">
            ¡ENTRASTE AL DASHBOARD!<br><br>
            TODO FUNCIONA PERFECTO
        </h1>
    `);
});

app.listen(3000, () => {
    console.log('ABRE ESTO EN TU NAVEGADOR: http://localhost:3000/login');
});