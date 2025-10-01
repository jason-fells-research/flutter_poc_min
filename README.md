# Minimal Flutter POC (web)

# Minimal Flutter POC (web) — IT

**LIVE**: https://flutterpocmin.vercel.app  
**API**: `GET /tasks`, `GET /tasks/:id`

## Funzioni
- Lista attività con checkbox e elimina (UI ottimistica, demo)
- Backend mock JSON (`db.json`, sola lettura) su Vercel Function

## Avvio locale
```bash
# 1) API mock su 8080
npx json-server --port 8080 --watch ./db.json

# 2) Flutter Web in locale (usa BASE_URL per puntare alla funzione mock)
flutter run -d chrome --dart-define=BASE_URL=http://localhost:8080
