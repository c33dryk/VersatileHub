# Guía de Despliegue en Servidor Remoto

**Servidor:** srv1340681 (76.13.239.206)  
**Ubicación:** `/opt/ATS/VersatileHub`  
**Fecha:** 2026-02-24

---

## ✅ Pre-requisitos Verificados

- [x] Conexión SSH establecida
- [x] Directorio `/opt/ATS/VersatileHub` creado
- [x] 21 archivos transferidos (272K)
- [x] Permisos de `deploy.sh` configurados
- [ ] Docker instalado
- [ ] Docker Compose instalado

---

## 🚀 Pasos de Despliegue

### 1. Instalar Docker y Docker Compose

```bash
# En el servidor remoto (76.13.239.206)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Verificar instalación
docker --version
docker compose version
```

### 2. Configurar Variables de Entorno

```bash
cd /opt/ATS/VersatileHub

# Copiar archivo de ejemplo
cp .env.example .env

# Editar con tus valores
nano .env
```

**Variables críticas a configurar:**

```bash
# Dominio principal
DOMAIN=tu-dominio.com

# Agent Service
AGENT_PORT=18789
OPENCLAW_API_KEY=tu-clave-api-segura

# Chat Service (Chatwoot)
CHATWOOT_PORT=3000
CHATWOOT_SECRET_KEY_BASE=$(openssl rand -hex 64)
POSTGRES_PASSWORD=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 32)

# Hub Service (ERPNext)
HUB_HTTP_PORT=8080
HUB_WEBSOCKET_PORT=9000
ERPNEXT_ADMIN_PASSWORD=tu-password-admin
MARIADB_ROOT_PASSWORD=$(openssl rand -base64 32)
```

### 3. Crear Red Docker Externa

```bash
# Crear red 'web' para Traefik
docker network create web
```

### 4. Desplegar Servicios

```bash
cd /opt/ATS/VersatileHub

# Opción A: Despliegue completo automatizado
./deploy.sh

# Opción B: Despliegue manual por servicio
docker compose up -d agent
docker compose up -d chat
docker compose up -d hub
```

### 5. Verificar Estado

```bash
# Ver contenedores activos
docker compose ps

# Ver logs
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f agent
docker compose logs -f chat-web
docker compose logs -f hub-frontend
```

### 6. Acceder a los Servicios

Una vez desplegado:

- **Agent (OpenClaw):** http://76.13.239.206:18789
- **Chat (Chatwoot):** http://76.13.239.206:3000
- **Hub (ERPNext):** http://76.13.239.206:8080

---

## 🔧 Comandos Útiles

### Gestión de Contenedores

```bash
cd /opt/ATS/VersatileHub

# Ver estado
docker compose ps

# Reiniciar todo
docker compose restart

# Detener todo
docker compose down

# Detener y eliminar volúmenes
docker compose down -v

# Ver logs en tiempo real
docker compose logs -f

# Rebuild y restart
docker compose up -d --build
```

### Monitoreo

```bash
# Recursos de contenedores
docker stats

# Ver networks
docker network ls
docker network inspect web

# Ver volúmenes
docker volume ls
```

### Backups

```bash
# Backup de volúmenes Docker
docker run --rm \
  -v versatilehub_chatwoot_storage:/data \
  -v /opt/ATS/backups:/backup \
  alpine tar czf /backup/chatwoot-$(date +%Y%m%d).tar.gz -C /data .

# Backup de base de datos Chatwoot
docker compose exec chat-postgres pg_dump -U postgres chatwoot_production \
  > /opt/ATS/backups/chatwoot-db-$(date +%Y%m%d).sql

# Backup de MariaDB (ERPNext)
docker compose exec hub-mariadb mysqldump -u root -p --all-databases \
  > /opt/ATS/backups/erpnext-db-$(date +%Y%m%d).sql
```

---

## 🐛 Troubleshooting

### Problema: Puerto ocupado

```bash
# Ver qué está usando el puerto
netstat -tulpn | grep :3000
lsof -i :3000

# Matar proceso
kill -9 <PID>
```

### Problema: Red 'web' no existe

```bash
docker network create web
docker compose up -d
```

### Problema: Contenedor no inicia

```bash
# Ver logs específicos
docker compose logs chat-web

# Verificar variables de entorno
docker compose config

# Recrear contenedor
docker compose up -d --force-recreate chat-web
```

### Problema: Sin espacio en disco

```bash
# Limpiar imágenes no usadas
docker system prune -a

# Limpiar volúmenes no usados
docker volume prune

# Ver espacio usado
docker system df
```

---

## 🔐 Seguridad

### Firewall

```bash
# Permitir puertos necesarios
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 18789/tcp
ufw allow 3000/tcp
ufw allow 8080/tcp

# Solo si necesitas SSH desde otro lugar
ufw allow 22/tcp

# Activar firewall
ufw enable
```

### SSL/TLS (Opcional)

Si tienes dominio configurado:

```bash
# Instalar Certbot
apt-get update
apt-get install -y certbot

# Obtener certificado
certbot certonly --standalone -d tu-dominio.com

# Certificados estarán en:
# /etc/letsencrypt/live/tu-dominio.com/
```

---

## 📊 Verificación Post-Despliegue

### Checklist

- [ ] Docker instalado y funcionando
- [ ] Red 'web' creada
- [ ] Archivo `.env` configurado
- [ ] 15 contenedores corriendo
- [ ] Agent accesible en puerto 18789
- [ ] Chatwoot accesible en puerto 3000
- [ ] ERPNext accesible en puerto 8080
- [ ] Logs sin errores críticos
- [ ] Bases de datos funcionando
- [ ] Firewall configurado

### Comandos de Verificación

```bash
# 1. Docker funcionando
docker ps | wc -l
# Debería mostrar 16 (15 contenedores + 1 header)

# 2. Redes activas
docker network ls | grep -E "web|shared"

# 3. Servicios respondiendo
curl -I http://localhost:18789  # Agent
curl -I http://localhost:3000   # Chatwoot
curl -I http://localhost:8080   # ERPNext

# 4. Espacio en disco
df -h /
```

---

## 📝 Notas Importantes

### Recursos Mínimos Recomendados

- **CPU:** 4 cores
- **RAM:** 8 GB (mínimo)
- **Disco:** 50 GB disponibles
- **Red:** 100 Mbps

### Primer Acceso

**Chatwoot:**
- URL: http://76.13.239.206:3000
- Crear cuenta de administrador en primera visita

**ERPNext:**
- URL: http://76.13.239.206:8080
- Usuario: Administrator
- Password: el configurado en `ERPNEXT_ADMIN_PASSWORD`

**OpenClaw:**
- URL: http://76.13.239.206:18789
- API Key: la configurada en `OPENCLAW_API_KEY`

---

## 🔄 Próximos Pasos

1. **Configurar dominio:** Apuntar DNS a 76.13.239.206
2. **SSL:** Instalar certificados con Certbot
3. **Backups:** Configurar backups automáticos
4. **Monitoreo:** Instalar Prometheus/Grafana
5. **Alertas:** Configurar notificaciones

---

## 📚 Documentación Adicional

- [README.md](./README.md) - Descripción general del proyecto
- [QUICKSTART.md](./QUICKSTART.md) - Guía rápida de 15 minutos
- [STRUCTURE.md](./STRUCTURE.md) - Estructura del proyecto
- [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md) - Detalles técnicos

---

**Servidor actual:** 193G total, 2.9G usado, 190G disponible  
**Estado:** ✅ Listo para desplegar

¡Buena suerte con el despliegue! 🚀
