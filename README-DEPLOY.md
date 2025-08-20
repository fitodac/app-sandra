# Deploy en Vercel - Sandra App

Guía paso a paso para hacer el deploy de la aplicación Sandra App en Vercel.

## Prerrequisitos

- Cuenta en [Vercel](https://vercel.com)
- Base de datos PostgreSQL (recomendado: [Supabase](https://supabase.com) o [Neon](https://neon.tech))
- Repositorio en GitHub/GitLab/Bitbucket

## Configuración de la Base de Datos

### Opción 1: Supabase (Recomendado)
1. Crea un proyecto en [Supabase](https://supabase.com)
2. Ve a Settings > Database
3. Copia la Connection String (URI format)
4. Asegúrate de que la base de datos esté configurada para aceptar conexiones externas

### Opción 2: Neon
1. Crea un proyecto en [Neon](https://neon.tech)
2. Copia la connection string desde el dashboard

## Configuración en Vercel

### 1. Importar el Proyecto
1. Ve a [Vercel Dashboard](https://vercel.com/dashboard)
2. Haz clic en "New Project"
3. Importa tu repositorio desde GitHub/GitLab/Bitbucket
4. Selecciona el framework "Next.js"

### 2. Configurar Variables de Entorno
En la sección "Environment Variables" de tu proyecto en Vercel, agrega:

```bash
# Base de datos
DATABASE_URI=postgresql://username:password@hostname:port/database_name

# Payload CMS (IMPORTANTE: Mínimo 32 caracteres)
PAYLOAD_SECRET=tu-clave-super-secreta-aqui-minimo-32-caracteres
PAYLOAD_CONFIG_PATH=src/payload.config.ts

# Next.js
NEXT_PUBLIC_SERVER_URL=https://tu-app.vercel.app
NEXTAUTH_SECRET=tu-nextauth-secret-aqui

# Node.js
NODE_OPTIONS=--no-deprecation --max-old-space-size=8000
```

### 3. Configuración de Build
Vercel debería detectar automáticamente la configuración desde `vercel.json`, pero verifica:

- **Build Command**: `pnpm run build`
- **Install Command**: `pnpm install`
- **Output Directory**: `.next` (automático)
- **Node.js Version**: 18.x o superior

## Configuración del Proyecto

### 1. Actualizar payload.config.ts
Asegúrate de que tu configuración de Payload incluya:

```typescript
import { postgresAdapter } from '@payloadcms/db-postgres'

export default buildConfig({
  // ... otras configuraciones
  db: postgresAdapter({
    pool: {
      connectionString: process.env.DATABASE_URI,
    },
  }),
  serverURL: process.env.NEXT_PUBLIC_SERVER_URL || 'http://localhost:3000',
  // ... resto de la configuración
})
```

### 2. Verificar next.config.mjs
El archivo ya está configurado correctamente con `withPayload`.

## Deploy

### 1. Primer Deploy
1. Haz push de todos los cambios a tu repositorio
2. Vercel automáticamente detectará el push y comenzará el build
3. El proceso puede tomar 5-10 minutos en el primer deploy

### 2. Verificar el Deploy
1. Ve a tu dashboard de Vercel
2. Revisa los logs de build en caso de errores
3. Accede a tu aplicación en la URL proporcionada
4. Verifica que puedas acceder a `/admin` para el panel de Payload

## Configuración Post-Deploy

### 1. Crear Usuario Admin
Si es el primer deploy, necesitarás crear un usuario administrador:
1. Ve a `https://tu-app.vercel.app/admin`
2. Completa el formulario de registro del primer usuario

### 2. Configurar Dominio Personalizado (Opcional)
1. En Vercel Dashboard > Settings > Domains
2. Agrega tu dominio personalizado
3. Actualiza `NEXT_PUBLIC_SERVER_URL` con tu nuevo dominio

## Troubleshooting

### Errores Comunes

**Build Timeout**
- Aumenta el timeout en `vercel.json` (ya configurado a 30s)
- Verifica que `NODE_OPTIONS` esté configurado correctamente

**Database Connection Error**
- Verifica que `DATABASE_URI` esté correctamente configurada
- Asegúrate de que la base de datos acepte conexiones externas
- Revisa que las credenciales sean correctas

**Payload Secret Error**
- `PAYLOAD_SECRET` debe tener mínimo 32 caracteres
- Usa un generador de secretos seguros

**Memory Issues**
- `NODE_OPTIONS=--max-old-space-size=8000` ya está configurado
- Considera optimizar las importaciones y el bundle size

### Logs y Debugging
1. Ve a Vercel Dashboard > Functions
2. Revisa los logs de las funciones serverless
3. Usa `console.log` para debugging (visible en los logs de Vercel)

## Comandos Útiles

```bash
# Desarrollo local
pnpm run dev

# Build local (para testing)
pnpm run build
pnpm run start

# Linting
pnpm run lint

# Tests
pnpm run test
```

## Recursos Adicionales

- [Documentación de Vercel](https://vercel.com/docs)
- [Documentación de Payload CMS](https://payloadcms.com/docs)
- [Next.js Deployment](https://nextjs.org/docs/deployment)
- [Supabase con Next.js](https://supabase.com/docs/guides/getting-started/quickstarts/nextjs)

---

**Nota**: Recuerda nunca commitear archivos `.env` con valores reales al repositorio. Usa siempre `.env.example` para documentar las variables necesarias.