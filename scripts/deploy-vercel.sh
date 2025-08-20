#!/bin/bash

# Script de deployment para Vercel
# Ejecuta verificaciones y preparaciones antes del deploy

set -e  # Exit on any error

echo "🚀 Preparando deploy para Vercel..."

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ Error: No se encontró package.json. Ejecuta este script desde la raíz del proyecto."
    exit 1
fi

# Verificar que existe vercel.json
if [ ! -f "vercel.json" ]; then
    echo "❌ Error: No se encontró vercel.json. Asegúrate de que el archivo existe."
    exit 1
fi

# Verificar variables de entorno críticas
echo "🔍 Verificando configuración..."

if [ -f ".env.local" ]; then
    echo "✅ Archivo .env.local encontrado"
else
    echo "⚠️  Advertencia: No se encontró .env.local. Asegúrate de configurar las variables en Vercel."
fi

# Limpiar cache y dependencias
echo "🧹 Limpiando cache..."
rm -rf .next
rm -rf node_modules/.cache

# Instalar dependencias
echo "📦 Instalando dependencias..."
pnpm install

# Ejecutar linting
echo "🔍 Ejecutando linting..."
pnpm run lint

# Generar tipos de Payload
echo "🏗️  Generando tipos de Payload..."
pnpm run generate:types

# Build local para verificar
echo "🔨 Ejecutando build local..."
pnpm run build

echo "✅ Preparación completada!"
echo ""
echo "📋 Checklist antes del deploy:"
echo "   □ Variables de entorno configuradas en Vercel"
echo "   □ Base de datos PostgreSQL configurada"
echo "   □ PAYLOAD_SECRET configurado (mín. 32 caracteres)"
echo "   □ NEXT_PUBLIC_SERVER_URL configurado"
echo "   □ Repositorio pusheado a GitHub/GitLab"
echo ""
echo "🚀 Listo para deploy en Vercel!"
echo "   Haz push de los cambios y Vercel automáticamente hará el deploy."
echo "   O ejecuta: vercel --prod (si tienes Vercel CLI instalado)"