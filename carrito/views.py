from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from datetime import datetime
import json
import mercadopago

# ============================================================
#  AGREGAR AL CARRITO
# ============================================================
@csrf_exempt
def api_agregar_carrito(request):
    """
    API para agregar un perfume al carrito.
    POST: {id_perfume, cantidad}
    """
    # Permitir agregar carrito sin estar logueado - se guarda en sesión de todas formas
    if request.method != "POST":
        return JsonResponse({"error": "Método no permitido"}, status=405)

    try:
        data = json.loads(request.body.decode())
        id_perfume = data.get("id_perfume")
        cantidad = int(data.get("cantidad", 1))

        if not id_perfume:
            return JsonResponse({"error": "ID del perfume faltante"}, status=400)
        
        if cantidad <= 0:
            return JsonResponse({"error": "La cantidad debe ser mayor a 0"}, status=400)

        with connection.cursor() as cur:
            cur.execute("""
                SELECT marca, precio, stock
                FROM gestion_perfumance.perfume
                WHERE id_perfume = %s
            """, [id_perfume])
            row = cur.fetchone()

        if not row:
            return JsonResponse({"error": "Perfume no encontrado"}, status=404)

        marca, precio, stock = row

        if cantidad > stock:
            return JsonResponse({"error": f"Stock insuficiente. Disponibles: {stock}"}, status=400)

        carrito = request.session.get("carrito", [])
        item = next((x for x in carrito if x["id_perfume"] == id_perfume), None)

        if item:
            nueva_cantidad = item["cantidad"] + cantidad
            if nueva_cantidad > stock:
                return JsonResponse({"error": f"Stock insuficiente. Disponibles: {stock}"}, status=400)
            item["cantidad"] = nueva_cantidad
            item["subtotal"] = item["cantidad"] * float(precio)
        else:
            carrito.append({
                "id_perfume": id_perfume,
                "marca": marca,
                "precio": float(precio),
                "cantidad": cantidad,
                "subtotal": cantidad * float(precio),
                "imagen_url": f"/static/img/perfume_{id_perfume}.jpg"
            })

        request.session["carrito"] = carrito
        return JsonResponse({"message": "Producto agregado", "carrito": carrito})

    except json.JSONDecodeError:
        return JsonResponse({"error": "JSON inválido"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
#  VER CARRITO (PÁGINA)
# ============================================================
def ver_carrito_page(request):
    """Renderiza la página del carrito"""
    if "usuario" not in request.session:
        return redirect("/login")
    return render(request, "carrito/carrito.html")

# ============================================================
# VER CARRITO (API)
# ============================================================
def api_ver_carrito(request):
    """API para obtener los items del carrito actual"""
    # Permitir acceso sin login - simplemente devolver carrito vacío
    carrito = request.session.get("carrito", [])
    total = sum(item["subtotal"] for item in carrito)
    cantidad_items = len(carrito)

    return JsonResponse({
        "carrito": carrito,
        "total": total,
        "cantidad_items": cantidad_items
    })

# ============================================================
#  ELIMINAR PRODUCTO DEL CARRITO
# ============================================================
@csrf_exempt
def api_eliminar_item(request):
    """API para eliminar un item del carrito"""
    # Permitir sin login - opera sobre sesión local
    if request.method != "POST":
        return JsonResponse({"error": "Método no permitido"}, status=405)

    try:
        data = json.loads(request.body.decode())
        id_perfume = data.get("id_perfume")

        if not id_perfume:
            return JsonResponse({"error": "ID del perfume faltante"}, status=400)

        carrito = request.session.get("carrito", [])
        carrito_original = len(carrito)
        carrito = [x for x in carrito if x["id_perfume"] != id_perfume]

        if len(carrito) == carrito_original:
            return JsonResponse({"error": "Producto no encontrado en el carrito"}, status=404)

        request.session["carrito"] = carrito
        return JsonResponse({"message": "Item eliminado", "carrito": carrito})

    except json.JSONDecodeError:
        return JsonResponse({"error": "JSON inválido"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
# ACTUALIZAR CANTIDAD DE ITEM
# ============================================================
@csrf_exempt
def api_actualizar_item(request):
    """API para actualizar la cantidad de un item en el carrito"""
    if "usuario" not in request.session:
        return JsonResponse({"error": "No autorizado"}, status=401)

    if request.method != "POST":
        return JsonResponse({"error": "Método no permitido"}, status=405)

    try:
        data = json.loads(request.body.decode())
        id_perfume = data.get("id_perfume")
        nueva_cantidad = int(data.get("cantidad", 0))

        if not id_perfume or nueva_cantidad <= 0:
            return JsonResponse({"error": "Datos inválidos"}, status=400)

        # Verificar stock disponible
        with connection.cursor() as cur:
            cur.execute("SELECT stock FROM gestion_perfumance.perfume WHERE id_perfume = %s", [id_perfume])
            row = cur.fetchone()

        if not row:
            return JsonResponse({"error": "Perfume no encontrado"}, status=404)

        stock = row[0]
        if nueva_cantidad > stock:
            return JsonResponse({"error": f"Stock insuficiente. Disponibles: {stock}"}, status=400)

        carrito = request.session.get("carrito", [])
        item = next((x for x in carrito if x["id_perfume"] == id_perfume), None)

        if not item:
            return JsonResponse({"error": "Producto no en carrito"}, status=404)

        item["cantidad"] = nueva_cantidad
        item["subtotal"] = nueva_cantidad * item["precio"]

        request.session["carrito"] = carrito
        return JsonResponse({"message": "Cantidad actualizada", "carrito": carrito})

    except (json.JSONDecodeError, ValueError):
        return JsonResponse({"error": "Datos inválidos"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
# VACIAR CARRITO
# ============================================================
@csrf_exempt
def api_vaciar_carrito(request):
    """API para vaciar todo el carrito"""
    # Permitir sin login - opera sobre sesión local
    if request.method != "POST":
        return JsonResponse({"error": "Método no permitido"}, status=405)

    request.session["carrito"] = []
    return JsonResponse({"message": "Carrito vaciado"})

# ============================================================
# CHECKOUT
# ============================================================
@csrf_exempt
def api_checkout(request):
    """
    API para procesar la compra.
    Crea la venta, el pago y actualiza el stock.
    """
    if "usuario" not in request.session:
        return JsonResponse({"error": "Necesita iniciar sesión"}, status=401)

    if request.method != "POST":
        return JsonResponse({"error": "Método no permitido"}, status=405)

    usuario = request.session["usuario"]
    id_cliente = usuario.get("id_usuario")
    carrito = request.session.get("carrito", [])

    if not carrito:
        return JsonResponse({"error": "Carrito vacío"}, status=400)

    try:
        with connection.cursor() as cur:
            # Calcular total
            monto_total = sum(item["cantidad"] * item["precio"] for item in carrito)

            # Crear venta
            cur.execute("""
                INSERT INTO gestion_perfumance.venta (fecha_venta, monto_total, id_cliente)
                VALUES (%s, %s, %s) RETURNING id_venta
            """, [datetime.now(), monto_total, id_cliente])
            id_venta = cur.fetchone()[0]

            # Crear pago
            cur.execute("""
                INSERT INTO gestion_perfumance.pago (id_cliente, total, estado, metododepago)
                VALUES (%s, %s, %s, %s) RETURNING id_pago
            """, [id_cliente, monto_total, "Completado", "Tarjeta"])
            id_pago = cur.fetchone()[0]

            # Detalles de pago + restar stock
            for item in carrito:
                cur.execute("""
                    INSERT INTO gestion_perfumance.detalle_pago
                    (id_pago, id_venta, id_cliente, id_perfume, cantidad, costo_unitario)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, [
                    id_pago, id_venta, id_cliente,
                    item["id_perfume"], item["cantidad"], item["precio"]
                ])

                cur.execute("""
                    UPDATE gestion_perfumance.perfume
                    SET stock = stock - %s
                    WHERE id_perfume = %s
                """, [item["cantidad"], item["id_perfume"]])

        # Limpiar carrito después de la compra exitosa
        request.session.pop("carrito", None)

        return JsonResponse({
            "message": "Compra realizada con éxito",
            "id_venta": id_venta,
            "id_pago": id_pago,
            "monto_total": float(monto_total)
        }, status=201)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
# HISTORIAL DE VENTAS
# ============================================================
def ver_historial_ventas(request, id_cliente):
    """API para obtener el historial de ventas de un cliente"""
    if "usuario" not in request.session:
        return JsonResponse({"error": "No autorizado"}, status=401)

    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT id_venta, fecha_venta, monto_total
                FROM gestion_perfumance.venta
                WHERE id_cliente = %s
                ORDER BY fecha_venta DESC
            """, [id_cliente])
            rows = cur.fetchall()

        return JsonResponse([
            {
                "id_venta": r[0],
                "fecha_venta": str(r[1]),
                "monto_total": float(r[2])
            }
            for r in rows
        ], safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
#  DETALLE DE VENTA
# ============================================================
def ver_detalle_venta(request, id_venta):
    """API para obtener los detalles de una venta específica"""
    if "usuario" not in request.session:
        return JsonResponse({"error": "No autorizado"}, status=401)

    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT dp.id_detalle_pago, p.marca, dp.cantidad, dp.costo_unitario
                FROM gestion_perfumance.detalle_pago dp
                JOIN gestion_perfumance.perfume p
                    ON dp.id_perfume = p.id_perfume
                WHERE dp.id_venta = %s
            """, [id_venta])
            rows = cur.fetchall()

        return JsonResponse([
            {
                "id_detalle": r[0],
                "marca": r[1],
                "cantidad": r[2],
                "precio_unitario": float(r[3]),
                "subtotal": r[2] * float(r[3])
            }
            for r in rows
        ], safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
#  PÁGINA CARRITO
# ============================================================    
def carrito_page(request):
    """Renderiza la página del carrito"""
    if "usuario" not in request.session:
        return redirect("/login/")
    return render(request, "carrito/carrito.html")

# ============================================================
#  PÁGINA CHECKOUT
# ============================================================
def checkout_page(request):
    """Renderiza la página de checkout"""
    if "usuario" not in request.session:
        return redirect("/login/")
    return render(request, "carrito/checkout.html")

# ============================================================
#  PÁGINA HISTORIAL DE COMPRAS 
# ============================================================
def historial_compras(request):
    """Renderiza la página de historial de compras"""
    if "usuario" not in request.session:
        return redirect("/login/")
    return render(request, "carrito/historial.html")

# ============================================================
#  PÁGINA DETALLE DE COMPRA
# ============================================================
def detalle_compra(request, id_venta):
    """Renderiza la página de detalle de una compra"""
    if "usuario" not in request.session:
        return redirect("/login/")
    return render(request, "carrito/detalle.html", {"id_venta": id_venta})

# ============================================================
# MERCADO PAGO INTEGRATION
# ============================================================

def crear_preferencia_mercado_pago(request):
    """Crea una preferencia de pago en Mercado Pago"""
    if "usuario" not in request.session:
        return JsonResponse({"error": "No autorizado"}, status=401)
    
    try:
        carrito = request.session.get("carrito", [])
        
        if not carrito:
            return JsonResponse({"error": "Carrito vacío"}, status=400)

        if not settings.MERCADO_PAGO_ACCESS_TOKEN:
            return JsonResponse({
                "error": "Configura MERCADO_PAGO_ACCESS_TOKEN en el entorno"
            }, status=500)
        
        # Inicializar cliente de Mercado Pago
        sdk = mercadopago.SDK(settings.MERCADO_PAGO_ACCESS_TOKEN)
        
        # Preparar items para Mercado Pago
        items = []
        for producto in carrito:
            items.append({
                "title": producto["marca"],
                "quantity": producto["cantidad"],
                "unit_price": float(producto["precio"])
            })
        
        # Obtener datos del cliente
        usuario_id = request.session["usuario"]["id_usuario"]
        with connection.cursor() as cur:
            cur.execute("""
                SELECT u.email, c.nombres, c.apellidos, c.telefono
                FROM gestion_perfumance.usuario u
                JOIN gestion_perfumance.cliente c ON u.id_cliente = c.id_cliente
                WHERE u.id_usuario = %s
            """, [usuario_id])
            user_data = cur.fetchone()
        
        email = user_data[0] if user_data else "cliente@example.com"
        nombres = user_data[1] if user_data else "Cliente"
        apellidos = user_data[2] if user_data else ""
        telefono = user_data[3] if user_data else ""
        
        # Procesar teléfono para Mercado Pago
        phone_data = {}
        if telefono:
            # Extraer área code (primeros 2 dígitos) y número
            telefono_limpio = ''.join(filter(str.isdigit, telefono))
            if len(telefono_limpio) >= 10:
                phone_data = {
                    "area_code": telefono_limpio[:2],
                    "number": telefono_limpio[2:]
                }
        
        # Crear preferencia
        preference_data = {
            "items": items,
            "payer": {
                "name": nombres,
                "surname": apellidos,
                "email": email
            },
            "back_urls": {
                "success": settings.MERCADO_PAGO_SUCCESS_URL,
                "failure": settings.MERCADO_PAGO_FAILURE_URL,
                "pending": settings.MERCADO_PAGO_PENDING_URL
            },
            "external_reference": f"DG_PERFUMANCE_{usuario_id}_{int(datetime.now().timestamp())}"
        }
        
        # Agregar auto_return solo si no es localhost
        if "localhost" not in settings.MERCADO_PAGO_SUCCESS_URL:
            preference_data["auto_return"] = "approved"
        
        # Agregar teléfono si está disponible
        if phone_data:
            preference_data["payer"]["phone"] = phone_data
        
        preference_response = sdk.preference().create(preference_data)
        response_status = preference_response.get("status")
        if response_status and response_status >= 400:
            # Devuelve el mensaje de Mercado Pago para facilitar el debug
            error_msg = preference_response.get("response", {}).get("message", "Error en Mercado Pago")
            return JsonResponse({"error": error_msg}, status=response_status)

        preference = preference_response.get("response", {})
        if not preference:
            return JsonResponse({"error": "Respuesta vacía desde Mercado Pago"}, status=502)
        
        return JsonResponse({
            "init_point": preference.get("init_point"),
            "id": preference.get("id")
        })
    
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

@csrf_exempt
def mercado_pago_success(request):
    """Callback de Mercado Pago cuando el pago es exitoso"""
    try:
        payment_id = request.GET.get("payment_id")
        
        if not payment_id:
            return redirect("/carrito/ver/")
        
        # Procesar el pago (crear venta)
        usuario = request.session.get("usuario")
        if not usuario:
            return redirect("/login/")
        
        usuario_id = usuario["id_usuario"]
        carrito = request.session.get("carrito", [])
        
        if not carrito:
            return redirect("/carrito/ver/")
        
        with connection.cursor() as cur:
            # Calcular total
            monto_total = sum(item["cantidad"] * item["precio"] for item in carrito)
            
            # Crear venta
            cur.execute("""
                INSERT INTO gestion_perfumance.venta (fecha_venta, monto_total, id_cliente)
                VALUES (%s, %s, %s) RETURNING id_venta
            """, [datetime.now(), monto_total, usuario_id])
            id_venta = cur.fetchone()[0]
            
            # Crear pago
            cur.execute("""
                INSERT INTO gestion_perfumance.pago 
                (id_cliente, total, estado, metododepago)
                VALUES (%s, %s, %s, %s) RETURNING id_pago
            """, [usuario_id, monto_total, "Completado", "Mercado Pago"])
            id_pago = cur.fetchone()[0]
            
            # Crear detalles y restar stock
            for item in carrito:
                cur.execute("""
                    INSERT INTO gestion_perfumance.detalle_pago
                    (id_pago, id_venta, id_cliente, id_perfume, cantidad, costo_unitario)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, [
                    id_pago, id_venta, usuario_id,
                    item["id_perfume"], item["cantidad"], item["precio"]
                ])
                
                cur.execute("""
                    UPDATE gestion_perfumance.perfume
                    SET stock = stock - %s
                    WHERE id_perfume = %s
                """, [item["cantidad"], item["id_perfume"]])
        
        # Limpiar carrito
        request.session["carrito"] = []
        request.session.modified = True
        
        return render(request, "carrito/pago_exito.html", {
            "id_venta": id_venta,
            "id_pago": id_pago,
            "total": monto_total
        })
    
    except Exception as e:
        return render(request, "carrito/pago_error.html", {"error": str(e)})

@csrf_exempt
def mercado_pago_failure(request):
    """Callback de Mercado Pago cuando el pago falla"""
    return render(request, "carrito/pago_error.html", {
        "error": "El pago fue rechazado. Intenta nuevamente."
    })

@csrf_exempt
def mercado_pago_pending(request):
    """Callback de Mercado Pago cuando el pago está pendiente"""
    return render(request, "carrito/pago_pendiente.html", {
        "mensaje": "Tu pago está siendo procesado. Te notificaremos cuando esté confirmado."
    })

