# 🦷 Clínica Dental - Caso de Uso Completo

## 🎯 **Escenario: Clínica Dental "Sonrisa Perfecta"**

### **Contexto**
- Clínica dental con 3 doctores
- Horario: Lunes a Viernes 8:00-18:00, Sábados 9:00-14:00
- Servicios: Emergencias, limpieza, ortodoncia, implantes, estética
- Sistema CRM: Odoo con pipeline personalizado

### **Flujo CRM Configurado**
1. **🎯 Prospecto Identificado** - Primer contacto
2. **📞 Primer Contacto** - Llamada inicial / WhatsApp
3. **💬 Reunión Programada** - Cita agendada
4. **🔍 Análisis de Necesidades** - Evaluación clínica
5. **📋 Propuesta Técnica** - Plan de tratamiento
6. **💰 Cotización Enviada** - Presupuesto detallado
7. **🤝 En Negociación** - Ajustes de precio/plan
8. **✅ Ganado - Cliente** - Tratamiento iniciado
9. **❌ Perdido** - No convertido

## 📱 **Casos de Uso Reales**

### **Caso 1: Emergencia Dental** 🚨

#### **Conversación Cliente**
```
Cliente: "Hola, tengo un dolor terrible en la muela del juicio. No puedo ni dormir, necesito ayuda urgente por favor"
```

#### **Análisis Claude**
```
Keywords detectadas: dolor, terrible, muela, urgente, ayuda
Trigger: emergencia_dental
Prioridad: CRÍTICA
Contexto histórico: Nuevo cliente (no hay historial en Chroma)
```

#### **Acciones Ejecutadas**
```python
# 1. Crear lead en Odoo
odoo_mcp.create_lead({
    "name": "Emergencia dental - Dolor muela juicio",
    "partner_name": "Cliente WhatsApp",
    "stage_id": 6,  # Primer Contacto
    "priority": "high",
    "description": "Dolor severo muela juicio, necesita atención urgente",
    "phone": "+52XXXXXXXXXX",
    "source": "whatsapp"
})

# 2. Programar cita urgente
calendar_mcp.create_event({
    "title": "EMERGENCIA: Dolor muela juicio",
    "start": "2025-07-16T10:00:00",
    "duration": 30,
    "type": "emergency",
    "doctor": "Dr. García",
    "priority": "high"
})

# 3. Enviar confirmación WhatsApp
whatsapp_mcp.send_message({
    "template": "emergencia_confirmacion",
    "variables": {
        "nombre": "Cliente",
        "fecha": "16 de julio",
        "hora": "10:00 AM",
        "doctor": "Dr. García"
    }
})

# 4. Registrar en MySQL
mysql_mcp.insert_log({
    "trigger_name": "emergencia_dental",
    "lead_id": 123,
    "keywords": ["dolor", "terrible", "muela", "urgente"],
    "actions": ["create_lead", "schedule_emergency", "send_whatsapp"],
    "success": true
})

# 5. Guardar contexto en Chroma
chroma_mcp.add_memory({
    "client_id": "whatsapp_client_123",
    "conversation": "Emergencia dental - dolor muela juicio",
    "context": "Cliente con dolor severo, cita urgente programada",
    "embedding": "vector_embedding_mistral"
})
```

#### **Respuesta al Cliente**
```
"Entiendo que tienes un dolor dental muy intenso. He programado una cita de emergencia para ti HOY a las 10:00 AM con el Dr. García, quien es especialista en este tipo de urgencias.

📅 Cita: Hoy 16 de julio - 10:00 AM
👨‍⚕️ Doctor: Dr. García
📍 Ubicación: Clínica Sonrisa Perfecta

Mientras tanto, puedes tomar ibuprofeno 400mg cada 6 horas si no eres alérgico. Si el dolor empeora o tienes fiebre, llámanos inmediatamente.

Te enviaré la ubicación exacta y un recordatorio 30 minutos antes. ¡Tranquilo, el Dr. García resolverá tu problema!"
```

### **Caso 2: Cita de Rutina** 📅

#### **Conversación Cliente**
```
Cliente: "Hola, quiero agendar una cita para limpieza dental. Prefiero por la mañana si es posible"
```

#### **Análisis Claude**
```
Keywords detectadas: agendar, cita, limpieza, dental, mañana
Trigger: cita_rutina
Prioridad: NORMAL
Contexto histórico: Cliente recurrente (última limpieza hace 8 meses)
```

#### **Acciones Ejecutadas**
```python
# 1. Consultar historial en Chroma
chroma_mcp.query_memory({
    "client_id": "whatsapp_client_456",
    "query": "historial dental, preferencias"
})

# 2. Actualizar lead en Odoo
odoo_mcp.update_lead({
    "lead_id": 456,
    "stage_id": 7,  # Reunión Programada
    "description": "Limpieza dental de rutina, prefiere mañanas"
})

# 3. Buscar disponibilidad
calendar_mcp.find_availability({
    "service": "limpieza",
    "duration": 60,
    "preference": "morning",
    "date_range": "next_week"
})

# 4. Crear cita
calendar_mcp.create_event({
    "title": "Limpieza dental - María López",
    "start": "2025-07-18T09:00:00",
    "duration": 60,
    "type": "routine",
    "doctor": "Dr. Martínez",
    "service": "limpieza"
})

# 5. Enviar confirmación
whatsapp_mcp.send_message({
    "template": "cita_confirmacion",
    "variables": {
        "nombre": "María",
        "servicio": "limpieza dental",
        "fecha": "18 de julio",
        "hora": "9:00 AM",
        "doctor": "Dr. Martínez"
    }
})
```

#### **Respuesta al Cliente**
```
"¡Hola María! Perfecto, veo que es tiempo de tu limpieza dental. He revisado tu historial y todo está en orden.

📅 Cita programada:
• Servicio: Limpieza dental completa
• Fecha: Viernes 18 de julio
• Hora: 9:00 AM
• Doctor: Dr. Martínez
• Duración: 60 minutos

Te recuerdo que la limpieza incluye:
✅ Eliminación de placa y sarro
✅ Pulido dental
✅ Aplicación de flúor
✅ Revisión general

No necesitas preparación especial, solo evita comer 2 horas antes. Te enviaré un recordatorio el día anterior.

¿Te funciona perfecto este horario?"
```

### **Caso 3: Consulta de Precios** 💰

#### **Conversación Cliente**
```
Cliente: "Hola, quiero saber cuánto cuesta una ortodoncia completa para mi hijo de 14 años"
```

#### **Análisis Claude**
```
Keywords detectadas: cuánto, cuesta, ortodoncia, completa, hijo
Trigger: consulta_precios
Prioridad: ALTA
Contexto histórico: Nuevo cliente, consulta específica
```

#### **Acciones Ejecutadas**
```python
# 1. Crear lead en Odoo
odoo_mcp.create_lead({
    "name": "Consulta ortodoncia - Hijo 14 años",
    "partner_name": "Cliente WhatsApp",
    "stage_id": 10,  # Cotización Enviada
    "description": "Interesado en ortodoncia completa para adolescente",
    "phone": "+52XXXXXXXXXX",
    "source": "whatsapp"
})

# 2. Disparar workflow de cotización
n8n_mcp.trigger_workflow({
    "workflow_id": "generate_orthodontic_quote",
    "parameters": {
        "patient_age": 14,
        "treatment_type": "comprehensive",
        "urgency": "normal"
    }
})

# 3. Generar presupuesto personalizado
odoo_mcp.create_quotation({
    "lead_id": 789,
    "items": [
        {
            "product": "Consulta inicial ortodoncia",
            "price": 800,
            "description": "Evaluación completa + radiografías"
        },
        {
            "product": "Tratamiento ortodoncia completa",
            "price": 28000,
            "description": "Brackets metálicos + seguimiento 24 meses"
        },
        {
            "product": "Retenedores",
            "price": 4500,
            "description": "Retenedores fijos y removibles"
        }
    ],
    "payment_terms": "12 meses sin intereses"
})

# 4. Enviar cotización por WhatsApp
whatsapp_mcp.send_document({
    "document_type": "quotation",
    "file_path": "ortodecia_quote_789.pdf",
    "message": "Aquí tienes el presupuesto detallado para la ortodoncia"
})
```

#### **Respuesta al Cliente**
```
"¡Excelente! La ortodoncia en adolescentes es una inversión muy importante para la salud y confianza de tu hijo.

📋 **Presupuesto Ortodoncia Completa (14 años):**

🔍 **Consulta inicial**: $800
• Evaluación completa
• Radiografías panorámica y lateral
• Plan de tratamiento personalizado

🦷 **Tratamiento completo**: $28,000
• Brackets metálicos de alta calidad
• Seguimiento mensual por 18-24 meses
• Todos los ajustes incluidos

🔄 **Retenedores**: $4,500
• Retenedor fijo (permanente)
• Retenedor removible (nocturno)

💳 **Total: $33,300**
✅ **12 meses sin intereses**
✅ **Incluye todas las consultas de seguimiento**

Te envío el presupuesto detallado por WhatsApp. ¿Te gustaría agendar la consulta inicial sin compromiso? El Dr. Rodríguez evaluará el caso específico de tu hijo."
```

### **Caso 4: Seguimiento Post-Tratamiento** 🔄

#### **Conversación Cliente**
```
Cliente: "Hola, terminé mi tratamiento de conducto la semana pasada y todavía siento un poco de molestia. ¿Es normal?"
```

#### **Análisis Claude**
```
Keywords detectadas: terminé, tratamiento, conducto, molestia, normal
Trigger: seguimiento_tratamiento
Prioridad: ALTA
Contexto histórico: Cliente con tratamiento reciente (buscar en Chroma)
```

#### **Acciones Ejecutadas**
```python
# 1. Consultar historial completo
chroma_mcp.query_memory({
    "client_id": "whatsapp_client_321",
    "query": "tratamiento conducto, última visita, síntomas"
})

# 2. Verificar en Odoo
odoo_mcp.search_treatments({
    "partner_id": 321,
    "treatment_type": "endodoncia",
    "date_range": "last_2_weeks"
})

# 3. Evaluar necesidad de cita
calendar_mcp.check_availability({
    "type": "follow_up",
    "urgency": "medium",
    "doctor": "Dr. Sánchez"  # Mismo doctor del tratamiento
})

# 4. Programar seguimiento
calendar_mcp.create_event({
    "title": "Seguimiento endodoncia - Carlos Ruiz",
    "start": "2025-07-17T14:00:00",
    "duration": 30,
    "type": "follow_up",
    "doctor": "Dr. Sánchez",
    "notes": "Revisar evolución post-endodoncia"
})

# 5. Actualizar CRM
odoo_mcp.update_lead({
    "lead_id": 321,
    "stage_id": 4,  # Ganado - Cliente (seguimiento)
    "description": "Seguimiento post-endodoncia, molestias leves"
})
```

#### **Respuesta al Cliente**
```
"Hola Carlos, gracias por contactarnos. He revisado tu expediente y veo que el Dr. Sánchez te realizó la endodoncia la semana pasada.

Es completamente normal sentir molestias leves después de un tratamiento de conducto, especialmente durante los primeros 7-10 días. Sin embargo, quiero que el Dr. Sánchez te revise para asegurar que todo evoluciona correctamente.

📅 **Cita de seguimiento programada:**
• Fecha: Mañana 17 de julio
• Hora: 2:00 PM
• Doctor: Dr. Sánchez
• Tipo: Revisión post-endodoncia
• **SIN COSTO** (incluida en tu tratamiento)

**Mientras tanto:**
✅ Continúa con el antibiótico si te lo recetaron
✅ Puedes tomar ibuprofeno para la molestia
❌ Evita masticar del lado tratado
❌ No consumas alimentos muy calientes o fríos

Si las molestias aumentan o tienes hinchazón, llámanos inmediatamente. ¡Mañana el Dr. Sánchez verificará que todo esté perfecto!"
```

## 📊 **Métricas del Caso de Uso**

### **Dashboard Dental - Métricas Diarias**
```python
# Métricas extraídas de MySQL
daily_metrics = {
    "total_conversations": 45,
    "triggers_executed": {
        "emergencia_dental": 8,
        "cita_rutina": 18,
        "consulta_precios": 12,
        "seguimiento_tratamiento": 7
    },
    "conversion_rate": 73.3,
    "response_time_avg": "1.2 minutos",
    "customer_satisfaction": 4.8
}
```

### **Flujo de Conversión**
```
Prospecto Identificado: 45 leads
↓ (85% conversión)
Primer Contacto: 38 leads
↓ (78% conversión)
Reunión Programada: 30 leads
↓ (90% conversión)
Análisis de Necesidades: 27 leads
↓ (85% conversión)
Propuesta Técnica: 23 leads
↓ (87% conversión)
Cotización Enviada: 20 leads
↓ (75% conversión)
Ganado - Cliente: 15 leads
```

## 🚀 **Implementación Inmediata**

### **Próximos Pasos**
1. **Configurar prompts específicos en Claude**
2. **Crear templates de WhatsApp**
3. **Configurar workflows en n8n**
4. **Testear con casos reales**
5. **Optimizar based on métricas**

### **Templates de WhatsApp**
```yaml
emergencia_confirmacion:
  "🚨 CITA DE EMERGENCIA CONFIRMADA
  
  📅 Fecha: {{fecha}}
  ⏰ Hora: {{hora}}
  👨‍⚕️ Doctor: {{doctor}}
  📍 Clínica Sonrisa Perfecta
  
  📲 Te enviaré la ubicación y un recordatorio 30 min antes.
  
  ⚠️ Si el dolor empeora, llámanos: (662) 123-4567"

cita_confirmacion:
  "✅ CITA CONFIRMADA
  
  👋 Hola {{nombre}}!
  
  📅 {{servicio}}
  📆 {{fecha}} a las {{hora}}
  👨‍⚕️ {{doctor}}
  
  📲 Te recordaré 1 día antes.
  
  ¿Alguna pregunta? Estoy aquí para ayudarte 😊"
```

Este caso de uso demuestra cómo Claude Multi-Wrapped puede manejar una clínica dental completa con automatización inteligente y respuestas empáticas. 🦷✨