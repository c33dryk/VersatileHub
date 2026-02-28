# Contexto de Despliegue - VersatileHub

## 🎯 Filosofía de Despliegue

VersatileHub está diseñado como una **infraestructura modular lista para desplegar** en entornos de clientes. No requiere migración de servicios existentes - es una suite completa que se levanta desde cero.

## 🏗️ Arquitectura de Despliegue

### Componentes Independientes

```
/opt/ATS/VersatileHub/
│
├── infrastructure/           # Infraestructura base
│   └── docker-compose.yml   # Traefik, Nginx, redes
│
├── services/
│   ├── agent/
│   │   └── docker-compose.yml    # Agent independiente
│   ├── chat/
│   │   └── docker-compose.yml    # Chat independiente
│   ├── hub/
│   │   └── docker-compose.yml    # Hub independiente
│   └── flow/
│       └── docker-compose.yml    # Flow independiente
│
└── docker-compose.yml       # Compose unificado (opcional)
```

### Tres Modos de Despliegue

#### Modo 1: Suite Completa (Recomendado)
```bash
# Desde la raíz
docker compose up -d
```
Levanta **todos** los servicios de una vez usando el compose unificado.

#### Modo 2: Infraestructura + Servicios Selectivos
```bash
# 1. Levantar infraestructura
cd infrastructure/
docker compose up -d

# 2. Levantar solo servicios necesarios
cd ../services/hub/
docker compose up -d

cd ../services/agent/
docker compose up -d
```

#### Modo 3: Servicio Individual (Testing/Dev)
```bash
cd services/agent/
docker compose up -d
```
Para desarrollo o pruebas de un servicio específico.

---

## 📋 Casos de Uso por Cliente

### Cliente con Necesidades Completas
**Requiere:** Agent + Chat + Hub + Flow

```bash
# Deploy completo
cd /opt/ATS/VersatileHub
docker compose up -d
```

**Servicios activos:**
- `agent.cliente.com` - Agente IA
- `chat.cliente.com` - Chat omnicanal
- `hub.cliente.com` - ERP completo
- `flow.cliente.com` - Automatizaciones

---

### Cliente Solo ERP
**Requiere:** Hub únicamente

```bash
cd /opt/ATS/VersatileHub/services/hub
docker compose up -d
```

**Servicios activos:**
- `hub.cliente.com` - ERPNext completo

---

### Cliente CRM + Chat
**Requiere:** Chat + Hub (módulo CRM)

```bash
cd /opt/ATS/VersatileHub

# Levantar solo chat y hub
docker compose up -d chat-web chat-postgres hub-frontend hub-backend hub-db
```

---

### Cliente Automatización Avanzada
**Requiere:** Flow + Hub (para datos)

```bash
cd /opt/ATS/VersatileHub/services/flow
docker compose up -d

cd ../hub
docker compose up -d
```

---

## 🔧 Configuración por Entorno

### Estructura de Variables de Entorno

```
/opt/ATS/VersatileHub/
├── .env.example                    # Template global
├── .env                            # Config global (git-ignored)
│
├── infrastructure/
│   ├── .env.example
│   └── .env                        # Config infraestructura
│
└── services/
    ├── agent/
    │   ├── .env.example
    │   └── .env                    # Config Agent
    ├── chat/
    │   ├── .env.example
    │   └── .env                    # Config Chat
    ├── hub/
    │   ├── .env.example
    │   └── .env                    # Config Hub
    └── flow/
        ├── .env.example
        └── .env                    # Config Flow
```

### Personalization por Cliente

Cada cliente tiene sus propios `.env` files con:
- Dominios personalizados
- Credenciales únicas
- API keys específicas
- Configuraciones de marca

**Ejemplo para Cliente A:**
```bash
# services/hub/.env
FRAPPE_SITE_NAME=erp.clienteA.com
FRAPPE_COMPANY_NAME="Cliente A S.A."
FRAPPE_TIMEZONE=America/Argentina/Buenos_Aires
```

**Ejemplo para Cliente B:**
```bash
# services/hub/.env
FRAPPE_SITE_NAME=erp.clienteB.com
FRAPPE_COMPANY_NAME="Cliente B Corp"
FRAPPE_TIMEZONE=America/Mexico_City
```

---

## 🌐 Redes Docker

### Red Externa `web`

**Propósito:** Exposición pública vía Traefik

**Creación:** Manual (una sola vez por servidor)
```bash
docker network create web
```

**Servicios conectados:**
- Traefik (infrastructure)
- Todos los frontends que necesitan exposición pública

### Redes Internas

**Auto-creadas por docker-compose:**
- `versatile-shared` - Comunicación inter-servicios
- `versatile-chat-internal` - Componentes privados de Chat
- `versatile-hub-internal` - Componentes privados de Hub
- `versatile-flow-internal` - Componentes privados de Flow

---

## 🚀 Proceso de Despliegue Típico

### 1. Preparación del Servidor

```bash
# Verificar requisitos
docker --version
docker compose version

# Crear red externa (si no existe)
docker network create web
```

### 2. Clonar/Copiar VersatileHub

```bash
cd /opt/ATS/
git clone [...] VersatileHub
cd VersatileHub
```

### 3. Configurar Variables de Entorno

```bash
# Global
cp .env.example .env
nano .env

# Por servicio (si se despliegan selectivamente)
cd services/hub/
cp .env.example .env
nano .env
```

### 4. Levantar Infraestructura

```bash
cd /opt/ATS/VersatileHub/infrastructure
docker compose up -d

# Verificar Traefik
docker compose ps
docker compose logs traefik
```

### 5. Levantar Servicios

**Opción A - Todo junto:**
```bash
cd /opt/ATS/VersatileHub
docker compose up -d
```

**Opción B - Selectivo:**
```bash
cd services/hub/
docker compose up -d

cd ../agent/
docker compose up -d
```

### 6. Setup Inicial de Servicios

**Hub (Frappe):**
```bash
docker exec -it versatile-hub-backend \
  bench new-site hub.cliente.com \
  --mariadb-root-password PASSWORD \
  --admin-password PASSWORD \
  --install-app erpnext
```

**Chat (Chatwoot):**
- Acceder vía navegador
- Crear cuenta admin
- Configurar primer inbox

### 7. Verificación

```bash
# Health check
docker compose ps

# Logs
docker compose logs -f

# Acceso web
curl -I https://hub.cliente.com
curl -I https://chat.cliente.com
curl -I https://agent.cliente.com
```

### 8. Backup Inicial

```bash
cd /opt/ATS/restic
./scripts/backup.sh
```

---

## 📦 Volúmenes y Persistencia

### Datos Críticos por Servicio

**Agent:**
```
./services/agent/data/
├── memory/          # Memoria del agente
├── skills/          # Skills instalados
└── openclaw/        # Configuración
```

**Chat:**
```
./services/chat/data/
├── postgres/        # Base de datos
├── redis/           # Cache
└── storage/         # Archivos subidos
```

**Hub:**
```
./services/hub/data/
├── mariadb/         # Base de datos ERP
└── sites/           # Sites Frappe
```

**Flow:**
```
./services/flow/data/
├── workflows/       # Workflows definidos
└── database/        # BD de flows
```

### Estrategia de Backup

Ver documentación completa en: `/opt/ATS/restic/sumary/`

**Integrado con Restic:**
- Backups automáticos diarios
- Cifrado AES-256
- Storage en Backblaze B2
- Retención: 7 días / 30 días / 12 meses

---

## 🔐 Seguridad

### Checklist de Seguridad Pre-Deploy

- [ ] Todos los `.env` con credenciales únicas (no usar defaults)
- [ ] Passwords generados con `openssl rand -base64 32`
- [ ] API keys válidas y activas
- [ ] Red `web` creada y Traefik funcionando
- [ ] Certificados SSL configurados (Let's Encrypt)
- [ ] Firewall del servidor configurado (solo 80, 443, 22)
- [ ] Backups automáticos configurados
- [ ] Usuarios Docker non-root donde sea posible

---

## 📊 Monitoreo Post-Deploy

### Primeras 24 horas

```bash
# Monitorear logs continuamente
docker compose logs -f

# Verificar salud de servicios
docker compose ps

# Verificar uso de recursos
docker stats
```

### Métricas a vigilar

- CPU usage < 70%
- Memory usage < 80%
- Disk I/O estable
- Logs sin errores críticos
- Respuesta de endpoints < 2s

---

## 🔄 Actualizaciones

### Update de Servicios

```bash
# 1. Backup
/opt/ATS/restic/scripts/backup.sh

# 2. Pull nuevas imágenes
docker compose pull

# 3. Recrear contenedores
docker compose up -d --force-recreate

# 4. Verificar
docker compose ps
```

---

## 🆘 Troubleshooting

### Servicio no levanta

```bash
# Ver logs
docker compose logs [servicio]

# Recrear contenedor
docker compose up -d --force-recreate [servicio]
```

### Red no disponible

```bash
# Verificar red existe
docker network ls | grep web

# Crear si no existe
docker network create web
```

### Volúmenes con permisos incorrectos

```bash
# Fix permisos
sudo chown -R 1000:1000 ./services/*/data/
```

---

## 📞 Soporte

**Para problemas de despliegue:**
- Ver logs: `docker compose logs -f`
- Revisar `.env` files
- Verificar conectividad de red
- Consultar `/opt/ATS/VersatileHub/lab/spec/deployment-guide.md`

---

**Última actualización:** 2026-02-28
