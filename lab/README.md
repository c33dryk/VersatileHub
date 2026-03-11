# Lab - Laboratorio de Desarrollo

Este directorio contiene todo el material de desarrollo, experimentación y documentación del proyecto Versatile Hub.

## 📁 Estructura

### context/
Documentación de contexto, decisiones de arquitectura y justificaciones técnicas.

**Contenido típico:**
- Decisiones de diseño (ADR - Architecture Decision Records)
- Contexto histórico del proyecto
- Razones detrás de elecciones técnicas
- Lecciones aprendidas

### spec/
Especificaciones técnicas detalladas de todos los componentes del sistema.

**Contenido:**
- Arquitectura general
- Especificaciones por servicio
- Guías de implementación
- Diagramas y documentación técnica

### backups/
Scripts y configuración para el sistema de respaldos.

**Contenido:**
- Scripts de backup automatizados
- Configuración de Restic
- Políticas de retención
- Procedimientos de recuperación

### config/
Configuraciones globales y plantillas para todos los servicios.

**Contenido:**
- Variables de entorno (.env templates)
- Configuraciones compartidas
- Plantillas de configuración
- Documentación de configuración
- **claude/** - Configuración de Claude Code/Copilot (ver [config/claude/README.md](config/claude/README.md))

### scripts/
Scripts de utilidad para gestión, despliegue y mantenimiento.

**Contenido:**
- Scripts de despliegue
- Herramientas de migración
- Utilidades de mantenimiento
- Scripts de automatización

## 📄 Archivos Principales

### CLAUDE.md
Guía completa para la integración de Claude Code / GitHub Copilot en el proyecto.

**Contenido:**
- Instalación y configuración en VS Code
- Comandos útiles y casos de uso
- Mejores prácticas con prompts
- Integración con el workflow del proyecto
- Troubleshooting y tips

### CURRENT_STATUS.md
Estado actual del proyecto y estructura de directorios.

## 🎯 Propósito

El directorio `lab/` sirve como:

1. **Centro de Documentación**: Todo el conocimiento del proyecto centralizado
2. **Herramientas de Desarrollo**: Scripts y utilidades para trabajar con el proyecto
3. **Configuración Centralizada**: Configuraciones globales y plantillas
4. **Sistema de Backups**: Herramientas para protección de datos

## 🚀 Uso Rápido

```bash
# Ver especificaciones técnicas
cd lab/spec/

# Ejecutar backup
./lab/backups/scripts/backup.sh

# Ver plantillas de configuración
ls lab/config/

# Ejecutar scripts de utilidad
./lab/scripts/deploy.sh
```

## 📝 Contribución

Al agregar nueva funcionalidad:

1. Documenta decisiones en `context/`
2. Actualiza especificaciones en `spec/`
3. Agrega configuraciones en `config/`
4. Crea scripts útiles en `scripts/`

## 🔗 Referencias

- [Especificaciones Técnicas](./spec/README.md)
- [Guía de Configuración](./config/README.md)
- [Sistema de Backups](./backups/README.md)
