## What this repo is

Minimal Flutter POC (web-first) with a tiny read-only mock API served by a Vercel Function.

- Frontend: Flutter web (also runnable on macOS/iOS/Android). Entry: `lib/main.dart` -> `lib/tasks_page.dart`.
- API: `api/index.js` reads `db.json` at runtime and exposes two endpoints: `GET /tasks` and `GET /tasks/:id`.
- Deployment: Vercel routes (see `vercel.json`) map `/tasks` to the function at `api/index.js`.

## Key patterns an AI agent should know

- API base handling: `lib/api.dart` resolves the base URL from a dart-define named `BASE_URL`. On web the default is empty (same-origin). On native builds the default points to `https://flutterpocmin.vercel.app`.
  - Example: to run locally against production API: `flutter run -d chrome --dart-define=BASE_URL=https://flutterpocmin.vercel.app`
- Read-only backend: `Api.createTask`, `Api.updateTaskFull`, and `Api.deleteTask` are no-ops that delay briefly (see `lib/api.dart`). The UI (`lib/tasks_page.dart`) performs optimistic local updates; network writes are not persisted.
- Routing: `vercel.json` contains rewrite rules mapping `^/tasks(?:/.*)?$` to `/api/index.js`. Changing API routes requires updating that file and redeploying to Vercel.
- Mock data: `db.json` contains the canonical mock tasks used on Vercel. Editing `db.json` locally does not change a deployed instance—redeploy the function or run a local mock server for testing.

## Useful files to open when making changes

- `lib/api.dart` — API client and BASE_URL behavior (primary place to adapt network logic or add auth headers).
- `lib/tasks_page.dart` — UI and optimistic update patterns; shows how the app expects task objects: `{id, title, done}`.
- `api/index.js` — Vercel function that reads `db.json`; useful for modifying API behavior or error responses.
- `db.json` — mock dataset; primary source for task fixtures.
- `vercel.json` — routing for serverless function.
- `pubspec.yaml` — Flutter SDK constraints and main dependencies (http, flutter_secure_storage).

## How to run & debug locally (explicit commands)

- Install deps: `flutter pub get`
- Run web against production mock API (recommended):

    flutter clean
    flutter pub get
    flutter run -d chrome --dart-define=BASE_URL=https://flutterpocmin.vercel.app

- Run native (macOS/iOS/Android) against production API:

    flutter run -d macos --dart-define=BASE_URL=https://flutterpocmin.vercel.app

- Local API experimentation: the repo includes `db.json` and a Vercel function. You can:
  - Edit `db.json` and deploy to Vercel (recommended for parity), OR
  - Run a local json-server against `db.json` (package present in `package.json`) to quickly test shape-only responses (note: `api/index.js` is a Vercel handler, not a drop-in json-server route).

## Conventions and non-obvious choices

- Single source of truth for API base: `BASE_URL` via `--dart-define`; do not hardcode URLs in widgets—use `Api`.
- UI assumes optimistic updates and will mutate local state before awaiting API calls; preserve this behavior unless intentionally changing UX.
- The mock API uses filesystem reads (`fs.readFileSync`) — editing `api/index.js` to write DB changes would require switching to a writable store and rethinking deployment.

## PR guidance for AI agents

- Small UI change: update `lib/tasks_page.dart` and run web locally with the `--dart-define` above to validate.
- API change (behavior or schema): update `api/index.js` and `db.json` together, and update `vercel.json` if routes change. Note: deploy to Vercel to fully validate runtime behavior.
- Tests: project includes `flutter_test` in `dev_dependencies`; add widget tests under `test/` to validate UI flows. Run `flutter test`.

## Example edits an agent might be asked to make (and where to look)

- Add a `created_at` field to tasks: update `db.json` fixture, `api/index.js` (if you want server to return that), and UI rendering in `lib/tasks_page.dart`.
- Switch API client to include an Authorization header: edit `lib/api.dart` and add a constructor param or environment read; update usages in `lib/main.dart`.

If anything in these notes is unclear or you want the file to include additional examples (scripts, test commands, or CI hooks), tell me which areas to expand and I’ll iterate.
