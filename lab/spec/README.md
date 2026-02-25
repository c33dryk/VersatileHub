# Especificaciones Técnicas - Versatile Hub

## 📋 Índice

1. [Arquitectura General](#arquitectura-general)
2. [Servicios](#servicios)
3. [Infraestructura](#infraestructura)
4. [Guías de Implementación](#guías-de-implementación)

## 🏛️ Arquitectura General

### Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────┐
│                     Traefik (Proxy)                      │
│                    SSL/Let's Encrypt                     │
└───────────────────────┬─────────────────────────────────┘
                        │
        ┌───────────────┴───────────────┐
        │                               │
┌───────▼────────┐              ┌──────▼──────┐
│  Nginx (Web)   │              │   Services   │
└────────────────┘              └──────┬───────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
              ┌─────▼─────┐     ┌─────▼─────┐     ┌─────▼─────┐
              │   Agent   │     │   Chat    │     │   Flow    │
              └───────────┘     └───────────┘     └───────────┘
                    │                  │                  │
                    └──────────────────┼──────────────────┘
                                       │
                                 ┌─────▼─────┐
                                 │    Hub    │
                                 │  (Core)   │
                                 └───────────┘
```

### Principios de Diseño

1. **Microservicios**: Cada servicio es independiente y escalable
2. **Contenedorización**: Todo corre en Docker para portabilidad
3. **Configuración Externa**: Variables de entorno y archivos de config
4. **Alta Disponibilidad**: Reinicio automático y health checks
5. **Seguridad**: Redes aisladas, SSL, secretos manejados correctamente

## 🔧 Servicios

### Agent Service

**Propósito**: Gestión de agentes inteligentes para automatización

**Stack Técnico**:
- Base: Por definir (Python/Node.js)
- Base de Datos: PostgreSQL/MongoDB
- Cache: Redis

**Puertos**:
- API: 8001
- Admin: 8002

Ver: [agent-spec.md](./agent-spec.md)

### Chat Service

**Propósito**: Plataforma de comunicación en tiempo real

**Stack Técnico**:
- Backend: Por definir (Node.js/Go)
- WebSocket: Socket.io/native WS
- Base de Datos: MongoDB/PostgreSQL
- Cache: Redis

**Puertos**:
- API: 8003
- WebSocket: 8004

Ver: [chat-spec.md](./chat-spec.md)

### Flow Service

**Propósito**: Automatización de flujos de trabajo

**Stack Técnico**:
- Motor: Node-RED/Airflow/Custom
- Base de Datos: PostgreSQL
- Queue: Redis/RabbitMQ

**Puertos**:
- UI: 8005
- API: 8006

Ver: [flow-spec.md](./flow-spec.md)

### Hub Service

**Propósito**: Centro de gestión y orquestación

**Stack Técnico**:
- Framework: Frappe/ERPNext (basado en código actual)
- Base de Datos: MariaDB
- Cache: Redis

**Puertos**:
- Frontend: 8080
- Backend: 8000

Ver: [hub-spec.md](./hub-spec.md)

## 🏗️ Infraestructura

### Traefik

- Versión: 2.10+
- Certificados: Let's Encrypt (ACME)
- Dashboard: Habilitado en desarrollo, deshabilitado en producción

Ver: [infrastructure-spec.md](./infrastructure-spec.md)

### Nginx

- Versión: 1.24+
- Uso: Servir estáticos, proxy adicional
- SSL: Gestionado por Traefik

### Redes Docker

```yaml
networks:
  proxy:      # Red pública (Traefik)
  agent:      # Red privada Agent
  chat:       # Red privada Chat
  flow:       # Red privada Flow
  hub:        # Red privada Hub
  shared:     # Red compartida entre servicios
```

## 📝 Guías de Implementación

### Orden de Implementación

1. ✅ Crear estructura de directorios
2. ✅ Organizar estructura lab/infrastructure/services
3. ⏳ Configurar infraestructura (Traefik, redes)
4. ⏳ Implementar Hub (servicio core)
5. ⏳ Implementar Agent
6. ⏳ Implementar Chat
7. ⏳ Implementar Flow
8. ⏳ Integrar todos los servicios
9. ⏳ Configurar backups
10. ⏳ Testing y validación
11. ⏳ Documentación final

### Variables de Entorno Requeridas

Ver: [environment-vars.md](./environment-vars.md)

### Comandos de Despliegue

Ver: [deployment-guide.md](./deployment-guide.md)

## 🔄 Migración desde Estructura Anterior

Ver guía detallada: [migration-guide.md](./migration-guide.md)

## 📊 Monitoreo y Logs

- Logs centralizados por servicio en `services/*/logs/`
- Configuración de logging en `lab/config/logging/`
- Health checks en cada servicio
- Métricas disponibles vía endpoints `/health` y `/metrics`

## 🔐 Seguridad

### Checklist de Seguridad

- [ ] Todos los secretos en variables de entorno
- [ ] Certificados SSL configurados
- [ ] Redes Docker aisladas
- [ ] Firewall configurado
- [ ] Backups cifrados y testeados
- [ ] Usuarios no-root en contenedores
- [ ] Volúmenes con permisos correctos

## 📅 Roadmap

### Fase 1: MVP (Actual)
- Estructura básica
- Servicios core funcionando
- Infraestructura básica

### Fase 2: Integración
- Comunicación entre servicios
- API Gateway
- Autenticación unificada

### Fase 3: Escalabilidad
- Load balancing
- Auto-scaling
- Alta disponibilidad

### Fase 4: Observabilidad
- Monitoreo avanzado
- Dashboards
- Alertas automatizadas
