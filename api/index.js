const fs = require('fs');
const path = require('path');

function loadTasks() {
  const file = path.join(process.cwd(), 'db.json');
  const raw = fs.readFileSync(file, 'utf-8');
  const parsed = JSON.parse(raw);
  return Array.isArray(parsed) ? parsed : (parsed.tasks || []);
}

module.exports = (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Read-only. Use GET.' });

  // Support /tasks and /tasks/:id
  const match = req.url.match(/^\/tasks\/?([^/?#]+)?/);
  const id = match && match[1];

  const tasks = loadTasks();
  if (id) {
    const item = tasks.find(t => String(t.id) === String(id));
    return item ? res.json(item) : res.status(404).json({ error: 'Not found' });
  }
  res.json(tasks);
};