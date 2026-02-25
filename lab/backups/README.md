# Backups - Sistema de Respaldos

Este directorio contiene scripts y configuración para el sistema de backups automatizados usando Restic.

## 📁 Estructura

```
backups/
├── scripts/          # Scripts de backup y recuperación
│   ├── backup.sh    # Script principal de backup
│   ├── restore.sh   # Script de restauración
│   ├── verify.sh    # Verificación de integridad
│   └── prune.sh     # Limpieza de backups antiguos
├── config/          # Configuración de Restic
│   └── policy.yml   # Políticas de retención
└── logs/            # Logs de backups
```

## 🎯 Estrategia de Backup

### ¿Qué se respalda?

1. **Bases de Datos**
   - MariaDB (Hub)
   - PostgreSQL (si se usa en otros servicios)
   - MongoDB (si se usa)

2. **Datos de Aplicación**
   - `services/agent/data/`
   - `services/chat/data/`
   - `services/flow/data/`
   - `services/hub/data/`

3. **Configuraciones**
   - Archivos `.env`
   - Configuraciones de servicios
   - Certificados SSL

4. **Infraestructura**
   - Configuración de Traefik
   - Configuración de Nginx

### ¿Qué NO se respalda?

- Contenedores Docker (se recrean desde imágenes)
- Imágenes Docker
- Logs antiguos (solo últimos 30 días)
- Cache de Redis
- Archivos temporales

## 🚀 Uso Rápido

### Realizar Backup Manual

```bash
./lab/backups/scripts/backup.sh
```

### Restaurar desde Backup

```bash
# Listar backups disponibles
./lab/backups/scripts/restore.sh --list

# Restaurar último backup
./lab/backups/scripts/restore.sh --latest

# Restaurar backup específico
./lab/backups/scripts/restore.sh --snapshot abc123
```

### Verificar Integridad

```bash
./lab/backups/scripts/verify.sh
```

## ⏰ Backups Automatizados

### Configuración con Cron

```bash
# Editar crontab
crontab -e

# Backup diario a las 2 AM
0 2 * * * /opt/ats/Versatile\ Hub/lab/backups/scripts/backup.sh >> /opt/ats/Versatile\ Hub/lab/backups/logs/backup.log 2>&1

# Limpieza semanal los domingos a las 3 AM
0 3 * * 0 /opt/ats/Versatile\ Hub/lab/backups/scripts/prune.sh >> /opt/ats/Versatile\ Hub/lab/backups/logs/prune.log 2>&1
```

## 📊 Política de Retención

### Default

- **Últimas 7 versiones**: Mantener siempre
- **Últimos 30 días**: Mantener todos los backups diarios
- **Últimos 12 meses**: Mantener un backup semanal
- **Últimos 3 años**: Mantener un backup mensual

### Personalizar

Editar: `lab/backups/config/policy.yml`

```yaml
retention:
  last: 7          # Últimas 7 snapshots
  daily: 30        # Backups diarios por 30 días
  weekly: 52       # Backups semanales por 1 año
  monthly: 36      # Backups mensuales por 3 años
  yearly: 5        # Backups anuales por 5 años
```

## 🔧 Configuración de Restic

### Variables de Entorno Requeridas

```bash
# Repositorio (S3 ejemplo)
RESTIC_REPOSITORY=s3:s3.amazonaws.com/bucket-name
RESTIC_PASSWORD=your-encryption-password

# Credenciales AWS
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key

# Opciones
RESTIC_COMPRESSION=auto
RESTIC_CACHE_DIR=/opt/ats/Versatile\ Hub/lab/backups/cache
```

### Inicializar Repositorio

```bash
# Primera vez solamente
export RESTIC_REPOSITORY="s3:s3.amazonaws.com/bucket-name"
export RESTIC_PASSWORD="your-password"
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"

restic init
```

## 📝 Scripts Detallados

### backup.sh

**Funcionalidad:**
1. Pre-checks (espacio en disco, repositorio accesible)
2. Detener servicios si es necesario (opcional)
3. Dump de bases de datos
4. Backup de archivos con Restic
5. Verificación post-backup
6. Reiniciar servicios
7. Notificación (email, webhook, etc.)

**Opciones:**
```bash
./backup.sh                    # Backup completo
./backup.sh --service agent    # Solo servicio específico
./backup.sh --databases-only   # Solo bases de datos
./backup.sh --no-verify        # Sin verificación post-backup
```

### restore.sh

**Funcionalidad:**
1. Listar backups disponibles
2. Seleccionar snapshot
3. Detener servicios afectados
4. Restaurar archivos
5. Restaurar bases de datos
6. Verificar integridad
7. Reiniciar servicios

**Opciones:**
```bash
./restore.sh --list                    # Listar snapshots
./restore.sh --latest                  # Último backup
./restore.sh --snapshot abc123         # Snapshot específico
./restore.sh --service agent           # Solo un servicio
./restore.sh --target /path/to/restore # Restaurar a ubicación específica
```

### verify.sh

**Funcionalidad:**
- Verifica integridad del repositorio Restic
- Comprueba todos los snapshots
- Detecta corrupción de datos
- Genera reporte

```bash
./verify.sh               # Verificación completa
./verify.sh --quick       # Verificación rápida
./verify.sh --snapshot abc123  # Solo un snapshot
```

### prune.sh

**Funcionalidad:**
- Aplica política de retención
- Elimina snapshots antiguos
- Libera espacio
- Optimiza repositorio

```bash
./prune.sh                # Limpieza según política
./prune.sh --dry-run      # Simular sin eliminar
```

## 🔐 Seguridad

### Encriptación

- Todos los backups están encriptados con AES-256
- Password de encriptación nunca se guarda en el repositorio
- Usar password fuerte (32+ caracteres)

### Almacenamiento de Credenciales

```bash
# Opción 1: Archivo de configuración protegido
echo "RESTIC_PASSWORD=your-password" > ~/.restic-credentials
chmod 600 ~/.restic-credentials

# Opción 2: Variables de entorno en script protegido
# Ver: lab/config/templates/restic.env
```

### Best Practices

1. **Guardar password de forma segura** (password manager)
2. **Probar restauración regularmente**
3. **Almacenar backups en ubicación diferente** al servidor
4. **Verificar integridad periódicamente**
5. **Rotar credenciales de acceso**
6. **Monitorear espacio de almacenamiento**

## 📊 Monitoreo

### Health Check

```bash
# Verificar último backup exitoso
./lab/backups/scripts/check-last-backup.sh

# Output:
# ✓ Último backup: 2026-02-23 02:00:00 (hace 8 horas)
# ✓ Estado: Exitoso
# ✓ Tamaño: 2.5 GB
# ✓ Duración: 12 minutos
```

### Alertas

Configurar alertas para:
- Backup fallido
- Más de 24h sin backup
- Espacio de almacenamiento bajo
- Errores de verificación

## 🧪 Testing

### Probar Backup

```bash
# Dry-run (sin hacer backup real)
DRY_RUN=true ./lab/backups/scripts/backup.sh
```

### Probar Restauración

```bash
# Restaurar a ubicación temporal
./lab/backups/scripts/restore.sh --latest --target /tmp/restore-test
```

## 📋 Checklist Pre-Producción

- [ ] Repositorio Restic inicializado
- [ ] Credenciales configuradas y probadas
- [ ] Primera backup manual exitoso
- [ ] Restauración de prueba exitosa
- [ ] Cron jobs configurados
- [ ] Política de retención definida
- [ ] Monitoreo y alertas configurados
- [ ] Documentación de recuperación lista
- [ ] Password de encriptación respaldado de forma segura

## 📚 Documentación Adicional

- [Restic Documentation](https://restic.readthedocs.io/)
- [Disaster Recovery Plan](../spec/disaster-recovery.md)
- [Runbook de Restauración](../spec/restore-runbook.md)

## 🆘 Recuperación de Desastres

Ver guía completa: [../spec/disaster-recovery.md](../spec/disaster-recovery.md)

### Escenario: Pérdida completa del servidor

1. Provisionar nuevo servidor
2. Instalar dependencias (Docker, etc.)
3. Clonar estructura de Versatile Hub
4. Configurar credenciales de Restic
5. Restaurar desde último backup
6. Verificar integridad
7. Iniciar servicios
8. Validar funcionamiento

Tiempo estimado: 2-4 horas

## 🔗 Referencias

- [Scripts de Utilidad](../scripts/README.md)
- [Configuración](../config/README.md)
- [Especificaciones](../spec/README.md)
