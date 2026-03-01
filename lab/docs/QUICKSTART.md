# Guía de Inicio Rápido - Versatile Hub

Esta guía te ayudará a desplegar Versatile Hub en 15 minutos.

## Paso 1: Preparar el Servidor

### Requisitos Mínimos
- Ubuntu 22.04 LTS
- 8 GB RAM
- 4 CPU cores
- 50 GB disco SSD
- Docker y Docker Compose instalados

### Instalar Docker (si no está instalado)

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Verificar instalación
docker --version
docker compose version
```

## Paso 2: Verificar Infraestructura

Versatile Hub puede usar la infraestructura existente de Production o crear la suya propia.

### Opción A: Usar Infraestructura de Production (Recomendado)

Si ya tienes el entorno de Production configurado en `/opt/ats/Production`:

```bash
# Verificar que Traefik esté corriendo
docker ps | grep traefik
# Output esperado: traefik container corriendo

# Verificar que la red 'web' exista
docker network ls | grep web
# Output esperado: web network (bridge, external)

# Verificar servicios de Production
cd /opt/ats/Production
docker compose ps
# Deberías ver: traefik, portainer, nginx, versatile-flow, watchtower
```

**Infraestructura disponible en Production:**
- ✅ **Traefik v2.11**: Reverse proxy con SSL automático
- ✅ **Let's Encrypt**: Certificados SSL con Cloudflare DNS
- ✅ **Portainer**: Dashboard de gestión Docker
- ✅ **Nginx**: Servidor de archivos estáticos
- ✅ **Watchtower**: Auto-actualización de contenedores
- ✅ **Red 'web'**: Red bridge externa compartida

**Servicios ya en Production:**
- `flow.versatilehub.app` - n8n Automation
- `crm.versatilehub.app` - Frappe CRM v16
- `healthcare.versatilehub.app` - Healthcare v16
- `microservices.versatilehub.app` - Portainer Dashboard
- `static.syspat.ar` - Nginx estático

Versatile Hub se integrará automáticamente con esta infraestructura.

### Opción B: Infraestructura Nueva (Servidor Limpio)

Si estás en un servidor sin la infraestructura de Production:

```bash
# Crear red externa
docker network create web

# Instalar Traefik (básico)
docker run -d \
  --name traefik \
  --network web \
  -p 80:80 \
  -p 443:443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  traefik:v2.11 \
  --api.insecure=true \
  --providers.docker=true \
  --providers.docker.exposedbydefault=false \
  --entrypoints.web.address=:80 \
  --entrypoints.websecure.address=:443
```

### Verificación Final

```bash
# Red 'web' debe existir
docker network inspect web

# Traefik debe estar corriendo
curl -I http://localhost:80
# Output: 404 (es normal, significa que Traefik responde)
```

## Paso 3: Clonar o Crear Estructura

```bash
# Si ya está creada
cd "/opt/ats/Versatile Hub"

# Si necesitas crearla desde cero (ya hecha en este caso)
# Asegurarte de estar en el directorio correcto
pwd
# Output esperado: /opt/ats/Versatile Hub
```

## Paso 4: Configurar Variables de Entorno

```bash
# Copiar template
cp .env.example .env

# Editar con tu editor preferido
nano .env
```

### Variables Críticas a Configurar

```bash
# === DOMINIOS (cambiar por los tuyos) ===
AGENT_DOMAIN=agent.tudominio.com
CHAT_DOMAIN=chat.tudominio.com
HUB_DOMAIN=hub.tudominio.com

# === AGENT ===
AGENT_ANTHROPIC_API_KEY=sk-ant-api03-xxxxx  # Obtener en console.anthropic.com
AGENT_GATEWAY_TOKEN=$(openssl rand -hex 32)

# === CHAT ===
CHAT_POSTGRES_PASSWORD=$(openssl rand -base64 32)
CHAT_SECRET_KEY_BASE=$(openssl rand -hex 64)

# Email (Gmail ejemplo)
CHAT_MAILER_SENDER_EMAIL=chat@tudominio.com
CHAT_SMTP_ADDRESS=smtp.gmail.com
CHAT_SMTP_USERNAME=tu-email@gmail.com
CHAT_SMTP_PASSWORD=tu-app-password

# === HUB ===
HUB_DB_ROOT_PASSWORD=$(openssl rand -base64 32)
HUB_SITE_NAME=hub.tudominio.com

# === BACKUPS ===
RESTIC_REPOSITORY=s3:s3.amazonaws.com/tu-bucket
RESTIC_PASSWORD=$(openssl rand -base64 32)
AWS_ACCESS_KEY_ID=tu_access_key
AWS_SECRET_ACCESS_KEY=tu_secret_key
```

### Generar Secretos Automáticamente

```bash
# Desde el directorio del proyecto
./lab/scripts/generate-secrets.sh  # (si existe)

# O manualmente:
echo "AGENT_GATEWAY_TOKEN=$(openssl rand -hex 32)"
echo "CHAT_POSTGRES_PASSWORD=$(openssl rand -base64 32)"
echo "CHAT_SECRET_KEY_BASE=$(openssl rand -hex 64)"
echo "HUB_DB_ROOT_PASSWORD=$(openssl rand -base64 32)"
echo "RESTIC_PASSWORD=$(openssl rand -base64 32)"
```

## Paso 5: Configurar DNS

Apuntar tus dominios al servidor:

```
A    agent.tudominio.com    →  IP_DEL_SERVIDOR
A    chat.tudominio.com     →  IP_DEL_SERVIDOR
A    hub.tudominio.com      →  IP_DEL_SERVIDOR
```

**Esperar a que propague** (puede tomar 5-60 minutos)

Verificar con:
```bash
dig agent.tudominio.com
```

## Paso 6: Desplegar

```bash
# Ejecutar script de deploy
./deploy.sh
```

El script:
1. ✓ Verifica dependencias
2. ✓ Verifica .env
3. ✓ Verifica red 'web'
4. ✓ Crea directorios de datos
5. ✓ Descarga imágenes Docker
6. ✓ Inicia servicios

## Paso 7: Verificar Despliegue

```bash
# Ver estado de todos los servicios
docker compose ps

# Deberías ver algo como:
# NAME                          STATUS    PORTS
# versatile-agent               Up        expose 3000,18789
# versatile-chat-web            Up        expose 3000
# versatile-chat-worker         Up
# versatile-chat-postgres       Up (healthy)
# versatile-chat-redis          Up (healthy)
# versatile-hub-frontend        Up        expose 8080
# versatile-hub-backend         Up
# ... etc
```

```bash
# Ver logs en tiempo real
docker compose logs -f

# Ver logs de servicio específico
docker compose logs -f agent
docker compose logs -f chat-web
docker compose logs -f hub-frontend
```

## Paso 8: Setup Servicios

### 8.1 Setup Hub (Frappe/ERPNext)

```bash
# Crear nuevo sitio Frappe
docker exec -it versatile-hub-backend \
  bench new-site hub.tudominio.com \
  --mariadb-root-password TU_DB_PASSWORD_AQUI \
  --admin-password TU_ADMIN_PASSWORD_AQUI \
  --install-app erpnext

# Establecer como sitio por defecto
docker exec -it versatile-hub-backend \
  bench use hub.tudominio.com

# Acceder: https://hub.tudominio.com
# Usuario: Administrator
# Password: (el que pusiste arriba)
```

### 8.2 Setup Chat (Chatwoot)

```bash
# Acceder a: https://chat.tudominio.com

# 1. Crear cuenta de administrador (primera vez)
# 2. Configurar inbox (Web Widget)
# 3. Ir a: Settings > Account Settings > API Access Token
# 4. Generar token nuevo
# 5. Copiar token

# Agregar token al .env
nano .env
# Buscar: CHAT_API_ACCESS_TOKEN=
# Pegar el token

# Reiniciar bridge para que tome el token
docker compose restart chat-bridge
```

### 8.3 Setup Agent (OpenClaw)

El agente se configura automáticamente con las variables del .env.

Para autenticación de GitHub Copilot (opcional):
```bash
# Ver logs del agente
docker compose logs -f agent

# Seguir instrucciones de device flow si aparecen
```

## Paso 9: Probar Integración

### Probar Agent

```bash
# WebSocket endpoint
curl https://agent.tudominio.com/health

# O acceder en navegador
# Debería ver interfaz web de OpenClaw
```

### Probar Chat

```bash
# Acceder a Chatwoot
https://chat.tudominio.com

# Crear conversación de prueba
# Si el bridge está configurado, el agente debería responder
```

### Probar Hub

```bash
# Acceder a ERPNext
https://hub.tudominio.com

# Login con usuario Administrator
# Explorar módulos: CRM, Ventas, Proyectos, etc.
```

## Paso 10: Configurar Backups

```bash
# Inicializar repositorio Restic (primera vez)
source .env
restic -r $RESTIC_REPOSITORY init

# O usar script helper
./lab/backups/scripts/init-restic.sh

# Configurar cron para backups diarios
crontab -e

# Agregar línea:
0 2 * * * /opt/ats/Versatile\ Hub/lab/backups/scripts/backup.sh >> /opt/ats/Versatile\ Hub/lab/backups/logs/backup.log 2>&1
```

## Troubleshooting

### Los servicios no inician

```bash
# Ver logs de error
docker compose logs [servicio]

# Verificar que .env esté configurado
cat .env | grep -v "^#" | grep -v "^$"

# Verificar que la red web exista
docker network inspect web
```

### No puedo acceder a los dominios

```bash
# Verificar DNS
dig agent.tudominio.com

# Verificar Traefik
docker logs traefik 2>&1 | grep -i error

# Verificar labels Docker
docker inspect versatile-agent | grep -A 20 Labels
```

### Base de datos no inicia

```bash
# Ver health check
docker compose ps

# Ver logs
docker compose logs hub-db
docker compose logs chat-postgres

# Verificar permisos de directorios
ls -la services/hub/data/
ls -la services/chat/data/
```

### SSL no funciona

```bash
# Verificar Traefik logs
docker logs traefik -f | grep -i cert

# Verificar que el dominio resuelva correctamente
curl -I http://agent.tudominio.com

# Verificar ACME challenge (Let's Encrypt)
docker logs traefik 2>&1 | grep -i acme
```

## Comandos Útiles

```bash
# Ver todos los contenedores
docker compose ps

# Reiniciar un servicio
docker compose restart agent

# Ver logs de todos los servicios
docker compose logs -f

# Entrar a un contenedor
docker exec -it versatile-agent sh
docker exec -it versatile-hub-backend bash

# Ver uso de recursos
docker stats

# Limpiar recursos no usados
docker system prune -a
```

## Soporte

- **Documentación completa**: `cat lab/context/services-overview.md`
- **Arquitectura de redes**: `cat lab/context/networks-architecture.md`
- **Estado del proyecto**: `cat lab/CURRENT_STATUS.md`
- **Estructura**: `cat STRUCTURE.md`

## Próximos Pasos

1. ✓ Desplegar servicios básicos
2. Configurar monitoreo (Netdata, Prometheus)
3. Configurar backups automatizados
4. Configurar alertas (healthchecks.io)
5. Documentar procedimientos de operación
6. Implementar Flow service (n8n o similar)

---

**Tiempo estimado total:** 15-30 minutos (dependiendo de velocidad de red y DNS)

**Última actualización:** 2026-02-23
