# 🎯 Decision Triggers - Automatización Inteligente

## 🧠 **Concepto de Decision Triggers**

Los **Decision Triggers** son reglas inteligentes que permiten a Claude tomar decisiones automáticas basadas en el contexto de la conversación y ejecutar acciones específicas en el CRM, workflows o notificaciones.

## 🔄 **Flujo de Decision Triggers**

```
Mensaje del Cliente → Análisis de Contexto (Claude) → Trigger Match → Acción Automática
                                    ↓
                           Chroma Memory Update
                                    ↓
                           MySQL Activity Log
                                    ↓
                           Odoo Stage Update
                                    ↓
                           n8n Workflow Execute
```

## 🎯 **Triggers por Industria**

### **🦷 Clínica Dental**

#### **Trigger 1: Emergencia Dental**
```yaml
name: "emergencia_dental"
keywords: ["dolor", "urgencia", "emergencia", "duele", "hinchazón", "infección"]
priority: "CRÍTICA"
actions:
  - move_to_stage: "Primer Contacto"
  - set_priority: "high"
  - create_calendar_event: "urgente_30min"
  - send_whatsapp: "template_urgencia"
  - notify_team: "emergencia_dental"
```

#### **Trigger 2: Cita de Rutina**
```yaml
name: "cita_rutina"
keywords: ["limpieza", "revisión", "chequeo", "mantenimiento", "cita"]
priority: "NORMAL"
actions:
  - move_to_stage: "Reunión Programada"
  - create_calendar_event: "rutina_60min"
  - send_whatsapp: "template_confirmacion"
```

#### **Trigger 3: Consulta de Precios**
```yaml
name: "consulta_precios"
keywords: ["precio", "costo", "presupuesto", "cotización", "cuánto"]
priority: "ALTA"
actions:
  - move_to_stage: "Cotización Enviada"
  - trigger_n8n: "generate_quote_workflow"
  - send_whatsapp: "template_presupuesto"
```

### **📈 Agencia de Marketing**

#### **Trigger 4: Lead Calificado**
```yaml
name: "lead_calificado"
keywords: ["marketing", "campaña", "publicidad", "estrategia", "roi"]
priority: "ALTA"
actions:
  - move_to_stage: "Análisis de Necesidades"
  - assign_to: "sales_team"
  - create_notion_page: "lead_analysis"
  - trigger_n8n: "lead_qualification_workflow"
```

#### **Trigger 5: Solicitud de Propuesta**
```yaml
name: "solicitud_propuesta"
keywords: ["propuesta", "plan", "estrategia", "presupuesto", "proyecto"]
priority: "CRÍTICA"
actions:
  - move_to_stage: "Propuesta Técnica"
  - create_calendar_event: "presentation_90min"
  - trigger_n8n: "proposal_generation_workflow"
```

### **🛒 E-commerce**

#### **Trigger 6: Soporte Técnico**
```yaml
name: "soporte_tecnico"
keywords: ["problema", "error", "no funciona", "ayuda", "soporte"]
priority: "ALTA"
actions:
  - move_to_stage: "Primer Contacto"
  - assign_to: "support_team"
  - create_ticket: "technical_support"
  - trigger_n8n: "support_workflow"
```

#### **Trigger 7: Upselling Opportunity**
```yaml
name: "upselling_opportunity"
keywords: ["más", "adicional", "upgrade", "premium", "mejor"]
priority: "NORMAL"
actions:
  - move_to_stage: "En Negociación"
  - trigger_n8n: "upselling_workflow"
  - send_email: "template_upselling"
```

## 🔧 **Implementación de Triggers**

### **Sistema de Prompts para Claude**

#### **Prompt Principal de Decision Triggers**
```markdown
# SISTEMA DE DECISION TRIGGERS

Eres un coordinador operativo inteligente. Analiza cada mensaje del cliente y ejecuta los triggers apropiados.

## TRIGGERS DISPONIBLES:

### EMERGENCIA DENTAL
- Keywords: dolor, urgencia, emergencia, duele, hinchazón, infección
- Acción: Mover a "Primer Contacto", Prioridad Alta, Crear cita urgente
- Comando: `trigger_emergencia_dental`

### CITA RUTINA
- Keywords: limpieza, revisión, chequeo, mantenimiento, cita
- Acción: Mover a "Reunión Programada", Crear cita normal
- Comando: `trigger_cita_rutina`

### CONSULTA PRECIOS
- Keywords: precio, costo, presupuesto, cotización, cuánto
- Acción: Mover a "Cotización Enviada", Generar presupuesto
- Comando: `trigger_consulta_precios`

## INSTRUCCIONES:
1. Analiza el mensaje del cliente
2. Identifica keywords relevantes
3. Ejecuta el trigger apropiado usando los MCPs
4. Actualiza Chroma con el contexto
5. Registra la acción en MySQL
6. Responde al cliente de manera natural

## EJEMPLO DE EJECUCIÓN:
Cliente: "Tengo un dolor terrible en la muela"
Análisis: Keywords detectadas: dolor, terrible, muela
Trigger: emergencia_dental
Acciones:
- Usar Odoo MCP para mover lead a "Primer Contacto"
- Usar Calendar MCP para crear cita urgente
- Usar WhatsApp MCP para enviar confirmación
- Usar Chroma MCP para guardar contexto
- Usar MySQL MCP para log de actividad
```

#### **Prompt Específico por Industria**
```markdown
# MODO: CLÍNICA DENTAL

Estás especializando en atención dental. Tus prioridades son:
1. Emergencias dentales (dolor, infección, trauma)
2. Citas de rutina (limpieza, revisión)
3. Tratamientos específicos (ortodoncia, implantes)
4. Consultas de precios

TRIGGERS ACTIVOS:
- emergencia_dental
- cita_rutina  
- consulta_precios
- seguimiento_tratamiento

RESPUESTAS TIPO:
- Empático y profesional
- Enfoque en la salud dental
- Urgencia para emergencias
- Opciones de horarios flexibles
```

## 📊 **Métricas de Triggers**

### **Tracking de Performance**
```sql
-- Tabla para tracking de triggers
CREATE TABLE trigger_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trigger_name VARCHAR(100),
    lead_id INT,
    message TEXT,
    keywords_matched JSON,
    actions_executed JSON,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    success BOOLEAN,
    error_message TEXT
);

-- Query para análisis de triggers
SELECT 
    trigger_name,
    COUNT(*) as total_executions,
    COUNT(CASE WHEN success = TRUE THEN 1 END) as successful_executions,
    AVG(CASE WHEN success = TRUE THEN 1 ELSE 0 END) * 100 as success_rate
FROM trigger_logs 
WHERE execution_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY trigger_name;
```

## 🚀 **Próximos Pasos**

### **Implementación Inmediata**
1. **Configurar prompts de Decision Triggers en Claude**
2. **Implementar engine de triggers básico**
3. **Crear triggers específicos para clínica dental**
4. **Configurar logging en MySQL**
5. **Testear con casos reales**

### **Expansión**
1. **Añadir más industrias**
2. **Implementar machine learning para optimización**
3. **Crear dashboard en tiempo real**
4. **Integrar con más canales de comunicación**

¿Quieres que implemente algún trigger específico ahora mismo? 🎯