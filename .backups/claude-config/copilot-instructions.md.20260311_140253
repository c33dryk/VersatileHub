# Instrucciones para Claude/Copilot en VersatileHub

## 📋 Contexto del Proyecto

VersatileHub es un sistema modular de microservicios diseñado para ser extensible y mantenible. El proyecto integra múltiples servicios independientes que pueden comunicarse entre sí.

### Servicios Principales
- **agent**: Servicio de agentes inteligentes con OpenClaw
- **chat**: Plataforma de chat (Chatwoot) con PostgreSQL y Redis
- **flow**: Motor de flujos de trabajo (Node-RED)
- **hub**: Hub central (WordPress/CMS)
- **portal**: Portal web principal (Next.js + TypeScript)

### Infraestructura
- **Traefik**: Reverse proxy y SSL automático
- **Nginx**: Servidor web y proxy
- **Docker Compose**: Orquestación de contenedores
- **PostgreSQL, Redis, MariaDB**: Bases de datos

## 🎯 Estándares de Código

### Estructura de Directorios
Cada servicio sigue esta convención:
```
services/[nombre-servicio]/
├── config/           # Configuraciones del servicio
├── data/             # Datos persistentes (volúmenes Docker)
├── scripts/          # Scripts de utilidad y deployment
└── docker-compose.yml (opcional)
```

### Lenguajes y Frameworks
- **JavaScript/TypeScript**: Node.js, Next.js, React
- **Python**: Scripts de automatización
- **Bash**: Scripts de deployment y utilidades
- **Docker**: Containerización de todos los servicios

### Convenciones de Código
1. **Variables de entorno**: Siempre usar archivos `.env` (nunca commitear)
2. **Puertos**: Documentar en docker-compose.yml
3. **Logs**: Usar formato consistente para debugging
4. **Errores**: Manejo explícito con try/catch o exit codes

## 📝 Documentación

### Idioma
- **Documentación de usuario**: Español (README.md, guías)
- **Comentarios técnicos**: Inglés o español según contexto
- **Commits**: Español, formato: `tipo: descripción`
  - feat: Nueva funcionalidad
  - fix: Corrección de bug
  - docs: Cambios en documentación
  - refactor: Refactorización de código
  - chore: Tareas de mantenimiento

### Ubicación de Documentos
- **lab/spec/**: Especificaciones técnicas detalladas
- **lab/context/**: Decisiones de arquitectura (ADR)
- **lab/config/**: Guías de configuración
- **services/[servicio]/**: README.md específico del servicio

## 🔧 Patrones de Desarrollo

### Docker Compose
```yaml
# Estructura preferida
services:
  [nombre-servicio]:
    container_name: ${PROJECT_NAME:-versatilehub}-[servicio]
    image: [imagen]:[tag]
    restart: unless-stopped
    networks:
      - versatilehub-network
    volumes:
      - ./data:/data
    environment:
      - VARIABLE=${VARIABLE}
    labels:
      - "traefik.enable=true"
      # ... configuración de Traefik
```

### Variables de Entorno
```bash
# Nomenclatura: SERVICIO_COMPONENTE_VARIABLE
CHAT_DATABASE_HOST=postgres
CHAT_DATABASE_PORT=5432
CHAT_REDIS_URL=redis://redis:6379

# Para servicios compartidos
PROJECT_NAME=versatilehub
DOMAIN=tudominio.com
EMAIL=admin@tudominio.com
```

### Scripts de Deployment
```bash
#!/bin/bash
# Estructura estándar de scripts

set -e  # Exit on error

# 1. Validaciones
echo "🔍 Verificando requisitos..."

# 2. Preparación
echo "📦 Preparando entorno..."

# 3. Ejecución
echo "🚀 Ejecutando..."

# 4. Verificación
echo "✅ Verificando resultado..."

# 5. Cleanup
echo "🧹 Limpiando..."
```

## 🛡️ Seguridad

### Mejores Prácticas
1. **Nunca** hardcodear credenciales
2. **Siempre** usar `.env` para secrets
3. **Validar** inputs en scripts
4. **Limitar** permisos de archivos: `chmod 600` para configs sensibles
5. **Usar** redes Docker aisladas
6. **Implementar** health checks en servicios

### Archivos Sensibles
```gitignore
# Nunca commitear:
.env
*.key
*.pem
acme.json
*.sqlite
*.db
```

## 🐛 Debugging

### Comandos Útiles
```bash
# Ver logs de un servicio
docker compose -f services/[servicio]/docker-compose.yml logs -f

# Inspeccionar contenedor
docker inspect [container_name]

# Verificar redes
docker network ls
docker network inspect versatilehub-network

# Estado de servicios
docker compose ps

# Variables de entorno de un contenedor
docker exec [container_name] env
```

### Troubleshooting
1. Revisar logs primero
2. Verificar conectividad de red
3. Comprobar variables de entorno
4. Validar volúmenes y permisos
5. Revisar health checks

## 🎨 Estilos y Formateo

### TypeScript/JavaScript (Next.js)
- ESLint + Prettier configurados
- 2 espacios de indentación
- Comillas simples
- Semicolons opcionales (seguir convención del archivo)

### Python
- PEP 8
- 4 espacios de indentación
- Type hints cuando sea posible

### Shell Scripts
- shfmt o Google Shell Style Guide
- 2 espacios de indentación
- Usar `[[]]` en lugar de `[]`
- Preferir `$()` sobre backticks

## 🚀 Flujo de Trabajo

### Desarrollo de Nueva Funcionalidad
1. **Planificar**: Documentar en lab/spec/
2. **Implementar**: Código + tests
3. **Probar**: Localmente con Docker
4. **Documentar**: Actualizar README.md
5. **Desplegar**: Scripts en services/[servicio]/scripts/

### Agregar Nuevo Servicio
1. Crear directorio en `services/[nombre]/`
2. Crear estructura: config/, data/, scripts/
3. Configurar docker-compose.yml
4. Agregar variables a .env
5. Documentar en README.md
6. Integrar con Traefik si es web

### Modificar Configuración
1. Actualizar archivos en config/
2. Documentar cambios
3. Verificar con ./verify-environment.sh
4. Reiniciar servicios afectados

## 📊 Monitoreo

### Health Checks
Implementar en docker-compose.yml:
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### Métricas
- Usar labels de Traefik para métricas
- Logs estructurados en JSON cuando sea posible
- Implementar endpoints /health y /metrics

## 🤝 Colaboración

### Al Sugerir Código
1. Seguir estructura existente
2. Mantener consistencia de estilo
3. Agregar comentarios explicativos
4. Incluir manejo de errores
5. Considerar casos edge

### Al Generar Documentación
1. Usar formato Markdown
2. Incluir ejemplos prácticos
3. Agregar emojis para mejor legibilidad
4. Referencias a archivos relacionados
5. Fecha de última actualización

## 🔍 Comandos de Claude

### Mejorar Prompts
```
# ✅ Prompts efectivos:
"Analiza services/portal/docker-compose.yml y sugiere optimizaciones de seguridad y rendimiento"
"Crea un script de backup para PostgreSQL del servicio chat siguiendo la estructura de lab/backups/"
"Explica cómo agregar autenticación JWT al servicio agent, considerando la arquitectura existente"

# ❌ Evitar:
"Arregla esto"
"Haz que funcione"
"Añade un servicio"
```

---

**Versión**: 1.0.0  
**Última actualización**: 2026-03-11  
**Mantenedor**: Equipo VersatileHub

Este archivo guía a Claude/Copilot para proporcionar sugerencias más relevantes y consistentes con la arquitectura de VersatileHub.
