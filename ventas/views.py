from django.http import JsonResponse
from django.shortcuts import render
from django.db import connection
from django.views.decorators.csrf import csrf_exempt

# ============================================================
# 🔷 HISTORIAL DE VENTAS DEL CLIENTE
# ============================================================
def historial_ventas(request):

    if "usuario" not in request.session:
        return JsonResponse({"error": "Necesita iniciar sesión"}, status=401)

    id_cliente = request.session["usuario"]["id_usuario"]

    try:
        with connection.cursor() as cur:

            cur.execute("""
                SELECT 
                    v.id_venta,
                    v.fecha_venta,
                    v.monto_total,
                    COALESCE(p.estado, 'SIN PAGO'),
                    COALESCE(p.metododepago, '---')
                FROM gestion_perfumance.venta v
                LEFT JOIN gestion_perfumance.pago p 
                    ON v.id_venta = p.id_venta
                WHERE v.id_cliente = %s
                ORDER BY v.fecha_venta DESC
            """, [id_cliente])

            rows = cur.fetchall()

        data = [{
            "id_venta": row[0],
            "fecha_venta": row[1].isoformat() if row[1] else None,
            "monto_total": float(row[2]),
            "estado_pago": row[3],
            "metodo_pago": row[4]
        } for row in rows]

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
# 🔷 DETALLES DE UNA VENTA
# ============================================================
def detalle_venta(request, id_venta):

    if "usuario" not in request.session:
        return JsonResponse({"error": "Debe iniciar sesión"}, status=401)

    id_cliente = request.session["usuario"]["id_usuario"]

    try:
        with connection.cursor() as cur:

            # Validar que la venta pertenece al usuario
            cur.execute("""
                SELECT id_venta 
                FROM gestion_perfumance.venta
                WHERE id_venta = %s AND id_cliente = %s
            """, [id_venta, id_cliente])

            if not cur.fetchone():
                return JsonResponse({"error": "Acceso no autorizado"}, status=403)

            # Obtener detalles de la venta
            cur.execute("""
                SELECT 
                    p.marca,
                    dv.cantidad,
                    dv.precio_unitario,
                    (dv.cantidad * dv.precio_unitario) AS subtotal
                FROM gestion_perfumance.detalle_venta dv
                JOIN gestion_perfumance.perfume p 
                    ON dv.id_perfume = p.id_perfume
                WHERE dv.id_venta = %s
            """, [id_venta])

            rows = cur.fetchall()

        detalles = [{
            "marca": row[0],
            "cantidad": row[1],
            "precio_unitario": float(row[2]),
            "subtotal": float(row[3])
        } for row in rows]

        return JsonResponse(detalles, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    #return render(request, "detalle.html", {"id_venta": id_venta})

# ============================================================
# 🔷 LISTA DE PAGOS DEL CLIENTE
# ============================================================
def ver_pagos(request):

    if "usuario" not in request.session:
        return JsonResponse({"error": "Debe iniciar sesión"}, status=401)

    id_cliente = request.session["usuario"]["id_usuario"]

    try:
        with connection.cursor() as cur:

            cur.execute("""
                SELECT 
                    id_pago,
                    fecha_pago,
                    total,
                    estado,
                    metododepago
                FROM gestion_perfumance.pago
                WHERE id_cliente = %s
                ORDER BY fecha_pago DESC
            """, [id_cliente])

            rows = cur.fetchall()

        data = [{
            "id_pago": row[0],
            "fecha_pago": row[1].isoformat() if row[1] else None,
            "total": float(row[2]),
            "estado": row[3],
            "metododepago": row[4]
        } for row in rows]

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ============================================================
# 🔷 VISTA DE PROCESO DE PAGO (FRONTEND)
# ============================================================
def pago_view(request):
    return render(request, "ventas/pago.html")
