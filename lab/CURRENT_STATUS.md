# Estructura Actual - Versatile Hub

**Fecha de creación:** 2026-02-23  
**Estado:** Estructura base creada ✅

## 📁 Estructura Completa

```
/opt/ats/Versatile Hub/
│
├── README.md                          # Documentación principal del proyecto
│
├── lab/                               # 🧪 Laboratorio y documentación
│   ├── README.md                      # Guía del directorio lab
│   │
│   ├── context/                       # Contexto y decisiones
│   │   └── README.md                  # ADRs y justificaciones técnicas
│   │
│   ├── spec/                          # Especificaciones técnicas
│   │   └── README.md                  # Arquitectura y specs detalladas
│   │
│   ├── config/                        # Configuraciones globales
│   │   └── README.md                  # Guía de configuración
│   │
│   ├── scripts/                       # Scripts de utilidad
│   │   └── README.md                  # Documentación de scripts
│   │
│   └── backups/                       # Sistema de backups
│       ├── README.md                  # Guía de backups con Restic
│       └── scripts/                   # Scripts de backup/restore
│
├── infrastructure/                    # 🏗️ Infraestructura
│   ├── traefik/                       # Reverse proxy y SSL
│   ├── nginx/                         # Servidor web
│   ├── ssl/                           # Certificados SSL
│   └── letsencrypt/                   # Let's Encrypt (ACME)
│
└── services/                          # 🚀 Microservicios
    ├── agent/                         # Servicio de agentes
    │   ├── config/
    │   ├── data/
    │   └── scripts/
    │
    ├── chat/                          # Servicio de chat
    │   ├── config/
    │   └── scripts/
    │
    ├── flow/                          # Servicio de flujos
    │   ├── config/
    │   └── data/
    │
    └── hub/                           # Hub central (Frappe)
        ├── config/
        └── data/
```

## ✅ Completado

1. ✅ Estructura de directorios creada
2. ✅ Organización en minúsculas
3. ✅ Lab como contenedor de documentación
4. ✅ Separación infrastructure/services
5. ✅ Subdirectorios para cada servicio
6. ✅ README en cada sección principal
7. ✅ Docker Compose unificado creado
8. ✅ Arquitectura de redes definida
9. ✅ Variables de entorno (.env.example) configuradas
10. ✅ Documentación de servicios completa
11. ✅ Script de despliegue (deploy.sh)

## ⏳ Próximos Pasos

### Fase 1: Configuración Base (✅ COMPLETADA)

1. **Crear archivos de configuración**
   - ✅ `.env.example` en raíz
   - ✅ `.env.example` en cada servicio
   - ✅ Configuración de redes Docker
   - ✅ Variables de entorno por servicio

2. **Docker Compose principal**
   - ✅ `docker-compose.yml` en raíz
   - ✅ Definición de redes (web, shared, *-internal)
   - ✅ Definición de volúmenes
   - ✅ Labels de Traefik configurados

3. **Documentación técnica**
   - ✅ `lab/context/services-overview.md`
   - ✅ `lab/context/networks-architecture.md`

### Fase 2: Migración de Servicios (Prioridad Alta)

4. **Migrar Hub Service**
   - [ ] Copiar configuración desde `/opt/ats/Dev/servicios/versatile-hub/`
   - [ ] Adaptar `docker-compose.yml`
   - [ ] Migrar datos existentes
   - [ ] Probar funcionamiento

5. **Migrar Agent Service**
   - [ ] Copiar desde `/opt/ats/Dev/servicios/ats-agent/`
   - [ ] Adaptar configuración
   - [ ] Integrar con red Docker

6. **Migrar Chat Service**
   - [ ] Copiar desde `/opt/ats/Dev/servicios/ats-chat/`
   - [ ] Configurar WebSocket
   - [ ] Integrar autenticación

7. **Migrar Flow Service**
   - [ ] Copiar desde `/opt/ats/Production/servicios/versatile-flow/`
   - [ ] Adaptar para nueva estructura
   - [ ] Configurar permisos

### Fase 3: Scripts y Automatización (Prioridad Media)

8. **Scripts de despliegue**
   - [ ] `lab/scripts/deploy.sh`
   - [ ] `lab/scripts/setup.sh`
   - [ ] `lab/scripts/rollback.sh`

9. **Scripts de backups**
   - [ ] Migrar configuración de `/opt/ats/restic/`
   - [ ] `lab/backups/scripts/backup.sh`
   - [ ] `lab/backups/scripts/restore.sh`
   - [ ] Configurar cron jobs

10. **Scripts de mantenimiento**
    - [ ] `lab/scripts/cleanup.sh`
    - [ ] `lab/scripts/update.sh`
    - [ ] `lab/scripts/health-check.sh`

### Fase 4: Documentación (Prioridad Media)

11. **Especificaciones detalladas**
    - [ ] `lab/spec/agent-spec.md`
    - [ ] `lab/spec/chat-spec.md`
    - [ ] `lab/spec/flow-spec.md`
    - [ ] `lab/spec/hub-spec.md`
    - [ ] `lab/spec/infrastructure-spec.md`

12. **Guías de operación**
    - [ ] `lab/spec/deployment-guide.md`
    - [ ] `lab/spec/migration-guide.md`
    - [ ] `lab/spec/disaster-recovery.md`

13. **Documentación de contexto**
    - [ ] `lab/context/migration-context.md`
    - [ ] `lab/context/tech-stack.md`
    - [ ] ADRs importantes

### Fase 5: Testing y Validación (Prioridad Alta)

14. **Validación**
    - [ ] Probar despliegue completo en entorno de prueba
    - [ ] Validar comunicación entre servicios
    - [ ] Probar backups y restauración
    - [ ] Verificar SSL y certificados
    - [ ] Load testing básico

15. **Documentar issues encontrados**
    - [ ] Crear lista de problemas y soluciones
    - [ ] Actualizar documentación con aprendizajes

### Fase 6: Preparación para Producción (Prioridad Alta)

16. **Hardening de seguridad**
    - [ ] Revisar todas las contraseñas
    - [ ] Configurar firewall
    - [ ] Limitar acceso a puertos
    - [ ] Configurar rate limiting

17. **Monitoreo**
    - [ ] Configurar health checks
    - [ ] Logs centralizados
    - [ ] Alertas básicas

18. **Documentación final**
    - [ ] Runbook de operaciones
    - [ ] Procedimientos de emergencia
    - [ ] Contactos y escalamiento

## 🎯 Hitos Principales

| Hito | Descripción | Fecha Objetivo |
|------|-------------|----------------|
| ✅ M1 | Estructura base creada | 2026-02-23 |
| ✅ M2 | Configuración base completa | 2026-02-23 |
| ⏳ M3 | Servicios migrados y funcionando | Por definir |
| ⏳ M4 | Scripts de automatización listos | Por definir |
| ⏳ M5 | Testing completo | Por definir |
| ⏳ M6 | Producción lista | Por definir |

## 📋 Archivos a Crear Inmediatamente

### Archivos de configuración esenciales

```bash
# En raíz
/opt/ats/Versatile Hub/.env.example
/opt/ats/Versatile Hub/.gitignore
/opt/ats/Versatile Hub/docker-compose.yml
/opt/ats/Versatile Hub/deploy.sh

# En lab/config/templates/
lab/config/templates/.env.agent
lab/config/templates/.env.chat
lab/config/templates/.env.flow
lab/config/templates/.env.hub
lab/config/templates/restic.env

# En infrastructure/
infrastructure/traefik/traefik.yml
infrastructure/traefik/docker-compose.yml
infrastructure/nginx/nginx.conf

# En servicios (adaptar desde originales)
services/hub/docker-compose.yml
services/agent/docker-compose.yml
services/chat/docker-compose.yml
services/flow/docker-compose.yml
```

## 🔗 Referencias de Migración

### Directorios origen

```bash
# Servicios de desarrollo
/opt/ats/Dev/servicios/ats-agent/      → services/agent/
/opt/ats/Dev/servicios/ats-chat/       → services/chat/
/opt/ats/Dev/servicios/versatile-hub/  → services/hub/

# Servicios de producción
/opt/ats/Production/servicios/versatile-flow/  → services/flow/

# Infraestructura
/opt/ats/Production/infraestructura/traefik/   → infrastructure/traefik/
/opt/ats/Production/infraestructura/nginx/     → infrastructure/nginx/
/opt/ats/Production/infraestructura/ssl/       → infrastructure/ssl/
/opt/ats/Production/infraestructura/letsencrypt/ → infrastructure/letsencrypt/

# Backups
/opt/ats/restic/                       → lab/backups/
```

## 💡 Notas Importantes

1. **No eliminar estructura antigua hasta validar completamente la nueva**
2. **Hacer backup de todo antes de cada paso importante**
3. **Probar cada servicio individualmente antes de integrar**
4. **Documentar cualquier cambio o decisión importante**
5. **Mantener este archivo actualizado con el progreso**

## 🚀 Comando Rápido: Siguiente Paso

Para desplegar el sistema completo:

```bash
# 1. Ir al directorio del proyecto
cd "/opt/ats/Versatile Hub"

# 2. Copiar y configurar variables de entorno
cp .env.example .env
nano .env

# 3. Verificar que Traefik esté corriendo y la red 'web' exista
docker network ls | grep web

# 4. Ejecutar despliegue
./deploy.sh

# 5. Ver logs
docker compose logs -f

# 6. Verificar estado
docker compose ps
```

Para migrar datos desde la estructura antigua:

```bash
# Ver guía de migración
cat lab/context/services-overview.md

# Script de migración (próximamente)
# ./lab/scripts/migrate-from-old-structure.sh
```

---

📅 **Última actualización:** 2026-02-23  
📝 **Mantenedor:** Actualizar después de cada hito completado
