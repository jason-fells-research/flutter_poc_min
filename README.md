# Minimal Flutter POC (web) — IT

**LIVE:** https://flutterpocmin.vercel.app  
**API (read-only):** `GET /tasks`, `GET /tasks/:id` (stessa origine su Vercel)

## Funzioni
- Lista attività con checkbox ed elimina (UI ottimistica, demo)
- Backend mock JSON (`db.json`, sola lettura) servito da Vercel Function (`/api/index.js`)
- UI in italiano

## Avvio locale

### Web (consigliato)
Usa direttamente l’API di produzione (stessa origine) o passa `BASE_URL` se vuoi essere esplicito:

```bash
flutter clean
flutter pub get
flutter run -d chrome --dart-define=BASE_URL=https://flutterpocmin.vercel.app

### macOS / iOS / Android

Anche qui puoi puntare all’API di produzione per avere dati durante il debug:

```bash
flutter run -d macos --dart-define=BASE_URL=https://flutterpocmin.vercel.app

Non serve più json-server in locale: l’API mock è su Vercel.
