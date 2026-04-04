import express from 'express';
import cors from 'cors';
import axios from 'axios';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import * as dotenv from 'dotenv';

dotenv.config();

// ─── ESM __dirname shim ───────────────────────────────────────────────────────
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// ─── Config ───────────────────────────────────────────────────────────────────
const PORT = process.env.FRONTEND_PORT || process.env.PORT || 3000;
const BACKEND_URL =
  process.env.BACKEND_URL || 'https://web-production-f4365.up.railway.app';
const NODE_ENV = process.env.NODE_ENV || 'production';

// ─── App setup ────────────────────────────────────────────────────────────────
const app = express();

// ─── View engine ─────────────────────────────────────────────────────────────
app.set('view engine', 'ejs');
app.set('views', join(__dirname, 'views'));

// ─── CORS ─────────────────────────────────────────────────────────────────────
const allowedOrigins = [
  'https://frontend-production.up.railway.app',
  BACKEND_URL,
  'http://localhost:3000',
  'http://localhost:8080',
];

app.use(
  cors({
    origin: (origin, callback) => {
      // Allow requests with no origin (e.g. curl, Postman, same-origin)
      if (!origin) return callback(null, true);
      if (allowedOrigins.includes(origin)) return callback(null, true);
      callback(new Error(`CORS policy: origin ${origin} not allowed`));
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  })
);

// ─── Body parsers ─────────────────────────────────────────────────────────────
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// ─── Static files ─────────────────────────────────────────────────────────────
app.use(express.static(join(__dirname, 'public'), { maxAge: '1d' }));

// ─── Security headers ─────────────────────────────────────────────────────────
app.use((_req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'SAMEORIGIN');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  next();
});

// ─── Request logger (dev only) ────────────────────────────────────────────────
if (NODE_ENV !== 'production') {
  app.use((req, _res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
  });
}

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({
    status: 'OK',
    service: 'nexaflow-frontend',
    version: '3.0.0',
    timestamp: new Date().toISOString(),
    environment: NODE_ENV,
    backendUrl: BACKEND_URL,
  });
});

// ─── API proxy ────────────────────────────────────────────────────────────────
// All requests to /api/* are forwarded to the Spring Boot backend.
app.use('/api', async (req, res) => {
  const targetUrl = `${BACKEND_URL}/api${req.path}`;

  try {
    const headers = {
      'Content-Type': req.headers['content-type'] || 'application/json',
      Accept: req.headers['accept'] || 'application/json',
    };

    // Forward the Authorization header when present (JWT bearer tokens)
    if (req.headers['authorization']) {
      headers['Authorization'] = req.headers['authorization'];
    }

    const response = await axios({
      method: req.method,
      url: targetUrl,
      params: req.query,
      data: ['GET', 'HEAD', 'DELETE'].includes(req.method.toUpperCase())
        ? undefined
        : req.body,
      headers,
      timeout: 30_000,
      validateStatus: () => true, // forward all HTTP status codes as-is
    });

    // Mirror response headers that are safe to forward
    const forwardHeaders = ['content-type', 'cache-control', 'etag'];
    forwardHeaders.forEach((h) => {
      if (response.headers[h]) res.setHeader(h, response.headers[h]);
    });

    res.status(response.status).json(response.data);
  } catch (err) {
    const isTimeout = err.code === 'ECONNABORTED' || err.code === 'ETIMEDOUT';
    const isUnreachable =
      err.code === 'ECONNREFUSED' || err.code === 'ENOTFOUND';

    console.error(
      `[proxy] ${req.method} ${targetUrl} →`,
      err.message || err.code
    );

    if (isTimeout) {
      return res
        .status(504)
        .json({ error: 'Gateway Timeout', message: 'Backend did not respond in time.' });
    }
    if (isUnreachable) {
      return res
        .status(502)
        .json({ error: 'Bad Gateway', message: 'Cannot reach the backend service.' });
    }

    res
      .status(500)
      .json({ error: 'Proxy Error', message: 'An unexpected error occurred.' });
  }
});

// ─── Catch-all: serve index.html (SPA / EJS fallback) ────────────────────────
// If views/index.ejs exists, render it; otherwise fall back to public/index.html.
app.get('*', (req, res) => {
  const ejsIndex = join(__dirname, 'views', 'index.ejs');

  res.render('index', { backendUrl: BACKEND_URL, env: NODE_ENV }, (err, html) => {
    if (err) {
      // No EJS template — try the static public/index.html
      const staticIndex = join(__dirname, 'public', 'index.html');
      return res.sendFile(staticIndex, (sendErr) => {
        if (sendErr) {
          res.status(404).json({
            error: 'Not Found',
            message: 'No index page found. Add views/index.ejs or public/index.html.',
          });
        }
      });
    }
    res.send(html);
  });
});

// ─── Global error handler ─────────────────────────────────────────────────────
app.use((err, _req, res, _next) => {
  console.error('[error]', err.message || err);
  const status = err.status || err.statusCode || 500;
  res.status(status).json({
    error: err.name || 'Internal Server Error',
    message:
      NODE_ENV === 'production'
        ? 'Something went wrong. Please try again later.'
        : err.message,
  });
});

// ─── Start ────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`✅  NexaFlow Frontend running on port ${PORT}`);
  console.log(`   Environment : ${NODE_ENV}`);
  console.log(`   Backend URL : ${BACKEND_URL}`);
  console.log(`   Health check: http://localhost:${PORT}/health`);
});

export default app;
