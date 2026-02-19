from django.urls import path
from . import views

urlpatterns = [
    path('historial/', views.historial_ventas, name='ventas_historial'),
    path('detalle/<int:id_venta>/', views.detalle_venta, name='ventas_detalle'),
    path('pagos/', views.ver_pagos, name='ventas_pagos'),
    path('pago/', views.pago_view, name='pago'),
]
