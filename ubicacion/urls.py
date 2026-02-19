from django.urls import path
from . import views

app_name = "ubicacion"

urlpatterns = [
    # Vista HTML única y simplificada
    path('mapa/', views.mapa_view, name='mapa'),
]