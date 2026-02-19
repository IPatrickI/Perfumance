// Ubicación/Mapa JavaScript - Leaflet (OpenStreetMap)

let mapa;
let marcadores = [];

/**
 * Inicializa el mapa de Leaflet con OpenStreetMap
 */
function inicializarMapa() {
    // Centro inicial (Ciudad de México - Iztapalapa)
    const centroInicial = [19.3574, -99.0706]; // [lat, lng]

    // Crear mapa
    mapa = L.map('mapa').setView(centroInicial, 12);

    // Agregar capa de OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        maxZoom: 19
    }).addTo(mapa);

    // Agregar marcadores para todas las sucursales
    cargarSucursales();
}

/**
 * Carga las sucursales desde el elemento HTML
 */
function cargarSucursales() {
    try {
        const sucursalesElement = document.getElementById('sucursales-data');
        if (sucursalesElement) {
            const sucursales = JSON.parse(sucursalesElement.textContent);
            sucursales.forEach(sucursal => {
                agregarMarcador(sucursal);
            });
        }
    } catch (error) {
        console.error('Error al cargar sucursales:', error);
    }
}

/**
 * Agrega un marcador al mapa para una sucursal
 * @param {Object} sucursal - Datos de la sucursal
 */
function agregarMarcador(sucursal) {
    const lat = parseFloat(sucursal.latitud);
    const lng = parseFloat(sucursal.longitud);

    // Icono personalizado morado
    const iconoMorado = L.icon({
        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-violet.png',
        shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
    });

    // Crear marcador
    const marcador = L.marker([lat, lng], { icon: iconoMorado }).addTo(mapa);

    // Crear contenido del popup
    const contenidoPopup = crearContenidoInfoWindow(sucursal);
    marcador.bindPopup(contenidoPopup);

    // Guardar referencia
    marcadores.push({ marcador, sucursal });
        infoWindow.open(mapa, marcador);
        infoWindowsAbiertas.push(infoWindow);
    });

    marcadores.push({
        marcador,
        infoWindow,
        sucursal
    });
}

/**
 * Crea el contenido HTML para el info window
 * @param {Object} sucursal - Datos de la sucursal
 * @returns {string} HTML del info window
 */
function crearContenidoInfoWindow(sucursal) {
    return `
        <div style="
            padding: 10px;
            font-family: Arial, sans-serif;
            max-width: 300px;
        ">
            <h3 style="
                margin: 0 0 10px 0;
                color: #8B4789;
                font-size: 1.1em;
            ">
                ${sucursal.nombre}
            </h3>
            <div style="font-size: 0.9em; color: #666;">
                <p style="margin: 5px 0;">
                    <strong>📍</strong> ${sucursal.direccion}
                </p>
                <p style="margin: 5px 0;">
                    <strong>📞</strong> 
                    <a href="tel:${sucursal.telefono}" style="color: #8B4789; text-decoration: none;">
                        ${sucursal.telefono}
                    </a>
                </p>
                ${sucursal.email ? `
                <p style="margin: 5px 0;">
                    <strong>📧</strong> 
                    <a href="mailto:${sucursal.email}" style="color: #8B4789; text-decoration: none;">
                        ${sucursal.email}
                    </a>
                </p>
                ` : ''}
                ${sucursal.horario ? `
                <p style="margin: 5px 0;">
                    <strong>⏰</strong> ${sucursal.horario}
                </p>
                ` : ''}
                ${sucursal.dias ? `
                <p style="margin: 5px 0;">
                    <strong>📅</strong> ${sucursal.dias}
                </p>
                ` : ''}
            </div>
        </div>
    `;
}

/**
 * Centra el mapa en una sucursal específica
 * @param {number} lat - Latitud
 * @param {number} lng - Longitud
 */
function centrarEnSucursal(latitud, longitud) {
    const lat = parseFloat(latitud);
    const lng = parseFloat(longitud);
    
    // Centrar y hacer zoom
    mapa.setView([lat, lng], 16);

    // Abrir popup del marcador
    const marcadorObj = marcadores.find(m =>
        parseFloat(m.sucursal.latitud) === lat &&
        parseFloat(m.sucursal.longitud) === lng
    );
    
    if (marcadorObj) {
        marcadorObj.marcador.openPopup();
    }
}

/**
 * Busca sucursales por nombre o dirección
 * @param {string} termino - Término de búsqueda
 */
function buscarSucursal(termino) {
    const terminoLower = termino.toLowerCase();
    const resultados = marcadores.filter(m => {
        return m.sucursal.nombre.toLowerCase().includes(terminoLower) ||
               m.sucursal.direccion.toLowerCase().includes(terminoLower);
    });

    if (resultados.length > 0) {
        // Ajustar mapa para mostrar todos los resultados
        const bounds = L.latLngBounds();
        resultados.forEach(r => {
            bounds.extend([parseFloat(r.sucursal.latitud), parseFloat(r.sucursal.longitud)]);
        });
        mapa.fitBounds(bounds);
    } else {
        console.log('No se encontraron sucursales');
    }
    
    return resultados;
}

/**
 * Obtiene todas las sucursales con marcadores
 * @returns {Array} Array de marcadores
 */
function obtenerSucursales() {
    return marcadores;
}

// Inicializar cuando carga la página (Leaflet se carga síncronamente)
window.addEventListener('load', inicializarMapa);

/**
 * Función global para centrar mapa (usada desde botones en HTML)
 */
function centrarMapa(latitud, longitud) {
    centrarEnSucursal(latitud, longitud);
}
