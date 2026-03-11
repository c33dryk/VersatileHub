# Referencia Rápida - VersatileHub

Comandos y rutas más usados del proyecto.

## 📂 Estructura Esencial

```
/                      # Raíz: solo archivos de deployment
├── lab/              # Todo desarrollo, docs y configuraciones
├── infrastructure/   # Traefik, Nginx, SSL  
└── services/         # Microservicios (agent, chat, flow, hub, portal)
```

## 🚀 Comandos Principales

### Deployment
```bash
./deploy.sh                           # Desplegar todos los servicios
./quick-install.sh                    # Instalación rápida
./verify-environment.sh               # Verificar entorno
```

### Docker
```bash
# Ver todos los servicios
docker compose ps

# Logs de todos los servicios
docker compose logs -f

# Reiniciar servicio específico
docker compose restart [servicio]

# Logs de servicio específico
docker compose -f services/[servicio]/docker-compose.yml logs -f
```

### Claude/Copilot
```bash
# Instalar configuraciones desde lab/
./lab/config/claude/install.sh

# Reinstalar (sobrescribir)
./lab/config/claude/install.sh --force

# Verificar setup
./lab/scripts/check-claude-setup.sh

# Limpiar archivos instalados
./lab/config/claude/install.sh --clean
```

### Backups
```bash
# Scripts en lab/backups/scripts/
./lab/backups/scripts/backup-all.sh
```

## 📖 Documentación

### Guías Principales
- [README.md](../README.md) - Documentación principal
- [lab/README.md](README.md) - Guía del laboratorio
- [lab/CLAUDE.md](CLAUDE.md) - Integración Claude/Copilot
- [lab/CURRENT_STATUS.md](CURRENT_STATUS.md) - Estado actual
- [STRUCTURE.md](../STRUCTURE.md) - Estructura detallada

### Configuración
- [lab/config/README.md](config/README.md) - Configuraciones generales
- [lab/config/claude/](config/claude/) - Claude/Copilot setup
- [lab/backups/README.md](backups/README.md) - Sistema de backups

### Especificaciones
- [lab/spec/](spec/) - Especificaciones técnicas
- [lab/context/](context/) - Decisiones de arquitectura

## 🎯 Flujos de Trabajo Comunes

### Crear Nuevo Servicio
```bash
# 1. Crear estructura
mkdir -p services/[nombre]/{config,data,scripts}

# 2. Crear docker-compose.yml
# (seguir patrón de otros servicios)

# 3. Agregar variables a .env

# 4. Documentar en lab/spec/

# 5. Integrar con Traefik si es web
```

### Modificar Configuraciones de Claude
```bash
# 1. Editar plantilla (fuente de verdad)
nano lab/config/claude/templates/.clinerules

# 2. Reinstalar
./lab/config/claude/install.sh --force

# 3. Reload VS Code
# Ctrl+Shift+P → "Reload Window"
```

### Debugging Servicio
```bash
# 1. Ver logs
docker compose -f services/[servicio]/docker-compose.yml logs --tail=100

# 2. Verificar red
docker network inspect versatilehub-network

# 3. Variables de entorno
docker exec [container] env

# 4. Entrar al container
docker exec -it [container] bash
```

### Backup y Restore
```bash
# Backup
./lab/backups/scripts/backup-postgres.sh [servicio]

# Restore
./lab/backups/scripts/restore-postgres.sh [servicio] [archivo.sql]
```

## 🔧 Archivos de Configuración

### En Raíz (esenciales)
- `.env` - Variables de entorno (gitignored)
- `.env.example` - Plantilla de variables
- `docker-compose.yml` - Orquestación principal
- `.gitignore` - Archivos ignorados

### Instalados desde lab/ (gitignored)
- `.clinerules` ← `lab/config/claude/templates/.clinerules`
- `.github/copilot-instructions.md` ← `lab/config/claude/templates/copilot-instructions.md`
- `.vscode/settings.json` ← `lab/config/claude/templates/vscode-settings.json`
- `.vscode/extensions.json` ← `lab/config/claude/templates/vscode-extensions.json`

## 🌐 Puertos y URLs

```bash
# Ver puertos en uso
docker compose ps

# URLs típicas (ajustar según DOMAIN en .env)
https://agent.tudominio.com
https://chat.tudominio.com
https://flow.tudominio.com
https://hub.tudominio.com
https://portal.tudominio.com
```

## 🎓 Tips

### VS Code con Claude
```
Ctrl+I          # Chat inline
Ctrl+Shift+I    # Panel de chat
@workspace      # Consultar proyecto completo
#file:nombre.js # Referenciar archivo
/explain        # Explicar código
/fix            # Sugerir fixes
```

### Git
```bash
# Verificar qué se va a commitear
git status

# Los archivos en raíz instalados están en .gitignore
# Solo se versionan las plantillas en lab/config/claude/templates/
```

### Variables de Entorno
```bash
# Nomenclatura
SERVICIO_COMPONENTE_VARIABLE

# Ejemplo
CHAT_DATABASE_HOST=postgres
CHAT_DATABASE_PORT=5432
```

## 🆘 Troubleshooting

### Servicio no inicia
1. Check logs: `docker compose logs [servicio]`
2. Check network: `docker network ls`
3. Check .env: `cat .env | grep [SERVICIO]`
4. Check permissions: `ls -la services/[servicio]/data/`

### Claude no responde
1. Verificar extensiones: `code --list-extensions | grep copilot`
2. Reload window: `Ctrl+Shift+P` → "Reload Window"
3. Check autenticación: `gh auth status`

### Traefik no rutea
1. Check labels en docker-compose.yml
2. Check logs: `docker compose logs traefik`
3. Dashboard: `https://traefik.tudominio.com`

---

**Actualizado**: 2026-03-11  
**Versión**: 1.0.0
