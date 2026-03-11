# Guía de Inicio Rápido - Programar con Claude Code

Configuración completa para desarrollar en VersatileHub con Claude Code.

## ⚡ Setup Rápido (5 minutos)

### 1. Instalar Configuraciones Base
```bash
# Instalar templates de Claude/Copilot
./lab/config/claude/install.sh

# Instalar MCP servers
./lab/config/claude/install-mcp.sh
```

### 2. Instalar Extensiones de VS Code
```bash
# GitHub Copilot (recomendado)
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat

# Cline/Claude Code (para agentes avanzados)
code --install-extension saoudrizwan.claude-dev
```

### 3. Configurar Autenticación

#### Para GitHub Copilot:
```bash
# Ya está si tienes GitHub Copilot Pro
# Selecciona Claude Sonnet 4.5:
# Ctrl+Shift+P → "GitHub Copilot: Select Model"
```

#### Para Cline (Claude Code):
```
1. Abre Cline en VS Code (ícono en la barra lateral)
2. Click en "Settings"
3. Selecciona método de autenticación:
   - Claude.ai Subscription ($20/mes - uso ilimitado)
   - Anthropic API Key (pay-per-use)
```

### 4. Configurar MCP (Opcional pero Recomendado)
```bash
# Editar configuración MCP
nano lab/config/claude/mcp-config.json

# Reemplazar PASSWORD_AQUI con tu contraseña de PostgreSQL

# En VS Code:
# Ctrl+Shift+P → "Cline: Open MCP Settings"
# Copiar contenido de mcp-config.json
```

### 5. Reload VS Code
```
Ctrl+Shift+P → "Reload Window"
```

## 🎯 Empezar a Programar

### Opción A: GitHub Copilot (Simple)

**Atajos:**
- `Ctrl+I` - Chat inline (mientras escribes código)
- `Ctrl+Shift+I` - Panel de chat lateral

**Ejemplos:**
```
// Mientras escribes código, Copilot sugiere automáticamente

// En el chat inline (Ctrl+I):
"Optimiza esta función para usar async/await"
"Agrega manejo de errores"
"Explica qué hace este código"

// En el panel (Ctrl+Shift+I):
"@workspace analiza la arquitectura de services/"
"#file:services/portal/docker-compose.yml optimiza este archivo"
"/tests genera tests para esta función"
```

### Opción B: Cline (Agentes Avanzados)

**Abrir Cline:**
- Click en ícono de Cline en barra lateral
- O `Ctrl+Shift+P` → "Cline: Open Chat"

**Ejemplos de uso:**

#### Tarea Simple (Solo lectura/análisis)
```
"Lee services/portal/docker-compose.yml y explica su configuración"
```

#### Tarea con Ejecución
```
"Crea un script de backup para PostgreSQL en services/chat/scripts/backup.sh 
siguiendo el patrón de lab/backups/.

El script debe:
1. Hacer dump de la base de datos
2. Comprimirlo
3. Guardarlo en data/backups/
4. Mantener solo últimos 7 días

Hazlo paso a paso y espera mi confirmación antes de escribir archivos."
```

Cline:
1. ✅ Te preguntará si puede crear el archivo
2. ✅ Mostrará el contenido antes de escribir
3. ✅ Esperará tu confirmación

#### Tarea Compleja (Multi-paso)
```
"Necesito crear un nuevo servicio de notificaciones en services/notifications/.

Requisitos:
- Node.js 20 con TypeScript
- Express para API REST
- PostgreSQL para almacenar notificaciones
- Redis para cola de jobs
- Integración con Traefik (notifications.midominio.com)
- Health check endpoint
- Logs estructurados
- Seguir estructura de services/agent/

Pasos:
1. Crea la estructura de directorios
2. Genera docker-compose.yml
3. Crea Dockerfile
4. Implementa API básica con endpoints:
   - POST /notifications (crear)
   - GET /notifications (listar)
   - GET /notifications/:id (obtener)
   - GET /health (health check)
5. Configura variables de entorno
6. Agrega configuración de Traefik
7. Crea README.md en español
8. Genera script de inicialización

Hazlo paso a paso y pide confirmación en cada paso importante."
```

Cline:
1. Planificará los pasos
2. Creará archivos uno por uno
3. Pedirá confirmación antes de ejecutar comandos
4. Verificará que todo funcione

## 🔌 Usar MCP (Acceso a Bases de Datos)

Una vez configurado MCP:

```
"Conecta a postgres-chat y muéstrame las últimas 10 conversaciones"

"Usando filesystem-services, analiza todos los docker-compose.yml 
y genera una tabla con:
- Nombre del servicio
- Puertos expuestos
- Bases de datos usadas
- Redes configuradas"

"Con git, muestra los últimos 5 commits y los archivos modificados"
```

## 🤖 Usar Agentes Personalizados

El agente `versatilehub-assistant` ya está configurado en `.clinerules`.

**Comandos especializados:**

### Crear Nuevo Servicio
```
"Usando el workflow newService, crea un servicio llamado 'analytics'"
```

### Optimizar Servicio
```
"Ejecuta workflow optimizeService en services/portal/"
```

### Debug
```
"Ejecuta workflow debugService para services/chat/"
```

## 💡 Tips para Mejores Resultados

### 1. Sé Específico
```
❌ "Arregla el código"
✅ "Optimiza esta función para reducir complejidad ciclomática 
    y agregar manejo de errores con try/catch"

❌ "Crea un servicio"
✅ "Crea un servicio de 'analytics' siguiendo la estructura de 
    services/agent con PostgreSQL, Express TypeScript y integración Traefik"
```

### 2. Da Contexto
```
"El servicio chat en services/chat/ usa PostgreSQL y Redis. 
Necesito optimizar el docker-compose.yml para:
- Reducir tiempo de inicio
- Agregar health checks robustos
- Limitar memoria a 512MB
- Usar secrets de Docker en lugar de variables de entorno"
```

### 3. Pide Pasos
```
"... hazlo paso a paso y explica cada cambio antes de aplicarlo"
"... espera mi confirmación antes de ejecutar comandos"
"... después de cada cambio, valida que funcione"
```

### 4. Usa Referencias
```
"@workspace analiza la arquitectura"
"#file:services/portal/docker-compose.yml revisa este archivo"
"Siguiendo el patrón de services/agent/, crea..."
```

## 🛡️ Configuración de Seguridad

### Permisos de Cline

Configuración recomendada en settings:

```json
{
  "cline.autoApproveAll": false,                    // IMPORTANTE: siempre false
  "cline.autoApproveFileReads": true,              // OK: solo lectura
  "cline.autoApproveFileWrites": false,            // Te pregunta antes de escribir
  "cline.autoApproveShellCommands": false,         // Te pregunta antes de ejecutar
  "cline.experimental.allowFileOperations": true,   // Permitir crear archivos
  "cline.experimental.allowShellCommands": true     // Permitir comandos (con confirmación)
}
```

### Comandos Seguros vs Peligrosos

**✅ Seguros (Cline puede ejecutar):**
```bash
docker compose ps
docker compose logs [servicio]
cat archivo.txt
ls -la
git status
git log
```

**⚠️ Requieren confirmación:**
```bash
docker compose down [servicio]
docker compose restart [servicio]
rm archivo.txt
git commit -m "..."
```

**❌ Nunca auto-aprobar:**
```bash
rm -rf /
docker system prune -a --volumes
DROP DATABASE
git push --force
```

## 📊 Workflows Comunes

### Desarrollo Diario
1. Abre VS Code en `/opt/ATS/VersatileHub`
2. `Ctrl+I` para sugerencias mientras escribes
3. `Ctrl+Shift+I` para consultas sobre el proyecto
4. Usa Cline para tareas complejas

### Crear Feature Nueva
1. Cline: "Crea estructura para feature X..."
2. Copilot: Sugerencias mientras implementas
3. Cline: "Genera tests para X..."
4. Copilot: `Ctrl+I` → "Documenta esta función"

### Debugging
1. Ver logs: `docker compose logs -f [servicio]`
2. Cline: "Analiza estos logs y diagnostica..."
3. Cline: "Propón solución y aplícala si apruebo"
4. Verificar: `docker compose ps`

### Refactorización
1. Cline: "Analiza services/X/ y sugiere mejoras..."
2. Review manual de sugerencias
3. Cline: "Implementa la mejora Y..."
4. Testing: `docker compose up -d`

## 🐛 Troubleshooting

### Copilot no sugiere
```bash
# Verificar modelo seleccionado
Ctrl+Shift+P → "GitHub Copilot: Select Model" → Claude Sonnet 4.5

# Reload
Ctrl+Shift+P → "Reload Window"
```

### Cline no responde
```bash
# Verificar autenticación
Cline → Settings → Re-authenticate

# Ver logs
Ctrl+Shift+P → "Cline: Show Logs"

# Reinstalar
code --uninstall-extension saoudrizwan.claude-dev
code --install-extension saoudrizwan.claude-dev
```

### MCP no conecta
```bash
# Ver logs MCP
Ctrl+Shift+P → "Cline: Show MCP Logs"

# Verificar configuración
cat lab/config/claude/mcp-config.json

# Test manual
npx @modelcontextprotocol/server-postgres postgresql://user:pass@localhost:5432/db
```

## 📚 Documentación Completa

- [lab/CLAUDE.md](../../CLAUDE.md) - Guía detallada completa
- [lab/config/claude/MCP_SETUP.md](MCP_SETUP.md) - Configuración MCP
- [lab/config/claude/agents/README.md](agents/README.md) - Agentes personalizados
- [lab/QUICK_REFERENCE.md](../../QUICK_REFERENCE.md) - Referencia rápida

## 🎓 Próximos Pasos

1. ✅ Prueba comandos simples con Copilot
2. ✅ Experimenta con Cline en tareas no críticas
3. ✅ Configura MCP para bases de datos
4. ✅ Crea tu primer agente personalizado
5. ✅ Integra en tu workflow diario

---

**¡Listo para programar!** 🚀

Empieza con: `Ctrl+Shift+I` → "@workspace explica la arquitectura de VersatileHub"
