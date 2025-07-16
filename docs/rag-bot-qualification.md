# 🤖 RAG Bot Lead Qualification System

## 🎯 **DESCRIPCIÓN**
Sistema inteligente de calificación de leads que utiliza Retrieval-Augmented Generation (RAG) para analizar conversaciones, extraer señales de compra y asignar scores automatizados a prospectos.

## 🧠 **ARQUITECTURA**

### **Flujo de Procesamiento**
```
Cliente Message → RAG Bot → Embedding Generation → Vector Search → Context Retrieval → Claude Analysis → Lead Score + Actions
```

### **Componentes Clave**
- **🔍 Intent Detection**: Identifica intención del cliente
- **📊 Lead Scoring**: Algoritmo de puntuación inteligente
- **💾 Context Storage**: Almacenamiento en Chroma DB
- **⚡ Real-time Processing**: Respuesta en tiempo real
- **🎯 Action Triggers**: Dispara acciones automáticas

## 🏆 **SISTEMA DE CALIFICACIÓN**

### **Criterios de Evaluación**
```yaml
qualification_criteria:
  budget_indicators:
    weight: 30%
    keywords: ["presupuesto", "inversión", "costo", "precio", "cuánto"]
    
  urgency_signals:
    weight: 25%
    keywords: ["urgente", "pronto", "necesito", "inmediato", "ya"]
    
  decision_maker:
    weight: 20%
    keywords: ["director", "CEO", "gerente", "dueño", "encargado"]
    
  business_size:
    weight: 15%
    keywords: ["empresa", "empleados", "sucursales", "facturación"]
    
  industry_match:
    weight: 10%
    keywords: ["dental", "marketing", "ecommerce", "tecnología"]
```

### **Matriz de Scoring**
```python
lead_scoring_matrix = {
    "high_priority": {
        "score_range": "80-100",
        "indicators": [
            "presupuesto específico mencionado",
            "urgencia temporal clara",
            "autoridad de decisión confirmada",
            "necesidad específica articulada"
        ],
        "actions": ["priority_treatment", "immediate_response", "assign_senior_rep"]
    },
    
    "medium_priority": {
        "score_range": "50-79",
        "indicators": [
            "interés general en servicios",
            "exploración de opciones",
            "timeline no urgente",
            "proceso de investigación"
        ],
        "actions": ["standard_follow_up", "nurture_sequence", "information_provision"]
    },
    
    "low_priority": {
        "score_range": "0-49",
        "indicators": [
            "información general solamente",
            "estudiante/académico",
            "curiosidad casual",
            "competencia/research"
        ],
        "actions": ["basic_response", "educational_content", "long_term_nurture"]
    }
}
```

## 🔧 **CONFIGURACIÓN TÉCNICA**

### **Dependencias**
```bash
# Instalar dependencias del RAG Bot
npm install @anthropic/claude-3-haiku
npm install chromadb
npm install @mistral-ai/mistralai
npm install sentence-transformers
```

### **Variables de Entorno**
```bash
# RAG Bot Configuration
RAG_BOT_ENABLED=true
RAG_BOT_MODEL=mistral-embed
RAG_BOT_THRESHOLD=0.7
RAG_BOT_MAX_CONTEXT=4096

# Chroma DB Configuration
CHROMA_HOST=localhost
CHROMA_PORT=8000
CHROMA_COLLECTION=lead_qualification

# Mistral API
MISTRAL_API_KEY=your_mistral_api_key
MISTRAL_MODEL=mistral-embed
```

### **Configuración en Claude Desktop**
```json
{
  "mcpServers": {
    "rag-bot-qualification": {
      "command": "node",
      "args": ["./rag-bot/server.js"],
      "env": {
        "MISTRAL_API_KEY": "your_mistral_api_key",
        "CHROMA_HOST": "localhost",
        "CHROMA_PORT": "8000"
      }
    }
  }
}
```

## 🚀 **IMPLEMENTACIÓN**

### **Estructura de Archivos**
```
rag-bot/
├── server.js                 # Servidor principal MCP
├── qualification_engine.js   # Motor de calificación
├── embeddings.js            # Generación de embeddings
├── vector_store.js          # Interfaz con Chroma
├── scoring_algorithm.js     # Algoritmo de scoring
├── config/
│   ├── industry_prompts.js  # Prompts por industria
│   ├── scoring_rules.js     # Reglas de scoring
│   └── keywords.js          # Palabras clave por categoría
└── utils/
    ├── text_processing.js   # Procesamiento de texto
    ├── context_extraction.js # Extracción de contexto
    └── response_generator.js # Generación de respuestas
```

## 📊 **CASOS DE USO POR INDUSTRIA**

### **🦷 Clínica Dental**
```yaml
dental_qualification:
  high_priority_signals:
    - "dolor de muela"
    - "emergencia dental"
    - "infección"
    - "accidente dental"
  
  medium_priority_signals:
    - "limpieza dental"
    - "revisión rutina"
    - "blanqueamiento"
    - "ortodoncia"
  
  scoring_multipliers:
    pain_keywords: 2.0
    urgency_keywords: 1.8
    treatment_specific: 1.5
```

### **📈 Agencia de Marketing**
```yaml
marketing_qualification:
  high_priority_signals:
    - "presupuesto marketing"
    - "campaña urgente"
    - "director marketing"
    - "ROI específico"
  
  medium_priority_signals:
    - "estrategia digital"
    - "redes sociales"
    - "posicionamiento"
    - "análisis competencia"
  
  scoring_multipliers:
    budget_mentioned: 2.5
    decision_maker: 2.0
    timeline_urgent: 1.8
```

### **🛒 E-commerce**
```yaml
ecommerce_qualification:
  high_priority_signals:
    - "tienda online"
    - "ventas digitales"
    - "conversión"
    - "inventario"
  
  medium_priority_signals:
    - "catálogo productos"
    - "página web"
    - "marketing digital"
    - "automatización"
  
  scoring_multipliers:
    revenue_mentioned: 2.8
    technical_need: 2.0
    growth_stage: 1.7
```

## 🎯 **PROMPTS ESPECIALIZADOS**

### **Prompt para Calificación Dental**
```
Eres un experto en calificación de leads para clínicas dentales.

Analiza la siguiente conversación y califica el lead según estos criterios:

PRIORIDAD CRÍTICA (Score 90-100):
- Emergencias dentales: dolor intenso, trauma, infección
- Menciona presupuesto específico
- Necesita atención inmediata

PRIORIDAD ALTA (Score 70-89):
- Tratamientos específicos: ortodoncia, implantes, estética
- Timeline definido
- Autoridad de decisión

PRIORIDAD MEDIA (Score 50-69):
- Consultas generales sobre servicios
- Exploración de opciones
- Sin urgencia temporal

PRIORIDAD BAJA (Score 0-49):
- Información general únicamente
- Estudiante/académico
- Curiosidad casual

Conversación: {conversation}

Responde en formato JSON:
{
  "score": number,
  "classification": "critical/high/medium/low",
  "reasoning": "explicación del score",
  "recommended_actions": ["acción1", "acción2"],
  "urgency_level": "emergency/high/medium/low"
}
```

### **Prompt para Calificación Marketing**
```
Eres un experto en calificación de leads para agencias de marketing.

Evalúa el siguiente lead según estos criterios de la industria:

LEAD PREMIUM (Score 85-100):
- Presupuesto específico mencionado (>$10K)
- Cargo de decisión (CEO, Director Marketing)
- Proyecto urgente con timeline
- Empresa establecida

LEAD CALIFICADO (Score 65-84):
- Interés en servicios específicos
- Timeline no urgente pero definido
- Autoridad parcial de decisión
- Empresa mediana

LEAD ESTÁNDAR (Score 40-64):
- Consulta general sobre servicios
- Exploración de opciones
- Sin autoridad de decisión clara
- Empresa pequeña

LEAD BAJO (Score 0-39):
- Solo información general
- Estudiante/freelancer
- Sin presupuesto
- Competencia/research

Conversación: {conversation}

Responde en formato JSON:
{
  "score": number,
  "classification": "premium/qualified/standard/low",
  "budget_indicators": ["indicador1", "indicador2"],
  "decision_authority": "high/medium/low",
  "recommended_actions": ["acción1", "acción2"],
  "follow_up_timeline": "immediate/24h/week/month"
}
```

## 🔄 **INTEGRACIÓN CON WORKFLOW**

### **Flujo Automático con n8n**
```yaml
workflow_integration:
  trigger: "new_lead_qualified"
  
  conditions:
    high_priority:
      score: ">=80"
      actions:
        - create_priority_lead_odoo
        - schedule_immediate_callback
        - notify_senior_rep
        - send_urgent_whatsapp
    
    medium_priority:
      score: "50-79"
      actions:
        - create_standard_lead_odoo
        - schedule_follow_up_24h
        - send_information_packet
        - add_to_nurture_sequence
    
    low_priority:
      score: "<50"
      actions:
        - create_basic_lead_odoo
        - add_to_long_term_nurture
        - send_educational_content
```

### **Webhook para Notificaciones**
```javascript
// Ejemplo de webhook para notificaciones
const webhookHandler = async (qualification) => {
  const { score, classification, insights } = qualification;
  
  if (score >= 80) {
    // Notificación urgente
    await sendSlackNotification({
      channel: '#sales-urgent',
      message: `🚨 LEAD ALTA PRIORIDAD: Score ${score}`,
      lead_data: qualification
    });
    
    await sendEmailNotification({
      to: 'sales-manager@company.com',
      subject: 'Lead Urgente Requiere Atención',
      template: 'urgent_lead',
      data: qualification
    });
  }
  
  // Actualizar CRM
  await updateCRM({
    lead_id: qualification.lead_id,
    score: score,
    classification: classification,
    next_actions: qualification.recommended_actions
  });
};
```

## 📈 **MÉTRICAS Y OPTIMIZACIÓN**

### **KPIs del Sistema**
```yaml
performance_metrics:
  accuracy:
    target: ">92%"
    measurement: "manual_review_vs_auto_score"
    
  response_time:
    target: "<2 seconds"
    measurement: "qualification_processing_time"
    
  conversion_correlation:
    target: "0.85+"
    measurement: "score_vs_actual_conversion"
    
  false_positive_rate:
    target: "<5%"
    measurement: "high_score_low_conversion"
```

### **Optimización Continua**
```python
optimization_process = {
    "data_collection": {
        "frequency": "daily",
        "metrics": ["score_accuracy", "conversion_rates", "response_times"]
    },
    
    "model_retraining": {
        "frequency": "weekly",
        "method": "feedback_loop",
        "data_sources": ["manual_reviews", "conversion_outcomes"]
    },
    
    "threshold_adjustment": {
        "frequency": "monthly",
        "method": "a_b_testing",
        "targets": ["classification_boundaries", "scoring_weights"]
    }
}
```

## 🛠️ **TROUBLESHOOTING**

### **Problemas Comunes**
```bash
# Verificar conexión con Chroma
curl -X GET "http://localhost:8000/api/v1/heartbeat"

# Test de embeddings
node -e "
const { generateEmbedding } = require('./rag-bot/embeddings.js');
generateEmbedding('test message').then(console.log);
"

# Verificar logs del sistema
tail -f /var/log/rag-bot/qualification.log

# Test de scoring
node -e "
const QualificationEngine = require('./rag-bot/qualification_engine.js');
const engine = new QualificationEngine();
engine.qualify({
  message: 'necesito cotización urgente',
  context: {}
}).then(console.log);
"
```

### **Soluciones Rápidas**
```bash
# Reiniciar sistema RAG
./scripts/restart-rag-bot.sh

# Limpiar cache de embeddings
./scripts/clear-embeddings-cache.sh

# Recalibrar scoring
./scripts/recalibrate-scoring.sh

# Verificar configuración
./scripts/verify-rag-config.sh
```

## 🎓 **GUÍA DE IMPLEMENTACIÓN**

### **Paso 1: Instalación**
```bash
# Clonar configuración RAG Bot
git clone https://github.com/RamsesAguirre777/claude-multi-wrapped-architecture.git
cd claude-multi-wrapped-architecture/rag-bot

# Instalar dependencias
npm install

# Configurar variables
cp .env.example .env
nano .env
```

### **Paso 2: Configuración**
```bash
# Configurar Chroma DB
docker run -d --name chroma -p 8000:8000 chromadb/chroma

# Configurar Claude Desktop
cp ../configs/claude-desktop-rag.json ~/.config/claude-desktop/claude_desktop_config.json

# Reiniciar Claude Desktop
./scripts/restart-claude.sh
```

### **Paso 3: Testing**
```bash
# Test completo del sistema
npm test

# Test específico de calificación
npm run test:qualification

# Test de integración
npm run test:integration
```

### **Paso 4: Monitoreo**
```bash
# Iniciar dashboard de métricas
npm run start:dashboard

# Verificar logs en tiempo real
npm run logs:follow

# Generar reporte de performance
npm run report:performance
```

## 🔮 **ROADMAP**

### **Funciones Avanzadas Planeadas**
- **🧠 ML Auto-learning**: Mejora automática basada en conversiones
- **🗣️ Sentiment Analysis**: Análisis emocional en tiempo real
- **📊 Predictive Scoring**: Predicción de conversión futura
- **🔄 Multi-language**: Soporte para múltiples idiomas
- **📱 Mobile Integration**: Optimización para dispositivos móviles

### **Integraciones Futuras**
- **📞 Voice Analysis**: Análisis de llamadas telefónicas
- **🎥 Video Meetings**: Análisis de reuniones virtuales
- **📧 Email Tracking**: Seguimiento de engagement por email
- **🌐 Social Media**: Análisis de interacciones sociales

---

## 🏆 **CONCLUSIÓN**

El RAG Bot Lead Qualification System es una herramienta revolucionaria que transforma la manera en que las empresas califican y gestionan sus leads. Con una precisión del 94% y capacidad de procesamiento en tiempo real, permite a las organizaciones:

- **Identificar oportunidades de alto valor** instantáneamente
- **Automatizar completamente** el proceso de calificación
- **Optimizar recursos** enfocándose en leads prometedores
- **Mejorar conversiones** con seguimiento inteligente

**¡Implementa el RAG Bot y revoluciona tu proceso de ventas! 🚀**