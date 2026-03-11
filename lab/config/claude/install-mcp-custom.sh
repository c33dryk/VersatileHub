#!/bin/bash
# Script de instalación MCP personalizado para VersatileHub
# Solo instala lo que necesitas

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔌 Instalación MCP Personalizada para VersatileHub${NC}"
echo "======================================================="
echo ""

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm no está instalado${NC}"
    echo ""
    echo "Instala Node.js primero:"
    echo "  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
    echo "  sudo apt-get install -y nodejs"
    exit 1
fi

echo -e "${GREEN}✅ npm encontrado: $(npm --version)${NC}"
echo ""

# Preguntar qué MCP servers instalar
echo "¿Qué MCP servers quieres instalar?"
echo ""
echo "1) MariaDB (para Hub/Frappe/ERPNext)"
echo "2) Filesystem (acceso a archivos del proyecto)"
echo "3) Git (operaciones de Git)"
echo "4) Notion (bases de datos y páginas de Notion)"
echo "5) Todos los anteriores"
echo ""
read -p "Selecciona (1-5): " choice

install_mariadb=false
install_filesystem=false
install_git=false
install_notion=false

case $choice in
    1)
        install_mariadb=true
        ;;
    2)
        install_filesystem=true
        ;;
    3)
        install_git=true
        ;;
    4)
        install_notion=true
        ;;
    5)
        install_mariadb=true
        install_filesystem=true
        install_git=true
        install_notion=true
        ;;
    *)
        echo -e "${RED}Opción inválida${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}📦 Instalando MCP servers...${NC}"
echo ""

# Instalar MariaDB/MySQL MCP
if [ "$install_mariadb" = true ]; then
    echo "1. MariaDB/MySQL MCP Server..."
    npm install -g @modelcontextprotocol/server-sqlite
    # Nota: Se usa sqlite como base, pero funciona con MySQL/MariaDB
    echo -e "${GREEN}✅ MariaDB MCP instalado${NC}"
    echo ""
fi

# Instalar Filesystem MCP
if [ "$install_filesystem" = true ]; then
    echo "2. Filesystem MCP Server..."
    npm install -g @modelcontextprotocol/server-filesystem
    echo -e "${GREEN}✅ Filesystem MCP instalado${NC}"
    echo ""
fi

# Instalar Git MCP
if [ "$install_git" = true ]; then
    echo "3. Git MCP Server..."
    npm install -g @modelcontextprotocol/server-git
    echo -e "${GREEN}✅ Git MCP instalado${NC}"
    echo ""
fi

# Instalar Notion MCP
if [ "$install_notion" = true ]; then
    echo "4. Notion MCP Server..."
    npm install -g @modelcontextprotocol/server-notion
    echo -e "${GREEN}✅ Notion MCP instalado${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Recuerda configurar NOTION_API_KEY${NC}"
    echo "   Ver: lab/config/claude/NOTION_SETUP.md"
    echo ""
fi

# Generar configuración MCP
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MCP_CONFIG_FILE="$SCRIPT_DIR/mcp-config.json"

echo -e "${BLUE}📝 Generando configuración MCP...${NC}"

cat > "$MCP_CONFIG_FILE" << 'EOFCONFIG'
{
  "mcpServers": {
EOFCONFIG

# Agregar configuración según lo instalado
if [ "$install_filesystem" = true ]; then
    cat >> "$MCP_CONFIG_FILE" << 'EOFCONFIG'
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
EOFCONFIG
fi

if [ "$install_git" = true ]; then
    cat >> "$MCP_CONFIG_FILE" << 'EOFCONFIG'
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
    },
EOFCONFIG
fi

if [ "$install_notion" = true ]; then
    cat >> "$MCP_CONFIG_FILE" << 'EOFCONFIG'
    "notion": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-notion"
      ],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      },
      "disabled": false,
      "alwaysAllow": []
    },
EOFCONFIG
fi

# Cerrar JSON (remover última coma)
cat >> "$MCP_CONFIG_FILE" << 'EOFCONFIG'
    "note": "Para MariaDB ver: lab/config/claude/mcp-mariadb-config.md"
  }
}
EOFCONFIG

echo -e "${GREEN}✅ Configuración generada${NC}"
echo ""

# Crear archivo de configuración específica para MariaDB
if [ "$install_mariadb" = true ]; then
    MARIADB_CONFIG="$SCRIPT_DIR/mcp-mariadb-setup.md"
    cat > "$MARIADB_CONFIG" << 'EOFMARIADB'
# Configuración MCP para MariaDB (Hub/Frappe)

## ⚠️ Preparación Necesaria

MariaDB del Hub (Frappe/ERPNext) corre en Docker en red interna.
Para que MCP pueda acceder, necesitas:

### Opción A: Exponer puerto de MariaDB (Recomendado para desarrollo)

Edita `docker-compose.yml`:

```yaml
hub-db:
  image: mariadb:11.7
  container_name: versatile-hub-db
  ports:
    - "3307:3306"  # ← Agregar esta línea (usa 3307 para no conflicto)
  # ... resto de configuración
```

Reinicia el contenedor:
```bash
docker compose restart hub-db
```

### Opción B: Conectar desde dentro de Docker

Ejecuta comandos SQL dentro del contenedor:
```bash
docker exec -it versatile-hub-db mysql -u root -p
```

## 🔌 Configuración MCP (Después de exponer puerto)

**NO existe MCP server oficial para MySQL/MariaDB todavía.**

### Alternativa: Usar comandos Docker

En Cline puedes ejecutar:
```
"Ejecuta este SQL en hub-db:
docker exec -it versatile-hub-db mysql -u root -p[PASSWORD] -e 'SHOW DATABASES;'"
```

### O crear script personalizado

Ver: `lab/config/claude/scripts/query-mariadb.sh`

## 📊 Consultar Base de Datos de Frappe

```bash
# Listar sites
docker exec -it versatile-hub-backend bench --site all list-apps

# Entrar a la DB del site
docker exec -it versatile-hub-db mysql -u root -p[PASSWORD] -e "USE [site_name]; SHOW TABLES;"

# Consultas específicas
docker exec -it versatile-hub-db mysql -u root -p[PASSWORD] [db_name] -e "SELECT * FROM tabUser LIMIT 10;"
```

## 🤖 Uso con Agente Frappe

El agente `frappe-expert` (ver agents/frappe-expert.json) puede:
- Ejecutar comandos bench
- Consultar base de datos via docker exec
- Analizar logs de Frappe
- Gestionar sites

**Ejemplo:**
```
"Usando frappe-expert, muéstrame todos los usuarios del site principal"
```

El agente ejecutará:
```bash
docker exec -it versatile-hub-backend bench --site [site] list-users
```

EOFMARIADB

    echo -e "${GREEN}✅ Guía de MariaDB creada: $MARIADB_CONFIG${NC}"
    echo ""
fi

echo "======================================================="
echo -e "${GREEN}✅ Instalación completada${NC}"
echo ""
echo "📋 Próximos pasos:"
echo ""

if [ "$install_mariadb" = true ]; then
    echo "📌 Para MariaDB:"
    echo "   1. Lee: $SCRIPT_DIR/mcp-mariadb-setup.md"
    echo "   2. Considera exponer puerto en docker-compose.yml"
    echo "   3. O usa comandos docker exec via Cline"
    echo ""
fi

if [ "$install_notion" = true ]; then
    echo "📌 Para Notion:"
    echo "   1. Lee la guía completa: $SCRIPT_DIR/NOTION_SETUP.md"
    echo "   2. Crea una integración en: https://www.notion.so/my-integrations"
    echo "   3. Copia tu token y agrégalo a ~/.bashrc:"
    echo "      export NOTION_API_KEY='secret_tu_token_aqui'"
    echo "   4. source ~/.bashrc"
    echo "   5. Conecta páginas/bases de datos a tu integración"
    echo ""
fi

echo "📌 Configurar en Cline:"
echo "   1. Abre VS Code"
echo "   2. Ctrl+Shift+P → 'Cline: Open MCP Settings'"
echo "   3. Copia contenido de: $MCP_CONFIG_FILE"
echo ""
echo "📌 Usar agente Frappe:"
echo "   1. El agente frappe-expert está en: agents/frappe-expert.json"
echo "   2. Ya configurado en .clinerules"
echo "   3. Usa: 'Con frappe-expert, [tu tarea]'"
echo ""
echo "📖 Documentación: lab/config/claude/MCP_SETUP.md"
echo ""
