-- Claude Multi-Wrapped Architecture - Database Schema
-- Este archivo crea todas las tablas necesarias para el sistema

-- Configuración inicial
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS claude_multiwrapped 
  DEFAULT CHARACTER SET utf8mb4 
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE claude_multiwrapped;

-- =====================================================
-- TABLAS PRINCIPALES
-- =====================================================

-- Tabla de logs de triggers
CREATE TABLE IF NOT EXISTS trigger_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trigger_name VARCHAR(100) NOT NULL,
    lead_id INT,
    client_id VARCHAR(100),
    client_phone VARCHAR(20),
    client_email VARCHAR(255),
    message TEXT,
    keywords_matched JSON,
    actions_executed JSON,
    execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_time_ms INT,
    success BOOLEAN DEFAULT TRUE,
    error_message TEXT,
    industry VARCHAR(50),
    source VARCHAR(50) DEFAULT 'whatsapp',
    INDEX idx_trigger_name (trigger_name),
    INDEX idx_execution_time (execution_time),
    INDEX idx_client_id (client_id),
    INDEX idx_industry (industry),
    INDEX idx_success (success)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de conversaciones
CREATE TABLE IF NOT EXISTS conversations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(100) NOT NULL,
    client_phone VARCHAR(20),
    client_email VARCHAR(255),
    client_name VARCHAR(200),
    message TEXT,
    response TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    industry VARCHAR(50),
    trigger_activated VARCHAR(100),
    lead_id INT,
    session_id VARCHAR(100),
    source VARCHAR(50) DEFAULT 'whatsapp',
    sentiment VARCHAR(20),
    urgency_level ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    INDEX idx_client_id (client_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_industry (industry),
    INDEX idx_session_id (session_id),
    INDEX idx_urgency (urgency_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de métricas diarias
CREATE TABLE IF NOT EXISTS daily_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    industry VARCHAR(50),
    total_conversations INT DEFAULT 0,
    triggers_executed INT DEFAULT 0,
    leads_created INT DEFAULT 0,
    appointments_scheduled INT DEFAULT 0,
    quotes_generated INT DEFAULT 0,
    conversion_rate DECIMAL(5,2) DEFAULT 0.00,
    avg_response_time_ms INT DEFAULT 0,
    customer_satisfaction DECIMAL(3,2) DEFAULT 0.00,
    total_revenue DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_date_industry (date, industry),
    INDEX idx_date (date),
    INDEX idx_industry (industry)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de servicios y precios
CREATE TABLE IF NOT EXISTS service_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    industry VARCHAR(50) NOT NULL,
    service_type VARCHAR(100) NOT NULL,
    service_name VARCHAR(200) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'MXN',
    duration_minutes INT DEFAULT 0,
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_industry_service (industry, service_type),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de clientes
CREATE TABLE IF NOT EXISTS clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(255),
    industry VARCHAR(50),
    source VARCHAR(50) DEFAULT 'whatsapp',
    first_contact TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_contact TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    total_conversations INT DEFAULT 0,
    total_appointments INT DEFAULT 0,
    total_revenue DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('active', 'inactive', 'blocked') DEFAULT 'active',
    preferences JSON,
    notes TEXT,
    INDEX idx_client_id (client_id),
    INDEX idx_phone (phone),
    INDEX idx_email (email),
    INDEX idx_industry (industry),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de citas/appointments
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(100) NOT NULL,
    lead_id INT,
    appointment_date DATETIME NOT NULL,
    service_type VARCHAR(100),
    service_name VARCHAR(200),
    duration_minutes INT DEFAULT 60,
    status ENUM('scheduled', 'confirmed', 'completed', 'cancelled', 'no_show') DEFAULT 'scheduled',
    doctor_name VARCHAR(200),
    price DECIMAL(10,2) DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_client_id (client_id),
    INDEX idx_appointment_date (appointment_date),
    INDEX idx_status (status),
    INDEX idx_lead_id (lead_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de workflows n8n
CREATE TABLE IF NOT EXISTS workflows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    workflow_name VARCHAR(200) NOT NULL,
    workflow_id VARCHAR(100) NOT NULL,
    industry VARCHAR(50),
    trigger_name VARCHAR(100),
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    execution_count INT DEFAULT 0,
    last_execution TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_workflow_name (workflow_name),
    INDEX idx_industry (industry),
    INDEX idx_trigger_name (trigger_name),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de workflow executions
CREATE TABLE IF NOT EXISTS workflow_executions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    workflow_id VARCHAR(100) NOT NULL,
    execution_id VARCHAR(100),
    trigger_name VARCHAR(100),
    client_id VARCHAR(100),
    lead_id INT,
    status ENUM('success', 'error', 'running', 'cancelled') DEFAULT 'running',
    input_data JSON,
    output_data JSON,
    error_message TEXT,
    execution_time_ms INT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP NULL,
    INDEX idx_workflow_id (workflow_id),
    INDEX idx_status (status),
    INDEX idx_client_id (client_id),
    INDEX idx_started_at (started_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- DATOS INICIALES
-- =====================================================

-- Insertar servicios para clínica dental
INSERT INTO service_prices (industry, service_type, service_name, base_price, duration_minutes, description) VALUES
('dental_clinic', 'emergency', 'Consulta de emergencia', 800.00, 30, 'Atención urgente para dolor dental, infección o trauma'),
('dental_clinic', 'routine', 'Limpieza dental completa', 1200.00, 60, 'Limpieza profunda con flúor y pulido'),
('dental_clinic', 'routine', 'Revisión general', 600.00, 30, 'Examen dental completo y diagnóstico'),
('dental_clinic', 'orthodontics', 'Consulta ortodoncia', 800.00, 45, 'Evaluación para brackets y plan de tratamiento'),
('dental_clinic', 'orthodontics', 'Tratamiento ortodoncia completa', 28000.00, 0, 'Brackets metálicos con seguimiento 18-24 meses'),
('dental_clinic', 'orthodontics', 'Retenedores', 4500.00, 30, 'Retenedores fijos y removibles post-ortodoncia'),
('dental_clinic', 'implants', 'Consulta implantes', 1000.00, 45, 'Evaluación para implantes dentales'),
('dental_clinic', 'implants', 'Implante dental completo', 15000.00, 120, 'Implante con corona incluida'),
('dental_clinic', 'endodontics', 'Tratamiento de conducto', 4500.00, 90, 'Endodoncia completa con obturación'),
('dental_clinic', 'periodontics', 'Tratamiento de encías', 2500.00, 60, 'Limpieza profunda y tratamiento periodontal'),
('dental_clinic', 'cosmetic', 'Blanqueamiento dental', 3500.00, 90, 'Blanqueamiento profesional en consulta'),
('dental_clinic', 'cosmetic', 'Carillas dentales', 8000.00, 120, 'Carillas de porcelana por diente'),
('dental_clinic', 'surgery', 'Extracción simple', 1500.00, 30, 'Extracción de diente sin complicaciones'),
('dental_clinic', 'surgery', 'Extracción quirúrgica', 3000.00, 60, 'Extracción compleja con cirugía'),
('dental_clinic', 'pediatric', 'Consulta pediátrica', 700.00, 45, 'Revisión dental para niños'),
('dental_clinic', 'pediatric', 'Selladores', 800.00, 30, 'Selladores de fosetas y fisuras');

-- Insertar servicios para agencia de marketing
INSERT INTO service_prices (industry, service_type, service_name, base_price, duration_minutes, description) VALUES
('marketing_agency', 'seo', 'Consultoría SEO', 2500.00, 60, 'Análisis y estrategia de posicionamiento web'),
('marketing_agency', 'seo', 'SEO mensual básico', 8000.00, 0, 'Optimización SEO mensual para sitio web'),
('marketing_agency', 'seo', 'SEO mensual avanzado', 15000.00, 0, 'SEO completo con link building y contenido'),
('marketing_agency', 'sem', 'Consultoría Google Ads', 3000.00, 90, 'Estrategia y configuración de campañas SEM'),
('marketing_agency', 'sem', 'Gestión Google Ads básica', 5000.00, 0, 'Gestión mensual de campañas SEM básicas'),
('marketing_agency', 'sem', 'Gestión Google Ads avanzada', 12000.00, 0, 'Gestión completa con optimización avanzada'),
('marketing_agency', 'social', 'Consultoría Social Media', 2000.00, 60, 'Estrategia para redes sociales'),
('marketing_agency', 'social', 'Social Media básico', 6000.00, 0, 'Manejo de 2 redes sociales'),
('marketing_agency', 'social', 'Social Media completo', 12000.00, 0, 'Manejo de todas las redes con contenido'),
('marketing_agency', 'content', 'Estrategia de contenido', 4000.00, 90, 'Plan de contenido y calendario editorial'),
('marketing_agency', 'content', 'Creación de contenido', 8000.00, 0, 'Creación mensual de contenido para web y redes'),
('marketing_agency', 'web', 'Consultoría web', 3500.00, 90, 'Análisis y recomendaciones para sitio web'),
('marketing_agency', 'web', 'Diseño web básico', 25000.00, 0, 'Sitio web responsive con CMS'),
('marketing_agency', 'web', 'Desarrollo web avanzado', 50000.00, 0, 'Desarrollo web completo con funcionalidades custom'),
('marketing_agency', 'email', 'Email Marketing setup', 3000.00, 60, 'Configuración de campañas de email marketing'),
('marketing_agency', 'email', 'Email Marketing mensual', 4000.00, 0, 'Gestión mensual de campañas de email');

-- Insertar servicios para e-commerce
INSERT INTO service_prices (industry, service_type, service_name, base_price, duration_minutes, description) VALUES
('ecommerce', 'consultation', 'Consultoría e-commerce', 4000.00, 90, 'Análisis y estrategia para tienda online'),
('ecommerce', 'development', 'Tienda online básica', 35000.00, 0, 'E-commerce con funcionalidades básicas'),
('ecommerce', 'development', 'Tienda online avanzada', 75000.00, 0, 'E-commerce completo con integraciones'),
('ecommerce', 'marketing', 'Marketing digital e-commerce', 15000.00, 0, 'Estrategia completa de marketing digital'),
('ecommerce', 'seo', 'SEO para e-commerce', 12000.00, 0, 'Optimización SEO específica para tiendas online'),
('ecommerce', 'maintenance', 'Mantenimiento mensual', 3000.00, 0, 'Mantenimiento y updates mensuales'),
('ecommerce', 'integration', 'Integración con ERP', 25000.00, 0, 'Integración con sistema de gestión'),
('ecommerce', 'analytics', 'Setup de Analytics', 5000.00, 120, 'Configuración de Google Analytics y métricas');

-- Insertar workflows iniciales
INSERT INTO workflows (workflow_name, workflow_id, industry, trigger_name, description, active) VALUES
('Emergencia Dental', 'dental_emergency_001', 'dental_clinic', 'emergencia_dental', 'Workflow para atender emergencias dentales', TRUE),
('Cita Rutina', 'dental_routine_001', 'dental_clinic', 'cita_rutina', 'Workflow para programar citas de rutina', TRUE),
('Consulta Precios Dental', 'dental_prices_001', 'dental_clinic', 'consulta_precios', 'Workflow para generar cotizaciones dentales', TRUE),
('Lead Marketing Calificado', 'marketing_lead_001', 'marketing_agency', 'lead_calificado', 'Workflow para calificar leads de marketing', TRUE),
('Propuesta Marketing', 'marketing_proposal_001', 'marketing_agency', 'solicitud_propuesta', 'Workflow para generar propuestas de marketing', TRUE),
('Soporte E-commerce', 'ecommerce_support_001', 'ecommerce', 'soporte_tecnico', 'Workflow para soporte técnico de e-commerce', TRUE),
('Upselling E-commerce', 'ecommerce_upsell_001', 'ecommerce', 'upselling_opportunity', 'Workflow para oportunidades de upselling', TRUE);

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista para métricas de rendimiento de triggers
CREATE VIEW IF NOT EXISTS trigger_performance AS
SELECT 
    trigger_name,
    industry,
    COUNT(*) as total_executions,
    COUNT(CASE WHEN success = TRUE THEN 1 END) as successful_executions,
    ROUND(COUNT(CASE WHEN success = TRUE THEN 1 END) * 100.0 / COUNT(*), 2) as success_rate,
    AVG(response_time_ms) as avg_response_time,
    DATE(execution_time) as execution_date
FROM trigger_logs 
WHERE execution_time >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY trigger_name, industry, DATE(execution_time)
ORDER BY execution_date DESC, total_executions DESC;

-- Vista para estadísticas de conversación por cliente
CREATE VIEW IF NOT EXISTS client_conversation_stats AS
SELECT 
    c.client_id,
    c.name as client_name,
    c.phone,
    c.industry,
    c.first_contact,
    c.last_contact,
    COUNT(conv.id) as total_conversations,
    COUNT(DISTINCT conv.session_id) as unique_sessions,
    AVG(CASE WHEN conv.urgency_level = 'low' THEN 1 
             WHEN conv.urgency_level = 'medium' THEN 2
             WHEN conv.urgency_level = 'high' THEN 3
             WHEN conv.urgency_level = 'critical' THEN 4 END) as avg_urgency_score,
    COUNT(a.id) as total_appointments,
    COALESCE(SUM(a.price), 0) as total_revenue
FROM clients c
LEFT JOIN conversations conv ON c.client_id = conv.client_id
LEFT JOIN appointments a ON c.client_id = a.client_id
GROUP BY c.client_id, c.name, c.phone, c.industry, c.first_contact, c.last_contact
ORDER BY total_conversations DESC;

-- Vista para análisis de conversión por industria
CREATE VIEW IF NOT EXISTS conversion_funnel AS
SELECT 
    industry,
    COUNT(DISTINCT client_id) as total_clients,
    COUNT(DISTINCT CASE WHEN trigger_activated IS NOT NULL THEN client_id END) as clients_with_triggers,
    COUNT(DISTINCT CASE WHEN trigger_activated = 'consulta_precios' THEN client_id END) as clients_requesting_quotes,
    COUNT(DISTINCT a.client_id) as clients_with_appointments,
    ROUND(COUNT(DISTINCT CASE WHEN trigger_activated IS NOT NULL THEN client_id END) * 100.0 / COUNT(DISTINCT client_id), 2) as trigger_conversion_rate,
    ROUND(COUNT(DISTINCT a.client_id) * 100.0 / COUNT(DISTINCT client_id), 2) as appointment_conversion_rate
FROM conversations c
LEFT JOIN appointments a ON c.client_id = a.client_id
WHERE c.timestamp >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY industry;

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================================================

DELIMITER //

-- Procedimiento para calcular métricas diarias
CREATE PROCEDURE IF NOT EXISTS calculate_daily_metrics(IN target_date DATE, IN target_industry VARCHAR(50))
BEGIN
    DECLARE total_conv INT DEFAULT 0;
    DECLARE total_trig INT DEFAULT 0;
    DECLARE total_leads INT DEFAULT 0;
    DECLARE total_appts INT DEFAULT 0;
    DECLARE total_quotes INT DEFAULT 0;
    DECLARE conv_rate DECIMAL(5,2) DEFAULT 0.00;
    DECLARE avg_response INT DEFAULT 0;
    DECLARE cust_sat DECIMAL(3,2) DEFAULT 0.00;
    DECLARE total_rev DECIMAL(10,2) DEFAULT 0.00;
    
    -- Calcular métricas
    SELECT COUNT(*) INTO total_conv
    FROM conversations 
    WHERE DATE(timestamp) = target_date 
    AND (target_industry IS NULL OR industry = target_industry);
    
    SELECT COUNT(*) INTO total_trig
    FROM trigger_logs 
    WHERE DATE(execution_time) = target_date 
    AND (target_industry IS NULL OR industry = target_industry)
    AND success = TRUE;
    
    SELECT COUNT(*) INTO total_appts
    FROM appointments 
    WHERE DATE(created_at) = target_date;
    
    SELECT COUNT(*) INTO total_quotes
    FROM trigger_logs 
    WHERE DATE(execution_time) = target_date 
    AND (target_industry IS NULL OR industry = target_industry)
    AND trigger_name = 'consulta_precios'
    AND success = TRUE;
    
    SELECT AVG(response_time_ms) INTO avg_response
    FROM trigger_logs 
    WHERE DATE(execution_time) = target_date 
    AND (target_industry IS NULL OR industry = target_industry)
    AND success = TRUE;
    
    SELECT SUM(price) INTO total_rev
    FROM appointments 
    WHERE DATE(created_at) = target_date
    AND status IN ('completed', 'confirmed');
    
    -- Calcular tasa de conversión
    IF total_conv > 0 THEN
        SET conv_rate = (total_appts * 100.0) / total_conv;
    END IF;
    
    -- Insertar o actualizar métricas
    INSERT INTO daily_metrics (
        date, industry, total_conversations, triggers_executed, 
        leads_created, appointments_scheduled, quotes_generated,
        conversion_rate, avg_response_time_ms, customer_satisfaction, total_revenue
    ) VALUES (
        target_date, target_industry, total_conv, total_trig,
        total_leads, total_appts, total_quotes,
        conv_rate, avg_response, cust_sat, COALESCE(total_rev, 0)
    ) ON DUPLICATE KEY UPDATE
        total_conversations = total_conv,
        triggers_executed = total_trig,
        leads_created = total_leads,
        appointments_scheduled = total_appts,
        quotes_generated = total_quotes,
        conversion_rate = conv_rate,
        avg_response_time_ms = avg_response,
        customer_satisfaction = cust_sat,
        total_revenue = COALESCE(total_rev, 0),
        updated_at = CURRENT_TIMESTAMP;
        
END //

-- Procedimiento para limpiar datos antiguos
CREATE PROCEDURE IF NOT EXISTS cleanup_old_data(IN days_to_keep INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Limpiar logs de triggers antiguos
    DELETE FROM trigger_logs 
    WHERE execution_time < DATE_SUB(CURRENT_DATE, INTERVAL days_to_keep DAY);
    
    -- Limpiar conversaciones antiguas
    DELETE FROM conversations 
    WHERE timestamp < DATE_SUB(CURRENT_DATE, INTERVAL days_to_keep DAY);
    
    -- Limpiar ejecuciones de workflow antiguas
    DELETE FROM workflow_executions 
    WHERE started_at < DATE_SUB(CURRENT_DATE, INTERVAL days_to_keep DAY);
    
    COMMIT;
    
    SELECT CONCAT('Datos anteriores a ', days_to_keep, ' días eliminados exitosamente') as result;
    
END //

DELIMITER ;

-- =====================================================
-- EVENTOS PROGRAMADOS
-- =====================================================

-- Evento para calcular métricas diarias automáticamente
CREATE EVENT IF NOT EXISTS daily_metrics_calculation
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY + INTERVAL 1 HOUR
DO
BEGIN
    CALL calculate_daily_metrics(CURRENT_DATE - INTERVAL 1 DAY, 'dental_clinic');
    CALL calculate_daily_metrics(CURRENT_DATE - INTERVAL 1 DAY, 'marketing_agency');
    CALL calculate_daily_metrics(CURRENT_DATE - INTERVAL 1 DAY, 'ecommerce');
END;

-- Evento para limpiar datos antiguos (mantener 90 días)
CREATE EVENT IF NOT EXISTS cleanup_old_data_event
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_DATE + INTERVAL 1 WEEK
DO
BEGIN
    CALL cleanup_old_data(90);
END;

-- Restaurar configuración
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Mensaje de confirmación
SELECT 'Claude Multi-Wrapped Architecture - Base de datos inicializada correctamente' as status;
