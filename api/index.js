import fs from 'fs';
import path from 'path';

export default function handler(req, res) {
  // CORS (safe for your FE + curl)
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') { res.status(200).end(); return; }

  const dbPath = path.join(process.cwd(), 'db.json');
  let db;
  try {
    db = JSON.parse(fs.readFileSync(dbPath, 'utf8'));
  } catch (e) {
    res.status(500).json({ error: 'DB_READ_FAILED', details: String(e) });
    return;
  }

  // /tasks or /tasks/:id
  const match = req.url.match(/^\/tasks(?:\/([^\/?#]+))?$/);
  if (!match) {
    res.status(404).json({ error: 'NOT_FOUND' });
    return;
  }

  const id = match[1];
  if (!id) {
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.status(200).end(JSON.stringify(db.tasks ?? []));
    return;
  }

  const item = (db.tasks ?? []).find(t => String(t.id) === String(id));
  if (!item) { res.status(404).json({ error: 'TASK_NOT_FOUND' }); return; }

  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  res.status(200).end(JSON.stringify(item));
}
