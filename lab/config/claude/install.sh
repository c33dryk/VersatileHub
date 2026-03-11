#!/bin/bash
# Script de instalación de configuraciones de Claude/Copilot
# 
# Uso:
#   ./install.sh              # Instalación normal
#   ./install.sh --force      # Sobrescribir archivos existentes
#   ./install.sh --clean      # Limpiar configuraciones instaladas
#   ./install.sh --backup     # Crear backup antes de instalar

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Directorios
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../../.." && pwd )"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
BACKUP_DIR="$PROJECT_ROOT/.backups/claude-config"

echo -e "${BLUE}🤖 Instalador de Configuración Claude/Copilot${NC}"
echo "=================================================="
echo ""

# Parsear argumentos
FORCE=false
CLEAN=false
BACKUP=false

for arg in "$@"; do
    case $arg in
        --force)
            FORCE=true
            ;;
        --clean)
            CLEAN=true
            ;;
        --backup)
            BACKUP=true
            ;;
        --help|-h)
            echo "Uso: $0 [opciones]"
            echo ""
            echo "Opciones:"
            echo "  --force     Sobrescribir archivos existentes"
            echo "  --clean     Limpiar configuraciones instaladas"
            echo "  --backup    Crear backup antes de instalar"
            echo "  --help      Mostrar esta ayuda"
            exit 0
            ;;
    esac
done

# Función para crear backup
create_backup() {
    if [ "$BACKUP" = true ] || [ "$FORCE" = true ]; then
        echo -e "${YELLOW}📦 Creando backup...${NC}"
        mkdir -p "$BACKUP_DIR"
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        
        [ -f "$PROJECT_ROOT/.clinerules" ] && cp "$PROJECT_ROOT/.clinerules" "$BACKUP_DIR/.clinerules.$TIMESTAMP"
        [ -f "$PROJECT_ROOT/.github/copilot-instructions.md" ] && cp "$PROJECT_ROOT/.github/copilot-instructions.md" "$BACKUP_DIR/copilot-instructions.md.$TIMESTAMP"
        [ -f "$PROJECT_ROOT/.vscode/settings.json" ] && cp "$PROJECT_ROOT/.vscode/settings.json" "$BACKUP_DIR/vscode-settings.json.$TIMESTAMP"
        [ -f "$PROJECT_ROOT/.vscode/extensions.json" ] && cp "$PROJECT_ROOT/.vscode/extensions.json" "$BACKUP_DIR/vscode-extensions.json.$TIMESTAMP"
        
        echo -e "${GREEN}✅ Backup creado en: $BACKUP_DIR${NC}"
        echo ""
    fi
}

# Función para limpiar
clean_config() {
    echo -e "${YELLOW}🧹 Limpiando configuraciones instaladas...${NC}"
    
    rm -f "$PROJECT_ROOT/.clinerules"
    rm -f "$PROJECT_ROOT/.cursorrules"
    rm -f "$PROJECT_ROOT/.github/copilot-instructions.md"
    # No eliminamos .vscode/ completo por si hay otras configs
    
    echo -e "${GREEN}✅ Configuraciones eliminadas${NC}"
    echo ""
    echo "Las plantillas en lab/config/claude/templates/ se mantienen intactas."
    exit 0
}

# Función para copiar archivo
copy_file() {
    local src="$1"
    local dest="$2"
    local name="$3"
    
    # Crear directorio destino si no existe
    mkdir -p "$(dirname "$dest")"
    
    if [ -f "$dest" ] && [ "$FORCE" != true ]; then
        echo -e "${YELLOW}⚠️  $name ya existe (usa --force para sobrescribir)${NC}"
        return 1
    fi
    
    cp "$src" "$dest"
    echo -e "${GREEN}✅${NC} $name instalado"
    return 0
}

# Ejecutar limpieza si se solicitó
if [ "$CLEAN" = true ]; then
    clean_config
fi

# Verificar que existan los templates
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo -e "${RED}❌ Error: Directorio de templates no encontrado${NC}"
    echo "   Esperado: $TEMPLATES_DIR"
    exit 1
fi

# Crear backup si se solicitó
create_backup

# Instalación
echo -e "${BLUE}📋 Instalando configuraciones...${NC}"
echo ""

# Contador de archivos instalados
INSTALLED=0
SKIPPED=0

# Copiar .clinerules
if copy_file "$TEMPLATES_DIR/.clinerules" "$PROJECT_ROOT/.clinerules" ".clinerules (Cline/Claude Code)"; then
    ((INSTALLED++))
else
    ((SKIPPED++))
fi

# Copiar .cursorrules (opcional, mismo contenido que .clinerules)
if [ -f "$TEMPLATES_DIR/.cursorrules" ]; then
    if copy_file "$TEMPLATES_DIR/.cursorrules" "$PROJECT_ROOT/.cursorrules" ".cursorrules (Cursor IDE)"; then
        ((INSTALLED++))
    else
        ((SKIPPED++))
    fi
fi

# Copiar copilot-instructions.md
if copy_file "$TEMPLATES_DIR/copilot-instructions.md" "$PROJECT_ROOT/.github/copilot-instructions.md" "GitHub Copilot instructions"; then
    ((INSTALLED++))
else
    ((SKIPPED++))
fi

# Copiar vscode-settings.json
if copy_file "$TEMPLATES_DIR/vscode-settings.json" "$PROJECT_ROOT/.vscode/settings.json" "VS Code settings"; then
    ((INSTALLED++))
else
    ((SKIPPED++))
fi

# Copiar vscode-extensions.json
if copy_file "$TEMPLATES_DIR/vscode-extensions.json" "$PROJECT_ROOT/.vscode/extensions.json" "VS Code extensions"; then
    ((INSTALLED++))
else
    ((SKIPPED++))
fi

echo ""
echo "=================================================="
echo -e "${GREEN}✅ Instalación completada${NC}"
echo ""
echo "Resultado:"
echo "  • Archivos instalados: $INSTALLED"
echo "  • Archivos omitidos: $SKIPPED"
echo ""

if [ $INSTALLED -gt 0 ]; then
    echo "Archivos instalados en:"
    echo "  • $PROJECT_ROOT/.clinerules"
    echo "  • $PROJECT_ROOT/.github/copilot-instructions.md"
    echo "  • $PROJECT_ROOT/.vscode/settings.json"
    echo "  • $PROJECT_ROOT/.vscode/extensions.json"
    echo ""
fi

echo "📚 Próximos pasos:"
echo ""
echo "1. Instalar extensiones (si no las tienes):"
echo "   code --install-extension GitHub.copilot"
echo "   code --install-extension GitHub.copilot-chat"
echo "   code --install-extension saoudrizwan.claude-dev"
echo ""
echo "2. Reiniciar VS Code:"
echo "   Ctrl+Shift+P → 'Reload Window'"
echo ""
echo "3. Configurar autenticación (solo Cline):"
echo "   Ctrl+Shift+P → 'Cline: Open Settings'"
echo ""
echo "4. Empezar a usar:"
echo "   • GitHub Copilot: Ctrl+I (inline) o Ctrl+Shift+I (panel)"
echo "   • Cline: Ctrl+Shift+P → 'Cline: Open Chat'"
echo ""
echo "📖 Documentación: lab/CLAUDE.md"
echo "🔧 Verificar setup: ./lab/scripts/check-claude-setup.sh"
echo ""
