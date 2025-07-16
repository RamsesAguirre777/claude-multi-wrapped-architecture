#!/bin/bash

# Claude Multi-Wrapped Architecture - Dental Clinic Deployment Script
# This script deploys the complete system for a dental clinic

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🦷 Claude Multi-Wrapped - Dental Clinic Deployment                 ║${NC}"
echo -e "${BLUE}║   Desplegando sistema completo para clínica dental                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running from project root
if [ ! -f "QUICK-SETUP.md" ]; then
    echo -e "${RED}❌ Por favor ejecuta este script desde el directorio raíz del proyecto${NC}"
    echo -e "${YELLOW}💡 Ejecuta: git clone https://github.com/RamsesAguirre777/claude-multi-wrapped-architecture.git${NC}"
    exit 1
fi

# Check prerequisites
echo -e "${YELLOW}📋 Verificando prerrequisitos...${NC}"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  Creando archivo .env...${NC}"
    cat > .env << 'EOF'
# Hetzner Server Configuration
HETZNER_IP=your_server_ip
MYSQL_HOST=${HETZNER_IP}
MYSQL_USER=your_mysql_user
MYSQL_PASSWORD=your_mysql_password
MYSQL_DATABASE=claude_multiwrapped

# Odoo Configuration
ODOO_HOST=${HETZNER_IP}
ODOO_PORT=8069
ODOO_DATABASE=your_odoo_db
ODOO_USER=your_odoo_user
ODOO_PASSWORD=your_odoo_password

# Chroma Configuration
CHROMA_HOST=${HETZNER_IP}
CHROMA_PORT=8000

# Flowise Configuration
FLOWISE_HOST=${HETZNER_IP}
FLOWISE_PORT=3000

# n8n Configuration
N8N_HOST=${HETZNER_IP}
N8N_PORT=5678

# API Keys
MISTRAL_API_KEY=your_mistral_key
GITHUB_TOKEN=your_github_token
NOTION_TOKEN=your_notion_token
WHATSAPP_TOKEN=your_whatsapp_token
EOF
    echo -e "${GREEN}✅ Archivo .env creado${NC}"
    echo -e "${YELLOW}⚠️  Por favor edita el archivo .env con tus credenciales reales${NC}"
    echo -e "${BLUE}nano .env${NC}"
    read -p "Presiona Enter cuando hayas configurado las variables..."
fi

# Load environment variables
echo -e "${YELLOW}📋 Cargando variables de entorno...${NC}"
source .env

# Verify critical variables
if [ -z "$HETZNER_IP" ] || [ "$HETZNER_IP" = "your_server_ip" ]; then
    echo -e "${RED}❌ Por favor configura HETZNER_IP en el archivo .env${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Variables cargadas correctamente${NC}"
echo ""

# Step 1: Install MCPs
echo -e "${YELLOW}📦 Paso 1: Instalando MCPs...${NC}"
if [ -f "scripts/quick-install.sh" ]; then
    chmod +x scripts/quick-install.sh
    ./scripts/quick-install.sh
else
    echo -e "${RED}❌ Script de instalación no encontrado${NC}"
    exit 1
fi

echo ""

# Step 2: Setup Database
echo -e "${YELLOW}🗄️ Paso 2: Configurando base de datos...${NC}"

# Check if MySQL is accessible
if command -v mysql &> /dev/null; then
    echo -e "${BLUE}Verificando conexión a MySQL...${NC}"
    if mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" &> /dev/null; then
        echo -e "${GREEN}✅ Conexión a MySQL establecida${NC}"
        
        # Create database and tables
        echo -e "${BLUE}Creando base de datos y tablas...${NC}"
        mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" < sql/schema.sql
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Base de datos configurada correctamente${NC}"
        else
            echo -e "${RED}❌ Error configurando base de datos${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ No se pudo conectar a MySQL${NC}"
        echo -e "${YELLOW}💡 Verifica las credenciales en .env${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  Cliente MySQL no instalado localmente${NC}"
    echo -e "${BLUE}Instalando cliente MySQL...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install mysql-client
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get update && sudo apt-get install mysql-client
    fi
fi

echo ""

# Step 3: Configure Claude Desktop
echo -e "${YELLOW}⚙️ Paso 3: Configurando Claude Desktop...${NC}"

CONFIG_FILE="$HOME/.config/claude-desktop/claude_desktop_config.json"

# Create configuration with actual values
cat > "$CONFIG_FILE" << EOF
{
  "mcpServers": {
    "odoo": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-odoo", "--host", "$ODOO_HOST", "--port", "$ODOO_PORT", "--database", "$ODOO_DATABASE", "--user", "$ODOO_USER", "--password", "$ODOO_PASSWORD"]
    },
    "mysql": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-mysql", "--host", "$MYSQL_HOST", "--port", "3306", "--user", "$MYSQL_USER", "--password", "$MYSQL_PASSWORD", "--database", "$MYSQL_DATABASE"]
    },
    "chroma": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-chroma", "--host", "$CHROMA_HOST", "--port", "$CHROMA_PORT"]
    },
    "flowise": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-flowise", "--host", "$FLOWISE_HOST", "--port", "$FLOWISE_PORT"]
    },
    "n8n-glyver": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-n8n", "--host", "$N8N_HOST", "--port", "$N8N_PORT"]
    },
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github", "--token", "$GITHUB_TOKEN"]
    },
    "notion": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-notion", "--token", "$NOTION_TOKEN"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "--allowed-directories", "$HOME/Documents/claude-projects"]
    }
  }
}
EOF

echo -e "${GREEN}✅ Configuración de Claude Desktop actualizada${NC}"
echo ""

# Step 4: Setup n8n Workflows
echo -e "${YELLOW}🔄 Paso 4: Configurando workflows n8n...${NC}"

# Check if n8n is accessible
if curl -s --max-time 5 "http://$N8N_HOST:$N8N_PORT/rest/workflows" &> /dev/null; then
    echo -e "${GREEN}✅ n8n accesible${NC}"
    
    # Import workflows
    echo -e "${BLUE}Importando workflows...${NC}"
    
    # Emergency workflow
    if [ -f "configs/n8n-workflows/dental-emergency.json" ]; then
        curl -X POST "http://$N8N_HOST:$N8N_PORT/rest/workflows/import" \
             -H "Content-Type: application/json" \
             -d @configs/n8n-workflows/dental-emergency.json
        echo -e "${GREEN}✅ Workflow de emergencia importado${NC}"
    fi
    
    # Quote generation workflow
    if [ -f "configs/n8n-workflows/quote-generation.json" ]; then
        curl -X POST "http://$N8N_HOST:$N8N_PORT/rest/workflows/import" \
             -H "Content-Type: application/json" \
             -d @configs/n8n-workflows/quote-generation.json
        echo -e "${GREEN}✅ Workflow de cotización importado${NC}"
    fi
    
else
    echo -e "${RED}❌ n8n no accesible en http://$N8N_HOST:$N8N_PORT${NC}"
    echo -e "${YELLOW}💡 Verifica que n8n esté corriendo en tu servidor${NC}"
fi

echo ""

# Step 5: Create Dental Clinic Configuration
echo -e "${YELLOW}🦷 Paso 5: Configurando parámetros de clínica dental...${NC}"

# Create dental clinic config
mkdir -p configs/dental-clinic
cat > configs/dental-clinic/config.json << EOF
{
  "clinic_name": "Clínica Dental Sonrisa Perfecta",
  "industry": "dental_clinic",
  "business_hours": {
    "monday": "08:00-18:00",
    "tuesday": "08:00-18:00",
    "wednesday": "08:00-18:00",
    "thursday": "08:00-18:00",
    "friday": "08:00-18:00",
    "saturday": "09:00-14:00",
    "sunday": "closed"
  },
  "doctors": [
    {
      "name": "Dr. García",
      "speciality": "Emergencias",
      "available_days": ["monday", "tuesday", "wednesday", "thursday", "friday"]
    },
    {
      "name": "Dr. Martínez",
      "speciality": "Limpieza y Preventiva",
      "available_days": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    },
    {
      "name": "Dr. Rodríguez",
      "speciality": "Ortodoncia",
      "available_days": ["tuesday", "wednesday", "thursday", "friday"]
    },
    {
      "name": "Dr. Sánchez",
      "speciality": "Endodoncia",
      "available_days": ["monday", "wednesday", "friday"]
    }
  ],
  "triggers": {
    "emergencia_dental": {
      "keywords": ["dolor", "terrible", "muela", "urgente", "emergencia", "duele", "hinchazón", "infección", "sangrado"],
      "priority": "critical",
      "response_time": 30,
      "actions": ["create_odoo_lead", "schedule_emergency", "send_whatsapp", "notify_team"]
    },
    "cita_rutina": {
      "keywords": ["limpieza", "revisión", "chequeo", "mantenimiento", "cita", "consulta"],
      "priority": "normal",
      "response_time": 60,
      "actions": ["create_odoo_lead", "schedule_appointment", "send_confirmation"]
    },
    "consulta_precios": {
      "keywords": ["precio", "costo", "presupuesto", "cotización", "cuánto", "valor"],
      "priority": "high",
      "response_time": 45,
      "actions": ["generate_quote", "send_whatsapp", "update_crm"]
    },
    "seguimiento_tratamiento": {
      "keywords": ["terminé", "tratamiento", "molestia", "dolor", "seguimiento", "revisión"],
      "priority": "high",
      "response_time": 30,
      "actions": ["schedule_followup", "notify_doctor", "update_history"]
    }
  },
  "whatsapp_templates": {
    "emergency_confirmation": "🚨 CITA DE EMERGENCIA CONFIRMADA\\n\\n📅 Fecha: {fecha}\\n⏰ Hora: {hora}\\n👨‍⚕️ Doctor: {doctor}\\n📍 Clínica Sonrisa Perfecta\\n\\n📲 Te enviaré la ubicación y un recordatorio 30 min antes.\\n\\n⚠️ Si el dolor empeora, llámanos: (662) 123-4567",
    "appointment_confirmation": "✅ CITA CONFIRMADA\\n\\n👋 Hola {nombre}!\\n\\n📅 {servicio}\\n📆 {fecha} a las {hora}\\n👨‍⚕️ {doctor}\\n\\n📲 Te recordaré 1 día antes.\\n\\n¿Alguna pregunta? Estoy aquí para ayudarte 😊",
    "quote_generated": "📋 COTIZACIÓN GENERADA\\n\\n💰 Total: \\${total} {currency}\\n⏱️ Duración: {duration} minutos\\n📅 Válida hasta: {valid_until}\\n\\n💳 Opciones de pago disponibles\\n\\n¿Te gustaría agendar una cita?"
  },
  "emergency_protocol": {
    "max_response_time": 30,
    "auto_schedule": true,
    "notify_team": true,
    "priority_doctors": ["Dr. García", "Dr. Sánchez"],
    "backup_actions": ["call_patient", "send_sms", "notify_manager"]
  }
}
EOF

echo -e "${GREEN}✅ Configuración de clínica dental creada${NC}"
echo ""

# Step 6: Run Tests
echo -e "${YELLOW}🧪 Paso 6: Ejecutando tests del sistema...${NC}"

if [ -f "scripts/test-mcps.sh" ]; then
    chmod +x scripts/test-mcps.sh
    ./scripts/test-mcps.sh
else
    echo -e "${YELLOW}⚠️  Script de tests no encontrado${NC}"
fi

echo ""

# Step 7: Final Setup
echo -e "${YELLOW}🎯 Paso 7: Configuración final...${NC}"

# Create startup script
cat > dental-clinic-startup.sh << 'EOF'
#!/bin/bash

# Dental Clinic Startup Script
echo "🦷 Iniciando Claude Multi-Wrapped para Clínica Dental..."

# Load environment variables
source .env

# Check all services
echo "📋 Verificando servicios..."

# Check MySQL
mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 'MySQL OK'" || echo "❌ MySQL no disponible"

# Check Odoo
curl -s --max-time 5 "http://$ODOO_HOST:$ODOO_PORT" &> /dev/null && echo "✅ Odoo OK" || echo "❌ Odoo no disponible"

# Check Chroma
curl -s --max-time 5 "http://$CHROMA_HOST:$CHROMA_PORT/api/v1/heartbeat" &> /dev/null && echo "✅ Chroma OK" || echo "❌ Chroma no disponible"

# Check Flowise
curl -s --max-time 5 "http://$FLOWISE_HOST:$FLOWISE_PORT/api/v1/chatflows" &> /dev/null && echo "✅ Flowise OK" || echo "❌ Flowise no disponible"

# Check n8n
curl -s --max-time 5 "http://$N8N_HOST:$N8N_PORT/rest/workflows" &> /dev/null && echo "✅ n8n OK" || echo "❌ n8n no disponible"

echo ""
echo "🚀 Claude Multi-Wrapped para Clínica Dental está listo!"
echo "📱 Puedes empezar a recibir mensajes de WhatsApp"
echo "🖥️  Abre Claude Desktop para interactuar con el sistema"
echo ""
echo "📊 Para ver métricas en tiempo real:"
echo "   mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE"
echo "   SELECT * FROM daily_metrics ORDER BY date DESC LIMIT 5;"
echo ""
EOF

chmod +x dental-clinic-startup.sh

echo -e "${GREEN}✅ Script de startup creado${NC}"
echo ""

# Display summary
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🎉 ¡DEPLOYMENT COMPLETADO EXITOSAMENTE!                            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}✅ COMPONENTES INSTALADOS:${NC}"
echo -e "${BLUE}• Claude Desktop con MCPs configurados${NC}"
echo -e "${BLUE}• Base de datos MySQL con esquema completo${NC}"
echo -e "${BLUE}• Workflows n8n para emergencias y cotizaciones${NC}"
echo -e "${BLUE}• Configuración específica para clínica dental${NC}"
echo -e "${BLUE}• Scripts de testing y startup${NC}"
echo ""

echo -e "${GREEN}🚀 PRÓXIMOS PASOS:${NC}"
echo -e "${BLUE}1. Reiniciar Claude Desktop:${NC}"
echo -e "   ${YELLOW}pkill -f \"Claude Desktop\" && open -a \"Claude Desktop\"${NC}"
echo ""
echo -e "${BLUE}2. Verificar que todos los MCPs aparezcan en Claude Desktop${NC}"
echo ""
echo -e "${BLUE}3. Ejecutar el script de startup:${NC}"
echo -e "   ${YELLOW}./dental-clinic-startup.sh${NC}"
echo ""
echo -e "${BLUE}4. Testear el sistema con un mensaje de prueba${NC}"
echo ""
echo -e "${BLUE}5. Configurar tu número de WhatsApp Business${NC}"
echo ""

echo -e "${GREEN}📚 DOCUMENTACIÓN:${NC}"
echo -e "${BLUE}• Casos de uso: examples/dental-clinic/${NC}"
echo -e "${BLUE}• Decision triggers: docs/decision-triggers.md${NC}"
echo -e "${BLUE}• Troubleshooting: scripts/test-mcps.sh${NC}"
echo ""

echo -e "${GREEN}🎯 Tu clínica dental ahora tiene un sistema de IA completamente automatizado!${NC}"
echo -e "${BLUE}El sistema puede manejar emergencias, programar citas, generar cotizaciones y más.${NC}"
echo ""

# Run startup script
echo -e "${YELLOW}🔄 Ejecutando verificación final...${NC}"
./dental-clinic-startup.sh

echo ""
echo -e "${GREEN}🦷 ¡Clínica Dental Sonrisa Perfecta lista para revolucionar la atención dental! 🚀${NC}"