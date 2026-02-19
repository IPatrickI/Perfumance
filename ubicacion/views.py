from django.shortcuts import render

SUCURSALES = [
    {
        "id": 1,
        "nombre": "Oficina Principal - DG Perfumance",
        "direccion": "Av Telecomunicaciones, Chinam Pac de Juárez, Iztapalapa, 09208 Ciudad de México, CDMX, Mexico",
        "telefono": "+52 56 5220 6277",
        "email": "l221080533@iztapalapa.tecnm.mx",
        "latitud": 19.3574,
        "longitud": -99.0706,
        "horario": "9:00 AM - 9:00 PM",
        "dias": "Lunes a Domingo"
    }
]

def mapa_view(request):
    """Renderiza la página de ubicaciones"""
    return render(request, 'ubicacion/mapa.html', {'sucursales': SUCURSALES})