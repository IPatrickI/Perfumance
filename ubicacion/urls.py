from django.urls import path
from . import views

app_name = "ubicacion"

urlpatterns = [
    # API
    path('api/buscar/', views.api_buscar_ubicacion, name='api_buscar'),
    path('api/ubicaciones/', views.api_listar_ubicaciones, name='api_ubicaciones'),
    
    # Vistas HTML
    path('mapa/', views.mapa_view, name='mapa'),
]
