# Workflow de Contratos de Desarrollo

## 🎯 Propósito

Este documento describe el proceso para gestionar contratos de desarrollo con clientes utilizando las especificaciones técnicas de VersatileHub.

## 📋 Proceso de Contratos

### 1. Recepción de Requerimiento

**Cliente solicita funcionalidad nueva**

```
Cliente → Requerimiento → Evaluación Técnica
```

**Información a recopilar:**
- Descripción detallada de la funcionalidad
- Objetivo de negocio
- Usuarios afectados
- Prioridad (Alta/Media/Baja)
- Timeline esperado
- Presupuesto aproximado

**Documento:** `lab/spec/requirements/REQ-YYYY-MM-NNN.md`

---

### 2. Análisis Técnico

**Equipo técnico evalúa viabilidad**

**Aspectos a evaluar:**
- ✅ ¿En qué servicio se implementa? (Agent/Chat/Hub/Flow)
- ✅ ¿Requiere cambios en infraestructura?
- ✅ ¿Hay dependencias con otros servicios?
- ✅ ¿Impacta funcionalidades existentes?
- ✅ ¿Requiere datos/APIs externas?

**Estimación:**
- Horas de desarrollo
- Complejidad (Baja/Media/Alta)
- Recursos necesarios
- Riesgos técnicos

**Output:** `lab/spec/analysis/ANA-YYYY-MM-NNN.md`

---

### 3. Creación de Especificación

**Documentar en spec del servicio correspondiente**

#### Para Agent Service
Archivo: `lab/spec/agent-spec.md`

```markdown
## Funcionalidad: [Nombre]

**ID Contrato:** CONT-2026-02-001
**Cliente:** [Nombre Cliente]
**Fecha:** 2026-02-28
**Estado:** En Desarrollo

### Descripción
[Qué hace la funcionalidad]

### Criterios de Aceptación
- [ ] Criterio 1
- [ ] Criterio 2
- [ ] Criterio 3

### Implementación Técnica
- Endpoint: `/api/agent/nueva-funcion`
- Método: POST
- Parámetros: {...}
- Response: {...}

### Testing
- [ ] Unit tests
- [ ] Integration tests
- [ ] E2E tests

### Deployment
- [ ] Variables de entorno nuevas
- [ ] Migraciones de BD (si aplica)
- [ ] Documentación de API
```

#### Para Chat Service
Archivo: `lab/spec/chat-spec.md`

Mismo formato adaptado a chat.

#### Para Hub Service
Archivo: `lab/spec/hub-spec.md`

Mismo formato adaptado a Hub (Frappe/ERPNext).

#### Para Flow Service
Archivo: `lab/spec/flow-spec.md`

Workflows y automatizaciones.

---

### 4. Aprobación de Contrato

**Cliente revisa y aprueba**

**Entregables del contrato:**
- Especificación técnica completa
- Estimación de horas/costo
- Timeline con milestones
- Criterios de aceptación
- Plan de testing
- Plan de deployment

**Firma digital/Email de confirmación**

Archivo: `lab/spec/contracts/CONT-YYYY-MM-NNN.md`

---

### 5. Desarrollo

**Implementación según spec**

```
Desarrollo → Testing → Code Review → QA
```

**Branch strategy:**
```bash
git checkout -b feature/CONT-2026-02-001-nombre-funcionalidad
```

**Commits:**
```bash
git commit -m "feat(agent): CONT-2026-02-001 - Implementa [funcionalidad]"
```

**Durante desarrollo:**
- Actualizar checklist en spec
- Documentar cambios no previstos
- Comunicar blockers al cliente

---

### 6. Testing y QA

**Validación técnica antes de entregar**

**Niveles de testing:**
1. **Unit Tests** - Funciones individuales
2. **Integration Tests** - Integración con otros componentes
3. **E2E Tests** - Flujo completo end-to-end
4. **Manual QA** - Pruebas manuales en staging

**Checklist de QA:**
- [ ] Todos los criterios de aceptación cumplidos
- [ ] Tests pasando (cobertura > 80%)
- [ ] Sin errores en logs
- [ ] Performance aceptable
- [ ] Documentación actualizada
- [ ] Variables de entorno documentadas

---

### 7. Staging Deploy

**Deploy en ambiente de pruebas para el cliente**

```bash
# Deploy en staging
./lab/scripts/deploy.sh --env staging --service agent
```

**Validación con cliente:**
- Demo de funcionalidad
- Cliente prueba en staging
- Recolección de feedback
- Ajustes menores (si necesario)

**Estado:** `En Validación`

---

### 8. Production Deploy

**Cliente aprueba → Deploy a producción**

```bash
# Backup antes de deploy
/opt/ATS/restic/scripts/backup.sh

# Deploy a producción
./lab/scripts/deploy.sh --env production --service agent

# Verificar
./lab/scripts/health-check.sh
```

**Post-deployment:**
- [ ] Monitorear logs por 24h
- [ ] Validar métricas
- [ ] Cliente confirma funcionamiento

**Estado:** `Desplegado`

---

### 9. Cierre de Contrato

**Entrega final y documentación**

**Entregables finales:**
- ✅ Funcionalidad en producción
- ✅ Documentación técnica actualizada
- ✅ Documentación de usuario (si aplica)
- ✅ Tests automatizados
- ✅ Configuración documentada

**Estado:** `Completado`

**Facturación:** Según horas/costo acordado

---

## 📊 Estados de Contratos

| Estado | Descripción |
|--------|-------------|
| `Propuesta` | Cliente propone funcionalidad |
| `Análisis` | Evaluación técnica en curso |
| `Aprobado` | Cliente aprobó especificación |
| `En Desarrollo` | Implementación en progreso |
| `En Testing` | QA en progreso |
| `En Validación` | Cliente validando en staging |
| `Desplegado` | En producción |
| `Completado` | Contrato cerrado |
| `Cancelado` | Cliente canceló |
| `En Pausa` | Temporalmente pausado |

---

## 📁 Estructura de Archivos

```
lab/spec/
├── agent-spec.md              # Especificaciones de Agent
├── chat-spec.md               # Especificaciones de Chat
├── hub-spec.md                # Especificaciones de Hub
├── flow-spec.md               # Especificaciones de Flow
├── contracts-workflow.md      # Este archivo
├── requirements/              # Requerimientos originales
│   └── REQ-YYYY-MM-NNN.md
├── analysis/                  # Análisis técnicos
│   └── ANA-YYYY-MM-NNN.md
└── contracts/                 # Contratos aprobados
    └── CONT-YYYY-MM-NNN.md
```

---

## 🔧 Templates

### Template: Requerimiento

```markdown
# REQ-2026-02-001 - [Nombre]

**Cliente:** [Nombre]
**Fecha:** 2026-02-28
**Prioridad:** Alta/Media/Baja

## Descripción
[Descripción detallada del requerimiento]

## Objetivo de Negocio
[Por qué el cliente necesita esto]

## Usuarios Afectados
[Quiénes usarán esta funcionalidad]

## Timeline Esperado
[Fecha esperada de entrega]

## Presupuesto
[Presupuesto aproximado del cliente]

## Notas Adicionales
[Cualquier información relevante]
```

### Template: Análisis Técnico

```markdown
# ANA-2026-02-001 - Análisis [Nombre]

**Basado en:** REQ-2026-02-001
**Analista:** [Nombre]
**Fecha:** 2026-02-28

## Resumen
[Resumen ejecutivo del análisis]

## Viabilidad Técnica
✅ / ⚠️ / ❌

## Servicio Afectado
- [X] Agent
- [ ] Chat
- [ ] Hub
- [ ] Flow

## Complejidad
- [ ] Baja (< 8 horas)
- [ ] Media (8-40 horas)
- [ ] Alta (> 40 horas)

## Dependencias
- [Listar dependencias con otros servicios/APIs]

## Riesgos
- [Riesgo 1]
- [Riesgo 2]

## Estimación
**Horas de desarrollo:** XX
**Costo estimado:** $XXX

## Recomendación
✅ Proceder / ⚠️ Proceder con precaución / ❌ No recomendado

## Próximos Pasos
1. [Paso 1]
2. [Paso 2]
```

### Template: Contrato

```markdown
# CONT-2026-02-001 - [Nombre Funcionalidad]

**Cliente:** [Nombre Cliente]
**Fecha Inicio:** 2026-02-28
**Fecha Entrega:** 2026-03-15
**Estado:** En Desarrollo

## Alcance

### Funcionalidades Incluidas
- [ ] Funcionalidad 1
- [ ] Funcionalidad 2

### Criterios de Aceptación
- [ ] Criterio 1
- [ ] Criterio 2

## Estimación
**Horas:** 40 horas
**Costo:** $XXXX
**Timeline:** 2 semanas

## Milestones
- [ ] Milestone 1 - 2026-03-05
- [ ] Milestone 2 - 2026-03-15

## Entregables
- [ ] Código en producción
- [ ] Documentación técnica
- [ ] Tests automatizados
- [ ] Documentación de usuario

## Firma
Cliente: _______________ Fecha: ___________
ATS: _______________ Fecha: ___________
```

---

## 🎯 Mejores Prácticas

1. **Documentar todo** - Cada decisión, cambio, problema
2. **Comunicación continua** - Actualizaciones regulares al cliente
3. **Testing exhaustivo** - No comprometer calidad por velocidad
4. **Backups antes de deploy** - Siempre
5. **Monitoreo post-deploy** - Seguimiento 24-48h después de deploy
6. **Retrospectiva** - Al cerrar contrato, documentar lecciones aprendidas

---

## 📞 Contactos

**Para preguntas sobre este workflow:**
- Equipo técnico: [email/slack]
- Gestión de proyectos: [email/slack]

---

**Última actualización:** 2026-02-28
