#!/usr/bin/env node

/**
 * Chatwoot <-> OpenClaw Agent Bridge
 * 
 * Conecta Chatwoot con el agente OpenClaw para respuestas automáticas.
 * 
 * Variables de entorno requeridas:
 * - CHATWOOT_URL: URL de Chatwoot (ej: https://chat.versatilehub.app)
 * - CHATWOOT_API_ACCESS_TOKEN: Token de API de Chatwoot
 * - CHATWOOT_ACCOUNT_ID: ID de cuenta de Chatwoot
 * - OPENCLAW_WS_URL: URL del WebSocket de OpenClaw (ej: ws://agent:18789)
 * - OPENCLAW_GATEWAY_TOKEN: Token del gateway de OpenClaw
 * - OPENCLAW_SESSION_KEY: Identificador de sesión para el agente
 * - BRIDGE_PORT: Puerto para health check (default: 4000)
 */

const http = require('http');

console.log('='.repeat(80));
console.log('Chatwoot <-> OpenClaw Agent Bridge');
console.log('='.repeat(80));

// Configuración desde variables de entorno
const config = {
    chatwoot: {
        url: process.env.CHATWOOT_URL,
        apiToken: process.env.CHATWOOT_API_ACCESS_TOKEN,
        accountId: process.env.CHATWOOT_ACCOUNT_ID || '1',
    },
    openclaw: {
        wsUrl: process.env.OPENCLAW_WS_URL,
        gatewayToken: process.env.OPENCLAW_GATEWAY_TOKEN,
        sessionKey: process.env.OPENCLAW_SESSION_KEY || 'chatwoot',
    },
    bridge: {
        port: parseInt(process.env.BRIDGE_PORT || '4000', 10),
    },
};

console.log('\nConfiguración:');
console.log('  Chatwoot URL:', config.chatwoot.url || '(no configurado)');
console.log('  Chatwoot Account ID:', config.chatwoot.accountId);
console.log('  OpenClaw WS:', config.openclaw.wsUrl || '(no configurado)');
console.log('  Bridge Port:', config.bridge.port);
console.log('');

// Validar configuración mínima
const missingVars = [];
if (!config.chatwoot.url) missingVars.push('CHATWOOT_URL');
if (!config.chatwoot.apiToken) missingVars.push('CHATWOOT_API_ACCESS_TOKEN');
if (!config.openclaw.wsUrl) missingVars.push('OPENCLAW_WS_URL');
if (!config.openclaw.gatewayToken) missingVars.push('OPENCLAW_GATEWAY_TOKEN');

if (missingVars.length > 0) {
    console.error('❌ Variables de entorno faltantes:');
    missingVars.forEach(v => console.error(`   - ${v}`));
    console.error('\nEl bridge continuará corriendo pero sin funcionalidad.');
    console.error('Configura las variables y reinicia el contenedor.\n');
} else {
    console.log('✅ Configuración completa\n');

    // TODO: Implementar lógica de bridge
    // 1. Conectar WebSocket a OpenClaw
    // 2. Polling o webhook desde Chatwoot
    // 3. Procesar mensajes y enviar respuestas

    console.log('⚠️  Lógica de bridge pendiente de implementación');
    console.log('    Por ahora, el servicio solo proporciona health check.\n');
}

// Health check HTTP server
const server = http.createServer((req, res) => {
    if (req.url === '/health' || req.url === '/') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            status: 'ok',
            service: 'chatwoot-agent-bridge',
            configured: missingVars.length === 0,
            missingVars: missingVars.length > 0 ? missingVars : undefined,
            timestamp: new Date().toISOString(),
        }));
    } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Not Found' }));
    }
});

server.listen(config.bridge.port, () => {
    console.log(`🚀 Bridge health check listening on port ${config.bridge.port}`);
    console.log(`   Health check: http://localhost:${config.bridge.port}/health\n`);
    console.log('='.repeat(80));
    console.log('Bridge running. Press Ctrl+C to stop.');
    console.log('='.repeat(80) + '\n');
});

// Manejo de señales
process.on('SIGTERM', () => {
    console.log('\n📛 SIGTERM recibido, cerrando...');
    server.close(() => {
        console.log('✅ Bridge cerrado correctamente');
        process.exit(0);
    });
});

process.on('SIGINT', () => {
    console.log('\n📛 SIGINT recibido, cerrando...');
    server.close(() => {
        console.log('✅ Bridge cerrado correctamente');
        process.exit(0);
    });
});
