# Minimal Flutter POC (web)

**Live FE + API base:** https://flutterpocmin.vercel.app

This is a minimal Proof-of-Concept showing a Flutter web frontend connected to a simple read-only API (served via Vercel).

## Demo Features
- Task list with checkbox + delete UI
- Backed by a mock JSON dataset (`db.json`)
- Optimistic UI for smooth demo (no full persistence)

## API Endpoints
- `GET /tasks` → list all tasks
- `GET /tasks/:id` → get a single task

## Sample Data (`db.json`)
```json
{
  "tasks": [
    { "id": 1, "title": "Inviare il video demo", "done": false },
    { "id": 2, "title": "Aggiornare la UI (checkbox)", "done": false },
    { "id": 3, "title": "Rendere pubblico il repo", "done": true }
  ]
}
