# Servicios de Versatile Hub - Documentación Técnica

## Resumen de Servicios

Versatile Hub está compuesto por 4 servicios principales que trabajan de forma integrada:

```
┌─────────────────────────────────────────────────────────┐
│                    Traefik (Proxy)                       │
│              SSL/TLS + Load Balancing                    │
└────────┬────────────┬────────────┬───────────────────────┘
         │            │            │
    ┌────▼───┐   ┌───▼────┐   ┌──▼─────┐
    │ Agent  │   │  Chat  │   │  Hub   │
    │(Cloud) │   │(Public)│   │(Public)│
    └────┬───┘   └───┬────┘   └──┬─────┘
         │           │            │
         └───────────┴────────────┘
                     │
                ┌────▼────┐
                │  Flow   │
                │(Internal)│
                └─────────┘
```

---

## 1. Agent Service (ATS Agent)

### Descripción
**OpenClaw** - Agente de IA conversacional con capacidades de código.

### Tecnología
- **Base**: OpenClaw (Node.js)
- **Imagen**: `ghcr.io/openclaw/openclaw:latest`
- **Puerto**: 18789 (WebSocket), 3000 (API)

### Funcionalidad
- Agente de IA con soporte para múltiples modelos (Claude, GPT-4)
- Capacidades de programación y ejecución de código
- Integración con Telegram
- WebSocket para comunicación en tiempo real
- Acceso a Docker para ejecutar comandos en otros contenedores

### Exposición
- ✅ **Público** vía `agent.versatilehub.app`
- Expuesto a través de Traefik
- SSL/TLS automático

### Características Especiales
- **Acceso a Docker Socket**: Puede ejecutar comandos en otros contenedores
- **Volúmenes de Workspace**: Acceso a código fuente de otros servicios
- **Multi-LLM**: Soporta Claude (Anthropic) y GPT (OpenAI)
- **Telegram Bot**: Interfaz conversacional vía Telegram

### Dependencias
- Ninguna (servicio independiente)
- Puede comunicarse con otros servicios vía WebSocket

### Variables de Entorno Requeridas
```bash
ANTHROPIC_API_KEY          # Claude API key
OPENAI_API_KEY            # OpenAI API key (opcional)
OPENCLAW_GATEWAY_TOKEN    # Token para autenticación
TELEGRAM_BOT_TOKEN        # Telegram bot (opcional)
TELEGRAM_ALLOWED_USERS    # IDs permitidos (opcional)
```

### Redes
- `web`: Exposición pública vía Traefik
- `shared`: Comunicación con otros servicios (opcional)

### Volúmenes
```bash
./services/agent/data/memory      # Memoria persistente
./services/agent/data/skills      # Skills del agente
./services/agent/data/openclaw    # Configuración y auth
./services/agent/config           # Configuración personalizada
/var/run/docker.sock             # Socket Docker (control)
```

### Health Check
- Endpoint: `http://localhost:18789/health`
- Protocolo: WebSocket disponible en `/ws`

---

## 2. Chat Service (ATS Chat)

### Descripción
**Chatwoot** - Plataforma de comunicación omnicanal con clientes.

### Tecnología
- **Base**: Chatwoot v4.8.0 (Rails + React)
- **Imagen**: `chatwoot/chatwoot:v4.8.0`
- **Base de Datos**: PostgreSQL 16 con pgvector
- **Cache/Queue**: Redis 7
- **Puertos**: 3000 (Web), 4000 (Bridge)

### Arquitectura Interna

```
chatwoot-web (Frontend)
    ↓
chatwoot-worker (Sidekiq - Background Jobs)
    ↓
postgres-chat + redis-chat
    ↓
chatwoot-bridge (Integración con Agent)
```

### Componentes

#### 2.1 Chatwoot Web
- Aplicación Rails principal
- UI React para agentes
- WebSocket para chat en tiempo real
- API REST para integraciones

#### 2.2 Chatwoot Worker
- Sidekiq worker para jobs background
- Procesamiento de mensajes
- Envío de emails
- Webhooks y notificaciones

#### 2.3 PostgreSQL + pgvector
- Base de datos principal
- Soporte para vectores (búsqueda semántica)
- Persistencia de conversaciones, usuarios, configuración

#### 2.4 Redis
- Cache de sesiones
- Cola de trabajos (Sidekiq)
- Pub/Sub para WebSocket

#### 2.5 Chatwoot Bridge
- **Función**: Conecta Chatwoot con ATS Agent
- **Tecnología**: Node.js + WebSocket
- **Puerto**: 4000
- Permite que el agente responda mensajes automáticamente

### Exposición
- ✅ **Público** vía `chat.versatilehub.app` (Web UI)
- ✅ **Público** vía `chat-bridge.versatilehub.app` (API Bridge)
- ❌ Worker, DB, Redis: Internos

### Variables de Entorno Requeridas
```bash
# Base de datos
POSTGRES_USER
POSTGRES_PASSWORD
POSTGRES_DB

# Rails
SECRET_KEY_BASE               # Generar con openssl rand -hex 64
FRONTEND_URL                  # https://chat.versatilehub.app
DEFAULT_LOCALE               # es
FORCE_SSL                    # true

# Email (SMTP)
MAILER_SENDER_EMAIL
SMTP_ADDRESS
SMTP_USERNAME
SMTP_PASSWORD

# Integración Agent
CHATWOOT_API_ACCESS_TOKEN    # Token de API de Chatwoot
OPENCLAW_GATEWAY_TOKEN       # Token compartido con Agent
```

### Redes
- `web`: Solo chatwoot-web y chatwoot-bridge
- `chat-internal`: Todos los componentes internos

### Volúmenes
```bash
./services/chat/data/postgres     # Base de datos PostgreSQL
./services/chat/data/redis        # Datos Redis
./services/chat/data/storage      # Archivos subidos
./services/chat/data/public       # Assets públicos
```

### Integraciones
- **Canales soportados**: Web Widget, Email, Telegram, WhatsApp (vía Twilio), Facebook, etc.
- **Webhooks**: Puede enviar eventos a servicios externos
- **API REST**: Full API para automatización

---

## 3. Hub Service (Versatile Hub Core)

### Descripción
**ERPNext/Frappe** - Sistema ERP completo para gestión empresarial.

### Tecnología
- **Base**: Frappe Framework v15 + ERPNext v15
- **Imagen**: `frappe/erpnext:v15`
- **Base de Datos**: MariaDB 11.7
- **Cache/Queue**: Redis 7.4
- **Puertos**: 8080 (Frontend), 8000 (Backend), 9000 (WebSocket)

### Arquitectura Interna

```
hub-frontend (Nginx)
    ↓
hub-backend (Gunicorn + Python)
    ↓
hub-websocket (Node.js SocketIO)
    ↓
hub-worker (Background Jobs)
    ↓
hub-scheduler (Cron Jobs)
    ↓
hub-db (MariaDB) + hub-redis-cache + hub-redis-queue
```

### Componentes

#### 3.1 Hub Frontend
- Nginx serving static assets
- Proxy reverso a backend y websocket
- Puerto: 8080

#### 3.2 Hub Backend
- Frappe/ERPNext Python application
- API REST y Frappe Desk
- Puerto: 8000 (interno)

#### 3.3 Hub WebSocket
- Node.js SocketIO server
- Realtime updates
- Puerto: 9000 (interno)

#### 3.4 Hub Worker
- Background job processor
- Procesamiento de reportes, emails, etc.
- Colas: long, short, default

#### 3.5 Hub Scheduler
- Scheduled tasks (cron)
- Tareas periódicas y mantenimiento

#### 3.6 MariaDB
- Base de datos principal
- UTF8MB4 para soporte completo Unicode
- Health checks integrados

#### 3.7 Redis (Cache y Queue)
- Cache: Sesiones y datos temporales
- Queue: Cola de trabajos

### Exposición
- ✅ **Público** vía `altamira.versatilehub.app` (Frontend)
- ❌ Backend, WebSocket, Worker, Scheduler, DB: Internos

### Funcionalidades ERP
- **CRM**: Gestión de clientes y oportunidades
- **Ventas**: Cotizaciones, órdenes, facturación
- **Compras**: Proveedores, órdenes de compra
- **Proyectos**: Gestión de proyectos y tareas
- **RRHH**: Empleados, asistencia, nómina
- **Contabilidad**: Libro mayor, reportes financieros
- **Inventario**: Stock, almacenes, movimientos
- **Manufacturing**: Órdenes de producción, BOM
- **Y más**: Portal de clientes, helpdesk, etc.

### Variables de Entorno Requeridas
```bash
FRAPPE_SITE_NAME              # altamira.versatilehub.app
FRAPPE_DB_ROOT_PASSWORD       # Password MariaDB
```

### Redes
- `web`: Solo hub-frontend
- `hub-internal`: Todos los componentes internos

### Volúmenes
```bash
./services/hub/data/mariadb       # Base de datos MariaDB
./services/hub/data/sites         # Sites Frappe (multi-tenant)
hub-assets (named volume)         # Assets compilados (compartido)
```

### Customizaciones
- Apps custom se instalan en `sites/apps/`
- Sites individuales en `sites/{site-name}/`
- Bench commands disponibles vía `docker exec`

---

## 4. Flow Service (Versatile Flow)

### Descripción
**Automatización** - Motor de flujos de trabajo y automatización.

### Estado Actual
⚠️ **Pendiente de implementación** - Estructura preparada, sin código migrado aún.

### Tecnología Propuesta
- **Opción 1**: n8n (Node.js workflow automation)
- **Opción 2**: Node-RED (Visual flow programming)
- **Opción 3**: Apache Airflow (Python DAGs)
- **Opción 4**: Custom (NestJS + Bull)

### Funcionalidad Planificada
- Workflows de automatización entre servicios
- Integraciones con APIs externas
- ETL y procesamiento de datos
- Orquestación de tareas complejas
- Triggers basados en eventos

### Exposición
- ❌ **Interno** - No expuesto públicamente
- Accesible solo desde otros servicios
- UI interna para configuración (opcional)

### Redes
- `shared`: Comunicación con otros servicios
- `flow-internal`: Componentes internos

---

## Integración entre Servicios

### Agent ↔ Chat
```
Usuario mensaje → Chatwoot
                  ↓
         chatwoot-bridge (webhook)
                  ↓
         ats-agent (procesa con IA)
                  ↓
         chatwoot-bridge (responde)
                  ↓
         Chatwoot → Usuario
```

### Agent ↔ Hub
```
Agent puede:
- Ejecutar comandos en hub-backend vía Docker
- Acceder a archivos de configuración
- Leer logs
- Ejecutar bench commands
```

### Chat ↔ Hub
```
Posibles integraciones:
- Crear tickets desde Chatwoot → ERPNext Issues
- Sincronizar contactos
- Notificaciones de ERPNext → Chatwoot
```

### Flow ↔ Todos
```
Flow orquesta:
- Workflows que involucran múltiples servicios
- Automatizaciones complejas
- Integraciones con servicios externos
```

---

## Redes Docker

### Red `web` (Externa)
- **Propósito**: Exposición pública vía Traefik
- **Servicios conectados**:
  - ats-agent
  - chatwoot-web
  - chatwoot-bridge
  - hub-frontend
- **Externa**: Debe crearse previamente

### Red `shared` (Interna)
- **Propósito**: Comunicación inter-servicios
- **Servicios conectados**: Todos los que necesiten comunicarse
- **Seguridad**: No expuesta públicamente

### Redes Internas por Servicio
- `chat-internal`: Componentes de Chatwoot
- `hub-internal`: Componentes de Hub
- `flow-internal`: Componentes de Flow

---

## Volúmenes y Persistencia

### Datos Críticos
```
services/
├── agent/data/         # Memoria y skills del agente
├── chat/data/          # PostgreSQL + Redis + Storage
├── hub/data/           # MariaDB + Sites Frappe
└── flow/data/          # Workflows y configuración
```

### Backup Priority
1. **Alta**: `hub/data/mariadb`, `chat/data/postgres`
2. **Media**: `agent/data/memory`, `chat/data/storage`
3. **Baja**: Redis, cache, logs

---

## Requisitos del Sistema

### Mínimo (Desarrollo)
- RAM: 8 GB
- CPU: 4 cores
- Disco: 50 GB SSD

### Recomendado (Producción)
- RAM: 16 GB
- CPU: 8 cores
- Disco: 200 GB SSD
- Backup: S3 o similar

---

## Variables de Entorno Globales

Ver `.env.example` en raíz del proyecto.

### Categorías
1. **Dominios y URLs**
2. **Credenciales de Bases de Datos**
3. **API Keys (LLMs, servicios externos)**
4. **Configuración de Email (SMTP)**
5. **Tokens de Integración**
6. **Configuración de Traefik**

---

## Orden de Inicio

Para levantar todos los servicios:

```bash
# 1. Verificar red Traefik existe
docker network create web

# 2. Levantar todos los servicios
docker-compose up -d

# 3. Verificar health
docker-compose ps

# 4. Ver logs
docker-compose logs -f
```

### Dependencias de Inicio
1. Bases de datos primero (MariaDB, PostgreSQL, Redis)
2. Backends después (hub-backend, chatwoot-web)
3. Frontends al final (hub-frontend, ats-agent)

---

📅 **Última actualización**: 2026-02-23
