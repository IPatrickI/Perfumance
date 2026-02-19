# 🚂 Despliegue en Railway desde Terminal

## 📦 Instalación de Railway CLI

### En Linux/macOS:
```bash
# Usando npm (recomendado)
npm i -g @railway/cli

# O usando Homebrew (macOS/Linux)
brew install railway
```

### En Windows:
```bash
# Usando npm
npm i -g @railway/cli

# O usando Scoop
scoop install railway
```

## 🔐 Autenticación

```bash
# Iniciar sesión en Railway
railway login
```

Esto abrirá tu navegador para autenticarte con tu cuenta de Railway.

## 🚀 Pasos para Desplegar

### 1. Inicializar el proyecto

```bash
cd /home/josevazquez/Escritorio/PERFUMANCE

# Vincular con Railway (crear nuevo proyecto)
railway init
```

Selecciona:
- **"Create a new project"**
- Nombre del proyecto: `PERFUMANCE` (o el que prefieras)

### 2. Agregar PostgreSQL

```bash
# Agregar servicio de PostgreSQL
railway add --database postgresql
```

Esto creará automáticamente una base de datos PostgreSQL y configurará la variable `DATABASE_URL`.

### 3. Configurar Variables de Entorno

```bash
# Generar SECRET_KEY
python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"

# Configurar variables (reemplaza con tus valores)
railway variables set SECRET_KEY="tu-secret-key-generada"
railway variables set DEBUG="False"
railway variables set ALLOWED_HOSTS=".railway.app"

# Mercado Pago
railway variables set MERCADO_PAGO_ACCESS_TOKEN="tu-access-token"
railway variables set MERCADO_PAGO_PUBLIC_KEY="tu-public-key"
```

### 4. Desplegar

```bash
# Desplegar el proyecto
railway up
```

Railway detectará automáticamente tu proyecto Django y:
- Instalará dependencias desde `requirements.txt`
- Ejecutará `collectstatic`
- Ejecutará migraciones
- Iniciará el servidor con gunicorn

### 5. Obtener la URL del proyecto

```bash
# Ver la URL de tu proyecto
railway domain
```

### 6. Actualizar BASE_URL

```bash
# Una vez que tengas tu dominio (ej: perfumance-production.up.railway.app)
railway variables set BASE_URL="https://perfumance-production.up.railway.app"
railway variables set CSRF_TRUSTED_ORIGINS="https://perfumance-production.up.railway.app"
```

### 7. Crear Superusuario

```bash
# Ejecutar comandos en el contenedor de Railway
railway run python manage.py createsuperuser
```

## 📋 Comandos Útiles

### Ver logs en tiempo real
```bash
railway logs
```

### Ver estado del proyecto
```bash
railway status
```

### Ver variables de entorno
```bash
railway variables
```

### Ejecutar comandos remotos
```bash
# Ejecutar migraciones
railway run python manage.py migrate

# Crear superusuario
railway run python manage.py createsuperuser

# Collectstatic
railway run python manage.py collectstatic --noinput

# Shell de Django
railway run python manage.py shell
```

### Ver información del proyecto
```bash
railway list
```

### Abrir el proyecto en el navegador
```bash
railway open
```

### Abrir dashboard de Railway
```bash
railway dashboard
```

## 🔄 Redesplegar después de cambios

Cada vez que hagas cambios:

```bash
# Hacer commit de los cambios
git add .
git commit -m "Descripción de cambios"
git push origin main

# Redesplegar
railway up
```

O puedes configurar despliegue automático desde GitHub (recomendado).

## 🔗 Conectar con GitHub para Auto-Deploy

```bash
# Vincular con repositorio de GitHub
railway link
```

Luego en el dashboard de Railway:
1. Ve a **Settings** → **Deploy**
2. Conecta tu repositorio de GitHub
3. Activa **Deploy on push**

Ahora cada `git push` desplegará automáticamente.

## 🛠️ Script de Despliegue Completo

Puedes crear un script `deploy.sh`:

```bash
#!/bin/bash

echo "🚂 Desplegando PERFUMANCE en Railway..."

# Generar SECRET_KEY si no existe
if [ -z "$SECRET_KEY" ]; then
    echo "📝 Generando SECRET_KEY..."
    SECRET_KEY=$(python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
    railway variables set SECRET_KEY="$SECRET_KEY"
fi

# Configurar variables básicas
echo "⚙️  Configurando variables de entorno..."
railway variables set DEBUG="False"
railway variables set ALLOWED_HOSTS=".railway.app"

# Desplegar
echo "🚀 Desplegando aplicación..."
railway up

# Obtener dominio
echo "🌐 Obteniendo dominio..."
DOMAIN=$(railway domain | grep -oP 'https://[^\s]+')

if [ -n "$DOMAIN" ]; then
    echo "📝 Actualizando BASE_URL y CSRF_TRUSTED_ORIGINS..."
    railway variables set BASE_URL="$DOMAIN"
    railway variables set CSRF_TRUSTED_ORIGINS="$DOMAIN"
fi

echo "✅ Despliegue completado!"
echo "🌐 Tu aplicación está disponible en: $DOMAIN"
echo ""
echo "📋 Próximos pasos:"
echo "1. Crear superusuario: railway run python manage.py createsuperuser"
echo "2. Configurar Mercado Pago si aún no lo has hecho"
echo "3. Ver logs: railway logs"
```

Hazlo ejecutable:
```bash
chmod +x deploy.sh
./deploy.sh
```

## ⚠️ Solución de Problemas

### Error: "Railway CLI not found"
```bash
# Verificar instalación
railway --version

# Si no está instalado
npm i -g @railway/cli
```

### Error: "Not logged in"
```bash
railway login
```

### Error: "No project linked"
```bash
railway link
# O crear nuevo proyecto
railway init
```

### Ver logs de errores
```bash
railway logs --tail 100
```

## 📊 Monitoreo

```bash
# Ver uso de recursos
railway status

# Ver métricas
railway open
# Ve a la pestaña "Metrics"
```

## 💡 Ventajas de usar Railway CLI

1. **Control total** desde la terminal
2. **Despliegue más rápido** que desde el navegador
3. **Automatización** con scripts
4. **Debugging** más fácil con logs en tiempo real
5. **Ejecución remota** de comandos Django

## 🎯 Resumen de Comandos

```bash
# Setup inicial
railway login
railway init
railway add --database postgresql

# Configuración
railway variables set KEY="VALUE"

# Despliegue
railway up

# Gestión
railway logs
railway status
railway run python manage.py <comando>
railway domain
railway open
```

---

¿Prefieres que te ayude a ejecutar estos comandos paso a paso ahora mismo?
