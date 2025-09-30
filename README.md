# flutter_poc_min
Simple Flutter FE
EN: 
Scope: Web FE parity demo — login skipped — tasks list with REST calls to a simple mock (json-server).
Run:
1) npx json-server --port 8080 --watch ../db.json
2) flutter run -d chrome --dart-define=BASE_URL=http://localhost:8080

Notes:
- Optimistic UI on toggle/delete for clean demo (server sync attempted).
- No container/K8s/hardening etc. Only FE touchpoints as requested.

IT
Ambito: demo di parità Web FE — login saltato — lista di attività con chiamate REST a un mock semplice (json-server).
Esecuzione:

npx json-server --port 8080 --watch ../db.json

flutter run -d chrome --dart-define=BASE_URL=http://localhost:8080

Note:

UI ottimistica su toggle/cancellazione per una demo pulita (sincronizzazione con server tentata).

Nessun container/K8s/rafforzamento ecc. Solo punti di contatto FE come richiesto.
