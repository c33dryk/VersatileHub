# Configuración de Claude Code / Cline para VersatileHub

Este directorio contiene todas las configuraciones de Claude Code, Cline y GitHub Copilot para VersatileHub.

## 📁 Estructura

```
lab/config/claude/
├── README.md                          # Esta guía
├── GETTING_STARTED.md                 # 🚀 Guía de inicio rápido
├── MCP_SETUP.md                       # 🔌 Configuración de MCP servers
├── FRAPPE_SETUP.md                    # ⭐ Agente experto en Frappe/ERPNext
├── NOTION_SETUP.md                    # 📝 Integración con Notion via MCP
├── MIGRACION.md                       # 🔄 Migrar configuración a otros proyectos
├── INTEGRACIONES.md                   # 📊 Dashboard de integraciones MCP
├── SUMMARY.md                         # Resumen completo de configuración
├── install.sh                         # Script de instalación base
├── install-mcp.sh                     # Script de instalación MCP estándar
├── install-mcp-custom.sh              # Script de instalación MCP personalizado
├── mcp-config.json                    # Configuración MCP (generada)
├── templates/                         # Plantillas maestras
│   ├── .clinerules                   # Reglas para Cline
│   ├── copilot-instructions.md       # Instrucciones para Copilot
│   ├── vscode-settings.json          # Configuración de VS Code
│   └── vscode-extensions.json        # Extensiones recomendadas
└── agents/                           # Agentes personalizados
    ├── README.md                     # Guía de agentes
    ├── versatilehub-assistant.json   # Agente principal
    └── frappe-expert.json            # ⭐ Agente Frappe/ERPNext v15
```

## 🚀 Instalación Rápida

### Setup Completo (Recomendado)
```bash
# 1. Instalar configuraciones base
./lab/config/claude/install.sh

# 2. Instalar MCP servers (para acceso a bases de datos, filesystem, git)
./lab/config/claude/install-mcp.sh

# 3. Instalar extensiones de VS Code
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
code --install-extension saoudrizwan.claude-dev

# 4. Reload VS Code
# Ctrl+Shift+P → "Reload Window"
```

**Ver guía detallada:** [GETTING_STARTED.md](GETTING_STARTED.md)

## 📦 Instalación Manual

### Paso 1: Instalar extensiones

**Opción A: GitHub Copilot (ya incluye Claude)**
```bash
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
```

**Opción B: Cline (Claude Code avanzado)**
```bash
# Instalar desde VS Code Marketplace
# Busca "Cline" o "Claude Dev"
# O usa el ID:
code --install-extension saoudrizwan.claude-dev
```

### Paso 2: Copiar configuraciones
```bash
# Desde la raíz del proyecto
cd /opt/ATS/VersatileHub

# Copiar .clinerules
cp lab/config/claude/templates/.clinerules .clinerules

# Copiar configuración de Copilot
mkdir -p .github
cp lab/config/claude/templates/copilot-instructions.md .github/copilot-instructions.md

# Copiar configuración de VS Code
mkdir -p .vscode
cp lab/config/claude/templates/vscode-settings.json .vscode/settings.json
cp lab/config/claude/templates/vscode-extensions.json .vscode/extensions.json
```

### Paso 3: Autenticación (solo para Cline)

Si usas Cline, necesitas autenticarte:

1. Abre VS Code
2. Presiona `Ctrl+Shift+P`
3. Busca "Cline: Open Settings"
4. Selecciona método de autenticación:
   - **Claude.ai Subscription** (Claude Pro - $20/mes)
   - **Anthropic API Key** (Pay per use)
   - **Bedrock/Foundry/Vertex** (Terceros)

## 🔄 Migrar a Otro Proyecto

Para usar estas configuraciones en otro proyecto:

```bash
# 1. Copiar todo el directorio claude/
cp -r VersatileHub/lab/config/claude/ NuevoProyecto/lab/config/

# 2. Editar templates según el nuevo proyecto
cd NuevoProyecto/lab/config/claude/templates/
# Editar .clinerules, copilot-instructions.md, etc.

# 3. Ejecutar instalación
cd NuevoProyecto/
./lab/config/claude/install.sh
```

## 🎯 Dos Opciones de Uso

### Opción A: GitHub Copilot Pro (Recomendado)
- **Costo**: $10/mes (ya incluye Claude Sonnet 4.5)
- **Ideal para**: Desarrollo normal día a día
- **Funciones**: Sugerencias, chat, explicación de código
- **Archivo usado**: `copilot-instructions.md`

### Opción B: Cline/Claude Code (Avanzado)
- **Costo**: Claude Pro $20/mes o API pay-per-use
- **Ideal para**: Agentes autónomos, tareas complejas
- **Funciones**: Ejecuta comandos, crea archivos, multi-paso
- **Archivo usado**: `.clinerules`

### Opción C: Usar Ambos ✅
- GitHub Copilot para sugerencias diarias
- Cline para tareas complejas automatizadas
- Ambos funcionan perfectamente juntos

## 📚 Archivos de Configuración

### `.clinerules`
Instrucciones específicas para Cline/Claude Code. Define:
- Contexto del proyecto
- Reglas de desarrollo
- Estándares de código
- Flujo de trabajo

### `copilot-instructions.md`
Instrucciones para GitHub Copilot. Similar a `.clinerules` pero:
- Formato Markdown completo
- Ubicación: `.github/copilot-instructions.md`
- Leído automáticamente por Copilot

### `vscode-settings.json`
Configuración de VS Code optimizada para:
- Claude/Copilot
- Docker
- TypeScript/JavaScript
- Python
- YAML/Markdown

### `vscode-extensions.json`
Lista de extensiones recomendadas:
- GitHub Copilot/Chat
- Docker
- ESLint/Prettier
- GitLens
- Y más...

## 🤖 Agentes Personalizados

Los agentes permiten crear asistentes especializados. Ver `agents/README.md`.

## 🔧 Comandos Útiles

```bash
# Verificar configuración
./lab/scripts/check-claude-setup.sh

# Reinstalar configuraciones
./lab/config/claude/install.sh --force

# Limpiar configuraciones instaladas
./lab/config/claude/install.sh --clean
```

## 📖 Documentación Relacionada

- [lab/CLAUDE.md](../../CLAUDE.md) - Guía completa de uso
- [lab/config/README.md](../README.md) - Configuraciones generales
- [.github/copilot-instructions.md](/.github/copilot-instructions.md) - Instrucciones activas

## ⚠️ Notas Importantes

1. **No commitear API keys**: Los archivos `.env` están en `.gitignore`
2. **Actualizar templates**: Cuando cambies configuración, actualiza templates en `lab/config/claude/templates/`
3. **Versionar en lab/**: Mantén siempre la fuente de verdad en `lab/config/claude/`
4. **Raíz = instalado**: Los archivos en la raíz son copias instaladas

---

**Última actualización**: 2026-03-11  
**Mantenedor**: Equipo VersatileHub
