let mapa;
let marcadores = [];

function inicializarMapa() {
    // Centro inicial: Iztapalapa
    const centroInicial = [19.3574, -99.0706];

    mapa = L.map('mapa').setView(centroInicial, 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(mapa);

    cargarSucursales();
}

function cargarSucursales() {
    const sucursalesElement = document.getElementById('sucursales-data');
    if (sucursalesElement) {
        const sucursales = JSON.parse(sucursalesElement.textContent);
        sucursales.forEach(sucursal => {
            agregarMarcador(sucursal);
        });
    }
}

function agregarMarcador(sucursal) {
    const lat = parseFloat(sucursal.latitud);
    const lng = parseFloat(sucursal.longitud);

    // Icono morado para DG Perfumance
    const iconoMorado = L.icon({
        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-violet.png',
        shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
    });

    const marcador = L.marker([lat, lng], { icon: iconoMorado }).addTo(mapa);
    
    // Contenido del Popup simplificado
    const contenido = `
        <div style="padding:10px;">
            <h3 style="color:#8B4789; margin:0;">${sucursal.nombre}</h3>
            <p style="margin:5px 0; font-size:0.9em;">${sucursal.direccion}</p>
            <p style="margin:0; font-size:0.9em;"><b>Horario:</b> ${sucursal.horario}</p>
        </div>
    `;
    
    marcador.bindPopup(contenido);
    marcadores.push({ marcador, sucursal });
}

// Función global para los botones del HTML
window.centrarMapa = function(latitud, longitud) {
    const lat = parseFloat(latitud);
    const lng = parseFloat(longitud);
    
    mapa.setView([lat, lng], 17);

    const marcadorObj = marcadores.find(m => 
        m.sucursal.latitud === lat && m.sucursal.longitud === lng
    );
    
    if (marcadorObj) {
        marcadorObj.marcador.openPopup();
    }
};

window.addEventListener('load', inicializarMapa);