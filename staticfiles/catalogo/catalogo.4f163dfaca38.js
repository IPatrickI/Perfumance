async function cargarPerfumes() {
    const resp = await fetch("/catalogo/api/lista/");
    const data = await resp.json();

    mostrarPerfumes(data);

    document.getElementById("buscador").addEventListener("input", async (e) => {
        const q = e.target.value.trim();

        if (q === "") return mostrarPerfumes(data);

        const r = await fetch(`/catalogo/api/buscar/?q=${q}`);
        const filtrados = await r.json();
        mostrarPerfumes(filtrados);
    });
}

function mostrarPerfumes(lista) {
    const cont = document.getElementById("lista-perfumes");

    if (!lista.length) {
        cont.innerHTML = "<p>No se encontraron perfumes.</p>";
        return;
    }

    cont.innerHTML = lista.map(p => `
        <div class="card">
            <img src="${p.imagen_url}" class="img">
            <h3>${p.marca}</h3>
            <p>${p.presentacion} - ${p.talla}</p>
            <p><strong>$${p.precio}</strong></p>
            <button class="btn" onclick="agregar(${p.id})">Agregar al carrito</button>
        </div>
    `).join("");
}

async function agregar(id) {
    await fetch("/carrito/api/agregar/", {
        method: "POST",
        body: JSON.stringify({id_perfume: id, cantidad: 1})
    });
    console.log("Agregado al carrito");
}

window.onload = cargarPerfumes;
