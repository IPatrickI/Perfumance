#!/usr/bin/env python
import os
import sys
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'perfumance.settings')

import django
django.setup()

from django.conf import settings
import mercadopago
from datetime import datetime

print("=" * 80)
print("TEST MERCADO PAGO")
print("=" * 80)

# Verificar configuración
print(f"\n1. Verificando configuración:")
print(f"   MERCADO_PAGO_ACCESS_TOKEN: {settings.MERCADO_PAGO_ACCESS_TOKEN[:30]}...")
print(f"   BASE_URL: {settings.MERCADO_PAGO_SUCCESS_URL}")

# Crear preferencia de prueba
print(f"\n2. Creando preferencia de prueba...")
try:
    sdk = mercadopago.SDK(settings.MERCADO_PAGO_ACCESS_TOKEN)
    
    preference_data = {
        "items": [
            {
                "title": "Perfume Test",
                "quantity": 1,
                "unit_price": 99.99
            }
        ],
        "payer": {
            "name": "Test",
            "surname": "User",
            "email": "test@example.com",
            "phone": {
                "area_code": "55",
                "number": "12345678"
            }
        },
        "back_urls": {
            "success": settings.MERCADO_PAGO_SUCCESS_URL,
            "failure": settings.MERCADO_PAGO_FAILURE_URL,
            "pending": settings.MERCADO_PAGO_PENDING_URL
        },
        "external_reference": f"TEST_{int(datetime.now().timestamp())}"
    }
    
    # Agregar auto_return solo si no es localhost
    if "localhost" not in settings.MERCADO_PAGO_SUCCESS_URL:
        preference_data["auto_return"] = "approved"
    
    print(f"   Preference data: {preference_data}")
    
    response = sdk.preference().create(preference_data)
    
    print(f"\n3. Respuesta del SDK:")
    print(f"   Status: {response.get('status')}")
    print(f"   Keys: {response.keys()}")
    print(f"   Full response: {response}")
    
    if response.get('status') and response.get('status') >= 400:
        print(f"\n   ERROR: {response.get('response', {}).get('message', 'Error desconocido')}")
    else:
        preference = response.get('response', {})
        if preference:
            print(f"\n   ✓ Preferencia creada:")
            print(f"     ID: {preference.get('id')}")
            print(f"     Init Point: {preference.get('init_point')}")
        else:
            print(f"\n   ERROR: Respuesta vacía")
            
except Exception as e:
    print(f"\n   EXCEPCIÓN: {type(e).__name__}: {e}")
    import traceback
    traceback.print_exc()

print("\n" + "=" * 80)
