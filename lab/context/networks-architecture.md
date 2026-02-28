# Arquitectura de Redes - Versatile Hub

## Resumen Ejecutivo

Versatile Hub utiliza una arquitectura de redes Docker que equilibra **seguridad**, **aislamiento** y **comunicación eficiente** entre servicios.

```
┌─────────────────────────────────────────────────────────────┐
│                         Internet                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
            ┌────────────────────────┐
            │   Traefik (Proxy)      │
            │   Red: web (externa)   │
            └────────┬───────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
    ┌───▼───┐   ┌───▼───┐   ┌───▼───┐
    │Agent  │   │ Chat  │   │  Hub  │
    │ Web   │   │ Web   │   │Front  │
    └───┬───┘   └───┬───┘   └───┬───┘
        │           │            │
        │       ┌───┴───┐    ┌───┴──────┐
        │       │ Redis │    │ Backend  │
        │       │  PG   │    │ WebSocket│
        │       │Worker │    │  Worker  │
        │       └───────┘    └──────────┘
        │    chat-internal   hub-internal
        │
        └──────────────┬───────────────┘
                       │
                 shared (inter-servicios)
```

---

## Redes Definidas

### 1. Red `web` (Externa)

**Tipo:** Externa  
**Driver:** Bridge  
**Propósito:** Exposición pública vía Traefik

#### Servicios Conectados
- `agent` (versatile-agent)
- `chat-web` (versatile-chat-web)
- `chat-bridge` (versatile-chat-bridge)
- `hub-frontend` (versatile-hub-frontend)

#### Características
- **Externa**: Debe crearse antes de levantar docker-compose
- **Gestión**: Compartida con Traefik y otros servicios del servidor
- **Seguridad**: Solo servicios que deben ser accesibles públicamente

#### Creación
```bash
docker network create web
```

#### Verificación
```bash
docker network ls | grep web
docker network inspect web
```

---

### 2. Red `shared` (Compartida)

**Tipo:** Interna  
**Driver:** Bridge  
**Nombre:** versatile-shared  
**Propósito:** Comunicación inter-servicios

#### Servicios Conectados
- `agent` (versatile-agent)
- `hub-backend` (versatile-hub-backend)
- `chat-bridge` (versatile-chat-bridge)

#### Características
- **Interna**: No expuesta a Internet
- **Comunicación**: Permite que servicios se comuniquen directamente
- **DNS**: Resolución automática por nombre de servicio

#### Casos de Uso
1. **Agent → Hub Backend**
   - Agent ejecuta comandos en hub-backend vía Docker
   - Acceso a API interna de Frappe
   
2. **Agent ↔ Chat Bridge**
   - WebSocket entre Agent y Bridge
   - Procesamiento de mensajes de Chatwoot
   
3. **Future**: Otros servicios que necesiten comunicarse

---

### 3. Red `chat-internal` (Chat Privada)

**Tipo:** Interna  
**Driver:** Bridge  
**Nombre:** versatile-chat-internal  
**Propósito:** Aislamiento de componentes de Chatwoot

#### Servicios Conectados
- `chat-web` (versatile-chat-web)
- `chat-worker` (versatile-chat-worker)
- `chat-postgres` (versatile-chat-postgres)
- `chat-redis` (versatile-chat-redis)
- `chat-bridge` (versatile-chat-bridge)

#### Características
- **Completamente aislada**: No se comunica con otras redes internas
- **Base de datos protegida**: DB y Redis no accesibles desde fuera
- **Worker interno**: Jobs background en red privada

#### Flujo de Datos
```
Internet → Traefik → chat-web (web + chat-internal)
                     ↓
                   worker (chat-internal)
                     ↓
                   postgres/redis (chat-internal)
```

---

### 4. Red `hub-internal` (Hub Privada)

**Tipo:** Interna  
**Driver:** Bridge  
**Nombre:** versatile-hub-internal  
**Subnet:** 172.31.0.0/16  
**Bridge Name:** br-hub  
**Propósito:** Aislamiento de componentes de Frappe/ERPNext

#### Servicios Conectados
- `hub-db` (versatile-hub-db)
- `hub-redis-cache` (versatile-hub-redis-cache)
- `hub-redis-queue` (versatile-hub-redis-queue)
- `hub-backend` (versatile-hub-backend)
- `hub-frontend` (versatile-hub-frontend)
- `hub-websocket` (versatile-hub-websocket)
- `hub-worker` (versatile-hub-worker)
- `hub-scheduler` (versatile-hub-scheduler)

#### Características
- **Subnet dedicada**: 172.31.0.0/16 (65,534 IPs disponibles)
- **Bridge nombrado**: br-hub para identificación fácil
- **Componentes múltiples**: 8 contenedores aislados
- **Backend en shared**: hub-backend también conectado a `shared` para comunicación con Agent

#### Flujo de Datos
```
Internet → Traefik → hub-frontend (web + hub-internal)
                     ↓
                   backend (hub-internal + shared)
                     ↓
                   websocket/worker/scheduler
                     ↓
                   mariadb/redis
```

---

## Matriz de Conectividad

| Servicio | web | shared | chat-internal | hub-internal |
|----------|-----|--------|---------------|--------------|
| **agent** | ✓ | ✓ | ✗ | ✗ |
| **chat-web** | ✓ | ✗ | ✓ | ✗ |
| **chat-worker** | ✗ | ✗ | ✓ | ✗ |
| **chat-postgres** | ✗ | ✗ | ✓ | ✗ |
| **chat-redis** | ✗ | ✗ | ✓ | ✗ |
| **chat-bridge** | ✓ | ✓ | ✓ | ✗ |
| **hub-frontend** | ✓ | ✗ | ✗ | ✓ |
| **hub-backend** | ✗ | ✓ | ✗ | ✓ |
| **hub-websocket** | ✗ | ✗ | ✗ | ✓ |
| **hub-worker** | ✗ | ✗ | ✗ | ✓ |
| **hub-scheduler** | ✗ | ✗ | ✗ | ✓ |
| **hub-db** | ✗ | ✗ | ✗ | ✓ |
| **hub-redis-*** | ✗ | ✗ | ✗ | ✓ |

### Leyenda
- ✓ : Conectado a la red
- ✗ : No conectado

---

## Patrones de Comunicación

### 1. Público → Servicio (vía Traefik)

```
Cliente HTTPS → Traefik → [web] → Servicio
                         ↓
                     TLS termination
                     Load balancing
                     HTTP headers
```

**Servicios expuestos:**
- `agent.versatilehub.app` → agent:18789
- `chat.versatilehub.app` → chat-web:3000
- `chat-bridge.versatilehub.app` → chat-bridge:4000
- `altamira.versatilehub.app` → hub-frontend:8080
- `flow.versatilehub.app` → flow:5678 (cuando se implemente)

### 2. Servicio → Servicio (misma red interna)

```
Servicio A → [red-internal] → Servicio B
             ↓
         DNS automático por nombre
         Comunicación directa
```

**Ejemplo:**
```bash
# Desde chat-web a postgres
DATABASE_URL=postgresql://user:pass@chat-postgres:5432/db
#                                    ↑
#                            DNS resuelve automáticamente
```

### 3. Servicio → Servicio (diferente red vía shared)

```
Agent → [shared] → Hub Backend
        ↓
    Comunicación inter-servicios
    DNS resolution
```

**Ejemplo:**
```bash
# Agent puede acceder a Hub Backend
curl http://hub-backend:8000/api/method/ping
```

### 4. Servicio → Base de Datos (red interna)

```
Aplicación → [internal] → Database
             ↓
         Solo red interna
         No acceso externo
```

**Seguridad:**
- Bases de datos **NUNCA** en red `web`
- Solo accesibles desde misma red interna
- No puertos expuestos en host

---

## Seguridad

### Principios

1. **Least Privilege**: Cada servicio solo en redes necesarias
2. **Network Isolation**: Bases de datos aisladas en redes internas
3. **No Bind Ports**: No exponer puertos innecesarios al host
4. **Traefik Gateway**: Único punto de entrada público

### Buenas Prácticas

#### ✅ Hacer

```yaml
# Exponer servicio vía Traefik (no bind port)
expose:
  - "8080"
labels:
  - "traefik.http.services.myapp.loadbalancer.server.port=8080"
networks:
  - web
```

#### ❌ No Hacer

```yaml
# NO exponer puertos innecesariamente
ports:
  - "5432:5432"  # ❌ Expone DB público
  - "6379:6379"  # ❌ Expone Redis público
```

### Firewall del Host

Además de redes Docker, configurar firewall:

```bash
# Permitir solo SSH, HTTP, HTTPS
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw default deny incoming
ufw enable
```

---

## Troubleshooting

### Verificar Redes

```bash
# Listar todas las redes
docker network ls

# Inspeccionar red específica
docker network inspect web
docker network inspect versatile-shared

# Ver qué contenedores están en una red
docker network inspect versatile-chat-internal \
  --format '{{range .Containers}}{{.Name}} {{end}}'
```

### Probar Conectividad

```bash
# Desde un contenedor a otro
docker exec versatile-agent ping -c 3 hub-backend
docker exec versatile-chat-web nc -zv chat-postgres 5432

# Ver DNS resolution
docker exec versatile-agent nslookup hub-backend
```

### Problemas Comunes

#### 1. Red `web` no existe

**Error:**
```
ERROR: Network web declared as external, but could not be found
```

**Solución:**
```bash
docker network create web
```

#### 2. Servicio no puede comunicarse

**Diagnóstico:**
```bash
# Verificar que estén en la misma red
docker inspect versatile-agent | grep -A 10 Networks
docker inspect hub-backend | grep -A 10 Networks
```

**Solución:** Agregar ambos a red compartida (`shared`)

#### 3. Conflicto de subnets

**Error:**
```
ERROR: Pool overlaps with other one on this address space
```

**Solución:** Cambiar subnet en docker-compose.yml

---

## Monitoreo

### Ver Tráfico

```bash
# Estadísticas de red por contenedor
docker stats

# Logs de conexiones (si Traefik tiene logging)
docker logs traefik -f | grep versatile
```

### Herramientas

```bash
# Instalar netdata para monitoreo de redes Docker
docker run -d \
  --name netdata \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  netdata/netdata
```

---

## Diagrama de Flujo de Datos

### Request HTTP/HTTPS

```
1. Cliente
   ↓ HTTPS (443)
2. Traefik (red: web)
   ↓ TLS termination
   ↓ HTTP (interno)
3. Servicio Frontend (red: web + internal)
   ↓ HTTP (interno)
4. Servicio Backend (red: internal)
   ↓ SQL/Redis
5. Base de Datos (red: internal)
```

### WebSocket (Agent)

```
1. Cliente
   ↓ WSS (443)
2. Traefik (red: web)
   ↓ Upgrade: websocket
3. Agent (red: web + shared)
   ↓ WS (interno)
4. Chat Bridge (red: shared + chat-internal)
   ↓ HTTP API
5. Chat Web (red: chat-internal)
```

---

## Configuración Avanzada

### Custom Subnet

```yaml
networks:
  custom-internal:
    driver: bridge
    ipam:
      config:
        - subnet: 172.32.0.0/16
          gateway: 172.32.0.1
```

### IPv6

```yaml
networks:
  web:
    enable_ipv6: true
    ipam:
      config:
        - subnet: 2001:db8::/64
```

### Network Plugins

Para funcionalidades avanzadas:
- **Weave**: Overlay network
- **Calico**: Network policy
- **Flannel**: Multi-host networking

---

## Referencias

- [Docker Networking Docs](https://docs.docker.com/network/)
- [Traefik Docker Provider](https://doc.traefik.io/traefik/providers/docker/)
- [Docker Network Security](https://docs.docker.com/engine/security/)

---

📅 **Última actualización:** 2026-02-23
