#!/bin/bash
# =============================================================================
# INSTALL DOCKER ENGINE
# =============================================================================
# Script para instalar Docker Engine en Ubuntu/Debian
# Documentación oficial: https://docs.docker.com/engine/install/ubuntu/
#
# Uso:
#   sudo bash install-docker.sh
#
# =============================================================================

set -e

echo "=== 🐳 Instalando Docker Engine ==="
echo ""

# 1. Actualizar repositorios
echo "📦 Actualizando repositorios..."
apt-get update

# 2. Instalar dependencias
echo "📦 Instalando dependencias..."
apt-get install -y ca-certificates curl gnupg lsb-release

# 3. Agregar clave GPG de Docker
echo "🔑 Agregando clave GPG de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# 4. Agregar repositorio de Docker
echo "📦 Agregando repositorio de Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Actualizar con el nuevo repositorio
apt-get update

# 6. Instalar Docker Engine
echo "⬇️  Instalando Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 7. Verificar instalación
echo ""
echo "=== ✅ Docker instalado exitosamente ==="
echo ""
docker --version
docker compose version
echo ""
systemctl is-active docker && echo "✅ Docker service: active" || echo "❌ Docker service: inactive"

# 8. Instrucciones adicionales
echo ""
echo "=== 📋 Próximos pasos ==="
echo ""
echo "1. Crear red Docker:"
echo "   docker network create web"
echo ""
echo "2. Levantar infraestructura:"
echo "   cd /opt/ATS/VersatileHub/infrastructure"
echo "   docker compose up -d"
echo ""
echo "3. Verificar contenedores:"
echo "   docker ps"
echo ""
