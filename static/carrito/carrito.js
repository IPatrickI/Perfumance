async function cargarCarrito() {
    try {
        const r = await fetch("/carrito/api/ver/");
        const data = await r.json();

        const box = document.getElementById("lista-carrito");

        if (!data.carrito || !data.carrito.length) {
            box.innerHTML = "<p style='text-align: center; color: #999; padding: 40px;'>El carrito está vacío.</p>";
            return;
        }

        let html = `<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">`;
        
        data.carrito.forEach(p => {
            html += `
                <div class="card" style="border: 1px solid #ddd; border-radius: 8px; padding: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    <div style="text-align: center; margin-bottom: 15px;">
                        <img src="${p.imagen_url}" alt="${p.marca}" style="width: 150px; height: 150px; object-fit: cover; border-radius: 6px;">
                    </div>
                    <h4 style="color: #8B4789; margin: 10px 0;">${p.marca}</h4>
                    <p style="color: #666; margin: 8px 0;"><strong>Cantidad:</strong> ${p.cantidad}</p>
                    <p style="color: #666; margin: 8px 0;"><strong>Precio unitario:</strong> $${parseFloat(p.precio).toFixed(2)}</p>
                    <p style="color: #8B4789; font-size: 1.2em; font-weight: bold; margin: 10px 0;">Subtotal: $${parseFloat(p.subtotal).toFixed(2)}</p>
                    <button class="btn-danger" onclick="eliminarItem(${p.id_perfume})" style="width: 100%; padding: 10px; background: #ff4444; color: white; border: none; border-radius: 4px; cursor: pointer;">
                        🗑️ Eliminar
                    </button>
                </div>
            `;
        });
        
        html += `</div>`;
        html += `<div style="margin-top: 30px; text-align: right;">
            <p style="font-size: 1.3em; color: #8B4789;"><strong>Total: $${parseFloat(data.total).toFixed(2)}</strong></p>
            <button class="btn-primary" onclick="vaciarCarrito()" style="padding: 10px 20px; background: #f0f0f0; color: #333; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;">
                🗑️ Vaciar Carrito
            </button>
            <a href="/carrito/checkout/" class="btn-primary" style="padding: 10px 20px; background: #8B4789; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block;">
                ✓ Finalizar Compra
            </a>
        </div>`;
        
        box.innerHTML = html;
    } catch (error) {
        console.error('Error al cargar carrito:', error);
        document.getElementById("lista-carrito").innerHTML = "<p style='color: red;'>Error al cargar el carrito</p>";
    }
}

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

async function eliminarItem(id) {
    try {
        const response = await fetch("/carrito/api/eliminar/", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({id_perfume: id})
        });
        
        if (response.ok) {
            cargarCarrito();
        } else {
            console.error("Error al eliminar producto");
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function vaciarCarrito() {
    if (!confirm('¿Estás seguro de que deseas vaciar el carrito?')) {
        return;
    }
    
    try {
        const response = await fetch("/carrito/api/vaciar/", {
            method: "POST",
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            }
        });
        
        if (response.ok) {
            cargarCarrito();
        } else {
            console.error("Error al vaciar carrito");
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function realizarCompra() {
    const r = await fetch("/carrito/api/checkout/", {method: "POST"});
    const data = await r.json();

    if (data.error) {
        console.error(data.error);
        return;
    }

    console.log("Compra realizada");
    window.location = "/carrito/historial/";
}

// Cargar carrito cuando la página se carga
document.addEventListener('DOMContentLoaded', cargarCarrito);
