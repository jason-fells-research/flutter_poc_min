const fs = require('fs');
const path = require('path');

module.exports = (req, res) => {
  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const dbPath = path.join(process.cwd(), 'db.json');
  let db;
  try {
    db = JSON.parse(fs.readFileSync(dbPath, 'utf8'));
  } catch (e) {
    // Fallback so UI isn't empty even if db.json is missing
    db = {
      tasks: [
        { id: 1, title: 'Inviare il video demo', done: false },
        { id: 2, title: 'Aggiornare la UI (checkbox)', done: false },
        { id: 3, title: 'Rendere pubblico il repo', done: true }
      ]
    };
  }

  // Match /tasks or /tasks/:id
  const m = req.url.match(/^\/tasks(?:\/([^\/\?]+))?/);
  if (!m) return res.status(404).json({ error: 'NOT_FOUND' });

  const id = m[1];
  const tasks = Array.isArray(db.tasks) ? db.tasks : [];

  if (!id) return res.status(200).json(tasks);

  const item = tasks.find(t => String(t.id) === String(id));
  if (!item) return res.status(404).json({ error: 'TASK_NOT_FOUND' });
  return res.status(200).json(item);
};
