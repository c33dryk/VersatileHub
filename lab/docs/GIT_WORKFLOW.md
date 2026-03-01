# Git Workflow - VersatileHub

## 🎯 Qué Se Debe Commitear

### ✅ **SIEMPRE Commitear**

#### Documentación
- `README.md`, `QUICKSTART.md`, `STRUCTURE.md`
- `lab/**/*.md` - Toda la documentación técnica
- `lab/spec/contracts-workflow.md`
- `lab/spec/requirements/README.md` y subdirectorios
- `lab/spec/analysis/README.md` y subdirectorios
- `lab/spec/contracts/README.md` y subdirectorios

#### Contratos de Desarrollo
- `lab/spec/requirements/REQ-*.md` - Requerimientos de clientes
- `lab/spec/analysis/ANA-*.md` - Análisis técnicos
- `lab/spec/contracts/CONT-*.md` - Contratos formalizados

**Importante:** Estos documentos son parte del negocio y deben estar en git para:
- Trazabilidad
- Historial de cambios
- Backup
- Colaboración del equipo

#### Configuración
- `.env.example` - Templates de configuración
- `services/*/.env.example`
- `docker-compose.yml` - Configuración de servicios
- `lab/config/**` - Configuraciones de referencia

#### Scripts y Código
- `lab/scripts/**/*.sh`
- `lab/backups/scripts/**`
- `deploy.sh`, `verify-environment.sh`

---

### ❌ **NUNCA Commitear**

#### Datos Sensibles
- `.env` - Variables de entorno reales
- `services/*/.env` - Configuración específica de servicios
- Archivos con contraseñas o API keys
- `*password*`, `*secret*` (excepto en scripts y docs)

#### Datos de Servicios
- `services/*/data/**` - Bases de datos, volúmenes
- `infrastructure/data/**` - Datos de Traefik, Portainer, etc.
- `*.sql`, `*.dump`, `*.backup`

#### Logs y Temporales
- `*.log`, `logs/`
- `tmp/`, `temp/`, `cache/`
- `*.swp`, `*.swo`, `*~`

#### Certificados SSL
- `*.pem`, `*.key`, `*.crt`
- `infrastructure/ssl/**`
- `infrastructure/letsencrypt/acme.json`

#### Build Artifacts
- `node_modules/`, `__pycache__/`
- `dist/`, `build/`

---

## 🔐 Información Confidencial en Contratos

### Regla General
Los contratos **SÍ se commitean** porque son documentación del negocio.

### Excepción: Información Ultra-Sensible
Si un contrato contiene información que NO debe estar en git:

#### Opción 1: Archivo Separado (Recomendado)
```markdown
# CONT-2026-02-001-feature-cliente.md

## Información General
[Info pública]

## Alcance
[Info pública]

## Costos
Ver: `CONT-2026-02-001-pricing.md` (no commiteado)
```

Crear archivo: `CONT-2026-02-001-pricing.md` con costos sensibles.
Este archivo será ignorado por git (patrón `*-pricing.md`).

#### Opción 2: Sección Confidencial
```markdown
# CONT-2026-02-001-feature-cliente-CONFIDENTIAL.md

## Información Sensible
- Costos detallados
- Márgenes
- Información interna del cliente
```

Este archivo será ignorado por git (patrón `*-CONFIDENTIAL.md`).

#### Opción 3: Anexos Privados
```
lab/spec/contracts/
├── CONT-2026-02-001.md              # ✅ Commiteado
└── CONT-2026-02-001/
    └── private/
        └── pricing-details.pdf      # ❌ No commiteado
```

---

## 📝 Convenciones de Commits

### Formato
```
<tipo>(<scope>): <descripción>

[cuerpo opcional]

[footer opcional]
```

### Tipos
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formato, estilo (no afecta código)
- `refactor`: Refactorización de código
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento
- `contract`: Cambios en contratos/specs

### Scope (Ejemplos)
- `agent`, `chat`, `hub`, `flow`
- `infrastructure`, `lab`, `docs`
- `contracts`, `specs`

### Ejemplos

```bash
# Nueva funcionalidad en Agent
git commit -m "feat(agent): implementar integración con WhatsApp"

# Nuevo contrato
git commit -m "contract(hub): agregar CONT-2026-02-001 - Reporte de ventas custom"

# Actualizar documentación
git commit -m "docs(lab): actualizar workflow de contratos"

# Corrección de bug
git commit -m "fix(chat): resolver problema de WebSocket desconexión"

# Refactorización
git commit -m "refactor(infrastructure): reorganizar configuración de Traefik"
```

---

## 🌿 Estrategia de Branches

### Main Branches

```
main (o master)
└── develop
    ├── feature/CONT-2026-02-001-feature-name
    ├── feature/CONT-2026-02-002-another-feature
    └── hotfix/critical-bug
```

### Branch Naming

#### Features (Contratos)
```bash
feature/CONT-YYYY-MM-NNN-nombre-corto

# Ejemplos:
git checkout -b feature/CONT-2026-02-001-whatsapp-integration
git checkout -b feature/CONT-2026-02-015-custom-reports
```

#### Hotfixes
```bash
hotfix/descripcion-corta

# Ejemplo:
git checkout -b hotfix/websocket-disconnection
```

#### Documentación
```bash
docs/descripcion

# Ejemplo:
git checkout -b docs/update-contracts-workflow
```

---

## 🚀 Workflow Típico

### Iniciar un Contrato

```bash
# 1. Crear branch desde develop
git checkout develop
git pull origin develop
git checkout -b feature/CONT-2026-02-001-whatsapp-integration

# 2. Crear documentos del contrato
cd lab/spec/requirements/
vi REQ-2026-02-001-whatsapp-integration.md
git add REQ-2026-02-001-whatsapp-integration.md
git commit -m "contract: agregar REQ-2026-02-001 - Integración WhatsApp"

# 3. Análisis técnico
cd ../analysis/
vi ANA-2026-02-001-whatsapp-integration.md
git add ANA-2026-02-001-whatsapp-integration.md
git commit -m "contract: agregar ANA-2026-02-001 - Análisis WhatsApp"

# 4. Contrato aprobado
cd ../contracts/
vi CONT-2026-02-001-whatsapp-integration.md
git add CONT-2026-02-001-whatsapp-integration.md
git commit -m "contract: agregar CONT-2026-02-001 - Contrato WhatsApp aprobado"

# 5. Push
git push origin feature/CONT-2026-02-001-whatsapp-integration
```

### Durante el Desarrollo

```bash
# Commits incrementales
git add services/chat/config/whatsapp.yml
git commit -m "feat(chat): agregar configuración WhatsApp"

git add lab/spec/chat-spec.md
git commit -m "docs(chat): actualizar spec con endpoint WhatsApp"

# Push regularmente
git push origin feature/CONT-2026-02-001-whatsapp-integration
```

### Completar el Contrato

```bash
# 1. Actualizar contrato con estado "Completado"
vi lab/spec/contracts/CONT-2026-02-001-whatsapp-integration.md
# Marcar todos los checkboxes como completados
git commit -am "contract: marcar CONT-2026-02-001 como completado"

# 2. Merge a develop
git checkout develop
git pull origin develop
git merge feature/CONT-2026-02-001-whatsapp-integration
git push origin develop

# 3. Merge a main (producción)
git checkout main
git pull origin main
git merge develop
git tag -a v1.1.0 -m "Release: WhatsApp Integration (CONT-2026-02-001)"
git push origin main --tags

# 4. Limpiar branch
git branch -d feature/CONT-2026-02-001-whatsapp-integration
git push origin --delete feature/CONT-2026-02-001-whatsapp-integration
```

---

## 🏷️ Tags y Releases

### Versionado Semántico

```
v{MAJOR}.{MINOR}.{PATCH}

MAJOR: Cambios incompatibles
MINOR: Nueva funcionalidad compatible
PATCH: Bug fixes
```

### Crear Release

```bash
# Después de merge a main
git checkout main
git pull origin main

# Tag con mensaje
git tag -a v1.2.0 -m "Release v1.2.0

- feat(chat): Integración WhatsApp (CONT-2026-02-001)
- feat(hub): Reportes custom (CONT-2026-02-005)
- fix(agent): Corrección de memoria (CONT-2026-02-003)
"

git push origin v1.2.0

# Ver tags
git tag -l
```

---

## 📋 Checklist Pre-Commit

Antes de hacer commit, verificar:

- [ ] No hay archivos `.env` (excepto `.env.example`)
- [ ] No hay passwords o API keys en el código
- [ ] No hay datos de producción (dumps de DB, etc.)
- [ ] Los archivos de contratos tienen información apropiada
- [ ] El mensaje de commit es descriptivo
- [ ] El código compila/funciona localmente

---

## 🔍 Comandos Útiles

```bash
# Ver qué se va a commitear
git status
git diff
git diff --cached

# Ver archivos ignorados
git status --ignored

# Verificar si un archivo está siendo ignorado
git check-ignore -v services/agent/.env

# Ver historial de un archivo
git log --follow lab/spec/contracts/CONT-2026-02-001.md

# Buscar en historial
git log --all --grep="whatsapp"

# Ver cambios en contratos
git log --oneline lab/spec/contracts/

# Revertir cambios no commiteados
git checkout -- archivo.md
git restore archivo.md

# Deshacer último commit (mantener cambios)
git reset --soft HEAD~1

# Ver tamaño del repo
git count-objects -vH
```

---

## 🆘 Problemas Comunes

### Commiteé un .env por error

```bash
# Si NO has hecho push:
git reset HEAD .env
git checkout -- .env

# Si YA hiciste push (más complicado):
git filter-branch --index-filter \
  "git rm -rf --cached --ignore-unmatch .env" HEAD
git push --force
```

### Quiero agregar .gitkeep a directorios vacíos

```bash
# Crear .gitkeep en directorios que deben existir pero estar vacíos
find services/*/data/ -type d -empty -exec touch {}/.gitkeep \;
git add **/.gitkeep
git commit -m "chore: agregar .gitkeep a directorios de datos"
```

---

## 📚 Referencias

- [Git Documentation](https://git-scm.com/doc)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

---

**Última actualización:** 2026-02-28
