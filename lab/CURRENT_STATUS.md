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
   - ✅ `docker-compose.yml` unificado en raíz
   - ✅ Definición de redes (web, shared, *-internal)
   - ✅ Definición de volúmenes
   - ✅ Labels de Traefik configurados

3. **Documentación técnica**
   - ✅ `lab/context/services-overview.md`
   - ✅ `lab/context/networks-architecture.md`
   - ✅ `lab/context/deployment-context.md`
   - ✅ `lab/spec/contracts-workflow.md`

### Fase 2: Despliegue Inicial (Próximo Paso)

4. **Verificar Infraestructura Base**
   - [ ] Verificar Traefik corriendo (desde /opt/ATS/Production o instalación nueva)
   - [ ] Validar red `web` existe
   - [ ] Confirmar acceso a DNS y dominios

5. **Configurar Variables de Entorno**
   - [ ] Copiar `.env.example` a `.env` en raíz
   - [ ] Configurar dominios del cliente
   - [ ] Configurar API keys y credenciales
   - [ ] Generar secrets con openssl

6. **Levantar Suite Completa**
   - [ ] Ejecutar `docker compose up -d` desde raíz
   - [ ] Verificar todos los servicios levantados
   - [ ] Revisar logs con `docker compose logs -f`

7. **Setup Inicial Post-Despliegue**
   - [ ] Hub: Crear sitio Frappe inicial
   - [ ] Chat: Configurar cuenta admin y primer inbox
   - [ ] Agent: Verificar conectividad WebSocket
   - [ ] Configurar integraciones entre servicios

8. **Configurar Backups**
   - [ ] Integrar con sistema Restic existente
   - [ ] Configurar cron jobs
   - [ ] Ejecutar primer backup de prueba

### Fase 3: Scripts y Automatización (Prioridad Media)

9. **Scripts de despliegue**
   - [ ] `lab/scripts/deploy.sh` - Despliegue completo
   - [ ] `lab/scripts/setup.sh` - Setup inicial
   - [ ] `lab/scripts/rollback.sh` - Rollback rápido

10. **Scripts de backups**
   - [ ] Integrar con `/opt/ATS/restic/` existente
   - [ ] `lab/backups/scripts/backup.sh` - Backup específico VersatileHub
   - [ ] `lab/backups/scripts/restore.sh` - Restauración
   - [ ] Configurar cron jobs

11. **Scripts de mantenimiento**
    - [ ] `lab/scripts/cleanup.sh` - Limpieza de logs y cache
    - [ ] `lab/scripts/update.sh` - Actualización de servicios
    - [ ] `lab/scripts/health-check.sh` - Verificación de salud

### Fase 4: Gestión de Contratos de Desarrollo (✅ ESTRUCTURA LISTA)

12. **Sistema de Contratos** (✅ Documentado)
    - ✅ `lab/spec/contracts-workflow.md` - Proceso completo documentado
    - ✅ `lab/spec/requirements/` - Requerimientos de clientes
    - ✅ `lab/spec/analysis/` - Análisis técnicos
    - ✅ `lab/spec/contracts/` - Contratos formalizados

13. **Especificaciones Técnicas por Servicio** (Por crear según contratos)
    - [ ] `lab/spec/agent-spec.md` - Features de Agent por contrato
    - [ ] `lab/spec/chat-spec.md` - Features de Chat por contrato
    - [ ] `lab/spec/flow-spec.md` - Features de Flow por contrato
    - [ ] `lab/spec/hub-spec.md` - Features de Hub por contrato

14. **Workflow de Contratos**
    ```
    Cliente solicita → REQ-YYYY-MM-NNN.md
                     ↓
    Análisis técnico → ANA-YYYY-MM-NNN.md
                     ↓
    Contrato aprobado → CONT-YYYY-MM-NNN.md
                     ↓
    Desarrollo → Spec de servicio actualizado
                     ↓
    Deploy → Cliente valida → Facturación
    ```

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

## 🏗️ Modelo de Despliegue

### Despliegue Desde Cero (No-Migración)

VersatileHub se despliega como **infraestructura nueva**:

```bash
# 1. Docker Compose Unificado (Recomendado)
cd /opt/ATS/VersatileHub
docker compose up -d
# Levanta todos los servicios: agent, chat, hub, flow

# 2. Infraestructura Compartida (Opcional)
# Puede usar Traefik existente de /opt/ATS/Production
# Solo requiere que exista la red 'web'
docker network create web

# 3. Backups
# Integra con sistema Restic existente
/opt/ATS/restic/scripts/backup.sh
```

### Opciones de Despliegue Futuras

```bash
# Si se necesita despliegue selectivo por servicio:
cd services/hub/
docker compose up -d  # Solo Hub

cd services/agent/
docker compose up -d  # Solo Agent
```

**Nota:** Actualmente solo existe docker-compose.yml unificado en raíz.
Docker-compose individuales por servicio se crearán si se requiere despliegue selectivo.

## 💡 Notas Importantes

1. **VersatileHub es infraestructura nueva** - No reemplaza servicios existentes
2. **Puede convivir con /opt/ATS/Production** - Comparte red Traefik
3. **Hacer backup antes de despliegues importantes**
4. **lab/spec/** es para gestionar contratos de desarrollo con clientes
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

Para gestionar contratos de desarrollo:

```bash
# Ver workflow de contratos
cat lab/spec/contracts-workflow.md

# Crear nuevo requerimiento
cd lab/spec/requirements/
cp README.md REQ-2026-02-001-feature-name.md

# Script de migración (próximamente)
# ./lab/scripts/migrate-from-old-structure.sh
```

---

📅 **Última actualización:** 2026-02-23  
📝 **Mantenedor:** Actualizar después de cada hito completado
