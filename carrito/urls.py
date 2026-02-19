from django.urls import path
from . import views

app_name = "carrito"

urlpatterns = [
    # API
    path('api/agregar/', views.api_agregar_carrito, name='api_agregar'),
    path('api/ver/', views.api_ver_carrito, name='api_ver'),
    path('api/eliminar/', views.api_eliminar_item, name='api_eliminar'),
    path('api/actualizar/', views.api_actualizar_item, name='api_actualizar'),
    path('api/vaciar/', views.api_vaciar_carrito, name='api_vaciar'),
    path('api/checkout/', views.api_checkout, name='api_checkout'),
    
    # Mercado Pago
    path('api/mercado-pago/crear/', views.crear_preferencia_mercado_pago, name='crear_preferencia_mp'),

    # Vistas HTML
    path('ver/', views.carrito_page, name='carrito_page'),
    path('checkout/', views.checkout_page, name='checkout_page'),

    # Ventas del cliente
    path('historial/', views.historial_compras, name='historial'),
    path('venta/<int:id_venta>/', views.detalle_compra, name='detalle'),
    
    # Callbacks de Mercado Pago
    path('mercado-pago/success/', views.mercado_pago_success, name='mercado_pago_success'),
    path('mercado-pago/failure/', views.mercado_pago_failure, name='mercado_pago_failure'),
    path('mercado-pago/pending/', views.mercado_pago_pending, name='mercado_pago_pending'),
]
