# Integración de Claude Code en VersatileHub

**Fecha:** 2026-03-11  
**Estado:** Configurado ✅

## 🚀 Inicio Rápido

**¿Primera vez?** → Lee [config/claude/GETTING_STARTED.md](config/claude/GETTING_STARTED.md)

**Setup completo en 5 minutos:**

```bash
# 1. Instalar configuraciones
./lab/config/claude/install.sh

# 2. Instalar MCP (opcional)
./lab/config/claude/install-mcp.sh

# 3. Instalar extensiones
code --install-extension GitHub.copilot
code --install-extension saoudrizwan.claude-dev

# 4. Reload VS Code
# Ctrl+Shift+P → "Reload Window"
```

**Ver configuración completa:** [config/claude/SUMMARY.md](config/claude/SUMMARY.md)

## 📚 Guías Disponibles

### 🎯 Para Usuarios
- **[config/claude/GETTING_STARTED.md](config/claude/GETTING_STARTED.md)** - Guía de inicio rápido
- **[config/claude/SUMMARY.md](config/claude/SUMMARY.md)** - Resumen de configuración
- **[config/claude/INTEGRACIONES.md](config/claude/INTEGRACIONES.md)** - ⭐ Todas las integraciones MCP
- **[config/claude/MIGRACION.md](config/claude/MIGRACION.md)** - 🔄 Migrar a otros proyectos
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Comandos rápidos

### 🔧 Para Configuración
- **[config/claude/README.md](config/claude/README.md)** - Configuración general
- **[config/claude/MCP_SETUP.md](config/claude/MCP_SETUP.md)** - Setup de MCP servers
- **[config/claude/NOTION_SETUP.md](config/claude/NOTION_SETUP.md)** - 📝 Integración con Notion
- **[config/claude/FRAPPE_SETUP.md](config/claude/FRAPPE_SETUP.md)** - ⭐ Agente Frappe/ERPNext
- **[config/claude/agents/README.md](config/claude/agents/README.md)** - Agentes personalizados

### 📖 Documentación Técnica
Esta guía (más abajo) contiene toda la información técnica detallada.

## 🤖 Acerca de Claude Code

Hay **dos formas diferentes** de usar Claude en VS Code:

### 1️⃣ GitHub Copilot Pro con Claude (RECOMENDADO ✅)
- **Costo**: Ya incluido en GitHub Copilot Pro ($10/mes)
- **Extensión**: GitHub Copilot + GitHub Copilot Chat
- **Modelo**: Claude Sonnet 4.5
- **Suficiente para**: 99% de casos de uso en desarrollo

### 2️⃣ Extensión Claude Code de Anthropic
- **Costo**: Requiere Claude Pro ($20/mes) o API key ADICIONAL
- **Extensión**: "Claude Dev" o "Claude Code"
- **Ventajas**: Agentes más avanzados, modo agentic coding
- **Solo necesario si**: Requieres funciones avanzadas específicas

**💡 Si ya tienes GitHub Copilot Pro, NO necesitas pagar Claude adicional.**

## 📦 Instalación en Visual Studio Code

### ✅ Opción A: GitHub Copilot con Claude (Ya tienes esto)

#### 1. Instalar extensiones (Ya hecho ✅)
```bash
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
```

#### 2. Seleccionar Claude como modelo
1. Abre Command Palette (`Ctrl+Shift+P`)
2. Busca "GitHub Copilot: Select Model"
3. Selecciona "Claude Sonnet 4.5"
4. ¡Listo! Ya puedes usar Claude

#### 3. Empezar a usar
```bash
# Atajos de teclado
Ctrl+I          # Chat inline (en el editor)
Ctrl+Shift+I    # Panel de chat lateral

# Comandos especiales en el chat
@workspace      # Consultar todo el proyecto
#file:nombre.js # Referenciar archivo específico
/explain        # Explicar código seleccionado
/fix            # Sugerir correcciones
/tests          # Generar tests
```

### 🔧 Opción B: Extensión Claude Code (Pago adicional)

**Solo sigue esto si necesitas funciones avanzadas de agentes**

#### 1. Instalar extensión
```bash
# Buscar en VS Code Extensions
# "Claude Dev" o "Cline" (fork popular)
```

#### 2. Autenticación
Opciones de login:
- **Claude.ai Subscription**: Claude Pro ($20/mes)
- **Anthropic Console**: API key (pay per use)
- **Bedrock/Foundry/Vertex**: Providers de terceros

#### 3. Funciones adicionales
- Agentes autónomos que ejecutan tareas
- Modo "agentic coding" (crea archivos, ejecuta comandos)
- Memoria persistente entre sesiones
- Integración con MCP (Model Context Protocol)

#### 4. Cuándo vale la pena
- Proyectos grandes que requieren refactorización masiva
- Necesitas que el agente ejecute comandos automáticamente
- Quieres usar MCP servers (bases de datos, APIs, etc)
- Desarrollo de features complejas multi-archivo

**💰 Costo-beneficio**: Para la mayoría de proyectos, GitHub Copilot Pro es suficiente.

## 🔧 Configuración en VS Code

### Configuración recomendada para VersatileHub

Agrega a `.vscode/settings.json`:
```json
{
  "github.copilot.enable": {
    "*": true,
    "yaml": true,
    "plaintext": false,
    "markdown": true
  },
  "github.copilot.editor.enableAutoCompletions": true,
  "chat.editor.wordWrap": "on"
}
```

## 🎯 Casos de uso en VersatileHub

### 1. Desarrollo de Servicios
```
# Ejemplo: Crear nuevo microservicio
"Ayúdame a crear un nuevo servicio en services/ siguiendo la estructura existente"
```

### 2. Scripts de Automatización
```
# Ejemplo: Generar scripts de deployment
"Crea un script de deployment para el servicio portal que verifique dependencias"
```

### 3. Documentación
```
# Ejemplo: Generar documentación técnica
"Documenta la arquitectura del servicio chat/ en formato markdown"
```

### 4. Docker y Compose
```
# Ejemplo: Optimizar configuración
"Revisa docker-compose.yml y sugiere optimizaciones de seguridad"
```

### 5. Debugging
```
# Ejemplo: Analizar logs
"El servicio agent/ falla al iniciar, ayúdame a diagnosticar desde los logs"
```

## 🚀 Comandos Útiles

### Usando GitHub Copilot (ya configurado)
- `Ctrl+I` - Inline chat (sugerencias en línea)
- `Ctrl+Shift+I` - Abrir panel de chat
- `@workspace` - Consultar sobre todo el workspace
- `#file:nombre.js` - Referenciar archivo específico
- `/explain` - Explicar código seleccionado
- `/fix` - Sugerir correcciones
- `/tests` - Generar tests

## 🤖 Agentes y Plugins

### ¿Qué son los agentes?
Los **agentes** son asistentes de IA que pueden:
- Ejecutar tareas de múltiples pasos automáticamente
- Leer y escribir archivos
- Ejecutar comandos en terminal
- Tomar decisiones sobre qué hacer a continuación

### GitHub Copilot (incluido en tu plan)
**Capacidades de agente básicas:**
- ✅ Leer archivos del proyecto
- ✅ Sugerir código
- ✅ Explicar y refactorizar
- ✅ Generar documentación
- ✅ Responder preguntas sobre el código
- ❌ No ejecuta comandos directamente
- ❌ No crea archivos automáticamente (solo sugiere)

**Ejemplo de uso:**
```
Usuario: "Analiza services/portal y sugiere optimizaciones"
Claude: [Lee archivos] → [Analiza] → [Sugiere cambios]
Usuario: [Revisa] → [Aplica cambios manualmente o los acepta]
```

### Claude Code / Extensions avanzadas
**Capacidades de agente completas (requiere pago adicional):**
- ✅ Todo lo de GitHub Copilot
- ✅ Ejecuta comandos en terminal
- ✅ Crea y modifica archivos automáticamente
- ✅ Instala dependencias
- ✅ Ejecuta tests y corrige errores
- ✅ Integración con MCP (Model Context Protocol)

**Ejemplo de uso agentic:**
```
Usuario: "Crea un nuevo servicio de notificaciones"
Agente: 
  1. [Crea directorio services/notifications/]
  2. [Crea docker-compose.yml]
  3. [Crea Dockerfile]
  4. [Instala dependencias necesarias]
  5. [Ejecuta docker compose up]
  6. [Verifica que funcione]
  7. ✅ "Servicio creado y funcionando"
```

### ¿Necesitas agentes avanzados?

**🟢 GitHub Copilot es suficiente si:**
- Quieres sugerencias y ayuda para escribir código
- Prefieres revisar y aprobar cambios manualmente
- Trabajas en desarrollo normal día a día
- **Esto cubre el 90% de casos de uso**

**🟡 Claude Code vale la pena si:**
- Necesitas automatización masiva (refactorizar 50+ archivos)
- Quieres que el agente ejecute tareas completas sin supervisión
- Trabajas con proyectos muy grandes
- Necesitas integración con bases de datos via MCP

### Archivos `.agent.ts` y `.prompt.md`

Estos son archivos de configuración para **extensiones avanzadas** (no GitHub Copilot):

```typescript
// .agent.ts - Define comportamiento de agentes personalizados
export default {
  name: "VersatileHub Assistant",
  skills: ["docker", "node", "python"],
  tools: ["terminal", "file-system"],
  context: {
    project: "VersatileHub microservices",
    services: ["agent", "chat", "flow", "hub", "portal"]
  }
}
```

```markdown
<!-- .prompt.md - Instrucciones personalizadas para el agente -->
# VersatileHub Development Agent

Cuando trabajes en este proyecto:
1. Siempre verifica docker-compose.yml
2. Usa variables de entorno desde .env
3. Documenta en español
4. Prueba con docker antes de confirmar
```

**📌 Con GitHub Copilot:** Usa `.github/copilot-instructions.md` (ya creado ✅)  
**📌 Con Claude Code:** Usa `.agent.ts` y `.prompt.md` (solo si pagas)

## 💡 Recomendación: Usar AMBOS

Puedes usar **GitHub Copilot + Claude Code juntos**:

### Setup Recomendado (lo mejor de ambos mundos)

```
✅ GitHub Copilot Pro → Para codificación diaria y sugerencias
✅ Claude Code → Para tareas complejas con agentes
```

**Ventajas de usar ambos:**
- GitHub Copilot para autocompletado rápido
- Claude Code para refactorizaciones masivas
- Dos "asistentes" con diferentes fortalezas

## 🎯 Configuración Completa de Claude Code

Si quieres las funciones avanzadas de agentes, sigue estos pasos:

### 1️⃣ Extensión a instalar

La mejor opción es **"Cline"** (fork popular de Claude Dev):

```bash
# Opción A: Desde VS Code
# 1. Ctrl+Shift+X (Extensions)
# 2. Busca "Cline" o "Claude Dev"
# 3. Instala "Cline - AI Coding Assistant"

# Opción B: CLI
code --install-extension saoudrizwan.claude-dev
```

**¿Por qué Cline?**
- ✅ Más activo y mantenido que Claude Dev original
- ✅ Mejores agentes y más rápido
- ✅ Soporta múltiples providers (Claude, OpenAI, etc)
- ✅ Gratis y open source

### 2️⃣ Autenticación (Elige una opción)

#### Opción A: Claude Pro (Recomendado para uso intensivo)
**Costo**: $20/USD al mes
1. Ve a [claude.ai](https://claude.ai) y contrata Claude Pro
2. En VS Code, abre Cline
3. Selecciona "Login with Claude.ai"
4. Autentica con tu cuenta

**Ventajas:**
- Uso ilimitado de Claude Sonnet
- Acceso a Claude Opus (más potente)
- Sin preocuparte por costos por token

#### Opción B: Anthropic API (Pay-as-you-go)
**Costo**: ~$3 USD per 1M tokens input, $15 USD per 1M tokens output
1. Crea cuenta en [console.anthropic.com](https://console.anthropic.com)
2. Genera una API key
3. Carga créditos (mínimo $5)
4. En Cline, selecciona "Anthropic API"
5. Pega tu API key

**Ventajas:**
- Solo pagas lo que usas
- Bueno para uso ocasional
- Más control sobre gastos

#### Opción C: OpenRouter (Múltiples modelos)
**Costo**: Variable según modelo
1. Cuenta en [openrouter.ai](https://openrouter.ai)
2. Agrega créditos
3. Genera API key
4. En Cline, selecciona "OpenRouter"

**Ventajas:**
- Acceso a múltiples modelos (Claude, GPT-4, etc)
- Más económico para ciertos modelos
- Flexibilidad

### 3️⃣ Configurar en VS Code

Una vez instalado Cline:

1. **Abrir Cline**: Click en el ícono de Cline en la barra lateral
2. **Configurar modelo**:
   ```
   - Model: Claude Sonnet 4.5 (recomendado)
   - API Provider: Tu opción elegida
   - Max Tokens: 8192 (ajustar según necesidad)
   ```

3. **Configurar permisos de agente**:
   ```json
   // Settings en Cline
   {
     "cline.experimental.allowFileOperations": true,
     "cline.experimental.allowShellCommands": true,
     "cline.experimental.allowBrowserControl": false,
     "cline.autoApproveAll": false  // IMPORTANTE: mantener en false
   }
   ```

### 4️⃣ Archivos de Configuración para Agentes

Ahora sí necesitas crear archivos específicos:

#### A. `.clinerules` (Instrucciones para Cline)

Crea en la raíz del proyecto: **✅ YA CREADO** en [.clinerules](.clinerules)

Este archivo le dice a Cline:
- Contexto del proyecto VersatileHub
- Reglas de desarrollo
- Qué puede y no puede hacer
- Patrones de código
- Comandos útiles

#### B. `.cursorrules` (Si usas Cursor IDE)

Similar a Cline, pero para Cursor:

```bash
# Copia desde .clinerules
cp .clinerules .cursorrules
```

#### C. Archivos específicos por servicio (opcional)

Puedes crear instrucciones específicas:

```bash
# Ejemplo: services/portal/.clinerules
"Este es el servicio de portal web (Next.js + TypeScript).
Puerto: 3000
Framework: Next.js 14
Estado: En desarrollo"
```

### 5️⃣ Uso de Agentes con Cline

#### Abrir Cline
1. Click en el ícono de Cline en la barra lateral (o `Ctrl+Shift+P` → "Cline: Open")
2. Verás un chat similar a ChatGPT pero con superpoderes

#### Comandos de Agente

**Tareas Simples:**
```
"Lee services/portal/docker-compose.yml y explícalo"
```

**Tareas con Ejecución:**
```
"Crea un script de backup para PostgreSQL en services/chat/scripts/backup.sh 
siguiendo el patrón de lab/backups/"
```

El agente:
1. ✅ Preguntará si puede crear el archivo
2. ✅ Creará el archivo con el contenido
3. ✅ Te mostrará el resultado
4. ⚠️ Pedirá confirmación antes de ejecutar

**Tareas Complejas (Multi-paso):**
```
"Quiero crear un nuevo servicio de notificaciones que:
1. Use Node.js con Express
2. Tenga integración con Traefik
3. Use PostgreSQL para persistencia
4. Siga la estructura de services/agent/
Hazlo paso por paso y explica cada cambio"
```

El agente:
1. Planificará los pasos
2. Creará estructura de directorios
3. Generará docker-compose.yml
4. Creará Dockerfile
5. Configurará variables de entorno
6. Agregará configuración de Traefik
7. Creará README.md
8. **Te pedirá confirmación en cada paso importante**

#### Modo de Aprobación

**Recomendado para empezar**:
```json
"cline.autoApproveAll": false
```

Así revisas cada cambio antes de aplicarlo.

**Para tareas conocidas**:
```json
"cline.autoApproveFileReads": true,
"cline.autoApproveFileWrites": false,
"cline.autoApproveShellCommands": false
```

Lee archivos automáticamente, pero pide permiso para escribir o ejecutar.

### 6️⃣ Uso Avanzado: MCP Servers

MCP (Model Context Protocol) permite a Cline acceder a recursos externos:

#### ¿Qué es MCP?
Servidores que Dan a Claude acceso a:
- 🗄️ Bases de datos (PostgreSQL, MySQL, MongoDB)
- 🌐 APIs externas (GitHub, Slack, etc)
- 📂 Sistemas de archivos remotos
- 🔍 Búsquedas en internet
- 💾 Caches y memorias persistentes

#### Configurar MCP para VersatileHub

```json
// En settings de Cline
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", 
               "postgresql://user:pass@localhost:5432/chatwoot"],
      "env": {
        "PGHOST": "localhost",
        "PGPORT": "5432"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem",
               "/opt/ATS/VersatileHub/services"]
    }
  }
}
```

Con esto, Cline puede:
```
"Conecta a la base de datos de chat y muéstrame las últimas conversaciones"
"Analiza todos los docker-compose.yml en services/ y genera un reporte"
```

#### MCP Servers Útiles para VersatileHub

1. **PostgreSQL MCP** - Acceso a bases de datos
2. **Filesystem MCP** - Acceso avanzado a archivos
3. **Git MCP** - Operaciones de Git
4. **Notion MCP** - Sincronización con Notion (⭐ NUEVO)
5. **Docker MCP** (custom) - Control de containers
6. **Slack MCP** - Notificaciones

**📝 Integración con Notion:**  
Ver guía completa: [config/claude/NOTION_SETUP.md](config/claude/NOTION_SETUP.md)

Quick start:
```bash
# 1. Instalar
./lab/config/claude/install-mcp-custom.sh  # Opción 4

# 2. Configurar token
echo 'export NOTION_API_KEY="secret_xxx"' >> ~/.bashrc

# 3. Usar
"Lista mis páginas de Notion con tag 'VersatileHub'"
```

**Casos de uso:**
- Sincronizar documentación entre Notion y el repo
- Crear tareas automáticamente desde bugs
- Generar reportes desde bases de datos de Notion

### 7️⃣ Costos Estimados

#### Con Claude Pro ($20/mes)
- ✅ **Uso ilimitado** de Claude Sonnet
- ✅ Acceso a Claude Opus
- ✅ Sin preocupación por tokens
- 💰 **Recomendado** si usas >4 horas/semana

#### Con API Pay-as-you-go
**Claude Sonnet 4.5**:
- Input: $3/1M tokens (~750k palabras)
- Output: $15/1M tokens (~750k palabras)

**Ejemplo de uso típico:**
- 1 tarea compleja (~10k tokens): $0.03 - $0.15
- 1 hora de desarrollo (~50k tokens): $0.15 - $0.75
- 1 día de trabajo (~200k tokens): $0.60 - $3.00

**Típicamente**: $10-30/mes para uso moderado

### 8️⃣ GitHub Copilot vs Cline - Cuándo usar cada uno

#### Usa GitHub Copilot (`Ctrl+I`) para:
- ✅ Autocompletado mientras escribes
- ✅ Sugerencias rápidas en línea
- ✅ Explicar fragmentos de código
- ✅ Generar funciones simples
- ✅ Refactorizar código existente
- ✅ Preguntas sobre el código

#### Usa Cline (panel lateral) para:
- ✅ Crear servicios completos desde cero
- ✅ Refactorizar múltiples archivos
- ✅ Ejecutar comandos de testing
- ✅ Debugging complejo con logs
- ✅ Generar documentación completa
- ✅ Tareas que requieren múltiples pasos

#### Workflow Combinado (Lo mejor de ambos)

```
1. Arquitectura → Cline
   "Diseña la estructura para un servicio de notificaciones"

2. Implementación base → Cline
   "Crea los archivos base con la estructura"

3. Desarrollo del código → Copilot
   [Escribes código y Copilot sugiere mientras tipeas]

4. Testing y debugging → Cline
   "Ejecuta los tests y corrige los errores que encuentres"

5. Documentación → Cline
   "Genera README.md completo con ejemplos de uso"
```

### 9️⃣ Ejemplos Prácticos para VersatileHub

#### Ejemplo 1: Crear Nuevo Servicio

**Prompt para Cline:**
```
Necesito crear un nuevo servicio de "analytics" en VersatileHub.

Requisitos:
- Node.js con Express
- PostgreSQL para almacenar métricas
- Integración con Traefik (analytics.midominio.com)
- Health check endpoint
- Seguir la estructura de services/agent/

Pasos:
1. Crea la estructura de directorios
2. Genera docker-compose.yml siguiendo los patrones del proyecto
3. Crea Dockerfile optimizado para producción
4. Configura variables de entorno necesarias
5. Agrega configuración de Traefik
6. Crea README.md en español
7. Genera un script de inicialización en scripts/setup.sh

Hazlo paso a paso y espera mi confirmación en cada paso importante.
```

**Cline hará:**
1. Leerá `.clinerules` para entender el proyecto
2. Analizará `services/agent/` como referencia
3. Creará cada archivo pidiendo confirmación
4. Ejecutará comandos si le das permiso
5. Verificará que todo funcione

#### Ejemplo 2: Optimizar Servicio Existente

**Prompt para Cline:**
```
Analiza el servicio services/portal/ y optimízalo:

1. Revisa docker-compose.yml para mejoras de seguridad
2. Verifica que tenga health checks apropiados
3. Optimiza el Dockerfile para builds más rápidos
4. Sugiere mejoras en variables de entorno
5. Analiza logs con: docker compose logs portal --tail=100

Genera un reporte con:
- Problemas encontrados
- Mejoras sugeridas con justificación
- Cambios propuestos (no los apliques todavía)
```

#### Ejemplo 3: Debugging Complejo

**Prompt para Cline:**
```
El servicio chat no está arrancando correctamente.

Diagnóstico completo:
1. Revisa logs: docker compose -f services/chat/docker-compose.yml logs
2. Verifica conectividad de red: docker network inspect versatilehub-network
3. Comprueba variables de entorno del container
4. Verifica que PostgreSQL esté accesible
5. Revisa health checks

Identifica el problema y propón solución.
```

#### Ejemplo 4: Migración y Refactorización

**Prompt para Cline:**
```
Necesito migrar el servicio hub/ de MariaDB a PostgreSQL.

Plan:
1. Analiza la configuración actual de hub/
2. Crea un script de migración de datos
3. Genera nuevo docker-compose.yml con PostgreSQL
4. Actualiza variables de entorno
5. Crea script de rollback por si falla
6. Documenta el proceso en lab/spec/hub-migration.md

IMPORTANTE: No ejecutes la migración, solo prepara todo.
```

#### Ejemplo 5: Generar Documentación

**Prompt para Cline:**
```
Genera documentación completa para el proyecto:

1. Actualiza README.md principal con:
   - Descripción de todos los servicios
   - Instrucciones de instalación
   - Comandos útiles
   - Troubleshooting común

2. Crea lab/spec/api-documentation.md analizando:
   - Endpoints de cada servicio
   - Puertos utilizados
   - Integraciones entre servicios

3. Genera diagrama de arquitectura en formato Mermaid

Usa formato markdown con emojis para mejor legibilidad.
```

#### Ejemplo 6: Testing Automatizado

**Prompt para Cline:**
```
Configura testing para VersatileHub:

1. Crea scripts de health check para todos los servicios
2. Genera script de smoke tests en lab/scripts/test-all.sh
3. Configura script para verificar:
   - Todos los containers están running
   - Servicios responden en sus puertos
   - Redes están correctamente configuradas
   - Traefik está ruteando correctamente

4. Ejecuta los tests y reporta resultados
```

## 🔐 Seguridad y Mejores Prácticas con Agentes

### ⚠️ Precauciones Importantes

1. **Revisa antes de ejecutar comandos destructivos**
   ```
   ❌ PELIGROSO: "rm -rf /*"
   ❌ PELIGROSO: "docker system prune -a --volumes"
   ❌ PELIGROSO: "DROP DATABASE"
   
   ✅ SEGURO con confirmación: "docker compose down [servicio]"
   ✅ SEGURO con confirmación: "Respalda y elimina data antigua"
   ```

2. **Mantén autoApprove en false para comandos críticos**
   ```json
   {
     "cline.autoApproveShellCommands": false,  // IMPORTANTE
     "cline.autoApproveFileDeletes": false,     // IMPORTANTE
   }
   ```

3. **Backups antes de cambios importantes**
   ```
   "Antes de modificar services/chat, haz backup de la base de datos"
   ```

4. **No expongas credenciales**
   - Cline puede ver archivos `.env` si los lee
   - No compartas logs que contengan secrets
   - Usa variables de entorno, no hardcodees

### 📊 Monitoreo de Uso

#### Con Claude Pro
- Dashboard en claude.ai muestra uso
- Límites son generosos (prácticamente ilimitado para Sonnet)

#### Con API
```bash
# Ver uso en Anthropic Console
# https://console.anthropic.com/settings/usage

# Configurar alertas de gasto
# Settings → Billing → Set spending limits
```

#### Limitar costos con API

```json
// En configuración de Cline
{
  "cline.maxTokensPerRequest": 8192,  // Límite por request
  "cline.warningThreshold": 50000,    // Alerta en 50k tokens
}
```

## 📝 Archivos de Configuración del Proyecto

### ✅ Estructura Organizada en /lab

Todas las configuraciones de Claude/Copilot están en:
```
lab/config/claude/
├── README.md                          # Guía completa
├── install.sh                         # Script de instalación  
├── templates/                         # Plantillas maestras
│   ├── .clinerules                   # Reglas para Cline
│   ├── copilot-instructions.md       # Instrucciones para Copilot
│   ├── vscode-settings.json          # Configuración de VS Code
│   └── vscode-extensions.json        # Extensiones recomendadas
└── agents/                           # Agentes personalizados
    └── README.md
```

### 🚀 Instalación Rápida

Las configuraciones se **instalan** desde `/lab` a la raíz cuando las necesitas:

```bash
# Ejecutar desde la raíz del proyecto
./lab/config/claude/install.sh
```

**Esto copia:**
- `templates/.clinerules` → `/.clinerules`
- `templates/copilot-instructions.md` → `/.github/copilot-instructions.md`
- `templates/vscode-settings.json` → `/.vscode/settings.json`
- `templates/vscode-extensions.json` → `/.vscode/extensions.json`

**Nota**: Los archivos instalados están en `.gitignore`, la fuente de verdad está en `lab/config/claude/templates/`

### 📦 Beneficios de esta Estructura

1. **Portable**: Copia `lab/` a otro proyecto y ejecuta `install.sh`
2. **Versionado**: Templates en `lab/` se versionan, archivos instalados no
3. **Limpio**: Raíz del proyecto solo tiene archivos esenciales
4. **Reutilizable**: Migra configuraciones entre proyectos fácilmente

### 🔄 Workflow de Configuración

```bash
# 1. Editar plantilla (fuente de verdad)
nano lab/config/claude/templates/.clinerules

# 2. Reinstalar (actualizar archivos en raíz)
./lab/config/claude/install.sh --force

# 3. Reload VS Code
Ctrl+Shift+P → "Reload Window"
```

## 🔐 Variables de Entorno y API Keys

### Con GitHub Copilot Pro (lo que tienes)
**No necesitas configurar nada** ✅
- La autenticación es automática via GitHub
- No requiere API keys de Anthropic
- No hay variables de entorno que configurar

### Solo si usas Claude Code (pago adicional)
Si decides pagar Claude Pro, necesitarías:

```bash
# En .env (NO COMMITEAR - ya está en .gitignore)
ANTHROPIC_API_KEY=sk-ant-xxxxx
CLAUDE_MODEL=claude-sonnet-4-20250514
```

**Pero para tu caso actual, IGNORA esto** ❌

## 📊 Mejorar Resultados

### 1. Context perfecto
- Usa `@workspace` para que Claude vea todo el proyecto
- Menciona archivos específicos con `#file:`
- Referencias rutas absolutas cuando sea necesario

### 2. Prompts efectivos
```
❌ "Arregla el error"
✅ "El servicio chat en services/chat no inicia. Error: 'cannot connect to postgres'. 
    Revisa docker-compose.yml y sugiere solución"

❌ "Crea un servicio"
✅ "Crea un nuevo microservicio llamado 'analytics' en services/ 
    siguiendo la estructura de services/agent con:
    - Docker Compose
    - Nginx reverse proxy
    - Variables de entorno
    - README.md en español"
```

### 3. Iteración
```
1. "Explica la arquitectura de services/portal"
2. "Ahora sugiere cómo agregar autenticación OAuth"
3. "Implementa la solución que propusiste"
```

## 🛠️ Integración con Pipeline

### Pre-commit con Claude
```bash
# .git/hooks/pre-commit
#!/bin/bash
# Revisar cambios con Claude antes de commit
git diff --cached | claude "Revisa estos cambios y sugiere mejoras"
```

### CI/CD Review
```yaml
# .github/workflows/claude-review.yml
name: Claude Code Review
on: [pull_request]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Claude Review
        run: |
          # Integración con Claude para review automatizado
          echo "Implementar review con Claude"
```

## 📚 Recursos

### Documentación Oficial
- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [Claude API Docs](https://docs.anthropic.com/)
- [VS Code Copilot](https://code.visualstudio.com/docs/copilot/overview)

### Comandos útiles del proyecto
```bash
# Ver estructura del proyecto
tree -L 3 /opt/ATS/VersatileHub

# Verificar servicios activos
docker compose ps

# Logs de todos los servicios
docker compose logs -f

# Estado del entorno
./verify-environment.sh
```

## 🎓 Tips y Trucos

1. **Usa conversación multi-turno**: Claude recuerda el contexto
2. **Selecciona código**: Antes de preguntar, selecciona el código relevante
3. **Modo Agente**: Deja que Claude ejecute múltiples pasos automáticamente
4. **Memoria de sesión**: Claude puede recordar preferencias durante la sesión
5. **Archivos grandes**: Si un archivo es muy grande, pide a Claude que busque partes específicas

## 🐛 Troubleshooting

### GitHub Copilot

#### Claude no responde en VS Code
```bash
# 1. Verifica autenticación
gh auth status

# 2. Recarga VS Code
Ctrl+Shift+P > "Reload Window"

# 3. Verifica extensión
code --list-extensions | grep copilot

# 4. Revisar modelo seleccionado
Ctrl+Shift+P > "GitHub Copilot: Select Model"
```

#### Sugerencias lentas
- Reduce el tamaño del contexto
- Usa `#file:` en lugar de `@workspace`
- Cierra archivos innecesarios en VS Code

### Cline / Claude Code

#### No aparece en la barra lateral
```bash
# Reinstalar
code --uninstall-extension saoudrizwan.claude-dev
code --install-extension saoudrizwan.claude-dev

# Reload window
Ctrl+Shift+P > "Reload Window"
```

#### Error de autenticación
```
Error: "Invalid API key" o "Unauthorized"

Solución:
1. Verifica que tu suscripción de Claude Pro esté activa
2. Si usas API, verifica la key en console.anthropic.com
3. Regenera la API key si es necesario
4. En Cline settings, re-autentica
```

#### Agente no puede ejecutar comandos
```
Error: "Command execution disabled"

Solución:
1. Abre Settings (Ctrl+,)
2. Busca "Cline"
3. Habilita "experimental.allowShellCommands"
4. Reload window
```

#### Agente muy lento o se queda pensando
```
Posibles causas:
- Modelo muy grande (Opus) con contexto extenso
- MCP servers lentos
- Workspace muy grande

Soluciones:
1. Cambia a Claude Sonnet 4.5 (más rápido)
2. Reduce maxTokens en settings
3. Especifica archivos concretos instead de @workspace
4. Desactiva MCP servers temporalmente
```

#### Errores de permisos al escribir archivos
```bash
# Verifica permisos del directorio
ls -la /opt/ATS/VersatileHub/services/

# Corrige permisos si es necesario
sudo chown -R $USER:$USER /opt/ATS/VersatileHub/

# En settings de Cline
"cline.experimental.allowFileOperations": true
```

#### Consumo excesivo de tokens con API
```
Solución:
1. Usa Sonnet en lugar de Opus (más económico)
2. Limita maxTokens por request
3. Sé más específico en prompts
4. Evita "analiza todo el proyecto" sin contexto
5. Considera Claude Pro si usas >$20/mes
```

---

**Última actualización:** 2026-03-11  
**Mantenedor:** Equipo VersatileHub
