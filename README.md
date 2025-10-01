# Minimal Flutter POC (web) — EN

**LIVE:** https://flutterpocmin.vercel.app  
**API (read-only):** `GET /tasks`, `GET /tasks/:id` (same origin on Vercel)

## Features
- Task list with checkboxes and delete (optimistic UI, demo)
- Mock backend JSON (`db.json`, read-only) served by a Vercel Function (`/api/index.js`)
- UI in Italian

## Local Development

### Web (recommended)
Use the production API (same origin) or pass `BASE_URL` explicitly:

    flutter clean
    flutter pub get
    flutter run -d chrome --dart-define=BASE_URL=https://flutterpocmin.vercel.app

### macOS / iOS / Android
You can also point to the production API during native debug:

    flutter run -d macos --dart-define=BASE_URL=https://flutterpocmin.vercel.app

No local json-server is required. The mock API is on Vercel.

---

# Minimal Flutter POC (web) — IT

**LIVE:** https://flutterpocmin.vercel.app  
**API (solo lettura):** `GET /tasks`, `GET /tasks/:id` (stessa origine su Vercel)

## Funzioni
- Lista attività con checkbox ed elimina (UI ottimistica, demo)
- Backend mock JSON (`db.json`, solo lettura) servito da una Vercel Function (`/api/index.js`)
- Interfaccia in italiano

## Avvio locale

### Web (consigliato)
Usa l’API di produzione (stessa origine) oppure passa `BASE_URL` in modo esplicito:

    flutter clean
    flutter pub get
    flutter run -d chrome --dart-define=BASE_URL=https://flutterpocmin.vercel.app

### macOS / iOS / Android
Puoi puntare all’API di produzione anche durante il debug nativo:

    flutter run -d macos --dart-define=BASE_URL=https://flutterpocmin.vercel.app

Non serve più json-server in locale: l’API mock è su Vercel.
