#!/bin/bash
set -e

# =============================================================================
# VERSATILE HUB - Quick Install Script
# =============================================================================
# Instalación rápida de VersatileHub con toda la infraestructura
# 
# Este script:
# 1. Instala Docker y Docker Compose (si no existen)
# 2. Crea la red 'web'
# 3. Despliega Traefik + Portainer
# 4. Configura y despliega VersatileHub
#
# Uso: sudo ./quick-install.sh
# =============================================================================

# === COLORES ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# === CONFIGURACIÓN ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
INFRA_DIR="$PROJECT_ROOT/infrastructure/traefik"

# === FUNCIONES ===

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║              VERSATILE HUB - Quick Install                     ║"
    echo "║                                                                ║"
    echo "║  Suite de Servicios: Agent + Chat + Hub + Flow               ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
}

log_info() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[→]${NC} $1"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        log_error "Este script debe ejecutarse como root"
        log_warning "Ejecuta: sudo $0"
        exit 1
    fi
    log_info "Ejecutando como root"
}

check_os() {
    log_step "Verificando sistema operativo..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
        log_info "Sistema: $OS $VER"
    else
        log_warning "No se pudo determinar el sistema operativo"
    fi
}

install_docker() {
    log_step "Verificando Docker..."
    
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        log_info "Docker ya instalado: $DOCKER_VERSION"
        return 0
    fi
    
    log_warning "Docker no encontrado. Instalando..."
    
    # Instalar usando script oficial
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
    
    # Agregar usuario actual al grupo docker (si no es root)
    if [ -n "$SUDO_USER" ]; then
        usermod -aG docker "$SUDO_USER"
        log_info "Usuario $SUDO_USER agregado al grupo docker"
    fi
    
    # Iniciar Docker
    systemctl enable docker
    systemctl start docker
    
    log_info "Docker instalado correctamente"
}

check_docker_compose() {
    log_step "Verificando Docker Compose..."
    
    if docker compose version &> /dev/null; then
        COMPOSE_VERSION=$(docker compose version)
        log_info "Docker Compose disponible: $COMPOSE_VERSION"
    else
        log_error "Docker Compose no disponible"
        exit 1
    fi
}

create_network() {
    log_step "Verificando red Docker 'web'..."
    
    if docker network inspect web &> /dev/null; then
        log_info "Red 'web' ya existe"
    else
        log_warning "Creando red 'web'..."
        docker network create web
        log_info "Red 'web' creada"
    fi
}

configure_domain() {
    log_step "Configuración de dominio..."
    echo ""
    
    read -p "Dominio base (ej: versatilehub.app): " DOMAIN
    DOMAIN=${DOMAIN:-graficadosd.ar}
    
    read -p "Email para Let's Encrypt (ej: admin@$DOMAIN): " ACME_EMAIL
    ACME_EMAIL=${ACME_EMAIL:-admin@$DOMAIN}
    
    log_info "Dominio: $DOMAIN"
    log_info "Email: $ACME_EMAIL"
    echo ""
}

setup_traefik() {
    log_step "Configurando Traefik + Portainer..."
    
    cd "$INFRA_DIR"
    
    # Crear directorios
    mkdir -p data/letsencrypt
    mkdir -p data/portainer
    mkdir -p config/dynamic
    
    # Permisos para acme.json
    touch data/letsencrypt/acme.json
    chmod 600 data/letsencrypt/acme.json
    
    # Actualizar .env
    cat > .env << EOF
BASE_DOMAIN=$DOMAIN
ACME_EMAIL=$ACME_EMAIL
TZ=America/Argentina/Buenos_Aires
EOF
    
    log_info "Traefik configurado"
}

deploy_traefik() {
    log_step "Desplegando Traefik + Portainer..."
    
    cd "$INFRA_DIR"
    docker compose pull
    docker compose up -d
    
    # Esperar a que Traefik esté listo
    sleep 5
    
    if docker ps | grep -q traefik; then
        log_info "Traefik desplegado correctamente"
    else
        log_error "Error al desplegar Traefik"
        exit 1
    fi
    
    if docker ps | grep -q portainer; then
        log_info "Portainer desplegado correctamente"
    else
        log_warning "Portainer no se inició correctamente"
    fi
}

setup_versatilehub() {
    log_step "Configurando VersatileHub..."
    
    cd "$PROJECT_ROOT"
    
    # Si no existe .env, crearlo
    if [ ! -f .env ]; then
        log_warning "Generando archivo .env..."
        
        GATEWAY_TOKEN=$(openssl rand -hex 32)
        POSTGRES_PASS=$(openssl rand -base64 32)
        SECRET_KEY=$(openssl rand -hex 64)
        DB_ROOT_PASS=$(openssl rand -base64 32)
        RESTIC_PASS=$(openssl rand -base64 32)
        
        cat > .env << EOF
# === GENERAL ===
PROJECT_NAME=versatile-hub
ENVIRONMENT=production
TZ=America/Argentina/Buenos_Aires

# === TRAEFIK ===
CERT_RESOLVER=cloudflare

# === DOMINIOS ===
AGENT_DOMAIN=agent.$DOMAIN
CHAT_DOMAIN=chat.$DOMAIN
CHAT_BRIDGE_DOMAIN=chat-bridge.$DOMAIN
HUB_DOMAIN=lab.$DOMAIN

# === AGENT ===
AGENT_ANTHROPIC_API_KEY=
AGENT_OPENAI_API_KEY=
AGENT_GATEWAY_TOKEN=$GATEWAY_TOKEN
AGENT_TELEGRAM_BOT_TOKEN=
AGENT_TELEGRAM_ALLOWED_USERS=

# === CHAT ===
CHAT_POSTGRES_USER=chatwoot
CHAT_POSTGRES_PASSWORD=$POSTGRES_PASS
CHAT_POSTGRES_DB=chatwoot_production
CHAT_SECRET_KEY_BASE=$SECRET_KEY
CHAT_DEFAULT_LOCALE=es
CHAT_ACCOUNT_ID=1
CHAT_MAILER_SENDER_EMAIL=chat@$DOMAIN
CHAT_SMTP_ADDRESS=smtp.gmail.com
CHAT_SMTP_PORT=587
CHAT_SMTP_USERNAME=
CHAT_SMTP_PASSWORD=
CHAT_SMTP_AUTHENTICATION=plain
CHAT_API_ACCESS_TOKEN=

# === HUB ===
HUB_SITE_NAME=lab.$DOMAIN
HUB_DB_ROOT_PASSWORD=$DB_ROOT_PASS

# === BACKUPS ===
RESTIC_REPOSITORY=/backups/versatile-hub
RESTIC_PASSWORD=$RESTIC_PASS
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# === MONITOREO ===
ENABLE_METRICS=false
METRICS_PORT=9090
EOF
        log_info "Archivo .env generado"
    else
        log_info "Archivo .env ya existe"
    fi
}

deploy_versatilehub() {
    log_step "Desplegando VersatileHub..."
    
    cd "$PROJECT_ROOT"
    
    # Ejecutar script de deploy
    if [ -f deploy.sh ]; then
        chmod +x deploy.sh
        ./deploy.sh
    else
        log_error "deploy.sh no encontrado"
        exit 1
    fi
}

show_summary() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                  INSTALACIÓN COMPLETADA                        ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}URLs de acceso:${NC}"
    echo -e "  • Traefik Dashboard: ${BLUE}https://traefik.$DOMAIN${NC}"
    echo -e "    Usuario: admin | Password: admin (CAMBIAR!)"
    echo ""
    echo -e "  • Portainer:        ${BLUE}https://portainer.$DOMAIN${NC}"
    echo ""
    echo -e "  • Agent (OpenClaw): ${BLUE}https://agent.$DOMAIN${NC}"
    echo -e "  • Chat (Chatwoot):  ${BLUE}https://chat.$DOMAIN${NC}"
    echo -e "  • Hub (Frappe):     ${BLUE}https://lab.$DOMAIN${NC}"
    echo ""
    
    echo -e "${YELLOW}Próximos pasos:${NC}"
    echo ""
    echo "1. Configurar DNS apuntando a este servidor:"
    echo "   - traefik.$DOMAIN"
    echo "   - portainer.$DOMAIN"
    echo "   - agent.$DOMAIN"
    echo "   - chat.$DOMAIN"
    echo "   - lab.$DOMAIN"
    echo ""
    echo "2. Configurar API keys en $PROJECT_ROOT/.env:"
    echo "   - AGENT_ANTHROPIC_API_KEY o AGENT_OPENAI_API_KEY"
    echo "   - CHAT_SMTP_* para envío de emails"
    echo ""
    echo "3. Verificar estado de servicios:"
    echo "   cd $PROJECT_ROOT"
    echo "   docker compose ps"
    echo ""
    echo "4. Ver logs:"
    echo "   docker compose logs -f [servicio]"
    echo ""
    echo "5. Setup inicial de Hub (Frappe):"
    echo "   docker exec -it versatile-hub-backend bench new-site lab.$DOMAIN \\"
    echo "     --mariadb-root-password \$HUB_DB_ROOT_PASSWORD \\"
    echo "     --admin-password admin123 \\"
    echo "     --install-app erpnext"
    echo ""
    
    echo -e "${GREEN}¡Instalación exitosa!${NC}"
    echo ""
}

# === MAIN ===

main() {
    print_banner
    
    check_root
    check_os
    install_docker
    check_docker_compose
    create_network
    configure_domain
    setup_traefik
    deploy_traefik
    setup_versatilehub
    deploy_versatilehub
    
    show_summary
}

# Ejecutar
main "$@"
