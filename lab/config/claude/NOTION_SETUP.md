# 📝 Integración de Notion con MCP (Model Context Protocol)

Esta guía te ayudará a conectar Notion con Claude Code mediante MCP para acceder a tus bases de datos, páginas y bloques de Notion.

## 🎯 ¿Qué puedes hacer con Notion MCP?

- ✅ Leer y buscar en tus bases de datos de Notion
- ✅ Crear y actualizar páginas
- ✅ Agregar contenido a páginas existentes
- ✅ Consultar propiedades de bases de datos
- ✅ Sincronizar documentación entre Notion y VersatileHub
- ✅ Automatizar creación de tareas desde Notion

## 📋 Requisitos Previos

```bash
# 1. Verificar que tienes Node.js instalado
node --version  # Debe ser v18 o superior

# Si no lo tienes:
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## 🔑 Paso 1: Crear una Integración en Notion

### 1.1 Accede a Notion Developers

1. Ve a: https://www.notion.so/my-integrations
2. Click en **"+ New integration"**

### 1.2 Configura tu Integración

**Información básica:**
- **Name**: `VersatileHub MCP` (o el nombre que prefieras)
- **Logo**: (opcional) Sube un logo
- **Associated workspace**: Selecciona tu workspace de Notion

**Capabilities (Capacidades):**
- ✅ **Read content** - Leer páginas y bases de datos
- ✅ **Update content** - Modificar páginas existentes
- ✅ **Insert content** - Crear nuevas páginas
- ⚠️ **Read comments** (opcional)
- ⚠️ **Insert comments** (opcional)

**Content Capabilities:**
- ✅ Read user information (para saber quién creó qué)
- ✅ No user information

### 1.3 Guarda tu Token

Después de crear la integración:
1. Copia el **"Internal Integration Token"**
2. Se ve así: `secret_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
3. ⚠️ **GUÁRDALO EN UN LUGAR SEGURO** - No lo compartas

## 🔗 Paso 2: Conectar Páginas/Bases de Datos

Para que tu integración pueda acceder a páginas específicas de Notion:

### 2.1 En cada página o base de datos que quieras conectar:

1. Abre la página en Notion
2. Click en los **3 puntos** (⋯) arriba a la derecha
3. Scroll hasta **"Connections"** o **"Add connections"**
4. Busca y selecciona **"VersatileHub MCP"** (tu integración)

### 2.2 Obtén el ID de la página/base de datos

**Opción A: Desde la URL**
```
https://www.notion.so/Tu-Pagina-abc123def456?v=...
                                 ↑
                    Este es el Page ID: abc123def456
```

**Opción B: Share → Copy link**
1. Click en "Share" en la página
2. "Copy link"
3. El ID está en la URL

## 📦 Paso 3: Instalar MCP Server de Notion

```bash
# Instalar el servidor MCP de Notion
npm install -g @modelcontextprotocol/server-notion

# Verificar instalación
which server-notion || npx -y @modelcontextprotocol/server-notion --version
```

## ⚙️ Paso 4: Configurar MCP en Cline

### 4.1 Ubicación del archivo de configuración

El archivo de configuración MCP debe estar en:
```bash
~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

### 4.2 Crear/Editar configuración

```bash
# Crear directorio si no existe
mkdir -p ~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings

# Editar archivo
nano ~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

### 4.3 Agregar configuración de Notion

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-notion"],
      "env": {
        "NOTION_API_KEY": "secret_tu_token_aqui"
      }
    }
  }
}
```

**⚠️ IMPORTANTE:** Reemplaza `secret_tu_token_aqui` con tu token real de Notion.

### 4.4 Configuración con múltiples MCP servers

Si ya tienes otros servers configurados (filesystem, git, etc.):

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-notion"],
      "env": {
        "NOTION_API_KEY": "secret_tu_token_aqui"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/opt/ATS/VersatileHub"]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git", "--repository", "/opt/ATS/VersatileHub"]
    }
  }
}
```

## 🔐 Paso 5: Seguridad - Usar Variables de Entorno (Recomendado)

En lugar de poner el token directamente en el JSON:

### 5.1 Agregar token al .bashrc/.zshrc

```bash
# Editar tu archivo de shell
nano ~/.bashrc  # o ~/.zshrc

# Agregar al final:
export NOTION_API_KEY="secret_tu_token_aqui"

# Guardar y recargar
source ~/.bashrc
```

### 5.2 Configuración MCP sin token hardcodeado

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-notion"],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      }
    }
  }
}
```

## 🚀 Paso 6: Reiniciar VS Code y Activar MCP

```bash
# 1. Guardar todos los archivos
# 2. Cerrar VS Code completamente
# 3. Abrir de nuevo

# O desde la Command Palette:
# Ctrl+Shift+P → "Developer: Reload Window"
```

## ✅ Paso 7: Verificar que Funciona

### 7.1 Abrir Cline

1. Click en el ícono de Cline en la barra lateral
2. O `Ctrl+Shift+P` → "Cline: Open"

### 7.2 Verificar MCP Servers

En la interfaz de Cline, busca un indicador de MCP servers activos (generalmente en la parte superior o configuración).

### 7.3 Probar conexión a Notion

Envía un mensaje a Cline:

```
"Lista todas mis páginas y bases de datos conectadas en Notion"
```

O más específico:

```
"Busca en Notion páginas con el tag 'VersatileHub' y muéstrame los títulos"
```

## 🎯 Casos de Uso Comunes

### 1. Sincronizar Documentación

```
"Lee la página de Notion 'Arquitectura VersatileHub' y actualiza 
el archivo lab/context/services-overview.md con el contenido más reciente"
```

### 2. Crear Tareas desde Issues

```
"Cuando creo un issue en GitHub con label 'documentation', 
crea automáticamente una página en Notion en la base de datos 
'Tareas Pendientes' con:
- Título del issue
- Descripción
- Link al issue
- Estado: Por hacer"
```

### 3. Centralizar Decisiones de Arquitectura

```
"Crea una nueva página en Notion bajo 'ADR - Architecture Decision Records':
- Título: 'ADR-005: Migración a MariaDB 11.7'
- Fecha: Hoy
- Estado: Aprobado
- Contexto: [describir]
- Decisión: [...]
- Consecuencias: [...]"
```

### 4. Reportes Automáticos

```
"Lee todas las páginas en la base de datos 'Sprint Actual' en Notion,
genera un reporte markdown con:
- Tareas completadas
- Tareas en progreso
- Blockers
- Guardar en lab/reports/sprint-[fecha].md"
```

### 5. Búsqueda y Análisis

```
"Busca en todas mis páginas de Notion menciones a 'PostgreSQL vs MariaDB',
analiza las notas y dame un resumen de las ventajas/desventajas discutidas"
```

## 🛠️ Comandos Disponibles en Notion MCP

El servidor MCP de Notion proporciona estos comandos:

### Lectura
- `notion_search` - Buscar páginas y bases de datos
- `notion_get_page` - Obtener contenido de una página
- `notion_get_database` - Obtener estructura de base de datos
- `notion_query_database` - Consultar registros con filtros

### Escritura
- `notion_create_page` - Crear nueva página
- `notion_update_page` - Actualizar página existente
- `notion_append_blocks` - Agregar contenido a página

### Propiedades
- `notion_get_property` - Obtener propiedad específica
- `notion_update_property` - Actualizar propiedad

## 🐛 Troubleshooting

### Error: "Notion API key not found"

**Solución:**
```bash
# Verificar que la variable está definida
echo $NOTION_API_KEY

# Si no aparece nada, agregar a ~/.bashrc:
export NOTION_API_KEY="secret_tu_token_aqui"
source ~/.bashrc

# Reiniciar VS Code completamente
```

### Error: "Cannot find module '@modelcontextprotocol/server-notion'"

**Solución:**
```bash
# Reinstalar el paquete
npm install -g @modelcontextprotocol/server-notion

# O usar npx (no requiere instalación global)
# Configurar con "npx" en vez de "server-notion" en el command
```

### Error: "Integration is not connected to this page"

**Solución:**
1. Abre la página en Notion
2. Click en ⋯ (3 puntos)
3. "Add connections" → Selecciona tu integración
4. Reintenta desde Cline

### No aparece MCP en Cline

**Solución:**
```bash
# 1. Verificar la ruta del archivo
ls -la ~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/

# 2. Verificar formato JSON
cat ~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json | jq .

# 3. Si jq da error, hay un problema de sintaxis JSON
# 4. Reiniciar VS Code completamente (no solo reload window)
```

### MCP conecta pero no puede leer páginas

**Verificar permisos:**
1. La integración tiene capabilities de "Read content"
2. La página está conectada a la integración
3. La página no está en un workspace diferente

## 📚 Recursos Adicionales

- **Notion API Reference:** https://developers.notion.com/reference
- **MCP Protocol:** https://modelcontextprotocol.io/
- **Notion Integrations:** https://www.notion.so/my-integrations

## 🔄 Script de Instalación Automática

Para facilitar la configuración, puedes usar el script personalizado:

```bash
./lab/config/claude/install-mcp-custom.sh
```

Selecciona la opción **"5) Notion"** y sigue las instrucciones.

## 💡 Ejemplo Completo: Workflow de Documentación

### Escenario
Tienes una base de datos en Notion llamada "Documentación Técnica" donde centralizas todas las decisiones y specs.

### Setup
1. Crea la integración "VersatileHub MCP"
2. Conecta la base de datos "Documentación Técnica" a la integración
3. Configura MCP como se explicó arriba

### Uso desde Cline
```
"Cuando termine de implementar una feature en VersatileHub:
1. Busca en Notion en la base 'Documentación Técnica' 
   si ya existe una página para esta feature
2. Si existe, actualiza la sección 'Estado Implementación' 
   con fecha de hoy y status 'Completado'
3. Si no existe, crea una nueva página con:
   - Título: [nombre feature]
   - Tags: 'Implementado', 'VersatileHub'
   - Secciones: Descripción, Implementación, Testing, Estado
4. Agrega links a los archivos relevantes del repositorio"
```

---

**Última actualización:** 2026-03-11  
**Versión MCP Notion:** Latest  
**Compatibilidad:** VS Code + Cline/Claude Code
