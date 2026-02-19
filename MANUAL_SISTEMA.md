# Manual de Sistema - DG Perfumance

## 📚 Tabla de Contenidos

1. [Descripción General](#descripción-general)
2. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
3. [Tecnologías Utilizadas](#tecnologías-utilizadas)
4. [Estructura de Carpetas](#estructura-de-carpetas)
5. [Módulos y Funcionalidades](#módulos-y-funcionalidades)
6. [Base de Datos](#base-de-datos)
7. [APIs](#apis)
8. [Seguridad](#seguridad)
9. [Desarrollo e Instalación Local](#desarrollo-e-instalación-local)
10. [Despliegue en Producción](#despliegue-en-producción)
11. [Mantenimiento y Troubleshooting](#mantenimiento-y-troubleshooting)

---

## Descripción General

**DG Perfumance** es una plataforma de e-commerce especializada en la venta de perfumes online. El sistema está diseñado con arquitectura MVC y utiliza Django como framework principal.

### Objetivos del Sistema

- ✅ Facilitar la compra online de perfumes
- ✅ Gestionar inventario de productos
- ✅ Procesar pagos de forma segura
- ✅ Administrar pedidos y devoluciones
- ✅ Mantener historial de compras del cliente
- ✅ Integración con Google Maps para ubicaciones

---

## Arquitectura del Proyecto

```
Django MVC (Model-View-Controller)
    ↓
┌─────────────────────────────────────┐
│        Django Application           │
├─────────────────────────────────────┤
│ Frontend (HTML/CSS/JavaScript)      │
│ Templates + Static Files            │
├─────────────────────────────────────┤
│ Views (Business Logic)              │
│ 7 Aplicaciones Django               │
├─────────────────────────────────────┤
│ Models (ORM + Raw SQL)              │
│ PostgreSQL Database                 │
├─────────────────────────────────────┤
│ APIs (JSON Endpoints)               │
│ Carrito, Checkout, Ubicaciones      │
└─────────────────────────────────────┘
```

---

## Tecnologías Utilizadas

### Backend
- **Django 6.0** - Framework web Python
- **PostgreSQL** - Base de datos relacional
- **Python 3.8+** - Lenguaje de programación

### Frontend
- **HTML5** - Estructura
- **CSS3** - Estilos y diseño responsivo
- **JavaScript (Vanilla)** - Interactividad
- **Font Awesome 6.4** - Iconos

### APIs Externas
- **Google Maps API** - Mapas interactivos
- **Procesador de Pagos** - Transacciones seguras

### DevOps
- **Git** - Control de versiones
- **Virtual Environment** - Aislamiento de dependencias
- **pip** - Gestor de paquetes Python

---

## Estructura de Carpetas

```
DG_PERFUMANCEdj/
│
├── perfumance/                  # Configuración principal del proyecto
│   ├── settings.py              # Configuraciones de Django
│   ├── urls.py                  # Enrutamiento principal
│   ├── wsgi.py                  # Configuración WSGI
│   └── asgi.py                  # Configuración ASGI
│
├── home/                        # Módulo de inicio
│   ├── views.py                 # Vistas (home, quiénes somos)
│   └── urls.py                  # Rutas del módulo
│
├── usuarios/                    # Módulo de autenticación
│   ├── views.py                 # Login, registro, perfil
│   └── urls.py                  # Rutas de usuarios
│
├── catalogo/                    # Módulo de productos
│   ├── views.py                 # Vistas de catálogo
│   └── urls.py                  # Rutas de catálogo
│
├── carrito/                     # Módulo de compras
│   ├── views.py                 # APIs y vistas del carrito
│   └── urls.py                  # Rutas de carrito
│
├── ventas/                      # Módulo de ventas/historial
│   ├── views.py                 # Vistas de ventas
│   └── urls.py                  # Rutas de ventas
│
├── adminpanel/                  # Módulo administrativo
│   ├── views.py                 # Vista de administración
│   └── urls.py                  # Rutas admin
│
├── ubicacion/                   # Módulo de ubicaciones
│   ├── views.py                 # APIs de Google Maps
│   └── urls.py                  # Rutas de ubicaciones
│
├── templates/                   # Plantillas HTML
│   ├── base.html                # Plantilla base
│   ├── home/
│   ├── usuarios/
│   ├── carrito/
│   ├── catalogo/
│   ├── adminpanel/
│   └── ubicacion/
│
├── static/                      # Archivos estáticos
│   ├── css/                     # Hojas de estilo
│   ├── js/                      # Scripts JavaScript
│   └── img/                     # Imágenes
│
├── logs/                        # Archivos de log
│
├── manage.py                    # Utilidad de línea de comandos
├── requirements.txt             # Dependencias Python
├── .env                         # Variables de entorno
└── README.md                    # Documentación principal
```

---

## Módulos y Funcionalidades

### 1. **home** - Página Principal y Quiénes Somos

**Funcionalidades:**
- Página de inicio con productos destacados
- Sección "Quiénes Somos" con información de la empresa
- Información sobre valores y estadísticas

**Archivos principales:**
- `home/views.py` - Contiene `home_view()` y `quienes_somos_view()`
- `templates/home.html` - Página principal
- `templates/home/quienes_somos.html` - Página de información

---

### 2. **usuarios** - Autenticación y Perfil

**Funcionalidades:**
- Registro de nuevos usuarios
- Login/Logout seguro
- Perfil de usuario
- Cambio de contraseña
- Gestión de direcciones

**Flujo de autenticación:**
```
Usuario ingresa datos
    ↓
Sistema verifica en BD
    ↓
Si válido: Crea sesión Django
    ↓
Usuario accede a rutas protegidas
```

**Variables de sesión:**
```python
request.session["usuario"] = {
    "id_usuario": 1,
    "nombre": "Juan",
    "email": "juan@example.com"
}
```

---

### 3. **catalogo** - Productos

**Funcionalidades:**
- Listado de todos los productos
- Catálogo por género
- Búsqueda y filtrado
- Detalles de cada perfume
- Filtrado por precio y marca

**Consulta BD:**
```sql
SELECT * FROM gestion_perfumance.perfume
WHERE genero = %s
ORDER BY precio
```

---

### 4. **carrito** - Compras

**Funcionalidades más importantes:**

#### API Endpoints:
| Método | Ruta | Función |
|--------|------|---------|
| POST | `/api/agregar/` | Agrega producto al carrito |
| GET | `/api/ver/` | Obtiene carrito actual |
| POST | `/api/eliminar/` | Elimina producto |
| POST | `/api/actualizar/` | Actualiza cantidad |
| POST | `/api/vaciar/` | Vacía el carrito |
| POST | `/api/checkout/` | Procesa compra |

#### Almacenamiento:
- El carrito se guarda en la **sesión del usuario**
- Estructura:
```python
request.session["carrito"] = [
    {
        "id_perfume": 1,
        "marca": "Dior",
        "precio": 150.00,
        "cantidad": 2,
        "subtotal": 300.00
    }
]
```

---

### 5. **ventas** - Historial y Detalles

**Funcionalidades:**
- Historial de compras del usuario
- Detalles de cada venta
- Información de pagos
- Estado de pedidos

---

### 6. **adminpanel** - Administración

**Funcionalidades:**
- Dashboard de ventas
- Gestión de productos
- Gestión de usuarios
- Gestión de pedidos
- Reportes

---

### 7. **ubicacion** - Sucursales

**Funcionalidades:**
- Mapa interactivo con Google Maps
- Listado de sucursales
- Búsqueda de ubicaciones
- Información de contacto

**Datos de sucursales:**
```python
SUCURSALES = [
    {
        "id": 1,
        "nombre": "Centro",
        "latitud": 40.7128,
        "longitud": -74.0060,
        "horario": "9:00 AM - 9:00 PM"
    }
]
```

---

## Base de Datos

### Configuración

**Tipo:** PostgreSQL
**Host:** localhost (desarrollo)
**Base de datos:** gestion_perfumance

### Tablas Principales

#### Tabla: `perfume`
```sql
CREATE TABLE gestion_perfumance.perfume (
    id_perfume SERIAL PRIMARY KEY,
    marca VARCHAR(100),
    presentacion VARCHAR(100),
    talla VARCHAR(50),
    precio DECIMAL(10, 2),
    stock INT,
    genero VARCHAR(50),
    descripcion TEXT,
    fecha_creacion TIMESTAMP
);
```

#### Tabla: `usuario`
```sql
CREATE TABLE gestion_perfumance.usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    telefono VARCHAR(20),
    direccion TEXT,
    fecha_registro TIMESTAMP
);
```

#### Tabla: `venta`
```sql
CREATE TABLE gestion_perfumance.venta (
    id_venta SERIAL PRIMARY KEY,
    fecha_venta TIMESTAMP,
    monto_total DECIMAL(10, 2),
    id_cliente INT REFERENCES usuario(id_usuario)
);
```

#### Tabla: `pago`
```sql
CREATE TABLE gestion_perfumance.pago (
    id_pago SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES usuario(id_usuario),
    total DECIMAL(10, 2),
    estado VARCHAR(50),
    metododepago VARCHAR(50),
    fecha_pago TIMESTAMP
);
```

#### Tabla: `detalle_pago`
```sql
CREATE TABLE gestion_perfumance.detalle_pago (
    id_detalle_pago SERIAL PRIMARY KEY,
    id_pago INT REFERENCES pago(id_pago),
    id_venta INT REFERENCES venta(id_venta),
    id_cliente INT REFERENCES usuario(id_usuario),
    id_perfume INT REFERENCES perfume(id_perfume),
    cantidad INT,
    costo_unitario DECIMAL(10, 2)
);
```

### Conexión en Django

```python
# settings.py
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'gestion_perfumance',
        'USER': 'postgres',
        'PASSWORD': 'tu_contraseña',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
```

---

## APIs

### 1. API de Carrito

**Agregar producto:**
```javascript
POST /carrito/api/agregar/
Content-Type: application/json

{
  "id_perfume": 1,
  "cantidad": 2
}

Response (201):
{
  "message": "Producto agregado",
  "carrito": [...]
}
```

**Ver carrito:**
```javascript
GET /carrito/api/ver/

Response (200):
{
  "carrito": [...],
  "total": 450.00,
  "cantidad_items": 2
}
```

**Checkout:**
```javascript
POST /carrito/api/checkout/

Response (201):
{
  "message": "Compra realizada",
  "id_venta": 123,
  "id_pago": 456,
  "monto_total": 450.00
}
```

### 2. API de Ubicación

**Listar sucursales:**
```javascript
GET /ubicacion/api/ubicaciones/

Response (200):
[
  {
    "id": 1,
    "nombre": "Sucursal Centro",
    "latitud": 40.7128,
    "longitud": -74.0060,
    "telefono": "+1-234-567-8900"
  }
]
```

**Buscar ubicación:**
```javascript
GET /ubicacion/api/buscar/?q=centro

Response (200):
[
  {...ubicación que coincide...}
]
```

---

## Seguridad

### Medidas Implementadas

#### 1. **Autenticación**
- Uso de sesiones de Django
- Validación en cada vista protegida
- `if "usuario" not in request.session: return error`

#### 2. **CSRF Protection**
- Tokens CSRF en todos los formularios
- `@csrf_exempt` solo en APIs necesarias
- Validación automática de Django

#### 3. **Validación de Datos**
- Validación en frontend (JavaScript)
- Validación en backend (Python)
- Sanitización de entrada

#### 4. **Contraseñas**
- Hash seguro (use Django's `make_password()`)
- Mínimo 8 caracteres
- No se almacenan en sesión

#### 5. **HTTPS en Producción**
- Certificado SSL/TLS
- `SECURE_SSL_REDIRECT = True`
- `SESSION_COOKIE_SECURE = True`

#### 6. **Protección de APIs**
```python
@csrf_exempt
def api_ejemplo(request):
    if "usuario" not in request.session:
        return JsonResponse({"error": "No autorizado"}, status=401)
    # ... resto del código
```

---

## Desarrollo e Instalación Local

### Requisitos Previos

- Python 3.8+
- PostgreSQL 12+
- Git
- pip y virtualenv

### Pasos de Instalación

**1. Clonar el repositorio:**
```bash
git clone https://github.com/tu_usuario/DG_PERFUMANCEdj.git
cd DG_PERFUMANCEdj
```

**2. Crear entorno virtual:**
```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

**3. Instalar dependencias:**
```bash
pip install -r requirements.txt
```

**4. Configurar variables de entorno:**
```bash
# Crear archivo .env en la raíz del proyecto
touch .env
```

**Contenido de .env:**
```
DEBUG=True
SECRET_KEY=tu-clave-secreta-segura
DATABASE_NAME=gestion_perfumance
DATABASE_USER=postgres
DATABASE_PASSWORD=tu_contraseña
DATABASE_HOST=localhost
DATABASE_PORT=5432
GOOGLE_MAPS_API_KEY=tu_api_key_de_google
```

**5. Aplicar migraciones:**
```bash
python manage.py migrate
```

**6. Crear superusuario (admin):**
```bash
python manage.py createsuperuser
```

**7. Ejecutar servidor de desarrollo:**
```bash
python manage.py runserver
```

La aplicación estará en `http://localhost:8000`

### Comando Útiles

```bash
# Ver rutas disponibles
python manage.py show_urls

# Entrar a shell interactivo
python manage.py shell

# Crear un usuario
python manage.py createsuperuser

# Limpiar base de datos
python manage.py flush

# Crear copias de seguridad
python manage.py dumpdata > backup.json

# Restaurar copias de seguridad
python manage.py loaddata backup.json
```

---

## Despliegue en Producción

### Opción 1: Heroku

**Pasos:**

1. **Instalar Heroku CLI:**
```bash
# En macOS
brew tap heroku/brew && brew install heroku

# En Linux
curl https://cli-assets.heroku.com/install.sh | sh
```

2. **Crear archivo Procfile:**
```
web: gunicorn perfumance.wsgi
```

3. **Crear archivo requirements.txt:**
```bash
pip freeze > requirements.txt
```

4. **Configurar para producción:**
```python
# settings.py
DEBUG = False
ALLOWED_HOSTS = ['tu-app.herokuapp.com']
SECURE_SSL_REDIRECT = True
```

5. **Desplegar:**
```bash
heroku login
heroku create tu-app-name
git push heroku main
heroku run python manage.py migrate
```

### Opción 2: AWS (EC2 + RDS)

**Arquitectura:**
```
┌─────────────────────────────────────┐
│      AWS EC2 Instance               │
│  ├─ Django Application              │
│  ├─ Nginx (Reverse Proxy)           │
│  ├─ Gunicorn (WSGI Server)          │
│  └─ Supervisor (Process Manager)    │
├─────────────────────────────────────┤
│      AWS RDS (PostgreSQL)           │
│  └─ Base de datos                   │
├─────────────────────────────────────┤
│      AWS S3 (Almacenamiento)        │
│  └─ Archivos estáticos y media      │
└─────────────────────────────────────┘
```

**Pasos básicos:**

1. **Crear instancia EC2** (Ubuntu 20.04)
2. **Instalar dependencias:**
```bash
sudo apt update
sudo apt install python3.9 python3-pip postgresql-client nginx supervisor
```

3. **Clonar código y configurar:**
```bash
git clone tu-repo.git
cd tu-proyecto
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

4. **Configurar Gunicorn:**
```bash
gunicorn perfumance.wsgi:application --bind 0.0.0.0:8000
```

5. **Configurar Nginx** como proxy inverso

6. **Usar Supervisor** para mantener el proceso activo

### Opción 3: DigitalOcean

Similar a AWS pero más sencillo. Sigue la guía oficial:
https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu

---

## Mantenimiento y Troubleshooting

### Logs

**Ubicación:** `logs/` directorio del proyecto

**Comandos útiles:**
```bash
# Ver últimas líneas de error
tail -f logs/django.log

# Buscar errores específicos
grep "error" logs/django.log

# Limpiar logs viejos
find logs/ -name "*.log" -mtime +30 -delete
```

### Problemas Comunes

#### 1. **Error de base de datos**
```
psycopg2.OperationalError: could not connect to server
```
**Solución:**
```bash
# Verificar que PostgreSQL esté activo
sudo systemctl status postgresql

# Iniciar si está apagado
sudo systemctl start postgresql
```

#### 2. **Migraciones no aplicadas**
```bash
# Ver estado de migraciones
python manage.py showmigrations

# Aplicar migraciones faltantes
python manage.py migrate
```

#### 3. **Static files no cargan**
```bash
# Recolectar archivos estáticos
python manage.py collectstatic
```

#### 4. **Error de CSRF**
- Asegurate de incluir `{% csrf_token %}` en formularios
- Verifica que el middleware CSRF esté activo

#### 5. **Sesión expirada**
**Configuración en settings.py:**
```python
SESSION_EXPIRE_AT_BROWSER_CLOSE = True
SESSION_COOKIE_AGE = 3600  # 1 hora en segundos
```

### Copias de Seguridad

**Backup de BD:**
```bash
pg_dump gestion_perfumance > backup_$(date +%Y%m%d).sql
```

**Restaurar BD:**
```bash
psql gestion_perfumance < backup_20240101.sql
```

### Monitoreo

**Monitorizar en tiempo real:**
```bash
# Ver procesos
ps aux | grep gunicorn

# Monitor de recursos
top

# Ver espacio en disco
df -h
```

---

## Variables de Entorno Completas

```bash
# Django
DEBUG=False
SECRET_KEY=django-insecure-u7e8f9g0h1i2j3k4l5m6n7o8p9q0
ALLOWED_HOSTS=localhost,127.0.0.1,tu-dominio.com

# Base de datos
DATABASE_ENGINE=django.db.backends.postgresql
DATABASE_NAME=gestion_perfumance
DATABASE_USER=postgres
DATABASE_PASSWORD=tu_contraseña_segura
DATABASE_HOST=localhost
DATABASE_PORT=5432

# Seguridad
SECURE_SSL_REDIRECT=True
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True

# APIs Externas
GOOGLE_MAPS_API_KEY=AIzaSy...
STRIPE_API_KEY=sk_live_...
STRIPE_PUBLISHABLE_KEY=pk_live_...

# Email (para notificaciones)
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=tu_email@gmail.com
EMAIL_HOST_PASSWORD=tu_contraseña_app
```

---

