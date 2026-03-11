# Versatile Hub - Suite de Servicios Integrados

**Versión**: 1.0.0  
**Fecha**: 2026-02-23  
**Estado**: Producción

## 📋 Descripción

Versatile Hub es una suite integrada de servicios empresariales que combina gestión de agentes, chat en tiempo real, automatización de flujos de trabajo y un hub central de aplicaciones.

## 🏗️ Arquitectura

### Servicios Principales

- **Agent**: Sistema de gestión de agentes inteligentes
- **Chat**: Plataforma de comunicación en tiempo real
- **Flow**: Motor de automatización y flujos de trabajo
- **Hub**: Centro de gestión y orquestación de aplicaciones

### Infraestructura

- **Traefik**: Reverse proxy y balanceador de carga
- **Nginx**: Servidor web y proxy
- **SSL/Let's Encrypt**: Gestión de certificados
- **Backups**: Sistema de respaldos automatizados

## 📁 Estructura del Proyecto

```
VersatileHub/
│
├── 📂 lab/                    # Laboratorio: documentación, specs, scripts, config
│   ├── CLAUDE.md             # Guía de integración Claude/Copilot
│   ├── CURRENT_STATUS.md     # Estado actual del proyecto
│   ├── README.md             # Documentación del lab
│   ├── backups/              # Scripts y configuración de backups
│   ├── config/               # Configuraciones y plantillas
│   │   ├── claude/           # Configuración de Claude/Copilot
│   │   │   ├── install.sh   # Instalar configuraciones en raíz
│   │   │   ├── templates/   # Plantillas maestras
│   │   │   └── agents/      # Agentes personalizados
│   │   └── README.md
│   ├── context/              # Decisiones de arquitectura (ADR)
│   ├── scripts/              # Scripts de utilidad
│   └── spec/                 # Especificaciones técnicas
│
├── 📂 infrastructure/         # Infraestructura base
│   ├── docker-compose.yml
│   ├── traefik/              # Reverse proxy y SSL
│   ├── nginx/                # Servidor web
│   └── data/                 # Datos persistentes (gitignored)
│
├── 📂 services/               # Microservicios
│   ├── agent/                # Servicio de agentes (OpenClaw)
│   ├── chat/                 # Chat (Chatwoot)
│   ├── flow/                 # Flujos (Node-RED)
│   ├── hub/                  # Hub central (WordPress)
│   └── portal/               # Portal web (Next.js)
│
├── 📄 .env                    # Variables de entorno (gitignored)
├── 📄 .env.example            # Plantilla de variables
├── 📄 .gitignore              # Archivos ignorados por Git
├── 📄 .dockerignore           # Archivos ignorados por Docker
├── 📄 docker-compose.yml      # Orquestación principal
├── 📄 deploy.sh               # Script de despliegue
├── 📄 quick-install.sh        # Instalación rápida
└── 📄 verify-environment.sh   # Verificación de entorno

Archivos de configuración instalados (desde lab/, gitignored):
├── 📄 .clinerules                        # ← lab/config/claude/templates/
├── 📂 .github/copilot-instructions.md    # ← lab/config/claude/templates/
└── 📂 .vscode/                           # ← lab/config/claude/templates/
```

**Filosofía de estructura:**
- **Raíz limpia**: Solo archivos esenciales de deployment y configuración
- **lab/**: Todo lo relacionado con desarrollo, documentación y configuración
- **Portable**: Copia `lab/` a otros proyectos y reutiliza configuraciones

## 🚀 Inicio Rápido

### Prerequisitos

- Docker 24.0+
- Docker Compose 2.20+
- Servidor Linux (Ubuntu 22.04+ recomendado)
- Red Docker `web` creada (para Traefik)

### Instalación

```bash
# 1. Crear red externa para Traefik (si no existe)
docker network create web

# 2. Copiar variables de entorno
cp .env.example .env

# 3. Editar variables según el entorno
nano .env

# 4. Desplegar todos los servicios
./deploy.sh
```

### Verificación

```bash
# Ver estado de servicios
docker compose ps

# Ver logs
docker compose logs -f

# Ver logs de servicio específico
docker compose logs -f agent
docker compose logs -f chat-web
docker compose logs -f hub-frontend
```

### Setup Inicial

#### Hub (Frappe/ERPNext)

```bash
# Crear sitio nuevo
docker exec -it versatile-hub-backend \
  bench new-site lab.versatilehub.app \
  --mariadb-root-password YOUR_DB_PASSWORD \
  --admin-password YOUR_ADMIN_PASSWORD \
  --install-app erpnext

# Establecer como sitio por defecto
docker exec -it versatile-hub-backend \
  bench use lab.versatilehub.app
```

#### Chat (Chatwoot)

1. Acceder a `https://chat.versatilehub.app`
2. Crear cuenta de administrador
3. Configurar inbox (Web Widget, Email, etc.)
4. Generar API Access Token en Settings > Account
5. Agregar token al `.env` como `CHAT_API_ACCESS_TOKEN`
6. Reiniciar chat-bridge: `docker compose restart chat-bridge`

## 🤖 Configuración de IDE (Claude/Copilot)

Para desarrollo con asistencia de IA, instala las configuraciones desde `lab/`:

```bash
# Instalar configuraciones de Claude/Copilot desde lab/
./lab/config/claude/install.sh
```

**Esto configura:**
- GitHub Copilot con instrucciones del proyecto
- Cline/Claude Code con reglas específicas
- VS Code con settings optimizados
- Extensiones recomendadas

**Ver guía completa:** [lab/CLAUDE.md](lab/CLAUDE.md)

**Requisitos:**
- Visual Studio Code instalado
- Extensión GitHub Copilot (recomendado) o
- Extensión Cline/Claude Code (opcional, para agentes avanzados)

## 📚 Documentación

### Guías de Uso
- [Referencia Rápida](./lab/QUICK_REFERENCE.md) - Comandos y rutas principales
- [Guía de Inicio Rápido](./lab/QUICKSTART.md) - Instalación paso a paso
- [Estructura del Proyecto](./lab/STRUCTURE.md) - Descripción detallada de directorios

### Desarrollo
- [Integración Claude/Copilot](./lab/CLAUDE.md) - Configuración de asistentes IA
- [Estado Actual](./lab/CURRENT_STATUS.md) - Estado del proyecto
- [Resumen de Implementación](./lab/IMPLEMENTATION_SUMMARY.md) - Cambios implementados

### Deployment
- [Deployment Remoto](./lab/DEPLOYMENT_REMOTE.md) - Despliegue en servidores remotos

### Técnico
- [Especificaciones](./lab/spec/README.md) - Especificaciones técnicas detalladas
- [Contexto y ADRs](./lab/context/README.md) - Decisiones de arquitectura
- [Backups](./lab/backups/README.md) - Sistema de respaldos
- [Contexto del Proyecto](./lab/context/README.md)
- [Guía de Configuración](./lab/config/README.md)
- [Scripts de Utilidad](./lab/scripts/README.md)

## 🔧 Configuración

### Variables de Entorno

El archivo `.env` en la raíz contiene toda la configuración necesaria:

```bash
# Dominios
AGENT_DOMAIN=agent.versatilehub.app
CHAT_DOMAIN=chat.versatilehub.app
HUB_DOMAIN=lab.versatilehub.app

# Credenciales (cambiar en producción)
AGENT_ANTHROPIC_API_KEY=sk-ant-...
CHAT_POSTGRES_PASSWORD=...
HUB_DB_ROOT_PASSWORD=...
```

Ver documentación completa:
- [Variables de Entorno](.env.example)
- [Configuración por Servicio](./lab/config/README.md)
- [Arquitectura de Redes](./lab/context/networks-architecture.md)

## 🔐 Seguridad

- Todos los servicios corren en redes Docker aisladas
- Certificados SSL automáticos vía Let's Encrypt
- Variables de entorno para secretos
- Backups cifrados

## 📦 Despliegue

### Producción

```bash
# Despliegue completo
./deploy.sh

# Opciones disponibles
docker compose up -d              # Iniciar todos los servicios
docker compose down               # Detener todos los servicios
docker compose restart [servicio] # Reiniciar servicio específico
docker compose pull               # Actualizar imágenes
```

### Por Servicio

```bash
# Solo Agent
docker compose up -d agent

# Solo Chat (web, worker, DB)
docker compose up -d chat-web chat-worker chat-postgres chat-redis

# Solo Hub (todos los componentes)
docker compose up -d hub-frontend hub-backend hub-websocket hub-worker hub-scheduler hub-db
```

### Actualización

```bash
# 1. Backup de datos
./lab/backups/scripts/backup.sh

# 2. Pull nuevas imágenes
docker compose pull

# 3. Recrear contenedores
docker compose up -d --force-recreate

# 4. Verificar
docker compose ps
```

## 🔄 Backups

Los backups se ejecutan automáticamente usando Restic:
```bash
./lab/backups/scripts/backup.sh
```

## 📝 Licencia

Propietario - Todos los derechos reservados

## 👥 Soporte

Para soporte y consultas, contactar al equipo de desarrollo.
