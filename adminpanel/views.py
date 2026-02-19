from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.db import connection
from django.contrib import messages
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import redirect
from functools import wraps
from argon2 import PasswordHasher

def admin_required(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        usuario = request.session.get("usuario")
        if not usuario:
            return redirect("/login/")
        if usuario.get("rol") != 1:  # solo admins
            return redirect("/")       # impedir acceso
        return view_func(request, *args, **kwargs)
    return wrapper

# Hasher para contraseñas
ph = PasswordHasher()

# ================================================
# 🟦 DASHBOARD DEL ADMIN
# ================================================
@admin_required
def admin_dashboard(request):
    total_prod = 0
    total_ped = 0
    total_usr = 0
    actividades = []

    try:
        with connection.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM gestion_perfumance.perfume;")
            total_prod = cur.fetchone()[0]

            cur.execute("SELECT COUNT(*) FROM gestion_perfumance.venta;")
            total_ped = cur.fetchone()[0]

            cur.execute("SELECT COUNT(*) FROM gestion_perfumance.usuario;")
            total_usr = cur.fetchone()[0]

            cur.execute("""
                SELECT a.descripcion, a.fecha, u.username, r.descripcion AS rol
                FROM gestion_perfumance.actividad a
                JOIN gestion_perfumance.usuario u ON a.id_usuario = u.id_usuario
                JOIN gestion_perfumance.rol r ON u.id_rol = r.id_rol
                ORDER BY a.fecha DESC
                LIMIT 8;
            """)
            rows = cur.fetchall()

            actividades = [{
                "descripcion": row[0],
                "fecha": row[1],
                "username": row[2],
                "rol": row[3]
            } for row in rows]

    except Exception as e:
        print(f"Error en dashboard: {e}")

    return render(request, "adminpanel/dashboard.html", {
        "total_prod": total_prod,
        "total_ped": total_ped,
        "total_usr": total_usr,
        "actividades": actividades
    })

# ================================================
# 🟪 LISTA DE PRODUCTOS
# ================================================
@admin_required
def admin_productos(request):
    perfumes = []
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT p.id_perfume, p.marca, p.presentacion, p.talla,
                       p.stock, g.descripcion
                FROM gestion_perfumance.perfume p
                LEFT JOIN gestion_perfumance.genero g
                ON p.id_genero = g.id_genero
                ORDER BY p.id_perfume
            """)

            rows = cur.fetchall()

        perfumes = [{
            "id_perfume": row[0],
            "marca": row[1],
            "presentacion": row[2],
            "talla": row[3],
            "stock": row[4],
            "genero": row[5] or "Sin género"
        } for row in rows]

    except Exception as e:
        messages.error(request, f"Error al cargar productos: {e}")

    return render(request, "adminpanel/productos.html", {"perfumes": perfumes})

# ================================================
# 🟨 PEDIDOS DEL ADMIN
# ================================================
@admin_required
def admin_pedidos(request):
    """Mostrar lista de todos los pedidos (ventas) del sistema"""
    pedidos = []
    total_ventas = 0
    total_ganancias = 0.0
    
    try:
        with connection.cursor() as cur:
            # Obtener todas las ventas con detalles del cliente
            cur.execute("""
                SELECT v.id_venta, v.fecha_venta, v.monto_total, 
                       c.nombres, c.apellidos, c.email,
                       COUNT(DISTINCT dp.id_detalle_pago) as items_count,
                       COUNT(DISTINCT CASE WHEN p.estado = 'Completado' THEN p.id_pago END) as pagos_completados
                FROM gestion_perfumance.venta v
                LEFT JOIN gestion_perfumance.cliente c ON v.id_cliente = c.id_cliente
                LEFT JOIN gestion_perfumance.detalle_pago dp ON v.id_venta = dp.id_venta
                LEFT JOIN gestion_perfumance.pago p ON v.id_cliente = p.id_cliente
                GROUP BY v.id_venta, v.fecha_venta, v.monto_total, 
                         c.nombres, c.apellidos, c.email
                ORDER BY v.fecha_venta DESC
            """)
            rows = cur.fetchall()
            
            for row in rows:
                pedidos.append({
                    "id_venta": row[0],
                    "fecha_venta": row[1],
                    "monto_total": float(row[2]),
                    "cliente_nombre": f"{row[3]} {row[4]}" if row[3] and row[4] else "Cliente desconocido",
                    "cliente_email": row[5],
                    "items_count": row[6] if row[6] else 0,
                    "pagos_completados": row[7] if row[7] else 0
                })
                total_ganancias += float(row[2])
            
            total_ventas = len(pedidos)
    
    except Exception as e:
        messages.error(request, f"Error al cargar pedidos: {e}")
        print(f"Error en admin_pedidos: {e}")
    
    return render(request, "adminpanel/pedidos.html", {
        "pedidos": pedidos,
        "total_ventas": total_ventas,
        "total_ganancias": total_ganancias
    })


# ================================================
# 🟨 DETALLE DE PEDIDO
# ================================================
@admin_required
def admin_detalle_pedido(request, id_venta):
    """Ver detalles de un pedido específico"""
    venta = None
    detalles = []
    cliente = None
    pagos = []
    
    try:
        with connection.cursor() as cur:
            # Obtener info de la venta
            cur.execute("""
                SELECT v.id_venta, v.fecha_venta, v.monto_total, v.id_cliente
                FROM gestion_perfumance.venta
                WHERE v.id_venta = %s
            """, [id_venta])
            venta_row = cur.fetchone()
            
            if not venta_row:
                messages.error(request, "Venta no encontrada.")
                return redirect("adminpanel:pedidos")
            
            venta = {
                "id_venta": venta_row[0],
                "fecha_venta": venta_row[1],
                "monto_total": float(venta_row[2]),
                "id_cliente": venta_row[3]
            }
            
            # Obtener datos del cliente
            if venta["id_cliente"]:
                cur.execute("""
                    SELECT c.id_cliente, c.nombres, c.apellidos, c.email, c.telefono
                    FROM gestion_perfumance.cliente
                    WHERE c.id_cliente = %s
                """, [venta["id_cliente"]])
                cliente_row = cur.fetchone()
                if cliente_row:
                    cliente = {
                        "id_cliente": cliente_row[0],
                        "nombres": cliente_row[1],
                        "apellidos": cliente_row[2],
                        "email": cliente_row[3],
                        "telefono": cliente_row[4]
                    }
            
            # Obtener detalles de pago (productos comprados)
            cur.execute("""
                SELECT dp.id_detalle_pago, p.marca, dp.cantidad, dp.costo_unitario,
                       (dp.cantidad * dp.costo_unitario) as subtotal
                FROM gestion_perfumance.detalle_pago dp
                JOIN gestion_perfumance.perfume p ON dp.id_perfume = p.id_perfume
                WHERE dp.id_venta = %s
                ORDER BY dp.id_detalle_pago
            """, [id_venta])
            detalles_rows = cur.fetchall()
            
            for row in detalles_rows:
                detalles.append({
                    "id_detalle": row[0],
                    "producto": row[1],
                    "cantidad": row[2],
                    "precio_unitario": float(row[3]),
                    "subtotal": float(row[4])
                })
            
            # Obtener pagos asociados al cliente (por id_cliente)
            cur.execute("""
                SELECT id_pago, estado, metododepago, total, fecha_pago
                FROM gestion_perfumance.pago
                WHERE id_cliente = %s
                ORDER BY id_pago DESC
            """, [venta["id_cliente"]])
            pagos_rows = cur.fetchall()
            
            for row in pagos_rows:
                pagos.append({
                    "id_pago": row[0],
                    "estado": row[1],
                    "metodo": row[2],
                    "total": float(row[3]),
                    "fecha": row[4]
                })
    
    except Exception as e:
        messages.error(request, f"Error al cargar detalle: {e}")
        print(f"Error en admin_detalle_pedido: {e}")
        return redirect("adminpanel:pedidos")
    
    return render(request, "adminpanel/detalle_pedido.html", {
        "venta": venta,
        "cliente": cliente,
        "detalles": detalles,
        "pagos": pagos
    })
# 🟧 USUARIOS
# ================================================
def admin_usuarios(request):
    usuarios = []
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT u.id_usuario, u.username, u.email, r.descripcion AS rol
                FROM gestion_perfumance.usuario u
                JOIN gestion_perfumance.rol r ON u.id_rol = r.id_rol
                ORDER BY u.id_usuario;
            """)
            rows = cur.fetchall()

        usuarios = [{
            "id_usuario": row[0],
            "username": row[1],
            "email": row[2],
            "rol": row[3]
        } for row in rows]

    except Exception as e:
        messages.error(request, f"Error al cargar usuarios: {e}")

    return render(request, "adminpanel/usuarios.html", {"usuarios": usuarios})

# ================================================
# 🟧 VISTA CREAR USUARIOS (GET - Mostrar formulario)
# ================================================
@admin_required
def vista_crear_usuario(request):
    """Vista para mostrar el formulario de crear usuario"""
    return render(request, "adminpanel/crear_usuario.html", {})

# ================================================
# 🟧 CREAR USUARIOS
# ================================================
@admin_required
def crear_usuario(request):
    if request.method != "POST":
        return redirect("adminpanel:crear_usuario")

    # Datos del formulario
    nombres = request.POST.get("nombres", "").strip()
    apellidos = request.POST.get("apellidos", "").strip()
    telefono = request.POST.get("telefono", "").strip()
    username = request.POST.get("username", "").strip()
    email = request.POST.get("email", "").strip()
    password = request.POST.get("password", "").strip()
    password_confirm = request.POST.get("password_confirm", "").strip()
    id_rol = request.POST.get("id_rol")

    # Validaciones básicas
    if not all([nombres, apellidos, telefono, username, email, password, password_confirm, id_rol]):
        messages.error(request, "Por favor completa todos los campos.")
        return redirect("adminpanel:crear_usuario")

    if len(username) < 3:
        messages.error(request, "El nombre de usuario debe tener al menos 3 caracteres.")
        return redirect("adminpanel:crear_usuario")

    if "@" not in email:
        messages.error(request, "Ingresa un correo electrónico válido.")
        return redirect("adminpanel:crear_usuario")

    if len(password) < 6:
        messages.error(request, "La contraseña debe tener al menos 6 caracteres.")
        return redirect("adminpanel:crear_usuario")

    if password != password_confirm:
        messages.error(request, "Las contraseñas no coinciden.")
        return redirect("adminpanel:crear_usuario")

    if not telefono.isdigit() or len(telefono) < 7:
        messages.error(request, "El teléfono debe contener solo números (mínimo 7 dígitos).")
        return redirect("adminpanel:crear_usuario")

    try:
        with connection.cursor() as cur:
            # Validar duplicados
            cur.execute("""
                SELECT id_usuario FROM gestion_perfumance.usuario
                WHERE username = %s OR email = %s
            """, [username, email])
            if cur.fetchone():
                messages.error(request, "Este usuario o correo ya está registrado.")
                return redirect("adminpanel:crear_usuario")

            # Crear cliente
            cur.execute("""
                INSERT INTO gestion_perfumance.cliente (nombres, apellidos, telefono, email)
                VALUES (%s, %s, %s, %s)
                RETURNING id_cliente
            """, [nombres, apellidos, telefono, email])
            id_cliente = cur.fetchone()[0]

            # Hash de contraseña
            hashed_password = ph.hash(password)

            # Crear usuario ligado al cliente
            cur.execute("""
                INSERT INTO gestion_perfumance.usuario (username, email, password, id_rol, id_cliente)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING id_usuario
            """, [username, email, hashed_password, id_rol, id_cliente])
            id_usuario = cur.fetchone()[0]

        # Registrar actividad
        admin = request.session.get("usuario")
        if admin:
            descripcion = f"Creó un nuevo usuario '{username}'."
            with connection.cursor() as cur:
                cur.execute("""
                    INSERT INTO gestion_perfumance.actividad (id_usuario, descripcion)
                    VALUES (%s, %s)
                """, [admin.get("id_usuario"), descripcion])

        messages.success(request, "Usuario creado con éxito.")

    except Exception as e:
        messages.error(request, f"Error al crear usuario: {e}")

    return redirect("adminpanel:usuarios")

# ================================================
# 🟧 VISTA EDITAR USUARIOS (GET - Mostrar formulario)
# ================================================
@admin_required
def vista_editar_usuario(request, id_usuario):
    """Vista para mostrar el formulario de editar usuario"""
    usuario = None
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT id_usuario, username, email, id_rol
                FROM gestion_perfumance.usuario
                WHERE id_usuario = %s
            """, [id_usuario])
            row = cur.fetchone()
            if row:
                usuario = {
                    'id_usuario': row[0],
                    'username': row[1],
                    'email': row[2],
                    'id_rol': row[3]
                }
    except Exception as e:
        messages.error(request, f"Error al cargar usuario: {e}")
    
    if not usuario:
        return redirect('/adminpanel/usuarios/')
    
    return render(request, "adminpanel/editar_usuario.html", {"usuario": usuario})

# ================================================
# 🟧 EDITAR USUARIOS
# ================================================
def editar_usuario(request, id_usuario):

    # GET → cargar formulario con datos
    if request.method == "GET":
        try:
            with connection.cursor() as cur:
                # Datos del usuario
                cur.execute("""
                    SELECT id_usuario, username, email, id_rol
                    FROM gestion_perfumance.usuario
                    WHERE id_usuario = %s
                """, [id_usuario])
                usuario = cur.fetchone()

                # Roles para dropdown
                cur.execute("SELECT id_rol, descripcion FROM gestion_perfumance.rol ORDER BY descripcion;")
                roles = cur.fetchall()

        except Exception as e:
            messages.error(request, f"Error al cargar usuario: {e}")
            return redirect("adminpanel:usuarios")

        return render(request, "admin_editar_usuario.html", {
            "usuario": usuario,
            "roles": roles
        })

    # POST → actualizar usuario
    username = request.POST.get("username")
    email = request.POST.get("email")
    password = request.POST.get("password")
    id_rol = request.POST.get("id_rol")

    try:
        with connection.cursor() as cur:
            # Si se envió contraseña → actualizarla
            if password:
                cur.execute("""
                    UPDATE gestion_perfumance.usuario
                    SET username = %s, email = %s, password = %s, id_rol = %s
                    WHERE id_usuario = %s
                """, [username, email, password, id_rol, id_usuario])
            else:
                # Sin cambiar contraseña
                cur.execute("""
                    UPDATE gestion_perfumance.usuario
                    SET username = %s, email = %s, id_rol = %s
                    WHERE id_usuario = %s
                """, [username, email, id_rol, id_usuario])

        # Registrar actividad
        admin = request.session.get("usuario")
        if admin:
            descripcion = f"Actualizó el usuario '{username}'."
            with connection.cursor() as cur:
                cur.execute("""
                    INSERT INTO gestion_perfumance.actividad (id_usuario, descripcion)
                    VALUES (%s, %s)
                """, [admin["id_usuario"], descripcion])

        messages.success(request, "Usuario actualizado con éxito.")

    except Exception as e:
        messages.error(request, f"Error al actualizar usuario: {e}")

    return redirect("adminpanel:usuarios")

# ================================================
# 🟧 ELIMINAR USUARIOS
# ================================================
def eliminar_usuario(request, id_usuario):
    try:
        # Obtener nombre (para actividad)
        with connection.cursor() as cur:
            cur.execute("SELECT username FROM gestion_perfumance.usuario WHERE id_usuario = %s", [id_usuario])
            usuario = cur.fetchone()
            nombre = usuario[0] if usuario else "Usuario"

        with connection.cursor() as cur:
            cur.execute("DELETE FROM gestion_perfumance.usuario WHERE id_usuario = %s", [id_usuario])

        # Registrar actividad
        admin = request.session.get("usuario")
        if admin:
            descripcion = f"Eliminó el usuario '{nombre}'."
            with connection.cursor() as cur:
                cur.execute("""
                    INSERT INTO gestion_perfumance.actividad (id_usuario, descripcion)
                    VALUES (%s, %s)
                """, [admin["id_usuario"], descripcion])

        messages.success(request, "Usuario eliminado correctamente.")

    except Exception as e:
        messages.error(request, f"Error al eliminar usuario: {e}")

    return redirect("adminpanel:usuarios")

# ================================================
# 🟩 FORMULARIO PARA CREAR PERFUME
# ================================================
@admin_required
def vista_crear_perfume(request):
    generos = []
    try:
        with connection.cursor() as cur:
            cur.execute("SELECT id_genero, descripcion FROM gestion_perfumance.genero ORDER BY descripcion;")
            rows = cur.fetchall()

        generos = [{"id": row[0], "nombre": row[1]} for row in rows]

    except Exception as e:
        messages.error(request, f"Error al cargar géneros: {e}")

    return render(request, "adminpanel/crear_perfume.html", {"generos": generos})

# ================================================
# 🟩 CREAR PERFUME (POST)
# ================================================
@csrf_exempt
@admin_required
def crear_perfume(request):
    if request.method != "POST":
        return redirect("adminpanel:productos")

    marca = request.POST.get("marca")
    presentacion = request.POST.get("presentacion")
    talla = request.POST.get("talla")
    id_genero = request.POST.get("id_genero")
    stock = request.POST.get("stock")
    precio = request.POST.get("precio")
    fecha_caducidad = request.POST.get("fecha_caducidad") or None

    try:
        with connection.cursor() as cur:
            cur.execute("""
                INSERT INTO gestion_perfumance.perfume
                (marca, presentacion, talla, id_genero, stock, precio, fecha_caducidad)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, [marca, presentacion, talla, id_genero, stock, precio, fecha_caducidad])

        # registrar actividad
        usuario = request.session["usuario"]["id_usuario"]
        descripcion = f"Agregó perfume {marca}"
        with connection.cursor() as cur:
            cur.execute("""
                INSERT INTO gestion_perfumance.actividad (id_usuario, descripcion)
                VALUES (%s, %s)
            """, [usuario, descripcion])

        messages.success(request, "Perfume agregado correctamente.")

    except Exception as e:
        messages.error(request, f"Error al crear perfume: {e}")

    return redirect("adminpanel:productos")

# ================================================
# 🟩 EDITAR PERFUME (POST)
# ================================================
@csrf_exempt
@admin_required
def editar_perfume(request, id_perfume):
    if request.method != "POST":
        return redirect("adminpanel:productos")

    marca = request.POST.get("marca")
    presentacion = request.POST.get("presentacion")
    talla = request.POST.get("talla")
    id_genero = request.POST.get("id_genero")
    stock = request.POST.get("stock")
    precio = request.POST.get("precio")
    fecha_caducidad = request.POST.get("fecha_caducidad") or None

    try:
        with connection.cursor() as cur:
            cur.execute("""
                UPDATE gestion_perfumance.perfume
                SET marca=%s, presentacion=%s, talla=%s, id_genero=%s, 
                    stock=%s, precio=%s, fecha_caducidad=%s
                WHERE id_perfume=%s
            """, [marca, presentacion, talla, id_genero, stock, precio, fecha_caducidad, id_perfume])

        # actividad
        usuario = request.session["usuario"]["id_usuario"]
        descripcion = f"Editó perfume {marca}"
        with connection.cursor() as cur:
            cur.execute("""
                INSERT INTO gestion_perfumance.actividad (id_usuario, descripcion)
                VALUES (%s, %s)
            """, [usuario, descripcion])

        messages.success(request, "Perfume actualizado.")

    except Exception as e:
        messages.error(request, f"Error al editar perfume: {e}")

    return redirect("adminpanel:productos")

# ================================================
# 🟩 VISTA EDITAR PERFUME (GET)
# ================================================
@admin_required
def vista_editar_perfume(request, id_perfume):
    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT id_perfume, marca, presentacion, talla, stock, precio, id_genero, fecha_caducidad
                FROM gestion_perfumance.perfume
                WHERE id_perfume = %s
            """, [id_perfume])
            row = cur.fetchone()

            cur.execute("SELECT id_genero, descripcion FROM gestion_perfumance.genero")
            generos = cur.fetchall()

        if not row:
            messages.error(request, "Perfume no encontrado.")
            return redirect("adminpanel:productos")

        perfume = {
            "id": row[0],
            "marca": row[1],
            "presentacion": row[2],
            "talla": row[3],
            "stock": row[4],
            "precio": row[5],
            "id_genero": row[6],
            "fecha_caducidad": row[7]
        }

        generos_list = [{"id": g[0], "nombre": g[1]} for g in generos]

        return render(request, "adminpanel/editar_perfume.html", {
            "perfume": perfume,
            "generos": generos_list
        })

    except Exception as e:
        messages.error(request, f"Error al cargar perfume: {e}")
        return redirect("adminpanel:productos")

# ================================================
# 🟩 ELIMINAR PERFUME 
# ================================================
@admin_required
def eliminar_perfume(request, id_perfume):
    try:
        with connection.cursor() as cur:
            # obtener nombre antes de borrar
            cur.execute("SELECT marca FROM gestion_perfumance.perfume WHERE id_perfume = %s", [id_perfume])
            row = cur.fetchone()
            marca = row[0] if row else "Perfume"

            cur.execute("DELETE FROM gestion_perfumance.perfume WHERE id_perfume = %s", [id_perfume])

        usuario = request.session["usuario"]["id_usuario"]
        descripcion = f"Eliminó perfume {marca}"
        with connection.cursor() as cur:
            cur.execute("""
                INSERT INTO gestion_perfumance.actividad (id_usuario, descripcion)
                VALUES (%s, %s)
            """, [usuario, descripcion])

        messages.success(request, "Perfume eliminado.")

    except Exception as e:
        messages.error(request, f"Error al eliminar: {e}")

    return redirect("adminpanel:productos")
