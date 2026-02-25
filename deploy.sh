#!/bin/bash
set -e

# =============================================================================
# VERSATILE HUB - Script de Despliegue
# =============================================================================
# Despliega todos los servicios de Versatile Hub
# Uso: ./deploy.sh [opciones]
# =============================================================================

# === COLORES ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# === CONFIGURACIÓN ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
COMPOSE_FILE="$PROJECT_ROOT/docker-compose.yml"
ENV_FILE="$PROJECT_ROOT/.env"
ENV_EXAMPLE="$PROJECT_ROOT/.env.example"

# === FUNCIONES ===

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

check_dependencies() {
    log_step "Verificando dependencias..."
    
    # Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado"
        exit 1
    fi
    
    # Docker Compose
    if ! docker compose version &> /dev/null; then
        log_error "Docker Compose no está instalado"
        exit 1
    fi
    
    log_info "✓ Docker y Docker Compose están instalados"
}

check_env_file() {
    log_step "Verificando archivo .env..."
    
    if [ ! -f "$ENV_FILE" ]; then
        log_error "Archivo .env no encontrado"
        log_warning "Copiando desde .env.example..."
        
        if [ -f "$ENV_EXAMPLE" ]; then
            cp "$ENV_EXAMPLE" "$ENV_FILE"
            log_warning "Archivo .env creado. DEBES EDITARLO antes de continuar!"
            log_warning "Edita: $ENV_FILE"
            exit 1
        else
            log_error ".env.example no encontrado"
            exit 1
        fi
    fi
    
    log_info "✓ Archivo .env encontrado"
}

check_network() {
    log_step "Verificando red Docker 'web'..."
    
    if ! docker network inspect web &> /dev/null; then
        log_warning "Red 'web' no existe. Creandola..."
        docker network create web
        log_info "✓ Red 'web' creada"
    else
        log_info "✓ Red 'web' ya existe"
    fi
}

create_directories() {
    log_step "Creando directorios de datos..."
    
    # Agent
    mkdir -p "$PROJECT_ROOT/services/agent/data/memory"
    mkdir -p "$PROJECT_ROOT/services/agent/data/skills"
    mkdir -p "$PROJECT_ROOT/services/agent/data/openclaw"
    mkdir -p "$PROJECT_ROOT/services/agent/config"
    
    # Chat
    mkdir -p "$PROJECT_ROOT/services/chat/data/postgres"
    mkdir -p "$PROJECT_ROOT/services/chat/data/redis"
    mkdir -p "$PROJECT_ROOT/services/chat/data/storage"
    mkdir -p "$PROJECT_ROOT/services/chat/data/public"
    mkdir -p "$PROJECT_ROOT/services/chat/scripts"
    mkdir -p "$PROJECT_ROOT/services/chat/config"
    
    # Hub
    mkdir -p "$PROJECT_ROOT/services/hub/data/mariadb"
    mkdir -p "$PROJECT_ROOT/services/hub/data/sites"
    mkdir -p "$PROJECT_ROOT/services/hub/config"
    
    # Flow
    mkdir -p "$PROJECT_ROOT/services/flow/data"
    mkdir -p "$PROJECT_ROOT/services/flow/config"
    
    log_info "✓ Directorios creados"
}

pull_images() {
    log_step "Descargando imágenes Docker..."
    
    docker compose -f "$COMPOSE_FILE" pull
    
    log_info "✓ Imágenes descargadas"
}

start_services() {
    log_step "Iniciando servicios..."
    
    docker compose -f "$COMPOSE_FILE" up -d
    
    log_info "✓ Servicios iniciados"
}

show_status() {
    log_step "Estado de los servicios:"
    echo ""
    docker compose -f "$COMPOSE_FILE" ps
    echo ""
}

show_urls() {
    log_step "URLs de acceso:"
    echo ""
    
    # Leer dominios desde .env
    source "$ENV_FILE"
    
    echo -e "${GREEN}Agent:${NC}  https://${AGENT_DOMAIN}"
    echo -e "${GREEN}Chat:${NC}   https://${CHAT_DOMAIN}"
    echo -e "${GREEN}Bridge:${NC} https://${CHAT_BRIDGE_DOMAIN}"
    echo -e "${GREEN}Hub:${NC}    https://${HUB_DOMAIN}"
    echo ""
}

show_next_steps() {
    log_step "Próximos pasos:"
    echo ""
    echo "1. Verificar que todos los servicios estén healthy:"
    echo "   docker compose ps"
    echo ""
    echo "2. Ver logs de un servicio específico:"
    echo "   docker compose logs -f [agent|chat-web|hub-frontend]"
    echo ""
    echo "3. Setup inicial de Hub (Frappe):"
    echo "   docker exec -it versatile-hub-backend \\"
    echo "     bench new-site ${HUB_DOMAIN} \\"
    echo "     --mariadb-root-password \$HUB_DB_ROOT_PASSWORD \\"
    echo "     --admin-password admin_password \\"
    echo "     --install-app erpnext"
    echo ""
    echo "4. Documentación completa:"
    echo "   cat lab/context/services-overview.md"
    echo ""
}

# === MAIN ===

main() {
    echo "=================================================="
    echo "VERSATILE HUB - Despliegue"
    echo "=================================================="
    echo ""
    
    check_dependencies
    check_env_file
    check_network
    create_directories
    pull_images
    start_services
    
    echo ""
    echo "=================================================="
    echo "DESPLIEGUE COMPLETADO"
    echo "=================================================="
    echo ""
    
    show_status
    show_urls
    show_next_steps
}

# Ejecutar
main "$@"
