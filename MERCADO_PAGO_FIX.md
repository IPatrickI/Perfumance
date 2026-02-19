# Fix Mercado Pago - Resumen de Cambios

## Problema Identificado
El API de Mercado Pago rechazaba las peticiones con error `400 Bad Request`:
- **Error 1**: `invalid type (string) for field: payer.phone`
- **Error 2**: `auto_return invalid. back_url.success must be defined` (en localhost)

## Causa Raíz
1. **Phone Field Format**: Mercado Pago requiere que `payer.phone` sea un objeto con estructura:
   ```python
   "phone": {
       "area_code": "55",
       "number": "12345678"
   }
   ```
   No un string plano como se estaba enviando.

2. **Auto Return en Localhost**: El campo `auto_return` solo es válido con URLs públicas HTTPS. En localhost (HTTP) debe omitirse.

3. **Dependency Missing**: Faltaba `python-decouple` en requirements.txt (aunque no se usa en el código actual).

## Cambios Realizados

### 1. `/carrito/views.py` - Función `crear_preferencia_mercado_pago()`
- ✅ Agregué procesamiento del teléfono para extraer `area_code` y `number`
- ✅ Construyo el objeto `phone` correctamente con estructura requerida
- ✅ Solo agrego `auto_return` si no es URL localhost
- ✅ Manejo de teléfono vacío/inválido sin fallar

### 2. `/requirements.txt`
- ✅ Agregué `python-decouple==3.8` a las dependencias

## Test de Validación
Script de prueba ejecutado satisfactoriamente:
```
Status: 201
ID: 1206929404-664d06dc-cabf-4e16-90c9-f7211c951fee
Init Point: https://www.mercadopago.com.mx/checkout/v1/redirect?pref_id=...
```

## Configuración Actual (.env)
```
MERCADO_PAGO_ACCESS_TOKEN=TEST-6149617311130216-120716-8c832365d8a47ef8effd31364f147223-1206929404
MERCADO_PAGO_PUBLIC_KEY=TEST-6224e72a-18f4-405f-a073-795708315087
BASE_URL=http://localhost:8000
```

## Próximos Pasos Recomendados
1. ✅ Actualizar SDK en producción si es necesario
2. ✅ Usar tokens PRODUCTION en .env cuando se despliegue a Railway
3. ✅ Configurar URLs públicas HTTPS en production
4. ✅ Probar flujo completo de checkout (agregar carrito → Mercado Pago → callback)
