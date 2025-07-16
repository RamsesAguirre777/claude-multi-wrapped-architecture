#!/bin/bash

# Claude Multi-Wrapped Architecture - Test Script
# This script tests all MCPs and connections

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🧪 Claude Multi-Wrapped Architecture - Test Suite                  ║${NC}"
echo -e "${BLUE}║   Verificando todos los MCPs y conexiones                            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Load environment variables if .env exists
if [ -f ".env" ]; then
    echo -e "${YELLOW}📋 Cargando variables de entorno...${NC}"
    source .env
    echo -e "${GREEN}✅ Variables cargadas${NC}"
else
    echo -e "${YELLOW}⚠️  No se encontró archivo .env${NC}"
fi

echo ""

# Test 1: Check Node.js and npm
echo -e "${YELLOW}🔍 Test 1: Verificando Node.js y npm...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Node.js ${NODE_VERSION}${NC}"
else
    echo -e "${RED}❌ Node.js no instalado${NC}"
    exit 1
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✅ npm ${NPM_VERSION}${NC}"
else
    echo -e "${RED}❌ npm no instalado${NC}"
    exit 1
fi

echo ""

# Test 2: Check Claude Desktop configuration
echo -e "${YELLOW}🔍 Test 2: Verificando configuración de Claude Desktop...${NC}"
CONFIG_FILE="$HOME/.config/claude-desktop/claude_desktop_config.json"

if [ -f "$CONFIG_FILE" ]; then
    echo -e "${GREEN}✅ Archivo de configuración encontrado${NC}"
    
    # Check if it's valid JSON
    if jq empty "$CONFIG_FILE" 2>/dev/null; then
        echo -e "${GREEN}✅ JSON válido${NC}"
    else
        echo -e "${RED}❌ JSON inválido en configuración${NC}"
    fi
else
    echo -e "${RED}❌ Archivo de configuración no encontrado${NC}"
    echo -e "${YELLOW}💡 Ejecuta: ./scripts/quick-install.sh${NC}"
fi

echo ""

# Test 3: Check MCP installations
echo -e "${YELLOW}🔍 Test 3: Verificando instalaciones de MCPs...${NC}"

CORE_MCPS=(
    "@modelcontextprotocol/server-odoo"
    "@modelcontextprotocol/server-mysql"
    "@modelcontextprotocol/server-chroma"
    "@modelcontextprotocol/server-flowise"
    "@modelcontextprotocol/server-n8n"
)

EXTERNAL_MCPS=(
    "@modelcontextprotocol/server-whatsapp"
    "@modelcontextprotocol/server-calendar"
    "@modelcontextprotocol/server-linkedin"
    "@modelcontextprotocol/server-github"
    "@modelcontextprotocol/server-notion"
    "@modelcontextprotocol/server-wordpress"
    "@modelcontextprotocol/server-filesystem"
)

echo -e "${BLUE}Core MCPs:${NC}"
for mcp in "${CORE_MCPS[@]}"; do
    if npm list -g "$mcp" &> /dev/null; then
        echo -e "${GREEN}✅ ${mcp}${NC}"
    else
        echo -e "${RED}❌ ${mcp}${NC}"
    fi
done

echo ""
echo -e "${BLUE}External MCPs:${NC}"
for mcp in "${EXTERNAL_MCPS[@]}"; do
    if npm list -g "$mcp" &> /dev/null; then
        echo -e "${GREEN}✅ ${mcp}${NC}"
    else
        echo -e "${YELLOW}⚠️  ${mcp} (opcional)${NC}"
    fi
done

echo ""

# Test 4: Check server connections
echo -e "${YELLOW}🔍 Test 4: Verificando conexiones de servidor...${NC}"

# Test MySQL connection
if [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
    echo -e "${BLUE}Testing MySQL connection...${NC}"
    if command -v mysql &> /dev/null; then
        if mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" &> /dev/null; then
            echo -e "${GREEN}✅ MySQL conectado correctamente${NC}"
        else
            echo -e "${RED}❌ Error conectando a MySQL${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Cliente MySQL no instalado${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Variables MySQL no configuradas${NC}"
fi

# Test Odoo connection
if [ -n "$ODOO_HOST" ] && [ -n "$ODOO_PORT" ]; then
    echo -e "${BLUE}Testing Odoo connection...${NC}"
    if curl -s --max-time 5 "http://$ODOO_HOST:$ODOO_PORT" &> /dev/null; then
        echo -e "${GREEN}✅ Odoo servidor accesible${NC}"
    else
        echo -e "${RED}❌ Error conectando a Odoo${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Variables Odoo no configuradas${NC}"
fi

# Test Chroma connection
if [ -n "$CHROMA_HOST" ] && [ -n "$CHROMA_PORT" ]; then
    echo -e "${BLUE}Testing Chroma connection...${NC}"
    if curl -s --max-time 5 "http://$CHROMA_HOST:$CHROMA_PORT/api/v1/heartbeat" &> /dev/null; then
        echo -e "${GREEN}✅ Chroma servidor accesible${NC}"
    else
        echo -e "${RED}❌ Error conectando a Chroma${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Variables Chroma no configuradas${NC}"
fi

# Test Flowise connection
if [ -n "$FLOWISE_HOST" ] && [ -n "$FLOWISE_PORT" ]; then
    echo -e "${BLUE}Testing Flowise connection...${NC}"
    if curl -s --max-time 5 "http://$FLOWISE_HOST:$FLOWISE_PORT/api/v1/chatflows" &> /dev/null; then
        echo -e "${GREEN}✅ Flowise servidor accesible${NC}"
    else
        echo -e "${RED}❌ Error conectando a Flowise${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Variables Flowise no configuradas${NC}"
fi

# Test n8n connection
if [ -n "$N8N_HOST" ] && [ -n "$N8N_PORT" ]; then
    echo -e "${BLUE}Testing n8n connection...${NC}"
    if curl -s --max-time 5 "http://$N8N_HOST:$N8N_PORT/rest/workflows" &> /dev/null; then
        echo -e "${GREEN}✅ n8n servidor accesible${NC}"
    else
        echo -e "${RED}❌ Error conectando a n8n${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Variables n8n no configuradas${NC}"
fi

echo ""

# Test 5: Check API keys
echo -e "${YELLOW}🔍 Test 5: Verificando API keys...${NC}"

if [ -n "$MISTRAL_API_KEY" ]; then
    echo -e "${GREEN}✅ Mistral API key configurada${NC}"
else
    echo -e "${YELLOW}⚠️  Mistral API key no configurada${NC}"
fi

if [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${GREEN}✅ GitHub token configurado${NC}"
else
    echo -e "${YELLOW}⚠️  GitHub token no configurado${NC}"
fi

if [ -n "$NOTION_TOKEN" ]; then
    echo -e "${GREEN}✅ Notion token configurado${NC}"
else
    echo -e "${YELLOW}⚠️  Notion token no configurado${NC}"
fi

if [ -n "$WHATSAPP_TOKEN" ]; then
    echo -e "${GREEN}✅ WhatsApp token configurado${NC}"
else
    echo -e "${YELLOW}⚠️  WhatsApp token no configurado${NC}"
fi

echo ""

# Test 6: Check required directories
echo -e "${YELLOW}🔍 Test 6: Verificando directorios...${NC}"

PROJECTS_DIR="$HOME/Documents/claude-projects"
if [ -d "$PROJECTS_DIR" ]; then
    echo -e "${GREEN}✅ Directorio de proyectos: $PROJECTS_DIR${NC}"
else
    echo -e "${YELLOW}⚠️  Creando directorio de proyectos...${NC}"
    mkdir -p "$PROJECTS_DIR"
    echo -e "${GREEN}✅ Directorio creado: $PROJECTS_DIR${NC}"
fi

echo ""

# Test 7: Test MCP commands
echo -e "${YELLOW}🔍 Test 7: Probando comandos MCP...${NC}"

# Test basic MCP help commands
echo -e "${BLUE}Testing MCP help commands...${NC}"

if npx @modelcontextprotocol/server-filesystem --help &> /dev/null; then
    echo -e "${GREEN}✅ Filesystem MCP funcional${NC}"
else
    echo -e "${RED}❌ Filesystem MCP no funcional${NC}"
fi

if npx @modelcontextprotocol/server-github --help &> /dev/null; then
    echo -e "${GREEN}✅ GitHub MCP funcional${NC}"
else
    echo -e "${RED}❌ GitHub MCP no funcional${NC}"
fi

if npx @modelcontextprotocol/server-notion --help &> /dev/null; then
    echo -e "${GREEN}✅ Notion MCP funcional${NC}"
else
    echo -e "${RED}❌ Notion MCP no funcional${NC}"
fi

echo ""

# Test 8: Database schema check
echo -e "${YELLOW}🔍 Test 8: Verificando esquema de base de datos...${NC}"

if [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ] && [ -n "$MYSQL_DATABASE" ]; then
    if command -v mysql &> /dev/null; then
        echo -e "${BLUE}Verificando tablas requeridas...${NC}"
        
        # Check if required tables exist
        TABLES=("trigger_logs" "conversations" "daily_metrics" "service_prices")
        
        for table in "${TABLES[@]}"; do
            if mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -D "$MYSQL_DATABASE" -e "DESCRIBE $table" &> /dev/null; then
                echo -e "${GREEN}✅ Tabla $table existe${NC}"
            else
                echo -e "${YELLOW}⚠️  Tabla $table no existe${NC}"
            fi
        done
    else
        echo -e "${YELLOW}⚠️  Cliente MySQL no disponible${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Configuración MySQL incompleta${NC}"
fi

echo ""

# Summary
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   📊 RESUMEN DE TESTS                                                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Count successful tests
TOTAL_TESTS=8
PASSED_TESTS=0

# This is a simplified success check - in a real implementation you'd track each test result
echo -e "${GREEN}Tests completados: $TOTAL_TESTS${NC}"
echo ""

# Recommendations
echo -e "${YELLOW}📝 RECOMENDACIONES:${NC}"
echo ""

echo -e "${GREEN}1. Si algún MCP falló:${NC}"
echo -e "   ${BLUE}npm install -g @modelcontextprotocol/server-[nombre]${NC}"
echo ""

echo -e "${GREEN}2. Si hay errores de conexión:${NC}"
echo -e "   ${BLUE}• Verificar que los servidores estén corriendo${NC}"
echo -e "   ${BLUE}• Verificar firewall y puertos abiertos${NC}"
echo -e "   ${BLUE}• Verificar credenciales en .env${NC}"
echo ""

echo -e "${GREEN}3. Para crear tablas de base de datos:${NC}"
echo -e "   ${BLUE}mysql -h \$MYSQL_HOST -u \$MYSQL_USER -p\$MYSQL_PASSWORD -D \$MYSQL_DATABASE < sql/schema.sql${NC}"
echo ""

echo -e "${GREEN}4. Para reiniciar Claude Desktop:${NC}"
echo -e "   ${BLUE}pkill -f \"Claude Desktop\" && open -a \"Claude Desktop\"${NC}"
echo ""

echo -e "${GREEN}5. Para verificar logs:${NC}"
echo -e "   ${BLUE}tail -f /tmp/claude-desktop-logs${NC}"
echo ""

echo -e "${YELLOW}📚 DOCUMENTACIÓN:${NC}"
echo -e "${BLUE}• Setup completo: QUICK-SETUP.md${NC}"
echo -e "${BLUE}• Configuración MCPs: docs/mcps-setup.md${NC}"
echo -e "${BLUE}• Casos de uso: examples/${NC}"
echo ""

echo -e "${GREEN}🎯 Tests completados. Revisa los resultados arriba para cualquier acción necesaria.${NC}"
echo ""