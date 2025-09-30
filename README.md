# Minimal Flutter POC (web)

**Live FE + API base:** https://flutterpocmin.vercel.app

## Demo Features
- Lista attività (UI con checkbox ed elimina)
- Backend mock JSON (`db.json`)
- UI ottimistica (solo demo)

## API (read-only)
- `GET /tasks` — elenco attività
- `GET /tasks/:id` — dettaglio

### Esempio `db.json`
```json
{
  "tasks": [
    { "id": 1, "title": "Inviare il video demo", "done": false },
    { "id": 2, "title": "Aggiornare la UI (checkbox)", "done": false },
    { "id": 3, "title": "Rendere pubblico il repo", "done": true }
  ]
}
