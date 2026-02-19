from django.shortcuts import render, redirect
from django.db import connection
from django.contrib import messages
from django.views.decorators.csrf import csrf_exempt
from django.core.mail import send_mail
from django.conf import settings
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError, InvalidHash
import secrets
import string

# Instancia para verificar contraseñas
ph = PasswordHasher()

# ============================================================
# 🔷 LOGIN
# ============================================================
@csrf_exempt
def login_view(request):
    if request.method == "GET":
        return render(request, "usuarios/login.html")

    username = request.POST.get("username")
    password = request.POST.get("password")

    try:
        with connection.cursor() as cur:
            cur.execute("""
                SELECT id_usuario, username, password, id_rol
                FROM gestion_perfumance.usuario
                WHERE username = %s
            """, [username])

            user = cur.fetchone()

        if not user:
            messages.error(request, "Usuario no encontrado.")
            return redirect("login")

        # Verificar contraseña con Argon2
        try:
            ph.verify(user[2], password)
        except (VerifyMismatchError, InvalidHash):
            messages.error(request, "Contraseña incorrecta.")
            return redirect("login")

        # Guardar sesión
        request.session["usuario"] = {
            "id_usuario": user[0],
            "username": user[1],
            "rol":     user[3]
        }
        request.session.set_expiry(1209600)  # 14 días
        request.session.modified = True  # Forzar guardado de sesión
        request.session.save()  # Guardar explícitamente en BD
        
        # Commit en BD para asegurar persistencia en Railway
        connection.commit()

        messages.success(request, f"Bienvenido {user[1]}")

        # Redirección según rol
        if user[3] == 1:  # Admin
            return redirect("/adminpanel/")
        else:
            return redirect("/catalogo/")

    except Exception as e:
        messages.error(request, f"Error en login: {e}")
        return redirect("login")

# ============================================================
# 🔷 LOGOUT
# ============================================================
def logout_view(request):
    request.session.flush()
    return redirect("login")

# ============================================================
# 🔷 PERFIL DE USUARIO
# ============================================================
def perfil_view(request):
    """Ver perfil del usuario actual"""
    usuario = request.session.get("usuario")
    
    if not usuario:
        return redirect("/login/")
    
    usuario_data = {}
    cliente_data = {}
    direcciones = []
    
    try:
        with connection.cursor() as cur:
            # Obtener datos del usuario
            cur.execute("""
                SELECT id_usuario, username, id_cliente
                FROM gestion_perfumance.usuario
                WHERE id_usuario = %s
            """, [usuario["id_usuario"]])
            
            row = cur.fetchone()
            if row:
                usuario_data = {
                    "id_usuario": row[0],
                    "username": row[1],
                    "id_cliente": row[2]
                }
                
                # Si tiene id_cliente, obtener datos de cliente
                if row[2]:
                    cur.execute("""
                        SELECT nombres, apellidos, email, telefono
                        FROM gestion_perfumance.cliente
                        WHERE id_cliente = %s
                    """, [row[2]])
                    
                    cliente_row = cur.fetchone()
                    if cliente_row:
                        cliente_data = {
                            "nombres": cliente_row[0],
                            "apellidos": cliente_row[1],
                            "email": cliente_row[2],
                            "telefono": cliente_row[3]
                        }
            
            # Obtener direcciones de envío
            try:
                cur.execute("""
                    SELECT id_direccion, nombre, calle, numero, departamento, ciudad, estado, codigo_postal, telefono
                    FROM gestion_perfumance.direccion
                    WHERE id_usuario = %s
                    ORDER BY fecha_creacion DESC
                """, [usuario["id_usuario"]])
                
                rows = cur.fetchall()
                direcciones = [{
                    "id_direccion": r[0],
                    "nombre": r[1],
                    "calle": r[2],
                    "numero": r[3],
                    "departamento": r[4],
                    "ciudad": r[5],
                    "estado": r[6],
                    "codigo_postal": r[7],
                    "telefono": r[8]
                } for r in rows]
            except Exception as e:
                print(f"Error al obtener direcciones: {e}")
                direcciones = []
    
    except Exception as e:
        print(f"Error al obtener perfil: {e}")
        messages.error(request, "Error al cargar el perfil")
    
    return render(request, "usuarios/perfil.html", {
        "usuario": usuario_data,
        "cliente": cliente_data,
        "direcciones": direcciones
    })

# ============================================================
# 🔷 REGISTRO DE USUARIOS
# ============================================================
@csrf_exempt
def registro_view(request):
    if request.method == "GET":
        return render(request, "usuarios/registro.html")

    # Obtener datos del formulario
    nombres = request.POST.get("nombres", "").strip()
    apellidos = request.POST.get("apellidos", "").strip()
    telefono = request.POST.get("telefono", "").strip()
    email = request.POST.get("email", "").strip()
    username = request.POST.get("username", "").strip()
    password = request.POST.get("password", "").strip()
    password_confirm = request.POST.get("password_confirm", "").strip()

    # Validaciones
    if not all([nombres, apellidos, telefono, email, username, password, password_confirm]):
        messages.error(request, "Por favor completa todos los campos.")
        return redirect("registro")

    if len(password) < 6:
        messages.error(request, "La contraseña debe tener al menos 6 caracteres.")
        return redirect("registro")

    if password != password_confirm:
        messages.error(request, "Las contraseñas no coinciden.")
        return redirect("registro")

    if len(username) < 3:
        messages.error(request, "El nombre de usuario debe tener al menos 3 caracteres.")
        return redirect("registro")

    if "@" not in email:
        messages.error(request, "Por favor ingresa un correo electrónico válido.")
        return redirect("registro")

    try:
        with connection.cursor() as cur:
            # Verificar si existe el usuario o email
            cur.execute("""
                SELECT id_usuario 
                FROM gestion_perfumance.usuario 
                WHERE username = %s OR email = %s
            """, [username, email])

            if cur.fetchone():
                messages.error(request, "Este usuario o correo ya está registrado.")
                return redirect("registro")

            # 1. Crear cliente primero
            cur.execute("""
                INSERT INTO gestion_perfumance.cliente (nombres, apellidos, telefono, email)
                VALUES (%s, %s, %s, %s)
                RETURNING id_cliente
            """, [nombres, apellidos, telefono, email])
            
            id_cliente = cur.fetchone()[0]

            # 2. Encriptar contraseña con Argon2
            hashed_password = ph.hash(password)

            # 3. Insertar usuario vinculado al cliente
            cur.execute("""
                INSERT INTO gestion_perfumance.usuario (username, email, password, id_rol, id_cliente)
                VALUES (%s, %s, %s, %s, %s)
            """, [username, email, hashed_password, 2, id_cliente])  # Rol 2 = cliente
            
        connection.commit()

        # Intentar enviar email de bienvenida
        try:
            send_mail(
                subject='Bienvenido a DG Perfumance',
                message=f'Hola {nombres} {apellidos},\n\nTu cuenta ha sido creada exitosamente.\n\nUsername: {username}\nEmail: {email}\n\nYa puedes iniciar sesión en nuestra plataforma.',
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[email],
                fail_silently=True
            )
        except Exception as e:
            print(f"Error al enviar email: {e}")

        messages.success(request, "Cuenta creada correctamente. ¡Bienvenido! Ahora inicia sesión.")
        return redirect("login")

    except Exception as e:
        messages.error(request, f"Error al registrar: {str(e)}")
        return redirect("registro")

# ============================================================
# 🔷 RECUPERAR CONTRASEÑA (BÁSICO)
# ============================================================
@csrf_exempt
def recuperar_view(request):
    if request.method == "POST":
        email = request.POST.get("email", "").strip()

        if not email:
            messages.error(request, "Debes ingresar un correo electrónico.")
            return redirect("recuperar")

        if "@" not in email:
            messages.error(request, "Por favor ingresa un correo válido.")
            return redirect("recuperar")

        try:
            with connection.cursor() as cur:
                cur.execute("""
                    SELECT id_usuario, username, email 
                    FROM gestion_perfumance.usuario
                    WHERE email = %s
                """, [email])

                user = cur.fetchone()

            if not user:
                # Por seguridad, no revelar si el email existe o no
                messages.success(
                    request,
                    "Si el correo electrónico está registrado, recibirás instrucciones para recuperar tu contraseña."
                )
                return redirect("login")

            user_id, username, user_email = user

            # Generar un token temporal (6 dígitos aleatorios para simplificar)
            reset_token = ''.join(secrets.choice(string.digits) for _ in range(6))

            # En producción, deberías guardar este token en una tabla temporal con expiración
            # Por ahora, solo lo mostraremos en el email (muy básico)

            # Enviar email con instrucciones de recuperación
            try:
                email_body = f"""
Hola {username},

Recibimos una solicitud para recuperar tu contraseña en DG Perfumance.

Para restablecer tu contraseña, sigue estos pasos:
1. Ve a la página de recuperación de contraseña
2. Ingresa tu nombre de usuario: {username}
3. Verifica tu identidad con el código: {reset_token}

Si no solicitaste esto, ignora este mensaje.

Por seguridad, este código expira en 1 hora.

Saludos,
Equipo DG Perfumance
                """

                send_mail(
                    subject='Instrucciones de Recuperación de Contraseña - DG Perfumance',
                    message=email_body,
                    from_email=settings.DEFAULT_FROM_EMAIL,
                    recipient_list=[user_email],
                    fail_silently=False
                )

                messages.success(
                    request,
                    f"Se enviaron instrucciones de recuperación al correo {user_email}. Revisa tu bandeja de entrada."
                )
            except Exception as email_error:
                # Si hay error al enviar email, mostrar un mensaje genérico
                print(f"Error al enviar email de recuperación: {email_error}")
                messages.success(
                    request,
                    "Si el correo electrónico está registrado, recibirás instrucciones."
                )

            return redirect("login")

        except Exception as e:
            messages.error(request, f"Error en el servidor: {str(e)}")
            return redirect("recuperar")

    # GET
    return render(request, "usuarios/recuperar.html")


# ============================================================
# 🔷 ACTUALIZAR PERFIL
# ============================================================
@csrf_exempt
def actualizar_perfil_view(request):
    """Actualizar información del perfil del usuario"""
    usuario = request.session.get("usuario")
    
    if not usuario:
        return redirect("/login/")
    
    if request.method == "POST":
        email = request.POST.get("email", "").strip()
        telefono = request.POST.get("telefono", "").strip()
        
        # Validar email si se proporciona
        if email and "@" not in email:
            messages.error(request, "Por favor ingresa un email válido.")
            return redirect("/usuarios/perfil/")
        
        try:
            with connection.cursor() as cur:
                # Obtener id_cliente del usuario
                cur.execute("""
                    SELECT id_cliente FROM gestion_perfumance.usuario
                    WHERE id_usuario = %s
                """, [usuario["id_usuario"]])
                
                result = cur.fetchone()
                id_cliente = result[0] if result else None
                
                # Actualizar datos del cliente
                if id_cliente:
                    cur.execute("""
                        UPDATE gestion_perfumance.cliente
                        SET email = %s, telefono = %s
                        WHERE id_cliente = %s
                    """, [email if email else None, telefono if telefono else None, id_cliente])
                
                connection.commit()
                messages.success(request, "✓ Perfil actualizado correctamente.")
        except Exception as e:
            messages.error(request, f"Error al actualizar perfil: {str(e)}")
        
        return redirect("/usuarios/perfil/")
    
    return redirect("/usuarios/perfil/")


# ============================================================
# 🔷 AGREGAR DIRECCIÓN
# ============================================================
@csrf_exempt
def agregar_direccion_view(request):
    """Agregar una nueva dirección de envío"""
    usuario = request.session.get("usuario")
    
    if not usuario:
        return redirect("/login/")
    
    if request.method == "POST":
        nombre = request.POST.get("nombre", "").strip()
        calle = request.POST.get("calle", "").strip()
        numero = request.POST.get("numero", "").strip()
        departamento = request.POST.get("departamento", "").strip()
        ciudad = request.POST.get("ciudad", "").strip()
        estado = request.POST.get("estado", "").strip()
        codigo_postal = request.POST.get("codigo_postal", "").strip()
        telefono = request.POST.get("telefono", "").strip()
        
        if not all([nombre, calle, numero, ciudad, estado, codigo_postal]):
            messages.error(request, "Por favor completa todos los campos requeridos.")
            return redirect("/usuarios/perfil/")
        
        try:
            with connection.cursor() as cur:
                cur.execute("""
                    INSERT INTO gestion_perfumance.direccion 
                    (id_usuario, nombre, calle, numero, departamento, ciudad, estado, codigo_postal, telefono)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, [usuario["id_usuario"], nombre, calle, numero, departamento if departamento else None, ciudad, estado, codigo_postal, telefono if telefono else None])
            
            connection.commit()
            messages.success(request, f"✓ Dirección '{nombre}' agregada correctamente.")
        except Exception as e:
            messages.error(request, f"Error al agregar dirección: {str(e)}")
        
        return redirect("/usuarios/perfil/")
    
    return redirect("/usuarios/perfil/")


# ============================================================
# 🔷 ELIMINAR DIRECCIÓN
# ============================================================
@csrf_exempt
def eliminar_direccion_view(request):
    """Eliminar una dirección de envío"""
    usuario = request.session.get("usuario")
    
    if not usuario:
        return redirect("/login/")
    
    if request.method == "POST":
        id_direccion = request.POST.get("id_direccion")
        
        if not id_direccion:
            messages.error(request, "ID de dirección inválido.")
            return redirect("/usuarios/perfil/")
        
        try:
            with connection.cursor() as cur:
                # Verificar que la dirección pertenece al usuario
                cur.execute("""
                    SELECT id_direccion FROM gestion_perfumance.direccion
                    WHERE id_direccion = %s AND id_usuario = %s
                """, [id_direccion, usuario["id_usuario"]])
                
                if not cur.fetchone():
                    messages.error(request, "No tienes permiso para eliminar esta dirección.")
                    return redirect("/usuarios/perfil/")
                
                # Eliminar dirección
                cur.execute("""
                    DELETE FROM gestion_perfumance.direccion
                    WHERE id_direccion = %s AND id_usuario = %s
                """, [id_direccion, usuario["id_usuario"]])
            
            connection.commit()
            messages.success(request, "✓ Dirección eliminada correctamente.")
        except Exception as e:
            messages.error(request, f"Error al eliminar dirección: {str(e)}")
        
        return redirect("/usuarios/perfil/")
    
    return redirect("/usuarios/perfil/")
