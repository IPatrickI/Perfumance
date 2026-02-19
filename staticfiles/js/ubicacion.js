// Ubicación/Mapa JavaScript

let mapa;
let marcadores = [];
let infoWindowsAbiertas = [];

/**
 * Inicializa el mapa de Google Maps
 */
function inicializarMapa() {
    // Centro inicial (Ciudad de México - Iztapalapa)
    const centroInicial = {
        lat: 19.3574,
        lng: -99.0706
    };

    mapa = new google.maps.Map(document.getElementById('mapa'), {
        zoom: 12,
        center: centroInicial,
        mapTypeControl: true,
        fullscreenControl: true,
        streetViewControl: true,
        zoomControl: true,
        styles: [
            {
                elementType: 'geometry',
                stylers: [{ color: '#f5f5f5' }]
            },
            {
                elementType: 'labels.icon',
                stylers: [{ visibility: 'off' }]
            },
            {
                elementType: 'labels.text.fill',
                stylers: [{ color: '#616161' }]
            },
            {
                elementType: 'labels.text.stroke',
                stylers: [{ color: '#f5f5f5' }]
            },
            {
                featureType: 'water',
                elementType: 'geometry',
                stylers: [{ color: '#c9c9c9' }]
            },
            {
                featureType: 'water',
                elementType: 'labels.text.fill',
                stylers: [{ color: '#9ca5b0' }]
            }
        ]
    });

    // Agregar marcadores para todas las sucursales
    cargarSucursales();
    
    // Event listeners
    document.addEventListener('sucursalSeleccionada', (e) => {
        centrarEnSucursal(e.detail);
    });
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
    const marcador = new google.maps.Marker({
        position: {
            lat: parseFloat(sucursal.latitud),
            lng: parseFloat(sucursal.longitud)
        },
        map: mapa,
        title: sucursal.nombre,
        icon: 'http://maps.google.com/mapfiles/ms/icons/purple-dot.png'
    });

    const infoWindow = new google.maps.InfoWindow({
        content: crearContenidoInfoWindow(sucursal)
    });

    marcador.addListener('click', () => {
        cerrarTodosInfoWindows();
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
 * Cierra todos los info windows abiertos
 */
function cerrarTodosInfoWindows() {
    infoWindowsAbiertas.forEach(iw => iw.close());
    infoWindowsAbiertas = [];
}

/**
 * Centra el mapa en una sucursal específica
 * @param {number} lat - Latitud
 * @param {number} lng - Longitud
 */
function centrarEnSucursal(latitud, longitud) {
    const lat = parseFloat(latitud);
    const lng = parseFloat(longitud);
    
    mapa.setCenter({ lat, lng });
    mapa.setZoom(16);

    // Abrir info window del marcador
    const marcador = marcadores.find(m =>
        parseFloat(m.sucursal.latitud) === lat &&
        parseFloat(m.sucursal.longitud) === lng
    );
    
    if (marcador) {
        cerrarTodosInfoWindows();
        marcador.infoWindow.open(mapa, marcador.marcador);
        infoWindowsAbiertas.push(marcador.infoWindow);
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
        const bounds = new google.maps.LatLngBounds();
        resultados.forEach(r => {
            bounds.extend({
                lat: parseFloat(r.sucursal.latitud),
                lng: parseFloat(r.sucursal.longitud)
            });
        });
        mapa.fitBounds(bounds);
        mapa.setZoom(Math.min(mapa.getZoom(), 15));
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

// Inicializar cuando carga la página
document.addEventListener('DOMContentLoaded', () => {
    // Esperar a que Google Maps esté cargado
    if (document.readyState === 'complete' || window.google?.maps) {
        inicializarMapa();
    } else {
        window.addEventListener('load', inicializarMapa);
    }
});

// Permitir reinicio de marcadores si es necesario
function limpiarMapa() {
    marcadores.forEach(m => m.marcador.setMap(null));
    marcadores = [];
    infoWindowsAbiertas = [];
}
