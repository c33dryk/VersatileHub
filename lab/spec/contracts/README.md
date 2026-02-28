# Contratos de Desarrollo

Este directorio contiene los contratos formalizados de desarrollo con clientes.

## 🎯 Propósito

Mantener registro oficial de todos los contratos de desarrollo, incluyendo:
- Funcionalidades acordadas
- Criterios de aceptación
- Timeline y milestones
- Costos y facturación
- Estado de ejecución

## 📋 Estructura de Archivos

```
contracts/
├── CONT-2026-02-001-integracion-whatsapp.md
├── CONT-2026-02-002-reporte-ventas-custom.md
└── README.md (este archivo)
```

## 📝 Nomenclatura

**Formato:** `CONT-YYYY-MM-NNN-nombre-descriptivo.md`

Debe coincidir con `REQ-*` y `ANA-*` previos (mismo número).

**Ejemplo del flujo completo:**
1. `REQ-2026-02-001-integracion-whatsapp.md` (Requerimiento)
2. `ANA-2026-02-001-integracion-whatsapp.md` (Análisis)
3. `CONT-2026-02-001-integracion-whatsapp.md` (Contrato)

## 📄 Contenido del Contrato

### Secciones Obligatorias

#### 1. Información General
- ID Contrato
- Cliente
- Fecha inicio
- Fecha entrega estimada
- Estado actual

#### 2. Alcance
- Funcionalidades incluidas (checklist)
- Funcionalidades **NO** incluidas (importante)

#### 3. Criterios de Aceptación
- Lista detallada de criterios
- Cada criterio debe ser verificable objetivamente

#### 4. Estimación y Costos
- Horas estimadas
- Costo total
- Forma de pago
- Facturación

#### 5. Timeline y Milestones
- Fechas clave
- Entregables por milestone
- Dependencias

#### 6. Entregables Finales
- Código en producción
- Documentación técnica
- Tests automatizados
- Documentación de usuario
- Training (si aplica)

#### 7. Responsabilidades
- **Cliente:** Qué debe proveer (accesos, info, validaciones)
- **ATS:** Qué se compromete a entregar

#### 8. Garantías y Soporte
- Período de garantía (bugs)
- Soporte post-entrega
- SLA (si aplica)

## 🔄 Estados de Contratos

| Estado | Icono | Descripción |
|--------|-------|-------------|
| Propuesta | 📋 | Borrador enviado a cliente |
| Aprobado | ✅ | Cliente aprobó, listo para desarrollo |
| En Desarrollo | 🔨 | Implementación en progreso |
| En Testing | 🧪 | QA en progreso |
| En Validación | 👀 | Cliente validando en staging |
| Desplegado | 🚀 | En producción |
| Completado | ✔️ | Contrato cerrado y facturado |
| Cancelado | ❌ | Cliente canceló |
| En Pausa | ⏸️ | Temporalmente pausado |

## 📊 Seguimiento

### Durante el Desarrollo

Actualizar regularmente:
- ✅ Marcar criterios de aceptación completados
- 📝 Documentar cambios de alcance
- ⏰ Actualizar timeline si hay cambios
- 💬 Registrar comunicaciones importantes con cliente

### Reportes de Avance

**Frecuencia:** Semanal o según acordado con cliente

**Contenido:**
- Milestones completados
- Trabajo en progreso
- Blockers/riesgos
- Próximos pasos

## 💼 Facturación

### Modelos de Facturación

**1. Precio Fijo**
```markdown
Costo Total: $X
Pago al completar todos los entregables
```

**2. Por Horas**
```markdown
Tasa horaria: $Y/hora
Estimado: Z horas
Facturación mensual por horas trabajadas
```

**3. Milestones**
```markdown
Milestone 1 (40%): $A - Al completar X
Milestone 2 (30%): $B - Al completar Y
Milestone 3 (30%): $C - Al deploy a producción
```

### Tracking de Horas

Si es por horas, mantener log detallado:
```markdown
## Log de Horas

| Fecha | Desarrollador | Horas | Descripción |
|-------|---------------|-------|-------------|
| 2026-02-28 | Juan | 4h | Implementación API endpoint |
| 2026-02-29 | María | 6h | Tests e integración |
```

## 📝 Template

Ver: `lab/spec/contracts-workflow.md` sección "Template: Contrato"

## 🔒 Confidencialidad

**IMPORTANTE:** Los contratos pueden contener información sensible:
- Costos y precios
- Datos del cliente
- Información de negocio

**Acceso:** Restringido a equipo autorizado

## 📞 Gestión de Cambios

Si el cliente solicita cambios al alcance:

1. Documentar en sección "Change Requests" del contrato
2. Evaluar impacto en tiempo/costo
3. Generar adenda al contrato
4. Obtener aprobación cliente
5. Actualizar timeline y costos

**Formato Change Request:**
```markdown
### CR-001: [Nombre del cambio]

**Fecha:** 2026-03-05
**Solicitado por:** Cliente
**Descripción:** [Qué cambió]
**Impacto:**
- Horas adicionales: +8h
- Costo adicional: $XXX
- Delay en entrega: +3 días
**Estado:** Aprobado / Rechazado / Pendiente
```

---

## 🎯 Mejores Prácticas

1. ✅ **Especificidad:** Criterios de aceptación deben ser claros y verificables
2. ✅ **Comunicación:** Updates regulares al cliente
3. ✅ **Documentación:** Registrar todo (decisiones, cambios, problemas)
4. ✅ **Testing:** No marcar completado sin testing exhaustivo
5. ✅ **Backup:** Backup completo antes de deploy a producción
6. ✅ **Validación:** Cliente debe validar en staging antes de producción

---

**Última actualización:** 2026-02-28
