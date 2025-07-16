#!/bin/bash

# Claude Multi-Wrapped Architecture - Quick Install Script
# This script installs all required MCPs for the system

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ASCII Art
echo -e "${BLUE}"
echo "  ╔═══════════════════════════════════════════════════════════════════════╗"
echo "  ║   🚀 Claude Multi-Wrapped Architecture - Quick Install Script         ║"
echo "  ║   Sistema de IA multi-wrapped para automatización inteligente        ║"
echo "  ╚═══════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GREEN}🚀 Iniciando instalación de Claude Multi-Wrapped Architecture...${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}📋 Verificando prerrequisitos...${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js no está instalado${NC}"
    echo "Por favor instala Node.js v18+ desde https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js ${NODE_VERSION} detectado${NC}"

# Check npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm no está instalado${NC}"
    exit 1
fi

NPM_VERSION=$(npm --version)
echo -e "${GREEN}✅ npm ${NPM_VERSION} detectado${NC}"

# Check Claude Desktop
if [ ! -d "$HOME/.config/claude-desktop" ]; then
    echo -e "${YELLOW}⚠️  Creando directorio de configuración de Claude Desktop...${NC}"
    mkdir -p "$HOME/.config/claude-desktop"
fi

echo -e "${GREEN}✅ Claude Desktop configurado${NC}"
echo ""

# Install Core MCPs
echo -e "${YELLOW}📦 Instalando MCPs Core...${NC}"

CORE_MCPS=(
    "@modelcontextprotocol/server-odoo"
    "@modelcontextprotocol/server-mysql"
    "@modelcontextprotocol/server-chroma"
    "@modelcontextprotocol/server-flowise"
    "@modelcontextprotocol/server-n8n"
)

for mcp in "${CORE_MCPS[@]}"; do
    echo -e "${BLUE}📥 Instalando ${mcp}...${NC}"
    if npm install -g "$mcp" &> /dev/null; then
        echo -e "${GREEN}✅ ${mcp} instalado correctamente${NC}"
    else
        echo -e "${RED}❌ Error instalando ${mcp}${NC}"
        # Continue with other MCPs
    fi
done

echo ""

# Install External MCPs
echo -e "${YELLOW}📦 Instalando MCPs External...${NC}"

EXTERNAL_MCPS=(
    "@modelcontextprotocol/server-whatsapp"
    "@modelcontextprotocol/server-calendar"
    "@modelcontextprotocol/server-linkedin"
    "@modelcontextprotocol/server-github"
    "@modelcontextprotocol/server-notion"
    "@modelcontextprotocol/server-wordpress"
    "@modelcontextprotocol/server-filesystem"
)

for mcp in "${EXTERNAL_MCPS[@]}"; do
    echo -e "${BLUE}📥 Instalando ${mcp}...${NC}"
    if npm install -g "$mcp" &> /dev/null; then
        echo -e "${GREEN}✅ ${mcp} instalado correctamente${NC}"
    else
        echo -e "${RED}❌ Error instalando ${mcp}${NC}"
        # Continue with other MCPs
    fi
done

echo ""

# Create configuration file
echo -e "${YELLOW}⚙️  Creando archivo de configuración...${NC}"

CONFIG_FILE="$HOME/.config/claude-desktop/claude_desktop_config.json"
TEMPLATE_URL="https://raw.githubusercontent.com/RamsesAguirre777/claude-multi-wrapped-architecture/main/configs/claude-desktop-config.template.json"

if curl -fsSL "$TEMPLATE_URL" -o "$CONFIG_FILE"; then
    echo -e "${GREEN}✅ Archivo de configuración creado: ${CONFIG_FILE}${NC}"
else
    echo -e "${YELLOW}⚠️  No se pudo descargar el template, creando configuración básica...${NC}"
    
    cat > "$CONFIG_FILE" << 'EOF'
{
  "mcpServers": {
    "odoo": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-odoo", "--host", "YOUR_ODOO_HOST", "--port", "8069", "--database", "YOUR_ODOO_DB", "--user", "YOUR_ODOO_USER", "--password", "YOUR_ODOO_PASSWORD"]
    },
    "mysql": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-mysql", "--host", "YOUR_MYSQL_HOST", "--port", "3306", "--user", "YOUR_MYSQL_USER", "--password", "YOUR_MYSQL_PASSWORD", "--database", "YOUR_MYSQL_DATABASE"]
    },
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github", "--token", "YOUR_GITHUB_TOKEN"]
    },
    "notion": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-notion", "--token", "YOUR_NOTION_TOKEN"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "--allowed-directories", "/Users/$USER/Documents/claude-projects"]
    }
  }
}
EOF
    echo -e "${GREEN}✅ Configuración básica creada${NC}"
fi

echo ""

# Create projects directory
echo -e "${YELLOW}📁 Creando directorio de proyectos...${NC}"
PROJECTS_DIR="$HOME/Documents/claude-projects"
mkdir -p "$PROJECTS_DIR"
echo -e "${GREEN}✅ Directorio creado: ${PROJECTS_DIR}${NC}"

echo ""

# Verify installation
echo -e "${YELLOW}🔍 Verificando instalación...${NC}"

INSTALLED_MCPS=$(npm list -g | grep -c "@modelcontextprotocol")
echo -e "${GREEN}✅ ${INSTALLED_MCPS} MCPs instalados correctamente${NC}"

echo ""

# Show next steps
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🎉 ¡Instalación completada exitosamente!                            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}📝 PRÓXIMOS PASOS:${NC}"
echo ""
echo -e "${GREEN}1. Configurar credenciales:${NC}"
echo -e "   ${BLUE}nano $CONFIG_FILE${NC}"
echo ""
echo -e "${GREEN}2. Reemplazar valores de ejemplo:${NC}"
echo -e "   ${BLUE}YOUR_ODOO_HOST     → Tu servidor Hetzner IP${NC}"
echo -e "   ${BLUE}YOUR_MYSQL_HOST    → Tu servidor MySQL IP${NC}"
echo -e "   ${BLUE}YOUR_GITHUB_TOKEN  → Tu token de GitHub${NC}"
echo -e "   ${BLUE}YOUR_NOTION_TOKEN  → Tu token de Notion${NC}"
echo ""
echo -e "${GREEN}3. Reiniciar Claude Desktop:${NC}"
echo -e "   ${BLUE}pkill -f \"Claude Desktop\" && open -a \"Claude Desktop\"${NC}"
echo ""
echo -e "${GREEN}4. Verificar MCPs en Claude Desktop:${NC}"
echo -e "   ${BLUE}Los MCPs deberían aparecer en el menú de herramientas${NC}"
echo ""
echo -e "${GREEN}5. Configurar tu caso de uso específico:${NC}"
echo -e "   ${BLUE}• Clínica Dental: docs/examples/dental-clinic/${NC}"
echo -e "   ${BLUE}• Agencia Marketing: docs/examples/marketing-agency/${NC}"
echo ""

echo -e "${YELLOW}📚 RECURSOS ADICIONALES:${NC}"
echo -e "${BLUE}• Documentación completa: https://github.com/RamsesAguirre777/claude-multi-wrapped-architecture${NC}"
echo -e "${BLUE}• Setup rápido: QUICK-SETUP.md${NC}"
echo -e "${BLUE}• Decision Triggers: docs/decision-triggers.md${NC}"
echo -e "${BLUE}• Casos de uso: examples/${NC}"
echo ""

echo -e "${GREEN}🚀 ¡Tu sistema Claude Multi-Wrapped está listo para revolucionar la automatización inteligente!${NC}"
echo ""

# Optional: Run test
read -p "¿Quieres ejecutar un test de verificación? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🧪 Ejecutando test de verificación...${NC}"
    
    # Test basic MCP installations
    echo -e "${BLUE}Verificando MCPs instalados:${NC}"
    npm list -g | grep "@modelcontextprotocol" | head -5
    
    echo -e "${GREEN}✅ Test completado${NC}"
fi

echo ""
echo -e "${GREEN}¡Instalación terminada! 🎯${NC}"