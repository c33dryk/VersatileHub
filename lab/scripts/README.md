# Scripts - Herramientas de Utilidad

Este directorio contiene scripts para despliegue, mantenimiento y automatización de Versatile Hub.

## 📁 Estructura

```
scripts/
├── deploy/           # Scripts de despliegue
├── maintenance/      # Mantenimiento y limpieza
├── migration/        # Migración de datos
├── monitoring/       # Monitoreo y health checks
└── utils/           # Utilidades generales
```

## 🚀 Scripts de Despliegue

### deploy.sh
**Propósito:** Script principal de despliegue

```bash
# Uso básico
./lab/scripts/deploy/deploy.sh

# Con opciones
./lab/scripts/deploy/deploy.sh --env production --force
```

**Opciones:**
- `--env [dev|staging|prod]` - Entorno de despliegue
- `--service [nombre]` - Desplegar solo un servicio
- `--force` - Forzar recreación de contenedores
- `--no-backup` - Saltar backup pre-despliegue

### setup.sh
**Propósito:** Configuración inicial del sistema

```bash
./lab/scripts/deploy/setup.sh
```

**Acciones:**
1. Verifica dependencias (Docker, Docker Compose)
2. Crea estructura de directorios
3. Genera configuraciones base
4. Configura permisos
5. Inicializa redes Docker

### rollback.sh
**Propósito:** Rollback a versión anterior

```bash
./lab/scripts/deploy/rollback.sh [version]
```

## 🔧 Scripts de Mantenimiento

### cleanup.sh
**Propósito:** Limpieza de recursos no utilizados

```bash
./lab/scripts/maintenance/cleanup.sh
```

**Limpia:**
- Contenedores detenidos
- Imágenes no utilizadas
- Volúmenes huérfanos
- Logs antiguos

### update.sh
**Propósito:** Actualizar servicios

```bash
# Actualizar todo
./lab/scripts/maintenance/update.sh

# Actualizar servicio específico
./lab/scripts/maintenance/update.sh --service hub
```

### restart-service.sh
**Propósito:** Reiniciar servicios de forma segura

```bash
./lab/scripts/maintenance/restart-service.sh [service-name]
```

## 📊 Scripts de Monitoreo

### health-check.sh
**Propósito:** Verificar salud de todos los servicios

```bash
./lab/scripts/monitoring/health-check.sh
```

**Output:**
```
✓ Agent Service: Healthy
✓ Chat Service: Healthy
✗ Flow Service: Unhealthy (timeout)
✓ Hub Service: Healthy
```

### logs.sh
**Propósito:** Ver logs de servicios

```bash
# Ver logs de todos los servicios
./lab/scripts/monitoring/logs.sh

# Ver logs de un servicio específico
./lab/scripts/monitoring/logs.sh --service agent

# Seguir logs en tiempo real
./lab/scripts/monitoring/logs.sh --service chat --follow
```

### metrics.sh
**Propósito:** Recopilar métricas del sistema

```bash
./lab/scripts/monitoring/metrics.sh
```

## 🔄 Scripts de Migración

### migrate-from-old-structure.sh
**Propósito:** Migrar desde la estructura antigua

```bash
./lab/scripts/migration/migrate-from-old-structure.sh
```

**Migra:**
- Datos de `/opt/ats/Dev/servicios/`
- Configuraciones de `/opt/ats/Production/`
- Backups existentes

### export-data.sh
**Propósito:** Exportar datos para migración

```bash
./lab/scripts/migration/export-data.sh --output /path/to/export
```

### import-data.sh
**Propósito:** Importar datos desde backup

```bash
./lab/scripts/migration/import-data.sh --input /path/to/backup
```

## 🛠️ Utilidades Generales

### validate-config.sh
**Propósito:** Validar archivo de configuración

```bash
./lab/scripts/utils/validate-config.sh
```

**Verifica:**
- Variables requeridas presentes
- Formato correcto
- Valores válidos
- Conflictos de puertos

### generate-ssl.sh
**Propósito:** Generar/renovar certificados SSL

```bash
./lab/scripts/utils/generate-ssl.sh --domain example.com
```

### backup-now.sh
**Propósito:** Ejecutar backup manual

```bash
./lab/scripts/utils/backup-now.sh
```

## 📝 Crear Nuevos Scripts

### Template Básico

```bash
#!/bin/bash
set -e  # Exit on error

# === CONFIGURACIÓN ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# === FUNCIONES ===
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# === MAIN ===
main() {
    log_info "Iniciando script..."
    
    # Tu código aquí
    
    log_info "Script completado exitosamente"
}

# Ejecutar
main "$@"
```

## 🔐 Permisos

Todos los scripts deben ser ejecutables:

```bash
chmod +x lab/scripts/**/*.sh
```

## 🧪 Testing

Probar scripts en entorno de desarrollo primero:

```bash
# Variable de entorno para modo dry-run
DRY_RUN=true ./lab/scripts/deploy/deploy.sh
```

## 📚 Documentación de Scripts

Cada script debe incluir:

1. **Comentario de cabecera** con descripción y uso
2. **Variables de configuración** documentadas
3. **Funciones** con comentarios
4. **Manejo de errores** apropiado
5. **Logging** informativo

## 🔗 Referencias

- [Guía de Despliegue](../spec/deployment-guide.md)
- [Configuración](../config/README.md)
- [Backups](../backups/README.md)
