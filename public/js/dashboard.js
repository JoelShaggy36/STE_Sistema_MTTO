// dashboard.js - Modo claro/oscuro + Chat Grok
document.addEventListener('DOMContentLoaded', function () {
    // Modo claro/oscuro
    const themeToggle = document.getElementById('themeToggle');
    const html = document.documentElement;

    // Cargar preferencia guardada
    const savedTheme = localStorage.getItem('theme') || 'dark';
    html.setAttribute('data-theme', savedTheme);
    if (savedTheme === 'light') {
        themeToggle.innerHTML = '<i class="bi bi-sun-fill"></i>';
    } else {
        themeToggle.innerHTML = '<i class="bi bi-moon-stars-fill"></i>';
    }

    // Cambiar tema al clic
    themeToggle.addEventListener('click', function () {
        if (html.getAttribute('data-theme') === 'light') {
            html.setAttribute('data-theme', 'dark');
            localStorage.setItem('theme', 'dark');
            themeToggle.innerHTML = '<i class="bi bi-moon-stars-fill"></i>';
        } else {
            html.setAttribute('data-theme', 'light');
            localStorage.setItem('theme', 'light');
            themeToggle.innerHTML = '<i class="bi bi-sun-fill"></i>';
        }
    });

    // Sidebar colapsable (expandir al hover)
    const sidebar = document.querySelector('.sidebar');
    sidebar.addEventListener('mouseenter', function () {
        this.classList.add('expanded');
    });
    sidebar.addEventListener('mouseleave', function () {
        this.classList.remove('expanded');
    });

    // Chat con Grok API
    const chatInput = document.getElementById('chatInput');
    const chatOutput = document.getElementById('chatOutput');
    const chatForm = chatInput?.parentElement; // Si usas form
    if (chatInput) {
        chatInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') enviarPregunta();
        });
    }

    window.enviarPregunta = function () {
        const pregunta = chatInput.value.trim();
        if (!pregunta) return;

        // Agregar pregunta del usuario
        chatOutput.innerHTML += `
            <div class="d-flex justify-content-end mb-2">
                <div class="bg-primary text-white p-2 rounded-pill max-w-75">
                    ${pregunta}
                </div>
            </div>
        `;
        chatInput.value = '';
        chatOutput.scrollTop = chatOutput.scrollHeight;

        // Llamar a Grok API
        fetch('/api/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: pregunta })
        })
            .then(response => response.json())
            .then(data => {
                chatOutput.innerHTML += `
                <div class="d-flex justify-content-start mb-3">
                    <div class="bg-light p-2 rounded-pill max-w-75">
                        <strong>Grok:</strong> ${data.reply || 'Respuesta de Grok aquí.'}
                    </div>
                </div>
            `;
                chatOutput.scrollTop = chatOutput.scrollHeight;
            })
            .catch(err => {
                chatOutput.innerHTML += `
                <div class="d-flex justify-content-start mb-3 text-danger">
                    <div class="bg-light p-2 rounded-pill max-w-75">
                        Error: No pude conectar con Grok. Intenta de nuevo.
                    </div>
                </div>
            `;
            });
    };
});