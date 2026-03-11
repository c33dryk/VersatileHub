# Configuración de MCP (Model Context Protocol) para VersatileHub

MCP permite que Claude Code acceda a recursos externos como bases de datos, sistemas de archivos, APIs, etc.

## 🔌 MCP Servers Configurados

### 1. PostgreSQL MCP
Acceso directo a las bases de datos PostgreSQL de los servicios.

**Servicios con PostgreSQL:**
- `chat` (Chatwoot - puerto 5432)
- Otros servicios que uses PostgreSQL

### 2. Filesystem MCP
Acceso avanzado al sistema de archivos del proyecto.

### 3. Docker MCP
Control y monitoreo de contenedores Docker.

### 4. Git MCP (opcional)
Operaciones avanzadas de Git.

## 📝 Archivo de Configuración

El archivo de configuración MCP debe estar en:
```
~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

O en la configuración de VS Code en `settings.json`.

## 🚀 Instalación

### Opción A: Instalación rápida (recomendada)

```bash
# Ejecutar script de instalación
./lab/config/claude/install-mcp.sh
```

### Opción B: Instalación manual

#### 1. Instalar MCP servers

```bash
# PostgreSQL MCP
npm install -g @modelcontextprotocol/server-postgres

# Filesystem MCP
npm install -g @modelcontextprotocol/server-filesystem

# Git MCP
npm install -g @modelcontextprotocol/server-git
```

#### 2. Configurar en Cline

1. Abre VS Code
2. `Ctrl+Shift+P` → "Cline: Open MCP Settings"
3. O edita manualmente el archivo de configuración

## 🔧 Configuración para VersatileHub

### PostgreSQL - Servicio Chat

```json
{
  "mcpServers": {
    "postgres-chat": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://chatwoot:${CHAT_DATABASE_PASSWORD}@localhost:5432/chatwoot"
      ],
      "env": {
        "POSTGRES_HOST": "localhost",
        "POSTGRES_PORT": "5432",
        "POSTGRES_DB": "chatwoot",
        "POSTGRES_USER": "chatwoot"
      }
    }
  }
}
```

### Filesystem - Acceso al proyecto

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/opt/ATS/VersatileHub"
      ],
      "env": {}
    }
  }
}
```

### Docker - Control de contenedores

```json
{
  "mcpServers": {
    "docker": {
      "command": "docker",
      "args": ["compose", "ps", "--format", "json"],
      "env": {
        "COMPOSE_FILE": "/opt/ATS/VersatileHub/docker-compose.yml"
      }
    }
  }
}
```

## 📋 Configuración Completa (Copiar y Pegar)

Archivo: `~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json`

```json
{
  "mcpServers": {
    "postgres-chat": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://chatwoot:TU_PASSWORD@localhost:5432/chatwoot"
      ],
      "disabled": false
    },
    "filesystem-services": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/opt/ATS/VersatileHub/services"
      ],
      "disabled": false
    },
    "git": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-git",
        "--repository",
        "/opt/ATS/VersatileHub"
      ],
      "disabled": false
    }
  }
}
```

## 🎯 Uso con Agentes

Una vez configurado MCP, puedes usar comandos como:

### Consultar Base de Datos
```
"Conecta a postgres-chat y muéstrame las últimas 10 conversaciones"
"Cuántos usuarios hay registrados en la base de datos de chat?"
```

### Operaciones de Archivos
```
"Usando filesystem-services, analiza todos los docker-compose.yml y lista los puertos usados"
"Busca todos los archivos .env.example en el proyecto"
```

### Operaciones Git
```
"Muestra los últimos 5 commits"
"¿Qué archivos han cambiado desde el último commit?"
```

## 🔒 Seguridad

### Credenciales de Base de Datos

**NUNCA** hardcodees contraseñas. Usa variables de entorno:

```bash
# En ~/.bashrc o ~/.zshrc
export CHAT_DB_PASSWORD="tu_password_aqui"

# En la configuración MCP
"postgresql://chatwoot:${CHAT_DB_PASSWORD}@localhost:5432/chatwoot"
```

### Permisos

Los MCP servers tienen acceso según lo configures:
- **PostgreSQL**: Solo lectura vs lectura/escritura
- **Filesystem**: Solo directorios específicos
- **Docker**: Comandos limitados

## 🐛 Troubleshooting

### MCP server no se conecta
```bash
# Verificar que el server está instalado
npm list -g @modelcontextprotocol/server-postgres

# Test manual
npx @modelcontextprotocol/server-postgres postgresql://user:pass@localhost:5432/db

# Ver logs en Cline
Ctrl+Shift+P → "Cline: Show MCP Logs"
```

### Error de conexión a PostgreSQL
```bash
# Verificar que el puerto está expuesto
docker compose ps
# Asegúrate que PostgreSQL está en 5432:5432

# Verificar desde host
psql -h localhost -U chatwoot -d chatwoot
```

### Error de permisos filesystem
```bash
# Verificar permisos del directorio
ls -la /opt/ATS/VersatileHub/

# Ajustar permisos si es necesario
sudo chown -R $USER:$USER /opt/ATS/VersatileHub/
```

## 📚 MCP Servers Disponibles

### Oficiales de Anthropic
- `@modelcontextprotocol/server-postgres` - PostgreSQL
- `@modelcontextprotocol/server-sqlite` - SQLite
- `@modelcontextprotocol/server-filesystem` - Sistema de archivos
- `@modelcontextprotocol/server-git` - Operaciones Git
- `@modelcontextprotocol/server-github` - API de GitHub
- `@modelcontextprotocol/server-slack` - API de Slack

### Comunitarios
- `@modelcontextprotocol/server-mongodb` - MongoDB
- `@modelcontextprotocol/server-redis` - Redis
- `@modelcontextprotocol/server-docker` - Docker API

## 🎓 Mejores Prácticas

1. **Empieza simple**: Configura filesystem primero, luego bases de datos
2. **Test individual**: Prueba cada MCP server por separado
3. **Limita acceso**: Solo da acceso a lo necesario
4. **Usa solo lectura**: Para bases de datos de producción
5. **Variables de entorno**: Para todas las credenciales

## 🔗 Referencias

- [MCP Documentation](https://modelcontextprotocol.io/docs)
- [Cline MCP Guide](https://github.com/cline/cline/blob/main/MCP.md)
- [Available MCP Servers](https://github.com/modelcontextprotocol/servers)

---

**Siguiente paso:** [Configurar Agentes](../agents/README.md)

**Última actualización:** 2026-03-11
