# ✅ Resumen de Configuración Claude/Copilot para VersatileHub

## 📁 Estructura Creada

```
/opt/ATS/VersatileHub/
│
├── lab/config/claude/                          # TODO en /lab (portable)
│   ├── README.md                               # Guía principal
│   ├── GETTING_STARTED.md                      # 🚀 Inicio rápido
│   ├── MCP_SETUP.md                            # 🔌 Setup de MCP
│   │
│   ├── install.sh                              # Instalar configs base
│   ├── install-mcp.sh                          # Instalar MCP servers
│   ├── mcp-config.json                         # Config MCP (generada)
│   │
│   ├── templates/                              # Plantillas (versionadas)
│   │   ├── .clinerules
│   │   ├── copilot-instructions.md
│   │   ├── vscode-settings.json
│   │   └── vscode-extensions.json
│   │
│   └── agents/                                 # Agentes personalizados
│       ├── README.md
│       └── versatilehub-assistant.json
│
├── (Archivos instalados - gitignored)
├── .clinerules                                 # ← desde templates/
├── .github/copilot-instructions.md             # ← desde templates/
└── .vscode/                                    # ← desde templates/
    ├── settings.json
    └── extensions.json
```

## 🚀 Para Empezar a Programar

### 1. Instalación (Una sola vez)

```bash
cd /opt/ATS/VersatileHub

# Instalar configuraciones base
./lab/config/claude/install.sh

# Instalar MCP servers (opcional pero recomendado)
./lab/config/claude/install-mcp.sh

# Instalar extensiones
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
code --install-extension saoudrizwan.claude-dev

# Reload VS Code
# Ctrl+Shift+P → "Reload Window"
```

### 2. Autenticación

**GitHub Copilot:**
- Ya funciona si tienes subscription
- Selecciona Claude: `Ctrl+Shift+P` → "GitHub Copilot: Select Model" → Claude Sonnet 4.5

**Cline (Claude Code):**
- Abre Cline (ícono en barra lateral)
- Click "Settings"
- Elige: Claude.ai Subscription o Anthropic API Key

### 3. Configurar MCP (Opcional)

```bash
# Editar config con tu contraseña de PostgreSQL
nano lab/config/claude/mcp-config.json

# En VS Code:
# Ctrl+Shift+P → "Cline: Open MCP Settings"
# Copiar contenido de mcp-config.json
```

### 4. ¡A programar!

```
# GitHub Copilot
Ctrl+I                  # Chat inline
Ctrl+Shift+I            # Panel de chat

# Cline
Click en ícono Cline    # Agentes avanzados
```

## 🎯 Qué Puedes Hacer

### Con GitHub Copilot (Simple - Día a día)
- ✅ Autocompletado inteligente mientras escribes
- ✅ Sugerencias de código
- ✅ Explicaciones de código
- ✅ Refactorización
- ✅ Generación de tests
- ✅ Consultas sobre el proyecto con `@workspace`

### Con Cline (Avanzado - Tareas complejas)
- ✅ Crear servicios completos desde cero
- ✅ Ejecutar comandos en terminal
- ✅ Debugging automático con logs
- ✅ Refactorización multi-archivo
- ✅ Tareas multi-paso autónomas
- ✅ Acceso a bases de datos (con MCP)

### Con MCP Configurado (Superpoderes)
- ✅ Consultar bases de datos directamente
- ✅ Análisis de sistema de archivos completo
- ✅ Operaciones Git avanzadas
- ✅ Integración con APIs externas

## 📖 Documentación

### Inicio Rápido
```bash
# Lee esto primero
cat lab/config/claude/GETTING_STARTED.md
```

### Guías Completas
- [lab/CLAUDE.md](../../CLAUDE.md) - Documentación completa
- [lab/config/claude/MCP_SETUP.md](MCP_SETUP.md) - Configuración MCP
- [lab/config/claude/agents/README.md](agents/README.md) - Agentes
- [lab/QUICK_REFERENCE.md](../../QUICK_REFERENCE.md) - Referencia rápida

## 🔄 Actualizar Configuraciones

```bash
# 1. Editar template (fuente de verdad)
nano lab/config/claude/templates/.clinerules

# 2. Reinstalar
./lab/config/claude/install.sh --force

# 3. Reload VS Code
Ctrl+Shift+P → "Reload Window"
```

## 🌐 Migrar a Otro Proyecto

```bash
# Copiar todo el directorio claude/
cp -r VersatileHub/lab/config/claude/ NuevoProyecto/lab/config/

# Editar templates según nuevo proyecto
cd NuevoProyecto/lab/config/claude/templates/
nano .clinerules
nano copilot-instructions.md

# Instalar en nuevo proyecto
cd NuevoProyecto/
./lab/config/claude/install.sh
```

## 💡 Ejemplos de Uso

### Tarea Simple (Copilot)
```
Ctrl+Shift+I → "@workspace explica la arquitectura de services/"
```

### Crear Archivo (Cline)
```
"Crea un script de backup para PostgreSQL en services/chat/scripts/backup.sh"
```

### Tarea Compleja (Cline)
```
"Crea un nuevo servicio 'analytics' con:
- Node.js + TypeScript + Express
- PostgreSQL y Redis
- API REST con CRUD
- Integración Traefik
- Docker Compose siguiendo patrón del proyecto
Hazlo paso a paso y espera confirmación."
```

### Con MCP (Cline + MCP)
```
"Conecta a postgres-chat y analiza las últimas 100 conversaciones.
Genera un reporte con estadísticas."
```

## ✅ Checklist de Configuración

- [ ] ✅ Extensiones instaladas
- [ ] ✅ Configuraciones instaladas (`.clinerules`, `.github/`, `.vscode/`)
- [ ] ✅ Autenticación configurada
- [ ] ⚠️ MCP configurado (opcional)
- [ ] ✅ VS Code reiniciado
- [ ] ✅ Test: `Ctrl+Shift+I` → "@workspace test"

## 🆘 Ayuda

### No funciona Copilot
```bash
# Verificar autenticación
gh auth status

# Seleccionar Claude
Ctrl+Shift+P → "GitHub Copilot: Select Model"

# Reload
Ctrl+Shift+P → "Reload Window"
```

### No funciona Cline
```bash
# Ver logs
Ctrl+Shift+P → "Cline: Show Logs"

# Re-autenticar
Cline → Settings → Re-authenticate

# Reinstalar
code --uninstall-extension saoudrizwan.claude-dev
code --install-extension saoudrizwan.claude-dev
```

### MCP no conecta
```bash
# Ver logs MCP
Ctrl+Shift+P → "Cline: Show MCP Logs"

# Verificar instalación
npm list -g @modelcontextprotocol/server-postgres

# Test manual
npx @modelcontextprotocol/server-postgres postgresql://user:pass@localhost:5432/db
```

---

**¡Todo listo!** 🎉

**Próximo paso:** Lee [GETTING_STARTED.md](GETTING_STARTED.md) y empieza a programar.

**Última actualización:** 2026-03-11
