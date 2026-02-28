# VERSATILE HUB - Estructura del Proyecto

## 🎯 Resumen Ejecutivo

**Versatile Hub** es una suite integrada de servicios empresariales lista para producción.

**Estado actual:** ✅ Estructura base creada  
**Fecha:** 2026-02-23

---

## 📊 Vista Rápida

```
Versatile Hub/
│
├── 🧪 lab/                    # Documentación, config, scripts, backups
├── 🏗️ infrastructure/         # Traefik, Nginx, SSL, Let's Encrypt
└── 🚀 services/               # Agent, Chat, Flow, Hub
```

---

## 📁 Estructura Detallada

### 1. LAB (Laboratorio de Desarrollo)

```
lab/
├── context/      📝 Decisiones arquitectónicas (ADRs)
├── spec/         📐 Especificaciones técnicas detalladas
├── config/       ⚙️  Configuraciones globales y templates
├── scripts/      🔧 Scripts de deploy, mantenimiento, monitoring
└── backups/      💾 Sistema de backups con Restic
```

**Propósito:** Centro de conocimiento, configuración y herramientas del proyecto.

### 2. INFRASTRUCTURE (Infraestructura)

```
infrastructure/
├── traefik/       🔀 Reverse proxy, load balancer, SSL automático
├── nginx/         🌐 Servidor web y proxy adicional
├── ssl/           🔐 Certificados SSL/TLS
└── letsencrypt/   📜 Configuración ACME para certificados
```

**Propósito:** Componentes de infraestructura compartidos por todos los servicios.

### 3. SERVICES (Microservicios)

```
services/
│
├── agent/         🤖 Sistema de gestión de agentes inteligentes
│   ├── config/
│   ├── data/
│   └── scripts/
│
├── chat/          💬 Plataforma de comunicación en tiempo real
│   ├── config/
│   └── scripts/
│
├── flow/          🔄 Motor de automatización y flujos de trabajo
│   ├── config/
│   └── data/
│
└── hub/           🏢 Centro de gestión y orquestación (Frappe/ERPNext)
    ├── config/
    └── data/
```

**Propósito:** Servicios independientes que forman la suite completa.

---

## 🗺️ Mapa de Navegación

| ¿Qué necesitas? | Ve a |
|----------------|------|
| **Entender el proyecto** | [README.md](./README.md) |
| **Ver el estado actual** | [lab/CURRENT_STATUS.md](./lab/CURRENT_STATUS.md) |
| **Aprender arquitectura** | [lab/spec/README.md](./lab/spec/README.md) |
| **Configurar servicios** | [lab/config/README.md](./lab/config/README.md) |
| **Desplegar** | [lab/scripts/README.md](./lab/scripts/README.md) |
| **Backups** | [lab/backups/README.md](./lab/backups/README.md) |
| **Contexto y decisiones** | [lab/context/README.md](./lab/context/README.md) |

---

## 🚀 Inicio Rápido

### Para Nuevos Desarrolladores

```bash
# 1. Leer documentación principal
cat README.md

# 2. Ver estado actual del proyecto
cat lab/CURRENT_STATUS.md

# 3. Leer especificaciones
cat lab/spec/README.md
```

### Para Operaciones

```bash
# 1. Configurar entorno
cp .env.example .env
nano .env

# 2. Desplegar
./deploy.sh

# 3. Verificar salud
./lab/scripts/health-check.sh

# 4. Ver logs
./lab/scripts/logs.sh
```

### Para Despliegue

```bash
# 1. Configurar variables de entorno
cp .env.example .env
nano .env

# 2. Verificar infraestructura base (Traefik, red 'web')
docker network create web

# 3. Desplegar suite completa
docker compose up -d

# 4. Ver estado
docker compose ps

# 5. Setup inicial de servicios
# Ver: lab/context/deployment-context.md
```

---

## 📚 Documentación por Rol

### 🔧 Desarrolladores

- [Arquitectura](./lab/spec/README.md)
- [Contexto del Proyecto](./lab/context/README.md)
- [Configuración de Desarrollo](./lab/config/README.md)

### 🚀 DevOps / SRE

- [Scripts de Despliegue](./lab/scripts/README.md)
- [Sistema de Backups](./lab/backups/README.md)
- [Guía de Configuración](./lab/config/README.md)

### 📊 Project Managers

- [README Principal](./README.md)
- [Estado Actual](./lab/CURRENT_STATUS.md)
- [Roadmap](./lab/spec/README.md#roadmap)

---

## 🎨 Filosofía de Organización

### Principios

1. **Todo en minúsculas** - Consistencia en nombres de directorios
2. **Lab como contenedor** - Documentación y herramientas centralizadas
3. **Separación clara** - Infrastructure vs Services
4. **Autodocumentado** - README en cada sección importante
5. **Listo para producción** - Estructura pensada para escalabilidad

### Ventajas de esta Estructura

✅ **Clara separación de responsabilidades**  
✅ **Fácil de navegar**  
✅ **Autodocumentada**  
✅ **Escalable**  
✅ **Lista para CI/CD**  
✅ **Portable entre entornos**  

---

## 📊 Comparación: Antes vs Ahora

### Antes (Estructura Original)

```
/opt/ats/
├── Dev/servicios/
│   ├── ats-agent/
│   ├── ats-chat/
│   └── versatile-hub/
├── Production/
│   ├── infraestructura/
│   └── servicios/
└── restic/
```

**Problemas anteriores:**
- ❌ Mezcla de dev y prod
- ❌ Nombres inconsistentes
- ❌ Documentación dispersa
- ❌ Difícil de replicar

### Ahora (Versatile Hub)

```
/opt/ATS/VersatileHub/
├── lab/              # Documentación y contratos
├── infrastructure/   # Infraestructura compartida
└── services/         # Microservicios independientes
```

**Beneficios:**
- ✅ Estructura unificada
- ✅ Nombres consistentes
- ✅ Documentación centralizada (lab/)
- ✅ Contratos de desarrollo integrados (lab/spec/)
- ✅ Fácil de desplegar y replicar

---

## 🚀 Modelo de Despliegue

### Despliegue Desde Cero

VersatileHub se despliega como **infraestructura nueva**, no requiere migración:

```bash
# 1. Preparar servidor
docker network create web

# 2. Configurar
cp .env.example .env
nano .env

# 3. Desplegar
docker compose up -d

# 4. Setup inicial
# Hub: crear sitio Frappe
# Chat: configurar admin e inbox
# Agent: verificar conectividad
```

### Convivencia con Infraestructura Existente

VersatileHub puede compartir Traefik con otros servicios:

| Compartido | Uso |
|------------|-----|
| Red `web` | ✅ Compartida con Traefik |
| Traefik | ✅ Puede usar el de /opt/ATS/Production |
| Restic | ✅ Integra con /opt/ATS/restic/ |
| Otros servicios | ❌ Independientes |

---

## 📈 Siguientes Fases

Ver: [lab/CURRENT_STATUS.md](./lab/CURRENT_STATUS.md) para detalles completos.

**Resumen:**
1. ✅ Estructura base creada
2. ✅ Documentación completa
3. ⏳ Despliegue inicial en entorno de prueba
4. ⏳ Configuración de contratos de desarrollo
5. ⏳ Implementación de features por contrato
6. ⏳ Testing y validación
7. ⏳ Despliegue en producción para clientes

---

## 💡 Convenciones

### Nombres de Archivos
- Directorios: **minúsculas** (`services/`, `lab/`)
- Archivos config: **minúsculas** (`.env`, `docker-compose.yml`)
- Documentación: **MAYÚSCULAS o PascalCase** (`README.md`, `CURRENT_STATUS.md`)

### Estructura de Servicios
```
services/{nombre}/
├── config/           # Configuración específica
├── data/            # Datos persistentes
├── scripts/         # Scripts específicos del servicio
├── docker-compose.yml
└── README.md
```

### Estructura de Scripts
```
lab/scripts/{categoria}/
├── script-name.sh
└── README.md
```

---

## 🆘 Ayuda Rápida

### Comandos Útiles

```bash
# Ver estructura completa
tree -L 3 "/opt/ats/Versatile Hub"

# Buscar archivos README
find "/opt/ats/Versatile Hub" -name "README.md"

# Ver TODOs pendientes
grep -r "TODO\|FIXME\|XXX" "/opt/ats/Versatile Hub/lab"

# Verificar tamaños
du -sh "/opt/ats/Versatile Hub"/*
```

---

## 📞 Soporte

- **Documentación:** Ver READMEs en cada carpeta
- **Issues:** Documentar en `lab/context/`
- **Estado:** Ver `lab/CURRENT_STATUS.md`

---

**Última actualización:** 2026-02-23  
**Versión:** 1.0.0
