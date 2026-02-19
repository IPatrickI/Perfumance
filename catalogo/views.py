from django.http import JsonResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import render

# ----------------------------------------------------------
# CATÁLOGO GENERAL
# ----------------------------------------------------------
def api_lista_perfumes(request):
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT p.id_perfume, p.marca, p.presentacion, p.talla,
                       p.stock, p.fecha_caducidad, p.precio, g.descripcion
                FROM gestion_perfumance.perfume p
                JOIN gestion_perfumance.genero g ON p.id_genero = g.id_genero
                ORDER BY p.id_perfume
            """)
            rows = cur.fetchall()

        data = [{
            "id": row[0],
            "marca": row[1],
            "presentacion": row[2],
            "talla": row[3],
            "stock": row[4],
            "caducidad": row[5],
            "precio": float(row[6]),
            "genero": row[7],
            "imagen_url": f"/static/img/perfume_{row[0]}.jpg"
        } for row in rows]

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ----------------------------------------------------------
# CATÁLOGO POR GÉNERO
# ----------------------------------------------------------
def api_perfumes_por_genero(request, genero):
    genero = genero.lower()

    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT p.id_perfume, p.marca, p.presentacion, p.talla,
                       p.precio, g.descripcion
                FROM gestion_perfumance.perfume p
                JOIN gestion_perfumance.genero g ON p.id_genero = g.id_genero
                WHERE LOWER(g.descripcion) = %s
                ORDER BY p.id_perfume
            """, [genero])

            rows = cur.fetchall()

        data = [{
            "id": row[0],
            "marca": row[1],
            "presentacion": row[2],
            "talla": row[3],
            "precio": float(row[4]),
            "genero": row[5],
            "imagen_url": f"/static/img/perfume_{row[0]}.jpg"
        } for row in rows]

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ----------------------------------------------------------
# BÚSQUEDA
# ----------------------------------------------------------
def api_buscar_perfume(request):
    termino = request.GET.get('q', '').strip()

    if not termino:
        return JsonResponse({"error": "Falta parámetro 'q'"}, status=400)

    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT id_perfume, marca, presentacion, talla,
                       precio, id_genero
                FROM gestion_perfumance.perfume
                WHERE marca ILIKE %s
            """, [f"%{termino}%"])

            rows = cur.fetchall()

        data = [{
            "id": row[0],
            "marca": row[1],
            "presentacion": row[2],
            "talla": row[3],
            "precio": float(row[4]),
            "imagen_url": f"/static/img/perfume_{row[0]}.jpg"
        } for row in rows]

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ----------------------------------------------------------
# OBTENER TODOS LOS PERFUMES
# ----------------------------------------------------------
def obtener_perfumes(request):
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT p.id_perfume, p.marca, p.presentacion, p.talla,
                       p.stock, p.fecha_caducidad, p.precio, g.descripcion
                FROM gestion_perfumance.perfume p
                JOIN gestion_perfumance.genero g ON p.id_genero = g.id_genero
                ORDER BY p.id_perfume
            """)
            rows = cur.fetchall()

        data = [{
            "id": r[0],
            "nombre": r[1],
            "presentacion": r[2],
            "talla": r[3],
            "stock": r[4],
            "fecha_caducidad": r[5],
            "precio": float(r[6]),
            "genero": r[7],
            "imagen_url": f"/static/img/perfume_{r[0]}.jpg"
        } for r in rows]

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ----------------------------------------------------------
# OBTENER PERFUME POR ID
# ----------------------------------------------------------
def api_perfume_por_id(request, id_perfume):
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT p.id_perfume, p.marca, p.presentacion, p.talla,
                       p.stock, p.fecha_caducidad, p.precio, g.descripcion
                FROM gestion_perfumance.perfume p
                JOIN gestion_perfumance.genero g ON p.id_genero = g.id_genero
                WHERE p.id_perfume = %s
            """, [id_perfume])

            row = cur.fetchone()

        if not row:
            return JsonResponse({"error": "Perfume no encontrado"}, status=404)

        data = {
            "id": row[0],
            "marca": row[1],
            "presentacion": row[2],
            "talla": row[3],
            "stock": row[4],
            "caducidad": row[5],
            "precio": float(row[6]),
            "genero": row[7],
            "imagen_url": f"/static/img/perfume_{row[0]}.jpg"
        }

        return JsonResponse(data)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# ----------------------------------------------------------
# CATÁLOGO GENERAL VISTA HTML
# ----------------------------------------------------------
def catalogo_page(request):
    """Mostrar catálogo general de productos con imágenes"""
    perfumes = []
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT p.id_perfume, p.marca, p.presentacion, p.talla,
                       p.stock, p.precio, g.descripcion
                FROM gestion_perfumance.perfume p
                JOIN gestion_perfumance.genero g ON p.id_genero = g.id_genero
                ORDER BY p.id_perfume
            """)
            rows = cur.fetchall()
            
            for row in rows:
                perfumes.append({
                    'id': row[0],
                    'marca': row[1],
                    'presentacion': row[2],
                    'talla': row[3],
                    'stock': row[4],
                    'precio': float(row[5]),
                    'genero': row[6],
                    'imagen': f'/static/img/perfume_{row[0]}.jpg'
                })
    except Exception as e:
        print(f"Error al cargar catálogo: {e}")
    
    return render(request, "catalogo/catalogo_general.html", {
        "perfumes": perfumes
    })

# ----------------------------------------------------------
# DETALLE DEL PRODUCTO
# ----------------------------------------------------------
def detalle_perfume(request, id_perfume):
    """Mostrar detalle completo de un perfume"""
    perfume = None
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT p.id_perfume, p.marca, p.presentacion, p.talla,
                       p.stock, p.precio, g.descripcion,
                       p.fecha_caducidad
                FROM gestion_perfumance.perfume p
                JOIN gestion_perfumance.genero g ON p.id_genero = g.id_genero
                WHERE p.id_perfume = %s
            """, [id_perfume])
            row = cur.fetchone()
            
            if row:
                perfume = {
                    'id': row[0],
                    'marca': row[1],
                    'presentacion': row[2],
                    'talla': row[3],
                    'stock': row[4],
                    'precio': float(row[5]),
                    'genero': row[6],
                    'imagen': f'/static/img/perfume_{row[0]}.jpg',
                    'caducidad': row[7]
                }
    except Exception as e:
        print(f"Error al cargar detalle: {e}")
    
    if not perfume:
        return render(request, "catalogo/error.html", {
            "mensaje": "Producto no encontrado"
        })
    
    return render(request, "catalogo/detalle_perfume.html", {
        "perfume": perfume
    })

# ----------------------------------------------------------
# CATÁLOGO POR GÉNERO VISTA HTML
# ----------------------------------------------------------
def catalogo_genero_page(request, genero):
    return render(request, "catalogo/catalogo_genero.html", {
        "genero": genero
    })
