#!/bin/bash
# Script de instalación de MCP servers para VersatileHub
# Instala los MCP servers necesarios y configura Cline

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔌 Instalador de MCP Servers para Claude Code${NC}"
echo "=================================================="
echo ""

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm no está instalado${NC}"
    echo "Instala Node.js primero: https://nodejs.org"
    exit 1
fi

echo -e "${GREEN}✅ npm encontrado${NC}"
echo ""

# Instalar MCP servers
echo -e "${BLUE}📦 Instalando MCP servers...${NC}"
echo ""

echo "1. PostgreSQL MCP Server..."
npm install -g @modelcontextprotocol/server-postgres
echo -e "${GREEN}✅ PostgreSQL MCP instalado${NC}"
echo ""

echo "2. Filesystem MCP Server..."
npm install -g @modelcontextprotocol/server-filesystem
echo -e "${GREEN}✅ Filesystem MCP instalado${NC}"
echo ""

echo "3. Git MCP Server..."
npm install -g @modelcontextprotocol/server-git
echo -e "${GREEN}✅ Git MCP instalado${NC}"
echo ""

# Crear configuración MCP
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MCP_CONFIG_FILE="$SCRIPT_DIR/mcp-config.json"

echo -e "${BLUE}📝 Generando configuración MCP...${NC}"

cat > "$MCP_CONFIG_FILE" << 'EOF'
{
  "mcpServers": {
    "postgres-chat": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://chatwoot:PASSWORD_AQUI@localhost:5432/chatwoot"
      ],
      "disabled": false,
      "alwaysAllow": []
    },
    "filesystem-services": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/opt/ATS/VersatileHub/services"
      ],
      "disabled": false,
      "alwaysAllow": []
    },
    "filesystem-lab": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/opt/ATS/VersatileHub/lab"
      ],
      "disabled": false,
      "alwaysAllow": []
    },
    "git": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-git",
        "--repository",
        "/opt/ATS/VersatileHub"
      ],
      "disabled": false,
      "alwaysAllow": []
    }
  }
}
EOF

echo -e "${GREEN}✅ Configuración generada en:${NC}"
echo "   $MCP_CONFIG_FILE"
echo ""

echo "=================================================="
echo -e "${GREEN}✅ Instalación completada${NC}"
echo ""
echo "📋 Próximos pasos:"
echo ""
echo "1. Editar configuración MCP:"
echo "   nano $MCP_CONFIG_FILE"
echo "   ${YELLOW}⚠️  Reemplaza 'PASSWORD_AQUI' con tu contraseña de PostgreSQL${NC}"
echo ""
echo "2. Configurar en Cline (VS Code):"
echo "   a) Abre VS Code"
echo "   b) Ctrl+Shift+P → 'Cline: Open MCP Settings'"
echo "   c) Copia el contenido de: $MCP_CONFIG_FILE"
echo "   d) O usa la UI de Cline para agregar servers"
echo ""
echo "3. Reiniciar Cline:"
echo "   Ctrl+Shift+P → 'Reload Window'"
echo ""
echo "4. Probar MCP:"
echo "   En el chat de Cline escribe:"
echo "   'Lista los archivos en services/ usando filesystem-services'"
echo ""
echo "📖 Documentación completa: lab/config/claude/MCP_SETUP.md"
echo ""
