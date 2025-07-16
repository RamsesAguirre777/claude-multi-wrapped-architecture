# 🚀 Configuración Rápida - Claude Multi-Wrapped Architecture

## ⚡ **Setup en 15 Minutos**

### **1. Prerrequisitos (5 min)**
```bash
# Verificar instalaciones
node --version  # v18+
npm --version   # v9+
python --version # v3.8+

# Verificar Claude Desktop
ls ~/.config/claude-desktop/
```

### **2. Instalar MCPs Core (5 min)**
```bash
# Script de instalación rápida
curl -fsSL https://raw.githubusercontent.com/RamsesAguirre777/claude-multi-wrapped-architecture/main/scripts/quick-install.sh | bash
```

### **3. Configurar Variables (5 min)**
```bash
# Copiar archivo de configuración
cp configs/claude-desktop-config.template.json ~/.config/claude-desktop/claude_desktop_config.json

# Editar con tus credenciales
nano ~/.config/claude-desktop/claude_desktop_config.json
```

## 🔧 **Configuración de Producción**

### **Variables de Entorno**
```bash
# Crear archivo .env
cat > .env << 'EOF'
# Hetzner Server
HETZNER_IP=your_server_ip
MYSQL_HOST=${HETZNER_IP}
MYSQL_USER=your_mysql_user
MYSQL_PASSWORD=your_mysql_password
MYSQL_DATABASE=claude_multiwrapped

# Odoo
ODOO_HOST=${HETZNER_IP}
ODOO_PORT=8069
ODOO_DATABASE=your_odoo_db
ODOO_USER=your_odoo_user
ODOO_PASSWORD=your_odoo_password

# Chroma
CHROMA_HOST=${HETZNER_IP}
CHROMA_PORT=8000

# Flowise
FLOWISE_HOST=${HETZNER_IP}
FLOWISE_PORT=3000

# n8n
N8N_HOST=${HETZNER_IP}
N8N_PORT=5678

# API Keys
MISTRAL_API_KEY=your_mistral_key
GITHUB_TOKEN=your_github_token
NOTION_TOKEN=your_notion_token
WHATSAPP_TOKEN=your_whatsapp_token
EOF
```

### **Configuración Claude Desktop**
```json
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
      "args": ["@modelcontextprotocol/server-filesystem", "--allowed-directories", "/Users/$USER/Documents/claude-projects"]
    }
  }
}
```

## 🎯 **Configuración por Industria**

### **Clínica Dental**
```json
{
  "industry": "dental_clinic",
  "triggers": [
    "emergencia_dental",
    "cita_rutina",
    "consulta_precios",
    "seguimiento_tratamiento"
  ],
  "schedules": {
    "emergency": 30,
    "routine": 60,
    "consultation": 45
  },
  "doctors": [
    {"name": "Dr. García", "speciality": "emergencias"},
    {"name": "Dr. Martínez", "speciality": "limpieza"},
    {"name": "Dr. Rodríguez", "speciality": "ortodoncia"}
  ]
}
```

### **Agencia de Marketing**
```json
{
  "industry": "marketing_agency",
  "triggers": [
    "lead_calificado",
    "solicitud_propuesta",
    "consulta_presupuesto",
    "seguimiento_comercial"
  ],
  "services": [
    {"name": "SEO", "duration": "3-6 meses"},
    {"name": "SEM", "duration": "ongoing"},
    {"name": "Social Media", "duration": "monthly"}
  ],
  "budget_ranges": [
    {"min": 5000, "max": 15000, "category": "small"},
    {"min": 15000, "max": 50000, "category": "medium"},
    {"min": 50000, "max": 200000, "category": "large"}
  ]
}
```

## 📊 **Base de Datos MySQL**

### **Tablas Principales**
```sql
-- Tabla de logs de triggers
CREATE TABLE trigger_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trigger_name VARCHAR(100) NOT NULL,
    lead_id INT,
    client_phone VARCHAR(20),
    message TEXT,
    keywords_matched JSON,
    actions_executed JSON,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_time_ms INT,
    success BOOLEAN DEFAULT TRUE,
    error_message TEXT,
    INDEX idx_trigger_name (trigger_name),
    INDEX idx_execution_time (execution_time)
);

-- Tabla de conversaciones
CREATE TABLE conversations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(100) NOT NULL,
    client_phone VARCHAR(20),
    message TEXT,
    response TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    industry VARCHAR(50),
    trigger_activated VARCHAR(100),
    lead_id INT,
    INDEX idx_client_id (client_id),
    INDEX idx_timestamp (timestamp)
);

-- Tabla de métricas diarias
CREATE TABLE daily_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    industry VARCHAR(50),
    total_conversations INT DEFAULT 0,
    triggers_executed INT DEFAULT 0,
    leads_created INT DEFAULT 0,
    appointments_scheduled INT DEFAULT 0,
    quotes_generated INT DEFAULT 0,
    conversion_rate DECIMAL(5,2),
    avg_response_time_ms INT,
    customer_satisfaction DECIMAL(3,2),
    UNIQUE KEY unique_date_industry (date, industry)
);

-- Tabla de servicios y precios
CREATE TABLE service_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    industry VARCHAR(50),
    service_type VARCHAR(100),
    service_name VARCHAR(200),
    base_price DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'MXN',
    duration_minutes INT,
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    INDEX idx_industry_service (industry, service_type)
);

-- Insertar datos iniciales para clínica dental
INSERT INTO service_prices (industry, service_type, service_name, base_price, duration_minutes, description) VALUES
('dental_clinic', 'emergency', 'Consulta de emergencia', 800.00, 30, 'Atención urgente para dolor dental'),
('dental_clinic', 'routine', 'Limpieza dental', 1200.00, 60, 'Limpieza completa con flúor'),
('dental_clinic', 'orthodontics', 'Consulta ortodoncia', 800.00, 45, 'Evaluación para brackets'),
('dental_clinic', 'orthodontics', 'Tratamiento ortodoncia completa', 28000.00, 0, 'Brackets metálicos 18-24 meses'),
('dental_clinic', 'implants', 'Implante dental', 15000.00, 90, 'Implante con corona'),
('dental_clinic', 'endodontics', 'Tratamiento de conducto', 4500.00, 90, 'Endodoncia completa');
```

## 🚨 **Troubleshooting Rápido**

### **Problemas Comunes**

1. **Claude Desktop no ve los MCPs**
   ```bash
   # Verificar configuración
   cat ~/.config/claude-desktop/claude_desktop_config.json
   
   # Verificar instalación
   npm list -g | grep modelcontextprotocol
   
   # Reiniciar Claude Desktop
   pkill -f "Claude Desktop"
   ```

2. **Error de conexión a servidor**
   ```bash
   # Verificar conectividad
   ping $HETZNER_IP
   
   # Verificar puertos
   nmap -p 3306,8069,8000,3000,5678 $HETZNER_IP
   
   # Verificar logs
   tail -f /var/log/mysql/error.log
   ```

3. **Triggers no se ejecutan**
   ```bash
   # Verificar logs en MySQL
   SELECT * FROM trigger_logs ORDER BY execution_time DESC LIMIT 10;
   
   # Verificar keywords
   SELECT DISTINCT keywords_matched FROM trigger_logs;
   ```

## 🚀 **Próximos Pasos**

1. **Configurar entorno de desarrollo**
   ```bash
   git clone https://github.com/RamsesAguirre777/claude-multi-wrapped-architecture.git
   cd claude-multi-wrapped-architecture
   ./scripts/dev-setup.sh
   ```

2. **Testear configuración**
   ```bash
   ./scripts/test-mcps.sh
   ```

3. **Implementar caso de uso específico**
   ```bash
   # Para clínica dental
   ./scripts/deploy-dental-clinic.sh
   
   # Para agencia de marketing
   ./scripts/deploy-marketing-agency.sh
   ```

## 📞 **Soporte**

- **Documentación**: [docs/](docs/)
- **Ejemplos**: [examples/](examples/)
- **Issues**: [GitHub Issues](https://github.com/RamsesAguirre777/claude-multi-wrapped-architecture/issues)

---

¡Tu sistema Claude Multi-Wrapped está listo para revolucionar la automatización inteligente! 🎯🚀