export default async function handler(req, res) {
  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Simple read-only tasks backed by db.json
  const { readFile } = await import('node:fs/promises');
  const path = new URL('../../db.json', import.meta.url);
  const raw = await readFile(path, 'utf-8');
  const data = JSON.parse(raw);

  if (req.method === 'GET') {
    // /tasks or /tasks/:id
    const m = req.url.match(/^\/tasks(?:\/([^\/\?]+))?/);
    if (!m) { res.status(404).json({ error: 'Not found' }); return; }
    const id = m[1];
    if (!id) { res.status(200).json(data.tasks || []); return; }
    const item = (data.tasks || []).find(t => String(t.id) === String(id));
    if (!item) { res.status(404).json({ error: 'Task not found' }); return; }
    res.status(200).json(item); return;
  }

  res.status(405).json({ error: 'Method not allowed' });
}
