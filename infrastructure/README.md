# Infrastructure - Infraestructura Base

Este directorio contiene toda la configuración de infraestructura compartida por los servicios de VersatileHub.

## 📦 Componentes

### Traefik
- **Versión**: v2.11
- **Función**: Reverse proxy, load balancer, SSL automático
- **Dashboard**: `http://localhost:8080` (acceso vía SSH tunnel 🔐)
- **Certificados**: Let's Encrypt vía Cloudflare DNS Challenge

### Portainer
- **Versión**: Community Edition (latest)
- **Función**: UI de gestión de Docker
- **Dashboard**: `http://localhost:9000` (acceso vía SSH tunnel 🔐)

### Nginx (Opcional)
- **Versión**: Alpine latest
- **Función**: Servidor de archivos estáticos
- **URL**: https://static.${BASE_DOMAIN}
- Estado: Comentado por defecto

## 🚀 Despliegue

### 1. Configuración Inicial

```bash
# Copiar variables de entorno
cd infrastructure/
cp .env.example .env

# Editar configuración
nano .env
```

### Variables Críticas
```bash
BASE_DOMAIN=graficadosd.ar
ACME_EMAIL=admin@graficadosd.ar
CLOUDFLARE_EMAIL=tu-email@cloudflare.com
CLOUDFLARE_API_KEY=tu-cloudflare-global-api-key
```

### 2. Crear Red Externa

```bash
# La red 'web' debe existir para Traefik
docker network create web
```

### 3. Permisos en Directorio de Let's Encrypt

```bash
# Crear directorio y dar permisos
mkdir -p letsencrypt
chmod 600 letsencrypt/
touch letsencrypt/acme.json
chmod 600 letsencrypt/acme.json
```

### 4. Levantar Servicios

```bash
# Desde el directorio infrastructure/
docker compose up -d

# Verificar
docker compose ps
docker compose logs -f traefik
```

## 📋 Configuración de Cloudflare

### Opción A: Global API Key (Más Simple)

1. Login en Cloudflare
2. Ir a: **My Profile** → **API Tokens** → **API Keys**
3. Ver **Global API Key**
4. Agregar a `.env`:
   ```bash
   CLOUDFLARE_EMAIL=tu-email@cloudflare.com
   CLOUDFLARE_API_KEY=tu-global-api-key
   ```

### Opción B: API Token (Más Seguro - Recomendado)

1. Login en Cloudflare
2. Ir a: **My Profile** → **API Tokens** → **Create Token**
3. Usar template: **Edit zone DNS**
4. Permisos necesarios:
   - Zone → DNS → Edit
   - Zone → Zone → Read
5. Zone Resources:
   - Include → Specific zone → versatilehub.app
6. Crear token y agregar a `.env`:
   ```bash
   CLOUDFLARE_DNS_API_TOKEN=tu-dns-api-token
   ```

### DNS Records en Cloudflare

Crear los siguientes registros **A** o **CNAME** apuntando a tu servidor:

```
Tipo  Nombre                  Contenido           Proxy
A     altamira               IP.DEL.SERVIDOR      ✅ Proxied
A     agent                  IP.DEL.SERVIDOR      ✅ Proxied
A     chat                   IP.DEL.SERVIDOR      ✅ Proxied
A     chat-bridge            IP.DEL.SERVIDOR      ✅ Proxied
A     flow                   IP.DEL.SERVIDOR      ✅ Proxied
```

**Nota:** Puedes usar CNAME apuntando a un registro A principal:
```
A     versatilehub.app       IP.DEL.SERVIDOR      ✅ Proxied
CNAME altamira              versatilehub.app     ✅ Proxied
CNAME agent                 versatilehub.app     ✅ Proxied
CNAME chat                  versatilehub.app     ✅ Proxied
...etc
```

**🔒 Seguridad:** Traefik y Portainer NO están expuestos públicamente.
Acceso solo vía SSH tunnel (ver sección "Acceso Seguro").

## 🔐 Acceso Seguro

### Traefik Dashboard (SSH Tunnel)

Traefik NO está expuesto públicamente por seguridad. Acceso solo vía SSH tunnel:

```bash
# En tu máquina local:
ssh -L 8080:localhost:8080 usuario@IP_DEL_SERVIDOR

# Mantener la sesión abierta y abrir navegador:
http://localhost:8080
```

**Alias para simplificar** (agregar a `~/.ssh/config`):
```
Host versatile-traefik
  HostName IP_DEL_SERVIDOR
  User tu_usuario
  LocalForward 8080 localhost:8080
```

Luego solo: `ssh versatile-traefik`

### Portainer (SSH Tunnel)

```bash
# En tu máquina local:
ssh -L 9000:localhost:9000 usuario@IP_DEL_SERVIDOR

# Abrir navegador:
http://localhost:9000
```

**Alias SSH**:
```
Host versatile-portainer
  HostName IP_DEL_SERVIDOR
  User tu_usuario
  LocalForward 9000 localhost:9000
```

### Tunnels Múltiples (Traefik + Portainer)

```bash
# Un solo comando para ambos:
ssh -L 8080:localhost:8080 -L 9000:localhost:9000 usuario@IP_DEL_SERVIDOR

# O crear alias:
Host versatile
  HostName IP_DEL_SERVIDOR
  User tu_usuario
  LocalForward 8080 localhost:8080
  LocalForward 9000 localhost:9000
```

Luego: `ssh versatile`

## 🔐 Seguridad

### Cambiar Password de Portainer

En el primer acceso a Portainer (`http://localhost:9000` vía SSH tunnel),
crea un usuario admin con password fuerte.

**Resetear password** (si se olvida):
```bash
docker compose stop portainer
docker compose run --rm portainer --admin-password='$(htpasswd -nb -B admin tu_nuevo_password | cut -d ":" -f 2)'
docker compose up -d portainer
```

### Firewall

```bash
# Permitir solo puertos necesarios
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw enable
```

## 📊 Monitoreo

### Ver Logs

```bash
# Todos los servicios
docker compose logs -f

# Solo Traefik
docker compose logs -f traefik

# Solo Portainer
docker compose logs -f portainer
```

### Dashboard de Traefik

Acceder vía SSH tunnel:

```bash
# En terminal local:
ssh -L 8080:localhost:8080 usuario@servidor

# En navegador:
http://localhost:8080
```

Ver:
- Routers configurados
- Middlewares activos
- Servicios registrados
- Certificados SSL

### Portainer

Acceder vía SSH tunnel:

```bash
# En terminal local:
ssh -L 9000:localhost:9000 usuario@servidor

# En navegador:
http://localhost:9000
```

Primera vez:
1. Crear usuario admin
2. Conectar al endpoint local
3. Gestionar contenedores, imágenes, volúmenes, redes

## 🔄 Mantenimiento

### Actualizar Imágenes

```bash
docker compose pull
docker compose up -d --force-recreate
```

### Renovar Certificados SSL

Let's Encrypt renueva automáticamente. Para forzar:

```bash
# Detener Traefik
docker compose stop traefik

# Eliminar acme.json
rm letsencrypt/acme.json
touch letsencrypt/acme.json
chmod 600 letsencrypt/acme.json

# Reiniciar
docker compose up -d traefik
```

### Backup

```bash
# Backup de configuración
tar -czf infrastructure-backup-$(date +%Y%m%d).tar.gz \
  .env \
  letsencrypt/acme.json \
  traefik/config/ \
  data/portainer/

# Restaurar
tar -xzf infrastructure-backup-YYYYMMDD.tar.gz
```

## 🆘 Troubleshooting

### Traefik no genera certificados

```bash
# Ver logs
docker compose logs traefik | grep -i cert

# Verificar permisos
ls -la letsencrypt/acme.json
# Debe ser 600

# Verificar Cloudflare API
docker compose exec traefik sh
# Dentro del contenedor:
env | grep CLOUDFLARE
```

### Error "network web not found"

```bash
docker network create web
docker compose up -d
```

### Dashboard Traefik no accesible

```bash
# Verificar que Traefik está corriendo
docker compose ps traefik

# Verificar puerto local
ss -tuln | grep 8080
# Debe mostrar: 127.0.0.1:8080

# Verificar desde el servidor
curl http://localhost:8080/dashboard/

# Acceder vía SSH tunnel desde tu máquina local
ssh -L 8080:localhost:8080 usuario@servidor
```

## 📁 Estructura

```
infrastructure/
├── .env.example              # Template de configuración
├── .env                      # Configuración real (git-ignored)
├── docker-compose.yml        # Definición de servicios
├── README.md                 # Este archivo
│
├── traefik/
│   └── config/              # Configuración adicional de Traefik
│
├── nginx/
│   ├── conf.d/              # Configuración de Nginx
│   └── www/                 # Archivos estáticos
│
├── ssl/                     # Certificados SSL manuales (opcional)
├── letsencrypt/             # Certificados Let's Encrypt
│   ├── acme.json           # Certificados (600 perms)
│   └── acme-http.json      # HTTP challenge (si se usa)
│
└── data/
    └── portainer/           # Datos de Portainer
```

## 🔗 Referencias

- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Portainer Documentation](https://docs.portainer.io/)
- [Cloudflare API](https://developers.cloudflare.com/api/)
- [Let's Encrypt](https://letsencrypt.org/docs/)

---

**Última actualización:** 2026-02-28
