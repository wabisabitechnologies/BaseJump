# Changelog

Running log of work sessions, intended so work can resume cleanly from
any machine. Newest entry on top. Each entry: what changed, what was
verified, and what's left for next time.

---

## 2026-06-22 — Verified app boots end-to-end; found a Turbo gap in todo creation

**Context:** Picking up after the S0-01 routing fix (below). Goal was to
run the app locally and confirm it actually works, not just that routes
resolve.

**Done / verified (browser-driven, headless Chrome via Playwright):**
- Booted with `bin/rails server` against the local Postgres dev DB
  (no Doppler needed for local dev — `DATABASE_URL` unset falls back to
  default Postgres config in `config/database.yml`).
- `/` → sign-in form renders correctly, matches the Basecamp beige/blue
  design system (screenshot confirmed).
- Logged in as `johndoe` / `password` → redirects to `/home`, dashboard
  renders Company HQ / Teams / Projects sections correctly.
- Clicked into a project (`/projects/1`) → tool card page renders.
- Clicked into Todo Lists (`/projects/1/todo_lists`) → index renders,
  "New todo list..." create form present.
- Created a todo list via the form → controller redirects straight to
  the list's `show` page (REST `create` → `show`, not back to index —
  expected, not a bug).
- Added a todo via the show page's inline form → todo was created and
  appeared.
- No browser console errors or page errors at any step.

**Found, not yet fixed — Turbo gap in todo creation:**
`app/views/todo_lists/show.html.erb`'s "Add a new todo" form uses
`form_with model: [@todo_list, @todo_list.todos.new], local: true`.
`local: true` forces a plain (non-Turbo) full-page submit. But
`TodosController#create` (`app/controllers/todos_controller.rb`)
supports `format.turbo_stream`, and `app/views/todos/create.turbo_stream.erb`
exists to append the new todo via Turbo Stream. Net effect: that
turbo_stream template is currently dead code — every todo creation does
a full page reload instead of a live append. The toggle form (same
view, checkbox) is *not* `local: true` and does use
`data: { turbo_stream: true }`, so toggling already works live — only
creation is inconsistent. **Next step:** drop `local: true` from the
create form (or add `data: { turbo_stream: true }`) and confirm the
`create.turbo_stream.erb` partial renders correctly.

**Tooling note for next machine:** `chromium-cli` (the harness's usual
browser driver) is not installed in this environment. Worked around it
by `npm install playwright` in `/tmp/pw-driver` and launching with
`channel: 'chrome'` against the system-installed Google Chrome (no
matching Playwright-bundled Chromium build was cached). If `chromium-cli`
is available on the next machine, prefer that instead.

**Local dev DB side effect:** the verification run created a real
"Smoke Test List" todo list (with one "Smoke test todo") under project
1 (Company HQ) in the local `basejump_development` database. Harmless,
but delete it via `bin/rails console` if it clutters manual testing.

---

## 2026-06-21 — Restored Sprint 0 Hotwire routing (S0-01), commit `00c66f2`

**Done:**
- Found that merging `feature/hotwire-restoration` into `master`
  (commit `76aeb6d`) silently reverted `config/routes.rb` to its
  pre-Hotwire state — `root` and `/home` were still pointing at
  `react_app#index` (broken React placeholder), even though Sprint 0
  (`.kilo/plans/rails-8-upgrade-with-hotwire-phased-tickets.md`,
  ticket S0-01) was supposed to have fixed this on the feature branch.
- Fixed: `root` → `sessions#new`, `/home` → `pages#home`. Scoped the
  React SPA to `/app` and `/app/*path` instead of a blanket `get '*path'`
  catch-all, so unported Phase 2 features (calendar, kanban — still
  served via the legacy `api` namespace + React) stay reachable without
  swallowing every unmatched route.
- Verified via `curl`: `/` renders the sign-in form, `/home` redirects
  logged-out users to `/` and renders the dashboard for a real logged-in
  session, `/app/foo` still serves the React shell.
- Audited the rest of Sprint 0 (S0-02 through S0-07) and found it was
  already done on `master` — todo list / project / home views already
  use the correct SCSS classes (`.main-app`, `.app-nav`, `.tool-page`,
  etc.), and the `.name`/`.title` mismatch noted as a "known bug" in
  prior notes was already fixed in commit `c7a3bcb`.

**Not started (flagged, explicitly deferred per user choice):**
- **P1-05 drag-drop:** dragging a loose todo into/out of a todo list
  has no Stimulus controller yet — only `hello_controller.js` (the
  Rails default stub) exists under `app/javascript/controllers/`.
- **Phase 2, S0-06 follow-on:** `messages_controller.rb` and
  `events_controller.rb` (+ views) don't exist yet, so
  `ProjectsController#show` only renders a Todo Lists tool card, not
  Messages/Events. Routes for both already exist in `config/routes.rb`
  (`resources :messages`, `resources :events` nested under `:projects`)
  but will 404/error on missing controller until built.

---

## How to resume

1. `git pull` — this changelog and the routing fix are the only
   uncommitted-then-pushed work; nothing else is pending in the working
   tree.
2. Read `.kilo/plans/rails-8-upgrade-with-hotwire-phased-tickets.md` for
   ticket definitions and `.skills/rule/basejump-architecture.md` for
   SCSS class conventions and gotchas before writing new views.
3. Local dev: `bin/rails server` (Doppler optional locally; required
   only if pointing at the NeonDB-backed `DATABASE_URL`). Run
   `bin/rails dartsass:build` once if `app/assets/builds/application.css`
   looks stale.
4. Suggested next ticket, in order of smallest-to-largest: fix the
   todo-creation Turbo gap above (small), then P1-05 drag-drop, then
   Phase 2 (`P2-02` Message Board or `P2-04` Events & Calendar).
