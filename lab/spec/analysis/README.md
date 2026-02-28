# Análisis Técnicos

Este directorio contiene los análisis técnicos de requerimientos de clientes.

## 🎯 Propósito

Evaluar viabilidad técnica de requerimientos antes de convertirlos en contratos de desarrollo.

## 📋 Estructura de Archivos

```
analysis/
├── ANA-2026-02-001-integracion-whatsapp.md
├── ANA-2026-02-002-reporte-ventas-custom.md
└── README.md (este archivo)
```

## 📝 Nomenclatura

**Formato:** `ANA-YYYY-MM-NNN-nombre-descriptivo.md`

Debe coincidir con el `REQ-*` correspondiente (mismo número).

**Ejemplo:**
- `REQ-2026-02-001-integracion-whatsapp.md` →
- `ANA-2026-02-001-integracion-whatsapp.md`

## 🔍 Contenido del Análisis

Cada análisis debe incluir:

### 1. Viabilidad Técnica
- ✅ Viable / ⚠️ Viable con riesgos / ❌ No viable

### 2. Servicio Afectado
- Agent / Chat / Hub / Flow

### 3. Complejidad
- Baja (< 8 horas)
- Media (8-40 horas)
- Alta (> 40 horas)

### 4. Dependencias
- APIs externas
- Otros servicios
- Bibliotecas/frameworks nuevos

### 5. Riesgos Técnicos
- Performance
- Seguridad
- Escalabilidad
- Mantenibilidad

### 6. Estimación
- Horas de desarrollo
- Costo aproximado
- Timeline realista

### 7. Recomendación
- ✅ Proceder
- ⚠️ Proceder con precaución
- ❌ No recomendado
- 🔄 Alternativa sugerida

## 🔄 Workflow

```
REQ → ANA → Decisión → [Aprobado] → Spec + Contrato
                   └→ [Rechazado] → Comunicar a cliente
```

## 📄 Template

Ver: `lab/spec/contracts-workflow.md` sección "Template: Análisis Técnico"

## 👥 Responsables

**Analistas técnicos:**
- Arquitecto del proyecto
- Tech leads de cada servicio
- DevOps (para análisis de infraestructura)

---

**Última actualización:** 2026-02-28
