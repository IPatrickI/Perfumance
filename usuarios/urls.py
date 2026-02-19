from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('perfil/', views.perfil_view, name='perfil'),
    path('registro/', views.registro_view, name='registro'),
    path('recuperar/', views.recuperar_view, name='recuperar'),
    path('actualizar-perfil/', views.actualizar_perfil_view, name='actualizar_perfil'),
    path('agregar-direccion/', views.agregar_direccion_view, name='agregar_direccion'),
    path('eliminar-direccion/', views.eliminar_direccion_view, name='eliminar_direccion'),
]

