# Context - Documentación de Contexto

Este directorio contiene la documentación de contexto del proyecto Versatile Hub, incluyendo decisiones de arquitectura, justificaciones técnicas y evolución histórica del proyecto.

## 📋 Contenido

### 1. Decisiones de Arquitectura (ADR)

Documentación de decisiones importantes usando el formato ADR (Architecture Decision Records).

**Formato:**
```
# ADR-XXX: Título de la Decisión

## Estado
[Propuesto | Aceptado | Deprecado | Supersedido]

## Contexto
¿Qué problema estamos tratando de resolver?

## Decisión
¿Qué decisión tomamos?

## Consecuencias
¿Cuáles son las implicaciones de esta decisión?
```

### 2. Historia del Proyecto

- Origen y evolución
- Cambios importantes en la arquitectura
- Lecciones aprendidas

### 3. Justificaciones Técnicas

- Por qué elegimos ciertas tecnologías
- Alternativas consideradas
- Trade-offs y compromisos

## 🎯 Propósito

Este directorio ayuda a:

- **Entender el "por qué"** detrás de decisiones técnicas
- **Mantener conocimiento institucional**
- **Facilitar onboarding** de nuevos desarrolladores
- **Evitar repetir errores** del pasado
- **Documentar evolución** del proyecto

## 📂 Documentos Principales

### Infraestructura Lista para Despliegue

**Archivo:** `deployment-context.md`

Documenta la infraestructura completa lista para desplegar:
- Cada servicio tiene su propio `docker-compose.yml`
- Infrastructure tiene configuración de Traefik y networking
- No requiere migración de servicios existentes
- Lista para levantar desde cero en entorno de cliente

### Selección de Stack Tecnológico

**Archivo:** `tech-stack.md`

- Frappe/ERPNext para Hub Core
- Docker para contenedorización
- Traefik como reverse proxy
- Restic para backups

### Arquitectura de Microservicios

**Archivo:** `microservices-architecture.md`

Justificación de la separación en servicios independientes:
- Agent
- Chat
- Flow
- Hub

## 🔄 Actualización

Este directorio debe actualizarse cuando:

- Se toma una decisión arquitectónica importante
- Se cambia significativamente la infraestructura
- Se aprende una lección valiosa
- Se depreca o reemplaza un componente

## 📝 Template ADR

```markdown
# ADR-001: [Título]

**Fecha:** YYYY-MM-DD
**Estado:** [Propuesto/Aceptado/Deprecado]
**Responsable:** [Nombre]

## Contexto

[Describe el problema o situación que motiva esta decisión]

## Opciones Consideradas

1. Opción A
   - Pros: ...
   - Contras: ...

2. Opción B
   - Pros: ...
   - Contras: ...

## Decisión

[La decisión tomada y su justificación]

## Consecuencias

### Positivas
- ...

### Negativas
- ...

### Riesgos
- ...

## Referencias

- [Links relevantes]
```

## 🔗 Ver También

- [Especificaciones Técnicas](../spec/README.md)
- [Guías de Configuración](../config/README.md)
