#!/bin/bash
# Script para verificar la configuración de Claude/Copilot

set -e

echo "🔍 Verificando configuración de Claude/Copilot en VersatileHub"
echo "================================================================"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para checks
check_item() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅${NC} $2"
    else
        echo -e "${RED}❌${NC} $2"
    fi
}

# Check VS Code instalado
echo "📌 Visual Studio Code:"
if command -v code &> /dev/null; then
    VERSION=$(code --version | head -n1)
    check_item 0 "VS Code instalado: $VERSION"
else
    check_item 1 "VS Code NO instalado"
fi
echo ""

# Check extensiones de Copilot
echo "📌 Extensiones de GitHub Copilot:"
COPILOT_INSTALLED=1
COPILOT_CHAT_INSTALLED=1

if code --list-extensions 2>/dev/null | grep -q "github.copilot"; then
    COPILOT_INSTALLED=0
fi

if code --list-extensions 2>/dev/null | grep -q "github.copilot-chat"; then
    COPILOT_CHAT_INSTALLED=0
fi

check_item $COPILOT_INSTALLED "GitHub Copilot"
check_item $COPILOT_CHAT_INSTALLED "GitHub Copilot Chat"
echo ""

# Check extensiones de Claude Code (no debería estar)
echo "📌 Extensión Claude Code (no necesaria):"
CLAUDE_CODE_EXTENSIONS=$(code --list-extensions 2>/dev/null | grep -i "claude\|cline\|anthropic" || true)

if [ -z "$CLAUDE_CODE_EXTENSIONS" ]; then
    echo -e "${GREEN}✅${NC} No hay extensiones Claude Code instaladas (correcto)"
else
    echo -e "${YELLOW}⚠️${NC}  Extensiones Claude Code encontradas (no necesarias):"
    echo "$CLAUDE_CODE_EXTENSIONS" | sed 's/^/    /'
    echo "   Considera desinstalarlas si no pagas Claude Pro"
fi
echo ""

# Check archivos de configuración
echo "📌 Archivos de configuración:"
PROJECT_ROOT="/opt/ATS/VersatileHub"

if [ -f "$PROJECT_ROOT/.github/copilot-instructions.md" ]; then
    check_item 0 ".github/copilot-instructions.md"
else
    check_item 1 ".github/copilot-instructions.md (faltante)"
fi

if [ -f "$PROJECT_ROOT/.vscode/settings.json" ]; then
    check_item 0 ".vscode/settings.json"
else
    check_item 1 ".vscode/settings.json (faltante)"
fi

if [ -f "$PROJECT_ROOT/.vscode/extensions.json" ]; then
    check_item 0 ".vscode/extensions.json"
else
    check_item 1 ".vscode/extensions.json (faltante)"
fi

if [ -f "$PROJECT_ROOT/lab/CLAUDE.md" ]; then
    check_item 0 "lab/CLAUDE.md (guía)"
else
    check_item 1 "lab/CLAUDE.md (faltante)"
fi
echo ""

# Resumen y recomendaciones
echo "================================================================"
echo "📋 RESUMEN:"
echo ""

if [ $COPILOT_INSTALLED -eq 0 ] && [ $COPILOT_CHAT_INSTALLED -eq 0 ]; then
    echo -e "${GREEN}✅ Configuración correcta!${NC}"
    echo ""
    echo "Tu setup actual:"
    echo "  • GitHub Copilot Pro con Claude Sonnet 4.5"
    echo "  • Archivos de configuración listos"
    echo "  • NO requiere pago adicional de Claude"
    echo ""
    echo "Comandos para empezar:"
    echo "  • Ctrl+I          → Chat inline"
    echo "  • Ctrl+Shift+I    → Panel de chat"
    echo "  • @workspace      → Consultar proyecto completo"
    echo ""
    echo "Lee lab/CLAUDE.md para más información"
else
    echo -e "${RED}⚠️  Instalación incompleta${NC}"
    echo ""
    echo "Instala las extensiones necesarias:"
    echo "  code --install-extension GitHub.copilot"
    echo "  code --install-extension GitHub.copilot-chat"
fi

echo ""
echo "================================================================"
