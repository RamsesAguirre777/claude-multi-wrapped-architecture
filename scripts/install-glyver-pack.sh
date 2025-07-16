#!/bin/bash
# 🚀 Glyver AI Ops Pack - Instalador Automático
# Versión: 1.0.0
# Descripción: Instalación completa del stack de automatización inteligente

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                           🚀 GLYVER AI OPS PACK 🚀                                  ║"
    echo "║                     Enterprise AI Automation Suite                                  ║"
    echo "║                                                                                      ║"
    echo "║    🧠 Claude Desktop + RAG Bot + Memory MCP + MCPs + Hetzner Infrastructure        ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar prerequisitos
check_prerequisites() {
    print_status "Verificando prerequisitos..."
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js no está instalado. Instala Node.js v18+ antes de continuar."
        exit 1
    fi
    
    # Verificar npm
    if ! command -v npm &> /dev/null; then
        print_error "npm no está instalado."
        exit 1
    fi
    
    # Verificar Claude Desktop
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ ! -d "/Applications/Claude Desktop.app" ]; then
            print_warning "Claude Desktop no está instalado. Por favor instálalo desde claude.ai"
        fi
    fi
    
    print_success "Prerequisitos verificados"
}

# Configurar variables de entorno
setup_environment() {
    print_status "Configurando variables de entorno..."
    
    # Crear directorio de configuración
    mkdir -p ~/.glyver-ai-ops
    
    # Solicitar API keys
    echo ""
    print_status "Necesitamos configurar las API keys necesarias:"
    echo ""
    
    read -p "🔑 Anthropic API Key (para Memory MCP): " ANTHROPIC_API_KEY
    read -p "🔑 Mistral API Key (para RAG Bot): " MISTRAL_API_KEY
    read -p "🌐 Hetzner Server IP (opcional): " HETZNER_IP
    read -p "🗄️ MySQL Host (opcional): " MYSQL_HOST
    read -p "🏢 Odoo URL (opcional): " ODOO_URL
    
    # Crear archivo de configuración
    cat > ~/.glyver-ai-ops/config.env << EOF
# Glyver AI Ops Pack Configuration
# Generated: $(date)

# API Keys
ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY
MISTRAL_API_KEY=$MISTRAL_API_KEY

# Infrastructure
HETZNER_IP=${HETZNER_IP:-localhost}
MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_PORT=3306
ODOO_URL=${ODOO_URL:-http://localhost:8069}

# RAG Bot Configuration
RAG_BOT_ENABLED=true
RAG_BOT_THRESHOLD=0.7
RAG_BOT_MAX_CONTEXT=4096

# Chroma Configuration
CHROMA_HOST=localhost
CHROMA_PORT=8000
CHROMA_COLLECTION=lead_qualification

# Memory MCP Configuration
MEMORY_DATABASE_PATH=~/.anthropic/memory.db
MEMORY_MAX_ENTRIES=10000
MEMORY_SIMILARITY_THRESHOLD=0.7
EOF
    
    # Cargar configuración
    source ~/.glyver-ai-ops/config.env
    
    print_success "Variables de entorno configuradas"
}

# Instalar MCPs
install_mcps() {
    print_status "Instalando MCPs necesarios..."
    
    # MCPs oficiales
    print_status "Instalando MCPs oficiales..."
    npm install -g @anthropic/memory-mcp-server
    npm install -g @modelcontextprotocol/server-mysql
    npm install -g @modelcontextprotocol/server-filesystem
    
    # MCPs adicionales
    print_status "Instalando MCPs adicionales..."
    npm install -g @modelcontextprotocol/server-github
    npm install -g @modelcontextprotocol/server-slack
    
    print_success "MCPs instalados correctamente"
}

# Configurar Memory MCP
setup_memory_mcp() {
    print_status "Configurando Anthropic Memory MCP..."
    
    # Crear directorio de configuración
    mkdir -p ~/.anthropic
    
    # Crear archivo de configuración
    cat > ~/.anthropic/memory-config.json << EOF
{
  "api_key": "$ANTHROPIC_API_KEY",
  "memory_database": "~/.anthropic/memory.db",
  "max_memories": 10000,
  "embedding_model": "text-embedding-3-small",
  "similarity_threshold": 0.7
}
EOF
    
    print_success "Memory MCP configurado"
}

# Instalar RAG Bot
install_rag_bot() {
    print_status "Instalando RAG Bot Lead Qualification System..."
    
    # Crear directorio del RAG Bot
    mkdir -p ~/.glyver-ai-ops/rag-bot
    cd ~/.glyver-ai-ops/rag-bot
    
    # Inicializar proyecto Node.js
    npm init -y
    
    # Instalar dependencias
    npm install @modelcontextprotocol/sdk
    npm install @mistral-ai/mistralai
    npm install chromadb
    npm install natural
    npm install uuid
    
    # Crear archivo principal del servidor
    cat > server.js << 'EOF'
const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');

class RAGBotServer {
  constructor() {
    this.server = new Server({
      name: 'rag-bot-qualification',
      version: '1.0.0',
    });
    
    this.setupHandlers();
  }
  
  setupHandlers() {
    this.server.setRequestHandler('qualify_lead', async (request) => {
      const { message, context } = request.params;
      
      // Lógica de calificación básica
      const score = this.calculateScore(message);
      
      return {
        success: true,
        qualification: {
          score: score,
          classification: score >= 80 ? 'high_priority' : score >= 50 ? 'medium_priority' : 'low_priority',
          timestamp: new Date().toISOString()
        }
      };
    });
  }
  
  calculateScore(message) {
    const text = message.toLowerCase();
    let score = 0;
    
    // Indicadores de presupuesto
    if (text.includes('presupuesto') || text.includes('precio') || text.includes('costo')) {
      score += 30;
    }
    
    // Señales de urgencia
    if (text.includes('urgente') || text.includes('pronto') || text.includes('necesito')) {
      score += 25;
    }
    
    // Decision maker
    if (text.includes('director') || text.includes('ceo') || text.includes('gerente')) {
      score += 20;
    }
    
    // Tamaño de empresa
    if (text.includes('empresa') || text.includes('empleados')) {
      score += 15;
    }
    
    return Math.min(score, 100);
  }
}

const server = new RAGBotServer();
const transport = new StdioServerTransport();
server.server.connect(transport);
EOF
    
    print_success "RAG Bot instalado"
}

# Configurar Claude Desktop
setup_claude_desktop() {
    print_status "Configurando Claude Desktop..."
    
    # Crear directorio de configuración
    mkdir -p ~/.config/claude-desktop
    
    # Backup configuración existente
    if [[ -f ~/.config/claude-desktop/claude_desktop_config.json ]]; then
        print_warning "Haciendo backup de configuración existente..."
        cp ~/.config/claude-desktop/claude_desktop_config.json ~/.config/claude-desktop/claude_desktop_config.json.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Crear nueva configuración
    cat > ~/.config/claude-desktop/claude_desktop_config.json << EOF
{
  "mcpServers": {
    "anthropic-memory": {
      "command": "npx",
      "args": ["@anthropic/memory-mcp-server"],
      "env": {
        "ANTHROPIC_API_KEY": "$ANTHROPIC_API_KEY"
      }
    },
    "rag-bot-qualification": {
      "command": "node",
      "args": ["$HOME/.glyver-ai-ops/rag-bot/server.js"],
      "env": {
        "MISTRAL_API_KEY": "$MISTRAL_API_KEY",
        "CHROMA_HOST": "localhost",
        "CHROMA_PORT": "8000"
      }
    },
    "mysql": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-mysql"],
      "env": {
        "MYSQL_HOST": "$MYSQL_HOST",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "glyver_user",
        "MYSQL_PASSWORD": "glyver_password",
        "MYSQL_DATABASE": "glyver_ai_ops"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "$HOME/.glyver-ai-ops"
      }
    }
  }
}
EOF
    
    print_success "Claude Desktop configurado"
}

# Crear archivos de sistema
create_system_files() {
    print_status "Creando archivos del sistema..."
    
    # Crear directorio de prompts
    mkdir -p ~/.glyver-ai-ops/prompts
    
    # Prompt principal del sistema
    cat > ~/.glyver-ai-ops/prompts/system-prompt.md << 'EOF'
# Glyver AI Ops Pack - System Prompt

Eres un asistente especializado en automatización empresarial con acceso a:

## 🧠 CAPACIDADES PRINCIPALES
- **Memory MCP**: Memoria persistente entre sesiones
- **RAG Bot**: Calificación inteligente de leads
- **MySQL**: Base de datos operativa
- **Filesystem**: Acceso a archivos del sistema

## 🎯 INSTRUCCIONES PRINCIPALES
1. Siempre consulta la memoria antes de responder
2. Usa el RAG Bot para calificar leads automáticamente
3. Almacena información importante en cada interacción
4. Mantén consistencia entre sesiones

## 📊 PROCESO DE CALIFICACIÓN
1. Analizar mensaje con RAG Bot
2. Recuperar contexto histórico con Memory MCP
3. Combinar información para scoring mejorado
4. Ejecutar acciones correspondientes

## 🔄 FLUJO TÍPICO
Cliente → Análisis RAG → Memoria Histórica → Calificación → Acciones
EOF
    
    # Crear directorio de templates
    mkdir -p ~/.glyver-ai-ops/templates
    
    # Template de respuesta
    cat > ~/.glyver-ai-ops/templates/response-template.md << 'EOF'
# Template de Respuesta Glyver AI Ops

## Para Leads High Priority (Score >= 80)
- Respuesta personal y cálida
- Enfoque en valor inmediato
- Llamada a acción directa
- Asignación de representante senior

## Para Leads Medium Priority (Score 50-79)
- Respuesta informativa y profesional
- Información relevante del servicio
- Seguimiento programado
- Nurturing sequence

## Para Leads Low Priority (Score < 50)
- Respuesta educativa y útil
- Recursos informativos
- Sin presión de venta
- Nurturing a largo plazo
EOF
    
    print_success "Archivos del sistema creados"
}

# Crear scripts de utilidad
create_utility_scripts() {
    print_status "Creando scripts de utilidad..."
    
    # Script de testing
    cat > ~/.glyver-ai-ops/test-system.sh << 'EOF'
#!/bin/bash
# Test del sistema Glyver AI Ops Pack

echo "🧪 Testing Glyver AI Ops Pack..."

# Test 1: Verificar MCPs instalados
echo "Test 1: Verificando MCPs..."
if npm list -g @anthropic/memory-mcp-server &>/dev/null; then
    echo "✅ Memory MCP instalado"
else
    echo "❌ Memory MCP no instalado"
fi

# Test 2: Verificar configuración Claude Desktop
echo "Test 2: Verificando configuración Claude Desktop..."
if [[ -f ~/.config/claude-desktop/claude_desktop_config.json ]]; then
    echo "✅ Configuración Claude Desktop encontrada"
else
    echo "❌ Configuración Claude Desktop no encontrada"
fi

# Test 3: Verificar RAG Bot
echo "Test 3: Verificando RAG Bot..."
if [[ -f ~/.glyver-ai-ops/rag-bot/server.js ]]; then
    echo "✅ RAG Bot instalado"
else
    echo "❌ RAG Bot no instalado"
fi

echo "🎉 Testing completo"
EOF
    
    chmod +x ~/.glyver-ai-ops/test-system.sh
    
    # Script de restart
    cat > ~/.glyver-ai-ops/restart-claude.sh << 'EOF'
#!/bin/bash
# Reiniciar Claude Desktop

echo "🔄 Reiniciando Claude Desktop..."

# Terminar proceso Claude Desktop
pkill -f "Claude Desktop" || true

# Esperar un momento
sleep 2

# Reiniciar Claude Desktop
if [[ "$OSTYPE" == "darwin"* ]]; then
    open -a "Claude Desktop"
    echo "✅ Claude Desktop reiniciado"
else
    echo "❌ Sistema no soportado para reinicio automático"
fi
EOF
    
    chmod +x ~/.glyver-ai-ops/restart-claude.sh
    
    print_success "Scripts de utilidad creados"
}

# Función principal
main() {
    print_banner
    
    # Verificar si ya existe instalación
    if [[ -d ~/.glyver-ai-ops ]]; then
        print_warning "Instalación existente encontrada en ~/.glyver-ai-ops"
        read -p "¿Deseas continuar y sobrescribir? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Instalación cancelada"
            exit 0
        fi
    fi
    
    # Ejecutar pasos de instalación
    check_prerequisites
    setup_environment
    install_mcps
    setup_memory_mcp
    install_rag_bot
    setup_claude_desktop
    create_system_files
    create_utility_scripts
    
    # Mensaje final
    echo ""
    print_success "🎉 ¡Glyver AI Ops Pack instalado correctamente!"
    echo ""
    print_status "📋 Próximos pasos:"
    echo "1. Reinicia Claude Desktop: ~/.glyver-ai-ops/restart-claude.sh"
    echo "2. Prueba el sistema: ~/.glyver-ai-ops/test-system.sh"
    echo "3. Configura tu servidor Hetzner (opcional)"
    echo "4. Conecta con Odoo CRM (opcional)"
    echo ""
    print_status "📚 Documentación completa en:"
    echo "https://github.com/RamsesAguirre777/claude-multi-wrapped-architecture"
    echo ""
    print_status "🎯 Para soporte técnico:"
    echo "GitHub Issues: https://github.com/RamsesAguirre777/claude-multi-wrapped-architecture/issues"
    echo ""
    print_success "¡Disfruta de tu nuevo sistema de automatización inteligente! 🚀"
}

# Ejecutar función principal
main "$@"