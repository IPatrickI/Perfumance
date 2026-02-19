# Instrucciones para conectar PostgreSQL a PERFUMANCE en Railway

## Paso 1: Ir al Dashboard de Railway
Abre: https://railway.app/dashboard

## Paso 2: Seleccionar el proyecto "perfumance"

## Paso 3: En el servicio PERFUMANCE
1. Haz click en el servicio PERFUMANCE
2. Selecciona la pestaña "Variables"
3. Haz click en "New Variable"

## Paso 4: Agregar referencia a PostgreSQL
1. En el campo "Variable Name": DATABASE_URL
2. En el campo "Value":  
   - Abre el servicio "Postgres" en otra pestaña
   - Copia la URL DATABASE_URL de Postgres
   - Pega en el campo Value
   - O usa: `postgresql://postgres:password@postgres.railway.internal:5432/railway`

## Paso 5: Deploy
Commit a GitHub y Railway se redesplegará automáticamente

## Alternativa CLI:
Puedes obtener la DATABASE_URL del servicio Postgres y configurarla:
```bash
railway service Postgres
railway variables  # copiar DATABASE_URL
railway service PERFUMANCE
railway variables --set DATABASE_URL="<URL_COPIADA>"
```
