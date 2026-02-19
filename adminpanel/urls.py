from django.urls import path
from . import views

app_name = "adminpanel"

urlpatterns = [
    path('', views.admin_dashboard, name='dashboard'),

    # Productos
    path('productos/', views.admin_productos, name='productos'),
    path('productos/crear/', views.vista_crear_perfume, name='crear_perfume'),
    path('productos/crear/post/', views.crear_perfume, name='crear_perfume_post'),
    path('productos/editar/<int:id_perfume>/', views.vista_editar_perfume, name='editar_perfume'),
    path('productos/editar/<int:id_perfume>/post/', views.editar_perfume, name='editar_perfume_post'),
    path('productos/eliminar/<int:id_perfume>/', views.eliminar_perfume, name='eliminar_perfume'),

    # Usuarios
    path('usuarios/', views.admin_usuarios, name='usuarios'),
    path('usuarios/crear/', views.vista_crear_usuario, name='crear_usuario'),
    path('usuarios/crear/post/', views.crear_usuario, name='crear_usuario_post'),
    path('usuarios/editar/<int:id_usuario>/', views.vista_editar_usuario, name='editar_usuario'),
    path('usuarios/editar/<int:id_usuario>/post/', views.editar_usuario, name='editar_usuario_post'),
    path('usuarios/eliminar/<int:id_usuario>/', views.eliminar_usuario, name='eliminar_usuario'),

    # Ventas
    path('pedidos/', views.admin_pedidos, name='pedidos'),
    path('pedidos/<int:id_venta>/', views.admin_detalle_pedido, name='detalle_pedido'),
]
