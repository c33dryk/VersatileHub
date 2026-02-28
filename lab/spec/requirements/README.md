# Requerimientos de Clientes

Este directorio contiene los requerimientos originales de los clientes antes de ser convertidos en especificaciones técnicas.

## 📋 Estructura de Archivos

```
requirements/
├── REQ-2026-02-001-nombre-funcionalidad.md
├── REQ-2026-02-002-otra-funcionalidad.md
└── README.md (este archivo)
```

## 🎯 Propósito

Mantener registro de:
- Solicitud original del cliente
- Contexto de negocio
- Justificación de la necesidad
- Timeline esperado
- Presupuesto aproximado

## 📝 Nomenclatura

**Formato:** `REQ-YYYY-MM-NNN-nombre-descriptivo.md`

- `YYYY`: Año (2026)
- `MM`: Mes (01-12)
- `NNN`: Número secuencial (001, 002, ...)
- `nombre-descriptivo`: Breve descripción en kebab-case

**Ejemplos:**
- `REQ-2026-02-001-integracion-whatsapp.md`
- `REQ-2026-03-015-reporte-ventas-custom.md`

## 🔄 Workflow

```
Cliente → REQ → Análisis Técnico → Especificación → Contrato → Desarrollo
```

1. Cliente solicita funcionalidad
2. Se crea documento `REQ-YYYY-MM-NNN.md`
3. Pasa a análisis técnico (`../analysis/`)
4. Se genera especificación técnica (en specs de servicio)
5. Se formaliza contrato (`../contracts/`)

## 📄 Template

Ver: `lab/spec/contracts-workflow.md` sección "Template: Requerimiento"

## 🔍 Estados

| Estado | Descripción |
|--------|-------------|
| `📝 Nuevo` | Recién recibido, sin revisar |
| `🔍 En Análisis` | Equipo técnico evaluando |
| `✅ Aprobado` | Viable, pasa a contrato |
| `❌ Rechazado` | No viable o fuera de alcance |
| `⏸️ En Espera` | Cliente debe proveer más info |

---

**Última actualización:** 2026-02-28
