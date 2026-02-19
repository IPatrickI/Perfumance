# 🚂 Guía de Despliegue en Railway

Esta guía te ayudará a desplegar tu aplicación Django de Perfumance en Railway.

## 📋 Pre-requisitos

1. Cuenta en [Railway.app](https://railway.app)
2. Cuenta en [GitHub](https://github.com)
3. Repositorio de GitHub con tu código

## 🚀 Pasos para Desplegar

### 1. Preparar el Repositorio

Asegúrate de que todos los archivos estén en tu repositorio de GitHub:

```bash
git add .
git commit -m "Preparar para despliegue en Railway"
git push origin main
```

### 2. Crear Proyecto en Railway

1. Ve a [railway.app](https://railway.app) e inicia sesión
2. Click en **"New Project"**
3. Selecciona **"Deploy from GitHub repo"**
4. Autoriza Railway para acceder a tu repositorio
5. Selecciona el repositorio `PERFUMANCE`

### 3. Agregar Base de Datos PostgreSQL

1. En tu proyecto de Railway, click en **"New"**
2. Selecciona **"Database"** → **"Add PostgreSQL"**
3. Railway creará automáticamente la variable `DATABASE_URL`

### 4. Configurar Variables de Entorno

En el dashboard de Railway, ve a tu servicio web y agrega estas variables:

#### Variables Obligatorias:

```
SECRET_KEY=tu-clave-secreta-aleatoria-larga
DEBUG=False
BASE_URL=https://tu-app.railway.app
```

#### Variables de Mercado Pago:

```
MERCADO_PAGO_ACCESS_TOKEN=tu-access-token
MERCADO_PAGO_PUBLIC_KEY=tu-public-key
```

#### Variables Opcionales:

```
ALLOWED_HOSTS=.railway.app
CSRF_TRUSTED_ORIGINS=https://tu-app.railway.app
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True
```

### 5. Generar SECRET_KEY

Puedes generar una clave secreta con Python:

```python
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

### 6. Configurar Dominio

1. Una vez desplegado, Railway te dará un dominio: `tu-app.railway.app`
2. Actualiza la variable `BASE_URL` con ese dominio
3. Actualiza `CSRF_TRUSTED_ORIGINS` con el mismo dominio

### 7. Verificar el Despliegue

Railway ejecutará automáticamente:

```bash
python manage.py migrate --noinput
python manage.py collectstatic --noinput
gunicorn perfumance.wsgi --bind 0.0.0.0:$PORT
```

## 🔧 Comandos Útiles

### Ver Logs

En el dashboard de Railway, ve a la pestaña **"Deployments"** y luego **"View Logs"**

### Ejecutar Comandos

Railway permite ejecutar comandos en el contenedor:

```bash
# Crear superusuario
railway run python manage.py createsuperuser

# Ejecutar migraciones manualmente
railway run python manage.py migrate

# Colectar archivos estáticos
railway run python manage.py collectstatic
```

## 📝 Variables de Entorno Completas

```env
# Django Core
SECRET_KEY=tu-secret-key-generada
DEBUG=False
ALLOWED_HOSTS=.railway.app
BASE_URL=https://tu-app.railway.app
CSRF_TRUSTED_ORIGINS=https://tu-app.railway.app
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True

# Database (Railway la provee automáticamente)
DATABASE_URL=postgresql://...

# Mercado Pago
MERCADO_PAGO_ACCESS_TOKEN=tu-token
MERCADO_PAGO_PUBLIC_KEY=tu-key
```

## ⚠️ Problemas Comunes

### Error 500 - Internal Server Error

- Verifica que `DEBUG=False`
- Revisa los logs en Railway
- Asegúrate de que `ALLOWED_HOSTS` incluya `.railway.app`

### Archivos Estáticos No Cargan

- Verifica que `whitenoise` esté en `requirements.txt`
- Ejecuta `railway run python manage.py collectstatic`

### Error de Base de Datos

- Verifica que el servicio PostgreSQL esté corriendo
- Asegúrate de que `DATABASE_URL` esté configurada
- Ejecuta las migraciones manualmente si es necesario

### CSRF Token Error

- Agrega tu dominio de Railway a `CSRF_TRUSTED_ORIGINS`
- Verifica que `BASE_URL` apunte a tu dominio de Railway

## 🎯 Checklist de Despliegue

- [ ] Código subido a GitHub
- [ ] Proyecto creado en Railway
- [ ] PostgreSQL agregado
- [ ] Variables de entorno configuradas
- [ ] SECRET_KEY generada
- [ ] BASE_URL actualizada
- [ ] Migraciones ejecutadas
- [ ] Archivos estáticos recolectados
- [ ] Sitio accesible en el navegador

## 📱 Después del Despliegue

1. **Crear superusuario:**
   ```bash
   railway run python manage.py createsuperuser
   ```

2. **Acceder al panel de administración:**
   ```
   https://tu-app.railway.app/admin/
   ```

3. **Actualizar Mercado Pago:**
   - Ve a tu cuenta de Mercado Pago
   - Actualiza las URLs de notificación con tu dominio de Railway

## 🔄 Actualizar la Aplicación

Cada vez que hagas cambios:

```bash
git add .
git commit -m "Descripción de los cambios"
git push origin main
```

Railway detectará los cambios y redesplegará automáticamente.

## 🆘 Soporte

- [Documentación de Railway](https://docs.railway.app)
- [Comunidad de Railway](https://discord.gg/railway)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/)
