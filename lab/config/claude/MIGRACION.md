# 🔄 Migrar Configuración de Claude a Otros Proyectos

## 🎯 Filosofía: /lab/ es Portable

**Diseño:** Toda la configuración de Claude está en `/lab/config/claude/` para que puedas copiarla fácilmente a otros proyectos.

---

## 📦 Qué Migrar

### Estructura Completa (/lab/)
```
lab/
├── config/claude/          # ← Configuración de Claude
│   ├── templates/          # Plantillas (source of truth)
│   ├── agents/             # Agentes personalizados
│   ├── install.sh          # Script de instalación
│   ├── install-mcp-custom.sh  # MCP personalizado
│   └── *.md               # Documentación
├── context/                # (opcional) Contexto del proyecto
├── spec/                   # (opcional) Especificaciones
└── ...
```

---

## 🚀 Métodos de Migración

### Método 1: Copiar /lab/ Completo (Recomendado)

**Cuándo:** Proyectos similares a VersatileHub

```bash
# 1. En el nuevo proyecto
cd /ruta/nuevo-proyecto

# 2. Copiar todo /lab/
cp -r /opt/ATS/VersatileHub/lab .

# 3. Instalar configuraciones
./lab/config/claude/install.sh

# 4. (Opcional) Configurar MCP
./lab/config/claude/install-mcp-custom.sh

# 5. Reiniciar VS Code
# Ctrl+Shift+P → "Developer: Reload Window"
```

**Resultado:** Configuración completa migrada + documentación

---

### Método 2: Solo Claude Config (Proyectos sin /lab/)

**Cuándo:** Proyectos que no usan estructura /lab/

```bash
# 1. Crear directorio en el nuevo proyecto
cd /ruta/nuevo-proyecto
mkdir -p .claude

# 2. Copiar configuración
cp -r /opt/ATS/VersatileHub/lab/config/claude/* .claude/

# 3. Instalar
./.claude/install.sh

# 4. Reiniciar VS Code
```

---

### Método 3: Template Empaquetado (Distribución)

**Cuándo:** Compartir con equipo o múltiples proyectos

```bash
# === CREAR PAQUETE ===
cd /opt/ATS/VersatileHub
tar -czf claude-config-v1.tar.gz \
    lab/config/claude/templates/ \
    lab/config/claude/agents/ \
    lab/config/claude/install.sh \
    lab/config/claude/*.md

# === DISTRIBUIR ===
# Subir a GitHub releases, compartir por email, etc.

# === INSTALAR EN NUEVO PROYECTO ===
cd /nuevo-proyecto
tar -xzf claude-config-v1.tar.gz
./lab/config/claude/install.sh
```

---

## 🎨 Personalizar para Proyecto Específico

### Paso 1: Copiar Base
```bash
cp -r /opt/ATS/VersatileHub/lab/config/claude /nuevo-proyecto/config/
```

### Paso 2: Editar Agentes

**Eliminar agentes no relevantes:**
```bash
cd /nuevo-proyecto/config/claude/agents
rm frappe-expert.json  # No necesito Frappe en este proyecto
```

**Crear agente específico del proyecto:**
```bash
# Copiar template
cp versatilehub-assistant.json mi-proyecto-assistant.json

# Editar y personalizar
nano mi-proyecto-assistant.json
```

**Ejemplo de agente personalizado:**
```json
{
  "name": "react-native-expert",
  "description": "Experto en React Native y desarrollo móvil",
  "systemPrompt": "Eres un experto en React Native...",
  "mode": "code",
  "capabilities": [
    "Desarrollo de componentes móviles",
    "Navegación con React Navigation",
    "Estado con Redux/Context",
    "APIs nativas y puentes"
  ],
  "preferredTools": ["expo", "react-native-cli"],
  "codeStyle": {
    "language": "typescript",
    "framework": "react-native"
  }
}
```

### Paso 3: Actualizar .clinerules

```bash
nano /nuevo-proyecto/config/claude/templates/.clinerules
```

Cambiar referencias específicas del proyecto:
- Nombres de servicios
- Estructura de directorios
- Comandos Docker
- URLs y dominios

### Paso 4: Instalar
```bash
./config/claude/install.sh
```

---

## 📋 Checklist de Migración

### ✅ Antes de Migrar
- [ ] Identificar qué parte necesitas (todo /lab/ o solo Claude)
- [ ] Decidir si usarás agentes personalizados existentes
- [ ] Verificar si el nuevo proyecto usa Docker/similar

### ✅ Durante la Migración
- [ ] Copiar archivos a nueva ubicación
- [ ] Editar templates según necesidad
- [ ] Personalizar agentes si es necesario
- [ ] Ejecutar install.sh

### ✅ Después de Migrar
- [ ] Reiniciar VS Code
- [ ] Verificar que .clinerules está cargado
- [ ] Probar GitHub Copilot (Ctrl+I)
- [ ] (Opcional) Configurar MCP si lo necesitas
- [ ] Actualizar .gitignore

---

## 🔧 Adaptación por Tipo de Proyecto

### Proyecto Next.js/React
```bash
# Agente sugerido: versatilehub-assistant (ya incluido)
# Foco: TypeScript, React, componentes, APIs
```

### Proyecto Django/Flask
```bash
# Crear agente: python-backend-expert.json
# Foco: Python, Django ORM, API REST, pytest
```

### Proyecto Node.js/Express
```bash
# Agente sugerido: versatilehub-assistant (adaptar)
# Foco: Node, Express, MongoDB/PostgreSQL, microservicios
```

### Proyecto Mobile (React Native)
```bash
# Crear agente: mobile-expert.json
# Foco: Components, Navigation, Native modules, Performance
```

### Proyecto DevOps
```bash
# Foco en: Docker, K8s, Terraform, CI/CD
# Usar templates Docker existentes de VersatileHub
```

---

## 🗂️ Estructura de .gitignore

Agregar al .gitignore del nuevo proyecto:

```gitignore
# Archivos instalados de Claude (templates están en lab/)
/.clinerules
/.github/copilot-instructions.md
/.vscode/settings.json
/.vscode/extensions.json

# Backups
/.backups/

# MCP config local
/.mcp.json

# Pero versionar los templates:
!/lab/config/claude/templates/
```

---

## 🎯 Casos de Uso Comunes

### Caso 1: Mismo Stack, Diferente Cliente

**Situación:** Cliente nuevo con proyecto similar a VersatileHub

```bash
# Copiar todo /lab/
cp -r /versatilehub/lab /cliente-nuevo/

# Editar solo lo específico
cd /cliente-nuevo/lab/config/claude/templates
nano .clinerules  # Cambiar nombres de proyecto
nano copilot-instructions.md  # Actualizar contexto

# Reinstalar
cd /cliente-nuevo
./lab/config/claude/install.sh --force
```

### Caso 2: Stack Diferente, Aprovechar Estructura

**Situación:** Proyecto Python Django (no microservicios)

```bash
# Copiar solo Claude config
cp -r /versatilehub/lab/config/claude /django-project/.claude/

# Eliminar agentes irrelevantes
rm /django-project/.claude/agents/frappe-expert.json
rm /django-project/.claude/agents/versatilehub-assistant.json

# Crear agente Django
nano /django-project/.claude/agents/django-expert.json

# Adaptar .clinerules
nano /django-project/.claude/templates/.clinerules
# Cambiar referencias Docker por comandos Python/Django

# Instalar
cd /django-project
./.claude/install.sh
```

### Caso 3: Proyecto Personal Pequeño

**Situación:** Proyecto simple, solo necesito Copilot básico

```bash
# Copiar solo lo esencial
cp /versatilehub/lab/config/claude/templates/.clinerules /proyecto/.clinerules
cp /versatilehub/lab/config/claude/templates/copilot-instructions.md \
   /proyecto/.github/copilot-instructions.md

# Editar manualmente
nano /proyecto/.clinerules
nano /proyecto/.github/copilot-instructions.md

# No necesitas scripts ni agentes complejos
```

---

## 🔄 Mantener Configuración Actualizada

### Crear Repositorio de Templates

```bash
# Opción: Repo Git separado para configs
mkdir ~/claude-configs
cd ~/claude-configs

git init
cp -r /versatilehub/lab/config/claude/* .
git add .
git commit -m "Initial Claude config templates"

# Ahora en cualquier proyecto nuevo:
cd /nuevo-proyecto
git clone file://~/claude-configs .claude
./.claude/install.sh
```

### Versionar Cambios

```bash
# En VersatileHub, cuando mejores la config:
cd /versatilehub/lab/config/claude
git tag -a claude-config-v1.1 -m "Added Notion MCP support"
git push origin claude-config-v1.1

# En otros proyectos, actualizar:
cd /otro-proyecto/lab/config/claude
git fetch origin
git checkout claude-config-v1.1
./install.sh --force
```

---

## 📚 Archivos Clave a Personalizar

### 1. `.clinerules` (Comportamiento de Claude)
**Qué cambiar:**
- Nombres de servicios
- Estructura de directorios
- Comandos específicos del proyecto
- Agentes disponibles

### 2. `copilot-instructions.md` (Contexto para Copilot)
**Qué cambiar:**
- Descripción del proyecto
- Stack tecnológico
- Convenciones de código
- Servicios y componentes

### 3. `agents/*.json` (Agentes especializados)
**Qué cambiar:**
- Crear/eliminar según necesidad
- Adaptar comandos y herramientas
- Cambiar referencias a infraestructura

### 4. `vscode-settings.json` (Configuración VS Code)
**Qué cambiar:**
- Rutas específicas del proyecto
- Extensiones requeridas
- Linters y formatters

---

## 🎓 Ejemplo Completo: Migración a Proyecto E-commerce

```bash
# === PASO 1: COPIAR BASE ===
cd ~/proyectos/ecommerce-xyz
cp -r /opt/ATS/VersatileHub/lab .

# === PASO 2: PERSONALIZAR AGENTES ===
cd lab/config/claude/agents

# Eliminar agentes no relevantes
rm frappe-expert.json

# Editar agente general
nano versatilehub-assistant.json
# Cambiar:
# - name: "ecommerce-xyz-assistant"
# - description: "Experto en e-commerce con Next.js y Stripe"
# - capabilities: "Next.js 15, Stripe, PostgreSQL, Redis"

# === PASO 3: ACTUALIZAR TEMPLATES ===
cd ../templates

# Editar .clinerules
nano .clinerules
# Cambiar:
# - PROJECT_NAME de "VersatileHub" a "EcommerceXYZ"
# - Servicios: "Frontend (Next.js), Backend (Nest.js), Database (PostgreSQL)"
# - Eliminar referencias a Traefik/Docker si no usas

# Editar copilot-instructions.md
nano copilot-instructions.md
# Actualizar:
# - Contexto del proyecto
# - Stack: Next.js 15, Nest.js, Stripe, PostgreSQL
# - Convenciones: API routes en /api/, componentes en /components/

# === PASO 4: INSTALAR ===
cd ~/proyectos/ecommerce-xyz
./lab/config/claude/install.sh

# === PASO 5: VERIFICAR ===
cat .clinerules | head -20
cat .github/copilot-instructions.md | head -20

# === PASO 6: REINICIAR VS CODE ===
# Ctrl+Shift+P → "Reload Window"

# === PASO 7: PROBAR ===
# Ctrl+I → "Ayúdame a crear un componente ProductCard con Stripe"
```

---

## 🆘 Troubleshooting

### Problema: Configuración no se aplica

**Solución:**
```bash
# Reinstalar con --force
./lab/config/claude/install.sh --force

# Verificar que archivos existen
ls -la .clinerules
ls -la .github/copilot-instructions.md

# Reiniciar VS Code COMPLETAMENTE (cerrar y abrir)
```

### Problema: Agentes no aparecen

**Solución:**
```bash
# Verificar que .clinerules menciona los agentes
grep -A5 "Agentes" .clinerules

# Verificar que archivos JSON existen
ls -la lab/config/claude/agents/

# Actualizar .clinerules si agregaste agentes nuevos
```

### Problema: MCP no funciona en nuevo proyecto

**Solución:**
```bash
# MCP es por usuario, no por proyecto
# Si ya configuraste en VersatileHub, debería funcionar en todos

# Verificar:
claude mcp list

# Si no aparece, reconfigurar:
./lab/config/claude/install-mcp-custom.sh
```

---

## 💡 Tips Pro

### Tip 1: Template Git Repo
Mantén un repositorio Git con tu configuración base de Claude y clónalo en proyectos nuevos.

### Tip 2: Make targets
Agrega a tu Makefile:
```makefile
.PHONY: install-claude
install-claude:
	./lab/config/claude/install.sh
	@echo "✅ Claude configurado"
```

### Tip 3: Docker Image con Config
Incluye la configuración en tu Docker image de desarrollo:
```dockerfile
COPY lab/config/claude /workspace/lab/config/claude
RUN /workspace/lab/config/claude/install.sh
```

### Tip 4: Documentar Cambios
Mantén un CHANGELOG en lab/config/claude/:
```markdown
## v1.2 - 2026-03-11
- Added Notion MCP support
- Created Frappe expert agent
- Improved .clinerules with Docker commands
```

---

**Última actualización:** 2026-03-11  
**Versión:** 1.0  
**Compatible con:** GitHub Copilot, Claude Code/Cline, MCP
