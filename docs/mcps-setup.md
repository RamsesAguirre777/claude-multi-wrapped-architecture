# 🛠️ Configuración de MCPs

## 📋 **MCPs Requeridos**

### **Core MCPs**
- **Odoo MCP**: Operaciones CRM/ERP
- **MySQL MCP**: Análisis de base de datos y logging
- **Chroma MCP**: Memoria/Embeddings/RAG
- **Flowise MCP**: Interfaz conversacional
- **n8n MCP**: Workflows de automatización

### **External MCPs**
- **WhatsApp MCP**: Notificaciones y mensajería
- **Calendar MCP**: Gestión de citas
- **LinkedIn MCP**: Prospección y networking
- **GitHub MCP**: Gestión de código
- **Notion MCP**: Documentación y notas
- **WordPress MCP**: Gestión de contenido

## ⚙️ **Configuración Claude Desktop**

### **claude_desktop_config.json**
```json
{
  "mcpServers": {
    "odoo": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-odoo", "--host", "tu_odoo_host", "--port", "8069", "--database", "tu_db", "--user", "tu_usuario", "--password", "tu_password"]
    },
    "mysql": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-mysql", "--host", "tu_mysql_host", "--port", "3306", "--user", "tu_usuario", "--password", "tu_password", "--database", "tu_db"]
    },
    "chroma": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-chroma", "--host", "tu_chroma_host", "--port", "8000"]
    },
    "flowise": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-flowise", "--host", "tu_flowise_host", "--port", "3000"]
    },
    "n8n-glyver": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-n8n", "--host", "tu_n8n_host", "--port", "5678"]
    },
    "whatsapp": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-whatsapp", "--api-key", "tu_whatsapp_api_key"]
    },
    "calendar": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-calendar", "--provider", "google", "--credentials", "tu_google_credentials"]
    },
    "linkedin": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-linkedin", "--session-cookie", "tu_linkedin_session"]
    },
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github", "--token", "tu_github_token"]
    },
    "notion": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-notion", "--token", "tu_notion_token"]
    },
    "wordpress": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-wordpress", "--url", "tu_wordpress_url", "--username", "tu_wp_user", "--password", "tu_wp_password"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "--allowed-directories", "/path/to/allowed/dir"]
    }
  }
}
```

## 📦 **Instalación de MCPs**

### **Comando de Instalación Completa**
```bash
# Core MCPs
npm install -g @modelcontextprotocol/server-odoo
npm install -g @modelcontextprotocol/server-mysql
npm install -g @modelcontextprotocol/server-chroma
npm install -g @modelcontextprotocol/server-flowise
npm install -g @modelcontextprotocol/server-n8n

# External MCPs
npm install -g @modelcontextprotocol/server-whatsapp
npm install -g @modelcontextprotocol/server-calendar
npm install -g @modelcontextprotocol/server-linkedin
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-notion
npm install -g @modelcontextprotocol/server-wordpress
npm install -g @modelcontextprotocol/server-filesystem
```

## 🔧 **Configuración por MCP**

### **1. Odoo MCP**
```bash
# Variables de entorno
export ODOO_HOST="tu_hetzner_ip"
export ODOO_PORT="8069"
export ODOO_DB="tu_database"
export ODOO_USER="tu_usuario"
export ODOO_PASSWORD="tu_password"

# Test de conexión
curl -X POST http://$ODOO_HOST:$ODOO_PORT/web/session/authenticate \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"call","params":{"db":"'$ODOO_DB'","login":"'$ODOO_USER'","password":"'$ODOO_PASSWORD'"}}'
```

### **2. MySQL MCP**
```bash
# Variables de entorno
export MYSQL_HOST="tu_hetzner_ip"
export MYSQL_PORT="3306"
export MYSQL_USER="tu_usuario"
export MYSQL_PASSWORD="tu_password"
export MYSQL_DATABASE="tu_database"

# Test de conexión
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1"
```

### **3. Chroma MCP**
```bash
# Variables de entorno
export CHROMA_HOST="tu_hetzner_ip"
export CHROMA_PORT="8000"

# Test de conexión
curl http://$CHROMA_HOST:$CHROMA_PORT/api/v1/heartbeat
```

### **4. Flowise MCP**
```bash
# Variables de entorno
export FLOWISE_HOST="tu_hetzner_ip"
export FLOWISE_PORT="3000"

# Test de conexión
curl http://$FLOWISE_HOST:$FLOWISE_PORT/api/v1/chatflows
```

### **5. n8n MCP**
```bash
# Variables de entorno
export N8N_HOST="tu_hetzner_ip"
export N8N_PORT="5678"

# Test de conexión
curl http://$N8N_HOST:$N8N_PORT/rest/workflows
```

## 🚀 **Script de Configuración Automática**

### **setup-mcps.sh**
```bash
#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Configurando Claude Multi-Wrapped Architecture${NC}"

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js no está instalado${NC}"
    exit 1
fi

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm no está instalado${NC}"
    exit 1
fi

# Instalar MCPs Core
echo -e "${YELLOW}📦 Instalando MCPs Core...${NC}"
npm install -g @modelcontextprotocol/server-odoo
npm install -g @modelcontextprotocol/server-mysql
npm install -g @modelcontextprotocol/server-chroma
npm install -g @modelcontextprotocol/server-flowise
npm install -g @modelcontextprotocol/server-n8n

# Instalar MCPs External
echo -e "${YELLOW}📦 Instalando MCPs External...${NC}"
npm install -g @modelcontextprotocol/server-whatsapp
npm install -g @modelcontextprotocol/server-calendar
npm install -g @modelcontextprotocol/server-linkedin
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-notion
npm install -g @modelcontextprotocol/server-wordpress
npm install -g @modelcontextprotocol/server-filesystem

# Crear directorio de configuración
mkdir -p ~/.config/claude-desktop

# Crear archivo de configuración base
cat > ~/.config/claude-desktop/claude_desktop_config.json << 'EOF'
{
  "mcpServers": {
    "odoo": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-odoo", "--host", "ODOO_HOST", "--port", "8069", "--database", "ODOO_DB", "--user", "ODOO_USER", "--password", "ODOO_PASSWORD"]
    },
    "mysql": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-mysql", "--host", "MYSQL_HOST", "--port", "3306", "--user", "MYSQL_USER", "--password", "MYSQL_PASSWORD", "--database", "MYSQL_DATABASE"]
    },
    "chroma": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-chroma", "--host", "CHROMA_HOST", "--port", "8000"]
    },
    "flowise": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-flowise", "--host", "FLOWISE_HOST", "--port", "3000"]
    },
    "n8n-glyver": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-n8n", "--host", "N8N_HOST", "--port", "5678"]
    },
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github", "--token", "GITHUB_TOKEN"]
    },
    "notion": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-notion", "--token", "NOTION_TOKEN"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "--allowed-directories", "/Users/username/Documents"]
    }
  }
}
EOF

echo -e "${GREEN}✅ MCPs instalados correctamente${NC}"
echo -e "${YELLOW}⚠️  Recuerda configurar las variables de entorno en ~/.config/claude-desktop/claude_desktop_config.json${NC}"
echo -e "${YELLOW}⚠️  Reinicia Claude Desktop después de la configuración${NC}"
```

## 🔍 **Verificación de Configuración**

### **test-mcps.sh**
```bash
#!/bin/bash

echo "🔍 Verificando configuración de MCPs..."

# Test Odoo
echo "Testing Odoo MCP..."
npx @modelcontextprotocol/server-odoo --help

# Test MySQL
echo "Testing MySQL MCP..."
npx @modelcontextprotocol/server-mysql --help

# Test Chroma
echo "Testing Chroma MCP..."
npx @modelcontextprotocol/server-chroma --help

# Test Flowise
echo "Testing Flowise MCP..."
npx @modelcontextprotocol/server-flowise --help

# Test n8n
echo "Testing n8n MCP..."
npx @modelcontextprotocol/server-n8n --help

echo "✅ Verificación completada"
```

## 🚨 **Troubleshooting**

### **Problemas Comunes**

1. **MCP no aparece en Claude Desktop**
   - Verificar que el comando esté bien escrito
   - Reiniciar Claude Desktop
   - Verificar logs en `/tmp/claude-desktop-logs`

2. **Error de conexión a servidor**
   - Verificar que el servidor esté corriendo
   - Verificar firewall y puertos abiertos
   - Verificar credenciales

3. **Comando no encontrado**
   - Verificar instalación con `npm list -g`
   - Reinstalar MCP específico
   - Verificar PATH de npm

### **Logs y Debugging**
```bash
# Ver logs de Claude Desktop
tail -f /tmp/claude-desktop-logs

# Verificar instalación de MCPs
npm list -g | grep modelcontextprotocol

# Test manual de MCP
npx @modelcontextprotocol/server-odoo --host localhost --port 8069 --database test --user admin --password admin
```

## 📝 **Próximos Pasos**

1. **Ejecutar script de configuración**
   ```bash
   chmod +x setup-mcps.sh
   ./setup-mcps.sh
   ```

2. **Configurar variables de entorno**
   - Editar `~/.config/claude-desktop/claude_desktop_config.json`
   - Agregar credenciales reales

3. **Reiniciar Claude Desktop**

4. **Verificar conexiones**
   ```bash
   chmod +x test-mcps.sh
   ./test-mcps.sh
   ```

5. **Proceder con configuración de Decision Triggers**
   - Ver `docs/decision-triggers.md`