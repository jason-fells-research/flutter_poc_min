# Minimal Flutter POC (FE-only)
Scope: Web FE parity demo — login skipped — tasks list with REST calls to a simple mock (json-server).
Run:
1) npx json-server --port 8080 --watch ../db.json
2) flutter run -d chrome --dart-define=BASE_URL=http://localhost:8080

Notes:
- Optimistic UI on toggle/delete for clean demo (server sync attempted).
- No container/K8s/hardening etc. Only FE touchpoints as requested.
