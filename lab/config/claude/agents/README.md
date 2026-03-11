# Agentes Personalizados para VersatileHub

Este directorio contiene configuraciones de agentes especializados para trabajar con VersatileHub.

## 🤖 ¿Qué son los Agentes?

Los agentes son asistentes de IA que pueden:
- Ejecutar múltiples tareas de forma autónoma
- Leer y escribir archivos
- Ejecutar comandos en terminal
- Tomar decisiones basadas en el contexto del proyecto

## 📋 Agentes Disponibles

### VersatileHub Assistant (Principal)
Agente principal para desarrollo en VersatileHub.

**Archivo:** `versatilehub-assistant.json`

**Especialidades:**
- Docker y Docker Compose
- Microservicios y arquitectura distribuida
- Node.js, TypeScript, Python
- Bases de datos (PostgreSQL, Redis, MariaDB)
- Traefik y configuración de reverse proxy
- CI/CD y deployment
- Debugging de containers

**Cuándo usarlo:**
- Crear nuevos servicios
- Optimizar servicios existentes
- Debugging de problemas
- Refactorización de código
- Documentación técnica

## 🎯 Casos de Uso

### 1. Crear Nuevo Servicio
```
"Crea un nuevo microservicio llamado 'notifications' siguiendo 
la estructura de services/agent con:
- Docker Compose
- PostgreSQL como base de datos
- API REST con Express
- Integración con Traefik"
```

**El agente:**
1. Crea directorio `services/notifications/`
2. Estructura: `config/`, `data/`, `scripts/`
3. Genera `docker-compose.yml`
4. Crea código base de la API
5. Configura variables de entorno
6. Agrega labels de Traefik
7. Actualiza documentación
8. Ejecuta y verifica

### 2. Optimizar Configuración
```
"Analiza todos los docker-compose.yml del proyecto y optimiza:
- Health checks
- Restart policies
- Recursos (memory, CPU limits)
- Seguridad (networks, secrets)"
```

**El agente:**
1. Lee todos los docker-compose.yml
2. Analiza configuración actual
3. Sugiere mejoras
4. Aplica cambios (con confirmación)
5. Valida sintaxis
6. Documenta cambios

### 3. Migrar Base de Datos
```
"Crea un script de migración para actualizar el schema de PostgreSQL
del servicio chat de v1 a v2, incluyendo:
- Backup antes de migrar
- Script de migración SQL
- Rollback si falla
- Validación post-migración"
```

**El agente:**
1. Crea script de backup
2. Genera SQL de migración
3. Crea script de rollback
4. Añade validaciones
5. Documenta proceso
6. Ejecuta en entorno de prueba

### 4. Debugging Automático
```
"El servicio portal no arranca, analiza logs y soluciona"
```

**El agente:**
1. Lee logs del contenedor
2. Identifica error
3. Busca solución en código/config
4. Aplica fix
5. Reinicia servicio
6. Verifica que funcione

## 🔧 Configurar Agente Personalizado

### Para Cline

1. Abre Cline settings: `Ctrl+Shift+P` → "Cline: Open Settings"
2. En "Custom Instructions", pega el contenido de `.clinerules`
3. (Opcional) Carga configuración de `versatilehub-assistant.json`

### Para GitHub Copilot

GitHub Copilot usa `.github/copilot-instructions.md` automáticamente.
No requiere configuración adicional de agentes.

## 📝 Crear Tu Propio Agente

### Plantilla Básica

```json
{
  "name": "mi-agente-custom",
  "version": "1.0.0",
  "description": "Agente especializado en...",
  "capabilities": {
    "codeGeneration": true,
    "fileOperations": true,
    "terminalCommands": true,
    "webSearch": false
  },
  "context": {
    "project": "VersatileHub",
    "focus": ["docker", "backend", "apis"],
    "excludePaths": [
      "**/node_modules/**",
      "**/data/**",
      "**/.git/**"
    ]
  },
  "rules": [
    "Siempre crear backups antes de cambios destructivos",
    "Validar sintaxis de YAML antes de guardar",
    "Documentar cambios en español",
    "Seguir convenciones del proyecto"
  ],
  "workflows": {
    "newService": {
      "steps": [
        "Crear estructura de directorios",
        "Generar docker-compose.yml",
        "Crear README.md",
        "Configurar variables de entorno",
        "Integrar con Traefik",
        "Documentar en lab/spec/"
      ]
    }
  }
}
```

### Guardar y Usar

1. Guarda tu agente en `lab/config/claude/agents/mi-agente.json`
2. Referéncialo en tu prompt:
   ```
   "Usando las reglas de mi-agente.json, crea..."
   ```

## 🚀 Comandos de Agente

### Comandos Básicos

```bash
# Listar agentes disponibles
ls lab/config/claude/agents/

# Ver configuración de un agente
cat lab/config/claude/agents/versatilehub-assistant.json

# Usar un agente específico (en Cline)
# En el chat: "@use versatilehub-assistant"
```

### Comandos Avanzados

```bash
# Ejecutar agente con contexto específico
# "@versatilehub-assistant optimize services/portal/"

# Agente con múltiples tareas
# "@versatilehub-assistant create new service 'analytics' with PostgreSQL and Redis"

# Debugging con agente
# "@versatilehub-assistant debug why chat service fails to start"
```

## 🎓 Mejores Prácticas

### 1. Define Claramente el Scope
```
❌ "Arregla el proyecto"
✅ "Optimiza docker-compose.yml de services/chat para reducir tiempo de inicio"
```

### 2. Proporciona Contexto
```
❌ "Crea un servicio"
✅ "Crea servicio 'notifications' siguiendo estructura de services/agent,
    usando PostgreSQL y Redis, con API REST en Express TypeScript"
```

### 3. Especifica Validaciones
```
✅ "... y valida que:
    - El servicio arranca sin errores
    - Responde en /health con status 200
    - Se conecta correctamente a PostgreSQL"
```

### 4. Pide Documentación
```
✅ "... y documenta los cambios en:
    - README.md del servicio
    - lab/spec/servicios.md
    - CHANGELOG.md"
```

## ⚠️ Limitaciones

### GitHub Copilot
- No ejecuta comandos directamente
- No crea archivos automáticamente
- Requiere confirmación manual para cambios

### Cline/Claude Code
- Requiere supervisión en tareas complejas
- Puede cometer errores en contextos grandes
- API key tiene límites de uso/costo

## 📚 Recursos

- [lab/CLAUDE.md](../../CLAUDE.md) - Guía completa
- [lab/config/claude/README.md](../README.md) - Configuración general
- [Cline Documentation](https://github.com/cline/cline)
- [GitHub Copilot Docs](https://docs.github.com/copilot)

---

**Tips:**
- Empieza con tareas pequeñas y ve escalando
- Siempre revisa el código generado antes de ejecutar
- Usa git para versionar cambios del agente
- Crea backups antes de tareas destructivas

**Última actualización**: 2026-03-11
