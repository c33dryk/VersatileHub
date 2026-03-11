# 🚀 Quick Start: Integrar Notion con MCP en 5 minutos

## 📋 Resumen de Pasos

### 1️⃣ Instalar Node.js (si no lo tienes)
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 2️⃣ Crear Integración en Notion
1. Ve a: https://www.notion.so/my-integrations
2. Click **"+ New integration"**
3. Nombre: `VersatileHub MCP`
4. Capabilities: ✅ Read, ✅ Update, ✅ Insert content
5. **Copia el token:** `secret_xxxxx...`

### 3️⃣ Conectar páginas a tu Integración
En cada página/base de datos de Notion:
1. Click **⋯** (3 puntos) arriba a la derecha
2. **Connections** → Selecciona **"VersatileHub MCP"**

### 4️⃣ Instalar MCP Server
```bash
cd /opt/ATS/VersatileHub
./lab/config/claude/install-mcp-custom.sh
# Selecciona opción 4 (Notion)
```

### 5️⃣ Configurar Token
```bash
# Agregar al final de ~/.bashrc
echo 'export NOTION_API_KEY="secret_tu_token_aqui"' >> ~/.bashrc
source ~/.bashrc
```

### 6️⃣ Reiniciar VS Code
```
Ctrl+Shift+P → "Developer: Reload Window"
```

### 7️⃣ Probar en Cline
```
"Lista todas mis páginas de Notion"
```

## 🎯 Casos de Uso Rápidos

### Sincronizar Documentación
```
"Lee la página 'Arquitectura VersatileHub' de Notion y actualiza 
lab/context/services-overview.md"
```

### Crear Página
```
"Crea una nueva página en Notion en mi workspace 'VersatileHub':
- Título: 'Sprint Planning - Marzo 2026'
- Contenido: Lista con objetivos del sprint"
```

### Búsqueda
```
"Busca en Notion todas las páginas que mencionan 'Docker' o 'Traefik'"
```

### Reporte
```
"Lee mi base de datos 'Tareas' en Notion y genera un reporte markdown 
con todas las tareas completadas esta semana"
```

## 📚 Documentación Completa

- [NOTION_SETUP.md](NOTION_SETUP.md) - Guía detallada paso a paso
- [Notion API Docs](https://developers.notion.com/reference)
- [MCP Protocol](https://modelcontextprotocol.io/)

## 🐛 Troubleshooting Rápido

**Error: "Notion API key not found"**
```bash
echo $NOTION_API_KEY  # Debe mostrar tu token
# Si no, agregar a ~/.bashrc y hacer source
```

**Error: "Integration is not connected"**
- Abre la página en Notion
- ⋯ → Add connections → Selecciona tu integración

**MCP no aparece en Cline**
- Reiniciar VS Code completamente (cerrar y abrir)
- Verificar que el token está en ~/.bashrc

---

**Tiempo estimado**: 5-10 minutos  
**Última actualización**: 2026-03-11
