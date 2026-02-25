#!/bin/bash
#
# Script de Verificación del Entorno
# Verifica la infraestructura disponible para Versatile Hub
#

set -e

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "======================================================"
echo "  🔍 Verificación de Entorno - Versatile Hub"
echo "======================================================"
echo ""

# Función para checks
check_ok() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 1. Verificar Docker
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐳 Docker"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v docker &> /dev/null; then
    check_ok "Docker instalado: $(docker --version)"
    if docker compose version &> /dev/null; then
        check_ok "Docker Compose: $(docker compose version | head -1)"
    else
        check_fail "Docker Compose no disponible"
    fi
else
    check_fail "Docker no instalado"
fi
echo ""

# 2. Verificar Red 'web'
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Red Docker"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if docker network inspect web &> /dev/null; then
    check_ok "Red 'web' existe"
    NETWORK_TYPE=$(docker network inspect web -f '{{.Driver}}')
    check_info "Tipo: $NETWORK_TYPE"
else
    check_fail "Red 'web' no existe. Crear con: docker network create web"
fi
echo ""

# 3. Verificar Infraestructura de Production
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏗️  Infraestructura de Production"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar si existe el directorio de Production
if [ -d "/opt/ats/Production" ] || [ -d "/opt/ATS/Production" ]; then
    check_ok "Directorio Production encontrado"
    
    # Verificar Traefik
    if docker ps | grep -q traefik; then
        check_ok "Traefik corriendo"
        TRAEFIK_VERSION=$(docker inspect traefik -f '{{.Config.Image}}' 2>/dev/null || echo "desconocida")
        check_info "Versión: $TRAEFIK_VERSION"
    else
        check_warning "Traefik no está corriendo"
    fi
    
    # Verificar Portainer
    if docker ps | grep -q portainer; then
        check_ok "Portainer corriendo"
    else
        check_warning "Portainer no está corriendo"
    fi
    
    # Verificar Watchtower
    if docker ps | grep -q watchtower; then
        check_ok "Watchtower corriendo (auto-updates activo)"
    else
        check_warning "Watchtower no está corriendo"
    fi
    
else
    check_warning "Directorio Production no encontrado"
    check_info "Se usará configuración standalone de Versatile Hub"
fi
echo ""

# 4. Verificar Servicios en Production
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Servicios en Production"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

services=(
    "versatile-flow:flow.versatilehub.app"
    "versatile-crm:crm.versatilehub.app"
    "versatile-healthcare:healthcare.versatilehub.app"
)

for service_info in "${services[@]}"; do
    IFS=':' read -r container domain <<< "$service_info"
    if docker ps | grep -q "$container"; then
        check_ok "$container → $domain"
    else
        check_info "$container (no corriendo)"
    fi
done
echo ""

# 5. Recursos del Sistema
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💻 Recursos del Sistema"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# CPU
CPU_CORES=$(nproc)
if [ "$CPU_CORES" -ge 4 ]; then
    check_ok "CPU: $CPU_CORES cores"
else
    check_warning "CPU: $CPU_CORES cores (recomendado: 4+)"
fi

# RAM
TOTAL_RAM=$(free -h | awk '/^Mem:/ {print $2}')
AVAILABLE_RAM=$(free -h | awk '/^Mem:/ {print $7}')
check_info "RAM Total: $TOTAL_RAM"
check_info "RAM Disponible: $AVAILABLE_RAM"

# Disco
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_AVAIL=$(df -h / | awk 'NR==2 {print $4}')
DISK_USED=$(df -h / | awk 'NR==2 {print $5}')
check_info "Disco: $DISK_AVAIL disponible de $DISK_TOTAL (usado: $DISK_USED)"

echo ""

# 6. Verificar Versatile Hub
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 Versatile Hub"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar si estamos en el directorio correcto
if [ -f "docker-compose.yml" ] && [ -f "deploy.sh" ]; then
    check_ok "Directorio correcto: $(pwd)"
    
    # Verificar .env
    if [ -f ".env" ]; then
        check_ok "Archivo .env configurado"
    else
        check_warning "Archivo .env no existe. Copiar desde .env.example"
    fi
    
    # Verificar servicios de Versatile Hub
    if docker compose ps | grep -q versatilehub; then
        check_ok "Servicios de Versatile Hub corriendo"
        echo ""
        docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    else
        check_info "Versatile Hub no está desplegado aún"
    fi
else
    check_warning "No estás en el directorio de Versatile Hub"
    check_info "Navega a: cd /opt/ATS/VersatileHub"
fi

echo ""

# 7. Resumen y Recomendaciones
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Resumen"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Contar checks
TOTAL_CONTAINERS=$(docker ps -q | wc -l)
check_info "Total contenedores corriendo: $TOTAL_CONTAINERS"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Próximos Pasos"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f ".env" ]; then
    if docker compose ps | grep -q versatilehub; then
        echo "🎉 ¡Versatile Hub está corriendo!"
        echo ""
        echo "Comandos útiles:"
        echo "  docker compose ps              # Ver estado"
        echo "  docker compose logs -f         # Ver logs"
        echo "  docker compose restart         # Reiniciar"
        echo "  docker compose down            # Detener"
    else
        echo "Listo para desplegar:"
        echo "  ./deploy.sh                    # Despliegue completo"
        echo "  docker compose up -d           # Despliegue manual"
    fi
else
    echo "Configurar antes de desplegar:"
    echo "  cp .env.example .env           # Copiar template"
    echo "  nano .env                      # Editar configuración"
    echo "  ./deploy.sh                    # Desplegar"
fi

echo ""
echo "Documentación:"
echo "  cat QUICKSTART.md              # Guía rápida 15 min"
echo "  cat IMPLEMENTATION_SUMMARY.md  # Resumen técnico completo"
echo "  cat DEPLOYMENT_REMOTE.md       # Guía de despliegue detallada"
echo ""
echo "======================================================"
