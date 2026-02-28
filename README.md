# Versatile Hub - Suite de Servicios Integrados

**Versión**: 1.0.0  
**Fecha**: 2026-02-23  
**Estado**: Producción

## 📋 Descripción

Versatile Hub es una suite integrada de servicios empresariales **lista para desplegar desde cero** en entornos de clientes. Combina gestión de agentes inteligentes (IA), chat omnicanal en tiempo real, automatización de flujos de trabajo y un hub central de aplicaciones ERP.

**Características principales:**
- ✅ Despliegue desde cero - No requiere migración
- ✅ Docker Compose unificado - Todos los servicios coordinados
- ✅ Puede convivir con infraestructura existente (Traefik)
- ✅ Sistema de contratos de desarrollo integrado (`lab/spec/`)
- ✅ Backups automatizados con Restic

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
Versatile Hub/
├── lab/              # 🧪 Laboratorio: Documentación y contratos de desarrollo
│   ├── context/      # Arquitectura y decisiones técnicas
│   ├── spec/         # ⭐ Especificaciones y contratos con clientes
│   │   ├── requirements/   # Requerimientos de clientes (REQ-*)
│   │   ├── analysis/       # Análisis técnicos (ANA-*)
│   │   ├── contracts/      # Contratos formalizados (CONT-*)
│   │   └── contracts-workflow.md  # Proceso de gestión
│   ├── backups/      # Scripts y configuración de backups
│   ├── config/       # Configuraciones globales
│   └── scripts/      # Scripts de utilidad
├── infrastructure/   # Infraestructura base (Traefik, Nginx)
└── services/         # Microservicios (agent, chat, flow, hub)
```

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

## 📚 Documentación

### Operaciones y Arquitectura
- **[Guía de Inicio Rápido](./QUICKSTART.md)** - Deploy en 15 minutos
- **[Contexto de Despliegue](./lab/context/deployment-context.md)** - Modelo de despliegue
- **[Arquitectura de Redes](./lab/context/networks-architecture.md)** - Redes Docker
- **[Overview de Servicios](./lab/context/services-overview.md)** - Detalles técnicos

### Gestión de Contratos de Desarrollo
- **[⭐ Workflow de Contratos](./lab/spec/contracts-workflow.md)** - Proceso completo
- **[Requerimientos](./lab/spec/requirements/)** - Solicitudes de clientes
- **[Análisis Técnicos](./lab/spec/analysis/)** - Evaluación de viabilidad
- **[Contratos](./lab/spec/contracts/)** - Contratos formalizados

### Configuración y Mantenimiento
- **[Variables de Entorno](.env.example)** - Configuración global
- **[Sistema de Backups](./lab/backups/README.md)** - Integrado con Restic
- **[Scripts de Utilidad](./lab/scripts/README.md)** - Automatización

### Control de Versiones
- **[🔀 Git Workflow](./GIT_WORKFLOW.md)** - Guía completa de Git para el proyecto
- **[.gitignore](./.gitignore)** - Qué commitear y qué no

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

### Por Servicio (Futuro)

**Nota:** Actualmente VersatileHub usa un docker-compose.yml unificado.
Docker-compose individuales por servicio se crearán si se requiere despliegue selectivo.

```bash
# Ejemplo futuro:
cd services/hub/
docker compose up -d  # Solo Hub
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

Los backups se integran con el sistema Restic existente en `/opt/ATS/restic/`:

```bash
# Backup completo del sistema
/opt/ATS/restic/scripts/backup.sh

# Scripts específicos de VersatileHub (próximamente)
./lab/backups/scripts/backup.sh
```

## 📝 Gestión de Contratos con Clientes

VersatileHub incluye un sistema completo para gestionar contratos de desarrollo:

```bash
# 1. Cliente solicita funcionalidad
cd lab/spec/requirements/
vi REQ-2026-02-001-nueva-feature.md

# 2. Análisis técnico
cd ../analysis/
vi ANA-2026-02-001-nueva-feature.md

# 3. Contrato formalizado
cd ../contracts/
vi CONT-2026-02-001-nueva-feature.md

# 4. Desarrollo según spec
# Ver: lab/spec/contracts-workflow.md
```

## 📝 Licencia

Propietario - Todos los derechos reservados

## 👥 Soporte

Para soporte y consultas, contactar al equipo de desarrollo.
