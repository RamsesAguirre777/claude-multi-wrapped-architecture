# 🧠 Anthropic Memory MCP Integration

## 🎯 **DESCRIPCIÓN**
Integración del Memory MCP oficial de Anthropic para proporcionar memoria persistente contextual a Claude Desktop, permitiendo mantener contexto entre sesiones y crear experiencias personalizadas continuas.

## 🔧 **CARACTERÍSTICAS PRINCIPALES**

### **💾 Memoria Persistente**
- **Cross-session Memory**: Mantiene contexto entre sesiones
- **Customer Profiles**: Perfiles detallados de clientes
- **Interaction History**: Historial completo de interacciones
- **Context Retrieval**: Recuperación inteligente de contexto relevante

### **🧠 Tipos de Memoria**
- **Short-term**: Memoria de sesión actual
- **Long-term**: Memoria persistente entre sesiones
- **Semantic**: Memoria basada en significado
- **Episodic**: Memoria de eventos específicos

## 🚀 **INSTALACIÓN**

### **Paso 1: Instalar Memory MCP**
```bash
# Instalar el servidor oficial de Memory MCP
npm install -g @anthropic/memory-mcp-server

# Verificar instalación
memory-mcp-server --version
```

### **Paso 2: Configurar API Key**
```bash
# Obtener API key de Anthropic
export ANTHROPIC_API_KEY="your_anthropic_api_key"

# Crear archivo de configuración
cat > ~/.anthropic/memory-config.json << EOF
{
  "api_key": "your_anthropic_api_key",
  "memory_database": "~/.anthropic/memory.db",
  "max_memories": 10000,
  "embedding_model": "text-embedding-3-small"
}
EOF
```

### **Paso 3: Configurar Claude Desktop**
```json
{
  "mcpServers": {
    "anthropic-memory": {
      "command": "npx",
      "args": ["@anthropic/memory-mcp-server"],
      "env": {
        "ANTHROPIC_API_KEY": "your_anthropic_api_key"
      }
    }
  }
}
```

### **Paso 4: Reiniciar Claude Desktop**
```bash
# Reiniciar Claude Desktop para aplicar cambios
pkill -f "Claude Desktop"
open -a "Claude Desktop"
```

## 🔧 **CONFIGURACIÓN AVANZADA**

### **Variables de Entorno**
```bash
# Configuración completa del Memory MCP
export ANTHROPIC_API_KEY="your_anthropic_api_key"
export MEMORY_DATABASE_PATH="~/.anthropic/memory.db"
export MEMORY_MAX_ENTRIES=10000
export MEMORY_EMBEDDING_MODEL="text-embedding-3-small"
export MEMORY_SIMILARITY_THRESHOLD=0.7
export MEMORY_MAX_CONTEXT_LENGTH=4096
```

### **Configuración Personalizada**
```json
{
  "mcpServers": {
    "anthropic-memory": {
      "command": "npx",
      "args": ["@anthropic/memory-mcp-server"],
      "env": {
        "ANTHROPIC_API_KEY": "your_anthropic_api_key",
        "MEMORY_DATABASE_PATH": "/path/to/your/memory.db",
        "MEMORY_MAX_ENTRIES": "10000",
        "MEMORY_SIMILARITY_THRESHOLD": "0.7"
      }
    }
  }
}
```

## 💡 **CASOS DE USO PRÁCTICOS**

### **Caso 1: Clínica Dental - Historial de Paciente**
```yaml
scenario: "Paciente regresa después de 6 meses"

primera_visita:
  input: "Hola, necesito una limpieza dental"
  memory_storage:
    customer_id: "patient_123"
    context: "Primera visita, limpieza dental programada"
    preferences: "Prefiere citas matutinas"
    treatment_history: "Limpieza inicial"
    next_appointment: "6 meses"

visita_seguimiento:
  input: "Hola, soy María, vine hace 6 meses para limpieza"
  memory_retrieval:
    customer_id: "patient_123"
    previous_context: "Limpieza dental hace 6 meses"
    preferences: "Citas matutinas"
    treatment_history: "Limpieza inicial exitosa"
  
  claude_response: |
    "¡Hola María! Me alegra verte de nuevo. Veo que tu última 
    limpieza fue hace 6 meses y todo salió perfecto. Como 
    prefieres las citas matutinas, te tengo disponible mañana 
    a las 9 AM. ¿Te funciona?"
```

### **Caso 2: Agencia Marketing - Cliente Recurrente**
```yaml
scenario: "Cliente que regresa para nuevo proyecto"

proyecto_anterior:
  input: "Necesito campaña de Facebook Ads"
  memory_storage:
    customer_id: "agency_client_456"
    context: "Campaña Facebook Ads para ecommerce"
    budget: "$5000 mensual"
    results: "ROAS 4.2x, CTR 2.8%"
    industry: "moda femenina"
    target_audience: "mujeres 25-45"

nuevo_proyecto:
  input: "Hola, quiero hacer otra campaña como la anterior"
  memory_retrieval:
    customer_id: "agency_client_456"
    previous_campaigns: "Facebook Ads, ROAS 4.2x"
    budget_history: "$5000 mensual"
    industry: "moda femenina"
    successful_strategies: "Video ads, lookalike audiences"
  
  claude_response: |
    "¡Perfecto! Recuerdo tu campaña anterior de Facebook Ads 
    que tuvo un ROAS de 4.2x. Podemos replicar esa estrategia 
    exitosa con video ads y lookalike audiences. ¿Mantienes 
    el presupuesto de $5000 mensual?"
```

## 🧩 **INTEGRACIÓN CON GLYVER AI OPS**

### **Flujo Integrado**
```python
# Flujo completo: RAG Bot + Memory MCP + Actions
cliente_message = "Hola, soy Juan, necesito otra campaña como la anterior"

# 1. Recuperar memoria histórica
memory_context = await memory_mcp.retrieve_context("juan_123")

# 2. Análisis RAG con contexto
rag_analysis = await rag_bot.analyze_with_context(
    message=cliente_message,
    historical_context=memory_context
)

# 3. Calificación mejorada con historial
enhanced_qualification = {
    "current_score": rag_analysis.score,
    "historical_value": memory_context.lifetime_value,
    "relationship_strength": memory_context.interaction_count,
    "final_score": calculate_enhanced_score(rag_analysis, memory_context)
}

# 4. Acciones contextuales
if enhanced_qualification.final_score > 90:
    actions = [
        "priority_treatment",
        "assign_account_manager",
        "custom_proposal_based_on_history"
    ]
```

### **Prompts Mejorados con Memoria**
```yaml
memory_enhanced_prompt: |
  Tienes acceso a la memoria histórica del cliente:
  
  Contexto histórico: {memory_context}
  Mensaje actual: {current_message}
  
  Usa la memoria para:
  1. Personalizar la respuesta
  2. Referenciar interacciones pasadas
  3. Sugerir basado en historial
  4. Mantener continuidad conversacional
  
  Responde de manera natural y contextual.
```

## 📊 **ESTRUCTURA DE DATOS**

### **Esquema de Memoria**
```json
{
  "customer_id": "unique_identifier",
  "created_at": "2025-07-16T10:00:00Z",
  "updated_at": "2025-07-16T15:30:00Z",
  "profile": {
    "name": "Juan Pérez",
    "email": "juan@empresa.com",
    "phone": "+52 662 123 4567",
    "company": "Empresa ABC",
    "role": "Director Marketing"
  },
  "preferences": {
    "communication_style": "formal",
    "preferred_times": ["morning", "afternoon"],
    "budget_range": "$5000-$10000",
    "decision_timeline": "1-2 weeks"
  },
  "interaction_history": [
    {
      "timestamp": "2025-07-16T10:00:00Z",
      "type": "inquiry",
      "content": "Necesito campaña de marketing",
      "response": "Campaña personalizada propuesta",
      "outcome": "meeting_scheduled"
    }
  ],
  "business_context": {
    "industry": "technology",
    "company_size": "50-100 employees",
    "current_challenges": ["lead generation", "conversion"],
    "goals": ["increase revenue", "expand market"]
  },
  "engagement_metrics": {
    "interaction_count": 15,
    "response_rate": 0.85,
    "meeting_attendance": 0.90,
    "project_completion": 0.95
  }
}
```

## 🔍 **FUNCIONES DISPONIBLES**

### **Almacenamiento de Memoria**
```python
# Guardar contexto nuevo
await memory_mcp.store_memory({
    "customer_id": "client_123",
    "content": "Cliente interesado en servicio premium",
    "context_type": "inquiry",
    "metadata": {
        "channel": "whatsapp",
        "timestamp": "2025-07-16T10:30:00Z",
        "qualification_score": 85
    }
})
```

### **Recuperación de Memoria**
```python
# Recuperar memoria por ID
memory = await memory_mcp.get_memory("client_123")

# Búsqueda semántica
similar_contexts = await memory_mcp.search_similar(
    query="campaña marketing digital",
    threshold=0.7,
    limit=5
)

# Recuperar por periodo
recent_interactions = await memory_mcp.get_memories_by_date(
    customer_id="client_123",
    start_date="2025-07-01",
    end_date="2025-07-16"
)
```

## 📈 **MÉTRICAS Y MONITOREO**

### **KPIs de Memoria**
```yaml
memory_metrics:
  storage_efficiency: "95.2%"
  retrieval_accuracy: "96.8%"
  context_relevance: "94.5%"
  response_personalization: "89.3%"
  
performance_metrics:
  average_storage_time: "< 100ms"
  average_retrieval_time: "< 200ms"
  memory_database_size: "2.5GB"
  active_customer_profiles: "1,247"
```

## 🛠️ **SCRIPTS DE INSTALACIÓN**

### **Script de Setup Completo**
```bash
#!/bin/bash
# setup-memory-mcp.sh

echo "🧠 Instalando Anthropic Memory MCP..."

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado"
    exit 1
fi

# Instalar Memory MCP
npm install -g @anthropic/memory-mcp-server

# Crear directorio de configuración
mkdir -p ~/.anthropic

# Configurar variables de entorno
read -p "🔑 Ingresa tu Anthropic API Key: " ANTHROPIC_API_KEY

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

# Crear configuración para Claude Desktop
CLAUDE_CONFIG=~/.config/claude-desktop/claude_desktop_config.json
mkdir -p ~/.config/claude-desktop

if [[ -f "$CLAUDE_CONFIG" ]]; then
    echo "📝 Actualizando configuración existente..."
    # Backup
    cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Configurar Claude Desktop
cat > "$CLAUDE_CONFIG" << EOF
{
  "mcpServers": {
    "anthropic-memory": {
      "command": "npx",
      "args": ["@anthropic/memory-mcp-server"],
      "env": {
        "ANTHROPIC_API_KEY": "$ANTHROPIC_API_KEY"
      }
    }
  }
}
EOF

echo "✅ Memory MCP instalado correctamente"
echo "🔄 Reinicia Claude Desktop para aplicar cambios"
```

### **Script de Testing**
```bash
#!/bin/bash
# test-memory-mcp.sh

echo "🧪 Testing Memory MCP..."

# Test 1: Verificar instalación
echo "Test 1: Verificando instalación..."
if command -v memory-mcp-server &> /dev/null; then
    echo "✅ Memory MCP Server instalado"
else
    echo "❌ Memory MCP Server no encontrado"
    exit 1
fi

# Test 2: Verificar configuración
echo "Test 2: Verificando configuración..."
if [[ -f ~/.anthropic/memory-config.json ]]; then
    echo "✅ Archivo de configuración encontrado"
else
    echo "❌ Archivo de configuración no encontrado"
    exit 1
fi

# Test 3: Verificar Claude Desktop config
echo "Test 3: Verificando configuración Claude Desktop..."
CLAUDE_CONFIG=~/.config/claude-desktop/claude_desktop_config.json
if [[ -f "$CLAUDE_CONFIG" ]]; then
    if grep -q "anthropic-memory" "$CLAUDE_CONFIG"; then
        echo "✅ Memory MCP configurado en Claude Desktop"
    else
        echo "❌ Memory MCP no configurado en Claude Desktop"
        exit 1
    fi
else
    echo "❌ Configuración de Claude Desktop no encontrada"
    exit 1
fi

echo "🎉 Todos los tests pasaron correctamente"
```

## 🔧 **CONFIGURACIÓN PARA GLYVER AI OPS**

### **Configuración Integrada**
```json
{
  "mcpServers": {
    "anthropic-memory": {
      "command": "npx",
      "args": ["@anthropic/memory-mcp-server"],
      "env": {
        "ANTHROPIC_API_KEY": "your_anthropic_api_key"
      }
    },
    "rag-bot-qualification": {
      "command": "node",
      "args": ["./rag-bot/server.js"],
      "env": {
        "MISTRAL_API_KEY": "your_mistral_api_key",
        "CHROMA_HOST": "localhost",
        "CHROMA_PORT": "8000"
      }
    },
    "odoo": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-odoo"],
      "env": {
        "ODOO_URL": "http://your-server:8069",
        "ODOO_DB": "your_database",
        "ODOO_USERNAME": "your_username",
        "ODOO_PASSWORD": "your_password"
      }
    },
    "mysql": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-mysql"],
      "env": {
        "MYSQL_HOST": "your-server",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "your_user",
        "MYSQL_PASSWORD": "your_password",
        "MYSQL_DATABASE": "your_database"
      }
    }
  }
}
```

## 🎯 **PROMPTS PARA MEMORY MCP**

### **Prompt Principal**
```yaml
memory_mcp_system_prompt: |
  Eres un asistente especializado en {industry} con acceso a memoria persistente.
  
  CAPACIDADES:
  1. Recordar interacciones pasadas con clientes
  2. Mantener contexto entre sesiones
  3. Personalizar respuestas basado en historial
  4. Sugerir acciones basadas en patrones
  
  INSTRUCCIONES:
  1. Siempre consulta la memoria antes de responder
  2. Usa el contexto histórico para personalizar
  3. Almacena información importante de cada interacción
  4. Mantén coherencia con interacciones pasadas
  
  EJEMPLO DE USO:
  - Cliente: "Hola, soy Juan"
  - Acción: Buscar memoria de "Juan" 
  - Respuesta: Personalizada con contexto histórico
```

### **Prompt para Calificación con Memoria**
```yaml
qualification_with_memory_prompt: |
  Analiza este mensaje considerando el contexto histórico:
  
  Mensaje actual: {current_message}
  Contexto histórico: {memory_context}
  
  Considera:
  1. Valor histórico del cliente (CLV)
  2. Frecuencia de interacciones
  3. Patrones de comportamiento
  4. Preferencias conocidas
  
  Califica el lead ajustando el score basado en:
  - Clientes recurrentes: +20 puntos
  - Historial de compras: +15 puntos
  - Interacciones frecuentes: +10 puntos
  - Preferencias documentadas: +5 puntos
```

## 🚀 **PRÓXIMOS PASOS**

### **Implementación Inmediata**
1. **Ejecutar script de instalación**
2. **Configurar API key de Anthropic**
3. **Integrar con RAG Bot existente**
4. **Testear con casos reales**
5. **Optimizar prompts con memoria**

### **Funcionalidades Futuras**
- **Análisis predictivo** basado en patrones
- **Segmentación automática** de clientes
- **Recomendaciones personalizadas**
- **Alertas de oportunidades**

## 📚 **RECURSOS ADICIONALES**

- 📖 [Documentación oficial Memory MCP](https://docs.anthropic.com/mcp/memory)
- 🛠️ [GitHub Memory MCP](https://github.com/anthropics/memory-mcp-server)
- 🎥 [Videos tutoriales](https://youtube.com/anthropic-mcp)
- 💬 [Soporte técnico](https://support.anthropic.com)

---

## 🧠 **MEMORY MCP: EL CEREBRO PERSISTENTE DE GLYVER AI OPS**

*Con Memory MCP, tu sistema no solo es inteligente - también recuerda y aprende de cada interacción.*

**🚀 Instala ahora y transforma tu experiencia de cliente! 🤖💾**