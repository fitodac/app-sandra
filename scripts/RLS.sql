-- =====================================================
-- SCRIPT DE ROW LEVEL SECURITY (RLS) PARA FITODAC APP
-- =====================================================
-- Este script habilita RLS en todas las tablas y crea políticas de seguridad
-- Ejecutar con privilegios de administrador en Supabase

-- Habilitar RLS en todas las tablas principales
ALTER TABLE IF EXISTS clinical_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS services ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS media ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS users ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS users_sessions ENABLE ROW LEVEL SECURITY;

-- Habilitar RLS en tablas de versiones y vistas
-- ALTER TABLE IF EXISTS _clinical_sessions_v ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE IF EXISTS _services_v ENABLE ROW LEVEL SECURITY;

-- Habilitar RLS en tablas internas de Payload
ALTER TABLE IF EXISTS payload_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS payload_preferences_rels ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS payload_locked_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS payload_locked_documents_rels ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS payload_migrations ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- FUNCIÓN PARA AUTO-HABILITAR RLS EN NUEVAS TABLAS
-- =====================================================
CREATE OR REPLACE FUNCTION auto_enable_rls_on_new_tables()
RETURNS event_trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands() WHERE command_tag = 'CREATE TABLE'
    LOOP
        IF obj.schema_name = 'public' THEN
            EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY', obj.schema_name, obj.object_identity);
        END IF;
    END LOOP;
END;
$$;

-- Crear trigger de evento DDL para auto-habilitar RLS
DROP EVENT TRIGGER IF EXISTS auto_enable_rls_trigger;
CREATE EVENT TRIGGER auto_enable_rls_trigger
    ON ddl_command_end
    WHEN TAG IN ('CREATE TABLE')
    EXECUTE FUNCTION auto_enable_rls_on_new_tables();

-- =====================================================
-- POLÍTICAS DE SEGURIDAD
-- =====================================================

-- Eliminar políticas existentes para recrearlas
DO $$
DECLARE
    pol record;
BEGIN
    FOR pol IN 
        SELECT schemaname, tablename, policyname 
        FROM pg_policies 
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', pol.policyname, pol.schemaname, pol.tablename);
    END LOOP;
END
$$;

-- =====================================================
-- POLÍTICAS PARA USUARIOS
-- =====================================================
CREATE POLICY "users_select_own" ON users 
    FOR SELECT USING (auth.uid()::text = id::text);

CREATE POLICY "users_update_own" ON users 
    FOR UPDATE USING (auth.uid()::text = id::text);

CREATE POLICY "service_role_bypass_users" ON users 
    FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- POLÍTICAS PARA SESIONES DE USUARIOS
-- =====================================================
CREATE POLICY "sessions_select_own" ON users_sessions 
    FOR SELECT USING (auth.uid()::text = _parent_id::text);

CREATE POLICY "sessions_insert_own" ON users_sessions 
    FOR INSERT WITH CHECK (auth.uid()::text = _parent_id::text);

CREATE POLICY "sessions_update_own" ON users_sessions 
    FOR UPDATE USING (auth.uid()::text = _parent_id::text);

CREATE POLICY "sessions_delete_own" ON users_sessions 
    FOR DELETE USING (auth.uid()::text = _parent_id::text);

CREATE POLICY "service_role_bypass_sessions" ON users_sessions 
    FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- POLÍTICAS PARA CLINICAL_SESSIONS
-- =====================================================
CREATE POLICY "clients_authenticated" ON clinical_sessions 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_clients" ON clinical_sessions 
    FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- POLÍTICAS PARA SERVICES
-- =====================================================
CREATE POLICY "services_authenticated" ON services 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_services" ON services 
    FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- POLÍTICAS PARA MEDIA
-- =====================================================
CREATE POLICY "media_authenticated" ON media 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_media" ON media 
    FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- POLÍTICAS PARA VISTAS DE CLINICAL_SESSIONS
-- =====================================================
-- CREATE POLICY "_clinical_sessions_v_authenticated" ON _clinical_sessions_v 
--     FOR ALL USING (auth.role() = 'authenticated');

-- CREATE POLICY "service_role_bypass_clinical_sessions_v" ON _clinical_sessions_v 
--     FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- POLÍTICAS PARA ITEMS DE VERSIONES DE SERVICES
-- =====================================================
-- CREATE POLICY "_services_v_version_items_authenticated" ON _services_v_version_items 
--     FOR ALL USING (auth.role() = 'authenticated');

-- CREATE POLICY "service_role_bypass_services_v_items" ON _services_v_version_items 
--     FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- POLÍTICAS PARA TABLAS INTERNAS DE PAYLOAD
-- =====================================================

-- Payload Preferences
CREATE POLICY "payload_preferences_authenticated" ON payload_preferences 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_payload_prefs" ON payload_preferences 
    FOR ALL USING (auth.role() = 'service_role');

-- Payload Preferences Relations
CREATE POLICY "payload_preferences_rels_authenticated" ON payload_preferences_rels 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_payload_prefs_rels" ON payload_preferences_rels 
    FOR ALL USING (auth.role() = 'service_role');

-- Payload Locked Documents
CREATE POLICY "payload_locked_docs_authenticated" ON payload_locked_documents 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_payload_locked" ON payload_locked_documents 
    FOR ALL USING (auth.role() = 'service_role');

-- Payload Locked Documents Relations
CREATE POLICY "payload_locked_docs_rels_authenticated" ON payload_locked_documents_rels 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_payload_locked_rels" ON payload_locked_documents_rels 
    FOR ALL USING (auth.role() = 'service_role');

-- Payload Migrations
CREATE POLICY "payload_migrations_authenticated" ON payload_migrations 
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "service_role_bypass_payload_migrations" ON payload_migrations 
    FOR ALL USING (auth.role() = 'service_role');

-- =====================================================
-- VERIFICACIÓN FINAL
-- =====================================================
-- Consulta para verificar que RLS está habilitado
-- SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

-- Consulta para verificar políticas creadas
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual FROM pg_policies WHERE schemaname = 'public' ORDER BY tablename, policyname;

-- =====================================================
-- INSTRUCCIONES DE USO
-- =====================================================
-- 1. Ejecutar este script en Supabase SQL Editor con privilegios de administrador
-- 2. Verificar que todas las tablas tienen RLS habilitado
-- 3. Verificar que las políticas se crearon correctamente
-- 4. El trigger automático mantendrá RLS habilitado en nuevas tablas
-- 5. Las políticas 'service_role_bypass' permiten que Payload funcione correctamente

-- NOTA: Este script es idempotente y puede ejecutarse múltiples veces sin problemas