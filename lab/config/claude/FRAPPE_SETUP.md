# 🎯 Configuración MCP para Hub (Frappe/ERPNext) - VersatileHub

## ✅ Lo que se configuró:

### 1. Agente Experto en Frappe/ERPNext v15
**Ubicación:** `lab/config/claude/agents/frappe-expert.json`

**Especializado en:**
- ✅ Frappe Framework v15
- ✅ ERPNext v15
- ✅ Bench commands
- ✅ DocTypes y customizations
- ✅ MariaDB queries
- ✅ Migraciones y troubleshooting
- ✅ API REST de Frappe
- ✅ Workflows y automation

**Uso:**
```
"Usando frappe-expert, muéstrame todos los sites instalados"
"Con frappe-expert, crea un DocType personalizado para..."
"Frappe-expert, diagnostica por qué el site no carga"
```

### 2. Script de Instalación MCP Personalizado
**Ubicación:** `lab/config/claude/install-mcp-custom.sh`

**Instala solo lo que necesitas:**
- MariaDB access (via docker exec)
- Filesystem access
- Git operations

## 🚀 Instalación Rápida

```bash
cd /opt/ATS/VersatileHub

# Instalar Node.js si no lo tienes
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar MCP servers
./lab/config/claude/install-mcp-custom.sh

# Selecciona opción 4 (todos)
```

## 🔌 Acceso a MariaDB del Hub

### Opción A: Comandos Docker (Recomendado - No requiere MCP)

El agente `frappe-expert` puede ejecutar comandos directamente:

```bash
# Ver bases de datos
docker exec versatile-hub-db mysql -u root -p[PASSWORD] -e "SHOW DATABASES;"

# Conectar a site específico
docker exec -it versatile-hub-backend bench --site [site] mariadb

# Listar tablas
docker exec versatile-hub-db mysql -u root -p[PASSWORD] [db_name] -e "SHOW TABLES;"

# Query personalizado
docker exec versatile-hub-db mysql -u root -p[PASSWORD] [db_name] -e "SELECT * FROM tabUser LIMIT 10;"
```

**Con Cline:**
```
"Usando frappe-expert, ejecuta:
docker exec versatile-hub-db mysql -u root -p[PASSWORD] -e 'SHOW DATABASES;'
y muéstrame las bases de datos disponibles"
```

### Opción B: Exponer Puerto MariaDB (Para MCP directo)

Si quieres acceso MCP directo a MariaDB:

1. **Edita `docker-compose.yml`:**
```yaml
hub-db:
  image: mariadb:11.7
  container_name: versatile-hub-db
  ports:
    - "3307:3306"  # ← Agregar esta línea
  # ... resto
```

2. **Reinicia:**
```bash
docker compose restart hub-db
```

3. **Ahora puedes conectar desde host:**
```bash
mysql -h localhost -P 3307 -u root -p
```

## 🤖 Comandos del Agente Frappe

### Información del Sistema
```
"Frappe-expert, lista todos los sites"
"Muéstrame las apps instaladas en cada site"
"¿Qué versión de Frappe y ERPNext estamos usando?"
```

### Migr

aciones y Actualizaciones
```
"Ejecuta migrate en el site principal"
"Clear cache de todos los sites"
"Rebuild assets del frontend"
```

### DocTypes y Customization
```
"Muéstrame la estructura del DocType 'Sales Order'"
"Crea un Custom Field en Customer para almacenar ID externo"
"Lista todos los Custom DocTypes del site"
```

### Troubleshooting
```
"El site no carga, diagnostica el problema"
"Hay errores en los logs del worker, analízalos"
"Por qué fallan las migraciones?"
```

### Base de Datos
```
"Muéstrame los últimos 10 usuarios creados"
"Cuántos Sales Orders tenemos pendientes?"
"Consulta la tabla tabItem y muestra productos"
```

### Backups
```
"Haz un backup completo del site principal"
"Dónde están los backups guardados?"
"Restaura el backup más reciente"
```

## 📁 Estructura de Datos

```
services/hub/
├── data/
│   ├── sites/                    # Sites de Frappe
│   │   ├── [site-name]/
│   │   │   ├── site_config.json # Config del site
│   │   │   ├── private/
│   │   │   │   └── backups/     # Backups automáticos
│   │   │   └── public/          # Assets públicos
│   │   └── assets/              # Assets compilados
│   └── mariadb/                 # Base de datos MariaDB
│
└── config/                      # Configs adicionales
```

## 🎓 Workflows Comunes

### Crear Nuevo Site
```
"Frappe-expert, crea un nuevo site llamado 'produccion.local' con:
- Admin password: [password]
- Instalar ERPNext
- Configurar como site por defecto"
```

### Instalar Custom App
```
"Frappe-expert, instala la app custom desde GitHub:
1. Clonar de: https://github.com/[user]/[app].git
2. Instalar en site principal
3. Ejecutar migraciones"
```

### Crear DocType Personalizado
```
"Frappe-expert, crea un DocType 'Proyecto Consultoría' con campos:
- Nombre del proyecto (Data)
- Cliente (Link a Customer)
- Fecha inicio (Date)
- Fecha fin (Date)
- Estado (Select: Nuevo, En Progreso, Completado)
- Descripción (Text Editor)

Incluye permisos para rol 'Projects User'"
```

### Debugging de Performance
```
"Frappe-expert, el sistema está lento:
1. Revisa logs de worker
2. Analiza queries lentas en MariaDB
3. Verifica uso de recursos de containers
4. Sugiere optimizaciones"
```

## 📖 Documentación de Referencia

### Frappe/ERPNext
- [Frappe Documentation](https://frappeframework.com/docs)
- [ERPNext Documentation](https://docs.erpnext.com/)
- [Frappe API](https://frappeframework.com/docs/user/en/api)

### Bench Commands
```bash
bench --help                              # Ayuda general
bench --site [site] console               # Python console
bench --site [site] mariadb               # MySQL console
bench --site [site] migrate               # Ejecutar migraciones
bench --site [site] clear-cache           # Limpiar cache
bench --site [site] backup                # Crear backup
bench --site [site] restore [archivo]     # Restaurar backup
bench --site [site] list-apps             # Apps instaladas
bench --site [site] install-app [app]     # Instalar app
```

### Variables de Entorno (desde .env)
```bash
HUB_DB_ROOT_PASSWORD      # Password root de MariaDB
HUB_DOMAIN                # Dominio del hub
HUB_SITE_NAME             # Nombre del site principal
```

## 🆘 Troubleshooting

### El agente no reconoce frappe-expert
```bash
# Reinstalar configuraciones
./lab/config/claude/install.sh --force

# Reload VS Code
Ctrl+Shift+P → "Reload Window"
```

### No puedo acceder a MariaDB
```bash
# Verificar que el container está corriendo
docker ps | grep hub-db

# Verificar password
echo $HUB_DB_ROOT_PASSWORD

# Probar conexión
docker exec -it versatile-hub-db mysql -u root -p
```

### Bench commands fallan
```bash
# Verificar que el backend está corriendo
docker ps | grep hub-backend

# Ver logs
docker logs versatile-hub-backend --tail=50

# Entrar al container
docker exec -it versatile-hub-backend bash
cd /home/frappe/frappe-bench
bench list-sites
```

## 🎯 Siguiente Paso

**Prueba el agente:**
```
# En Cline
"Frappe-expert, muéstrame un resumen del sistema:
- Qué sites hay instalados
- Qué apps tiene cada site
- Usuarios del sistema
- Estado general de los contenedores"
```

---

**Última actualización:** 2026-03-11  
**Agente:** frappe-expert v1.0.0  
**Frappe:** v15  
**ERPNext:** v15
