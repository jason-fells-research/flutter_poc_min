export default async function handler(req, res) {
  // CORS (safe for local dev + other origins)
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') { res.status(204).end(); return; }

  // Read-only tasks from db.json (one level up from /api)
  const { readFile } = await import('node:fs/promises');
  const path = new URL('../db.json', import.meta.url); // <— ONE level up
  const raw = await readFile(path, 'utf-8');
  const data = JSON.parse(raw);
  const tasks = Array.isArray(data.tasks) ? data.tasks : [];

  if (req.method === 'GET') {
    // /tasks or /tasks/:id
    const m = req.url.match(/^\/tasks(?:\/([^\/\?]+))?/);
    if (!m) { res.status(404).json({ error: 'Not found' }); return; }
    const id = m[1];
    if (!id) { res.status(200).json(tasks); return; }
    const item = tasks.find(t => String(t.id) === String(id));
    if (!item) { res.status(404).json({ error: 'Task not found' }); return; }
    res.status(200).json(item); return;
  }

  res.status(405).json({ error: 'Method not allowed' });
}
