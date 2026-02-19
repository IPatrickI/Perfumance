from django.shortcuts import render
from django.db import connection

def home_view(request):
    """
    Vista principal: muestra 6 perfumes aleatorios en la página de inicio
    """
    productos = []

    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT id_perfume, marca, presentacion, talla, precio
                FROM gestion_perfumance.perfume
                ORDER BY RANDOM()
                LIMIT 6
            """)
            rows = cur.fetchall()

            productos = [{
                "id": r[0],
                "marca": r[1],
                "presentacion": r[2],
                "talla": r[3],
                "precio": r[4],
                "imagen_url": f"/static/img/perfume_{r[0]}.jpg"
            } for r in rows]

    except Exception as e:
        print("Error home:", e)

    return render(request, "home.html", {"productos": productos})


def quienes_somos_view(request):
    """
    Vista de "Quiénes Somos": información sobre la empresa
    """
    info = {
        "nombre_empresa": "DG Perfumance",
        "mision": "Llevar las mejores fragancias del mundo a nuestros clientes, ofreciendo calidad, variedad y experiencia única en cada compra.",
        "vision": "Ser la perfumería de referencia en el país, reconocida por excelencia en servicio y variedad de productos.",
        "valores": [
            {"titulo": "Calidad", "descripcion": "Seleccionamos marcas y productos premium"},
            {"titulo": "Confianza", "descripcion": "Transparencia y honestidad en cada transacción"},
            {"titulo": "Innovación", "descripcion": "Incorporamos tecnología en nuestros servicios"},
            {"titulo": "Servicio", "descripcion": "Atención personalizada y profesional"}
        ],
        "anios_experiencia": 4,
        "clientes_satisfechos": 500,
        "marcas_disponibles": 20,
        "historia": "DG Perfumance nació como una pequeña tienda física con la visión de democratizar el acceso a fragancias premium. Tras años de trabajo y dedicación, hemos expandido nuestro servicio al mundo digital, manteniendo siempre nuestro compromiso con la calidad."
    }
    
    return render(request, "home/quienes_somos.html", {"info": info})
