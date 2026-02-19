from django.urls import path
from . import views

urlpatterns = [
    path('', views.home_view, name='home'),
    path('quienes-somos/', views.quienes_somos_view, name='quienes_somos'),
]
