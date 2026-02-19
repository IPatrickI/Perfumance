async function cargarPorGenero() {
    const resp = await fetch(`/catalogo/api/genero/${generoSeleccionado}/`);
    const data = await resp.json();
    mostrarPerfumes(data);
}

function mostrarPerfumes(lista) {
    const cont = document.getElementById("lista-perfumes");

    cont.innerHTML = lista.map(p => `
        <div class="card">
            <img src="${p.imagen_url}" class="img">
            <h3>${p.marca}</h3>
            <p>${p.presentacion} - ${p.talla}</p>
            <p><strong>$${p.precio}</strong></p>
            <button onclick="agregar(${p.id})" class="btn">Agregar</button>
        </div>
    `).join("");
}

async function agregar(id) {
    await fetch("/carrito/api/agregar/", {
        method: "POST",
        body: JSON.stringify({id_perfume: id, cantidad: 1})
    });
    alert("Agregado al carrito");
}

window.onload = cargarPorGenero;
