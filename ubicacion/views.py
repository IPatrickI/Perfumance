from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
import os

# Coordenadas de sucursales
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
    """
    Renderiza la página con el mapa de Leaflet (OpenStreetMap)
    """
    context = {
        'sucursales': SUCURSALES,
        'sucursales_json': json.dumps(SUCURSALES)
    }
    
    return render(request, 'ubicacion/mapa.html', context)


@csrf_exempt
def api_buscar_ubicacion(request):
    """
    API para buscar sucursales por dirección o nombre.
    GET: ?q=busqueda
    """
    if request.method != 'GET':
        return JsonResponse({"error": "Método no permitido"}, status=405)
    
    query = request.GET.get('q', '').lower()
    
    if not query:
        return JsonResponse(SUCURSALES, safe=False)
    
    # Buscar en nombre o dirección
    resultados = [
        s for s in SUCURSALES 
        if query in s['nombre'].lower() or query in s['direccion'].lower()
    ]
    
    return JsonResponse(resultados, safe=False)


def api_listar_ubicaciones(request):
    """
    API para obtener todas las sucursales.
    Retorna lista con coordenadas para mapas.
    """
    return JsonResponse(SUCURSALES, safe=False)
