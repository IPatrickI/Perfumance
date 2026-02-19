from django.urls import path
from . import views

app_name = "catalogo"

urlpatterns = [
    # API REST
    path('api/lista/', views.api_lista_perfumes, name='api_lista'),
    path('api/genero/<str:genero>/', views.api_perfumes_por_genero, name='api_genero'),
    path('api/buscar/', views.api_buscar_perfume, name='api_buscar'),
    path('api/<int:id_perfume>/', views.api_perfume_por_id, name='api_id'),

    # VISTAS HTML
    path('', views.catalogo_page, name='catalogo_page'),
    path('detalle/<int:id_perfume>/', views.detalle_perfume, name='detalle_perfume'),
    path('genero/<str:genero>/', views.catalogo_genero_page, name='catalogo_genero_page'),
]
