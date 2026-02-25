# Config - Configuraciones Globales

Este directorio contiene todas las configuraciones globales, plantillas y documentación de configuración para Versatile Hub.

## 📁 Estructura

```
config/
├── templates/          # Plantillas de configuración
│   ├── .env.example   # Variables de entorno
│   └── docker/        # Templates de Docker
├── shared/            # Configuraciones compartidas
│   ├── networks.yml   # Definición de redes
│   └── volumes.yml    # Definición de volúmenes
└── docs/              # Documentación de configuración
```

## 🔧 Variables de Entorno

### Estructura del .env

```bash
# === INFORMACIÓN GENERAL ===
PROJECT_NAME=versatile-hub
ENVIRONMENT=production  # development | staging | production
DOMAIN=example.com

# === BASE DE DATOS ===
DB_ROOT_PASSWORD=changeme
DB_USER=versatile
DB_PASSWORD=changeme
DB_NAME=versatile_hub

# === REDIS ===
REDIS_PASSWORD=changeme

# === SERVICIOS ===
# Agent Service
AGENT_PORT=8001
AGENT_API_KEY=changeme

# Chat Service
CHAT_PORT=8003
CHAT_WS_PORT=8004
CHAT_SECRET=changeme

# Flow Service
FLOW_PORT=8005
FLOW_API_KEY=changeme

# Hub Service
HUB_FRONTEND_PORT=8080
HUB_BACKEND_PORT=8000
FRAPPE_SITE_NAME=hub.example.com
FRAPPE_DB_ROOT_PASSWORD=changeme

# === SSL/TLS ===
LETSENCRYPT_EMAIL=admin@example.com
ACME_SERVER=https://acme-v02.api.letsencrypt.org/directory  # Production
# ACME_SERVER=https://acme-staging-v02.api.letsencrypt.org/directory  # Staging

# === BACKUPS ===
RESTIC_REPOSITORY=s3:s3.amazonaws.com/bucket-name
RESTIC_PASSWORD=changeme
AWS_ACCESS_KEY_ID=changeme
AWS_SECRET_ACCESS_KEY=changeme

# === MONITOREO ===
ENABLE_METRICS=true
METRICS_PORT=9090
```

## 🌐 Configuración de Redes

### Redes Docker

```yaml
networks:
  proxy:
    driver: bridge
    external: false
  
  agent:
    driver: bridge
    internal: true
  
  chat:
    driver: bridge
    internal: true
  
  flow:
    driver: bridge
    internal: true
  
  hub:
    driver: bridge
    internal: true
  
  shared:
    driver: bridge
    internal: false
```

## 📦 Volúmenes

### Estrategia de Volúmenes

- **Data permanente**: `./services/*/data/`
- **Configuraciones**: `./services/*/config/`
- **Logs**: `./services/*/logs/`
- **Backups**: `./lab/backups/data/`

## 🚀 Uso

### 1. Crear configuración para nuevo entorno

```bash
# Copiar template
cp lab/config/templates/.env.example .env

# Editar según entorno
nano .env
```

### 2. Validar configuración

```bash
# Usar script de validación
./lab/scripts/validate-config.sh
```

### 3. Aplicar configuración

```bash
# Las variables se cargan automáticamente desde .env
docker-compose up -d
```

## 🔐 Seguridad

### Best Practices

1. **Nunca commitear el archivo `.env`** real
2. **Usar secretos fuertes** (32+ caracteres)
3. **Rotar secretos regularmente**
4. **Diferentes secretos por entorno**
5. **Backup de configuraciones críticas**

### Generar Secretos Seguros

```bash
# Generar password aleatorio
openssl rand -base64 32

# Generar API key
openssl rand -hex 32
```

## 📋 Checklist de Configuración

Antes de desplegar:

- [ ] Actualizar todas las contraseñas del template
- [ ] Configurar dominio correcto
- [ ] Configurar email para Let's Encrypt
- [ ] Configurar credenciales de backup (Restic)
- [ ] Verificar puertos disponibles
- [ ] Configurar límites de recursos si es necesario
- [ ] Probar conexión a servicios externos
- [ ] Validar configuración con script

## 🔧 Configuraciones por Servicio

### Agent
Ver: `../../services/agent/config/`

### Chat
Ver: `../../services/chat/config/`

### Flow
Ver: `../../services/flow/config/`

### Hub
Ver: `../../services/hub/config/`

## 📚 Documentación Adicional

- [Variables de Entorno Completas](./docs/environment-variables.md)
- [Configuración de Redes](./docs/networks.md)
- [Configuración de SSL](./docs/ssl-configuration.md)
- [Configuración de Backups](./docs/backup-configuration.md)

## 🔗 Referencias

- [Especificaciones](../spec/README.md)
- [Scripts de Despliegue](../scripts/README.md)
