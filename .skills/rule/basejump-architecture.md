# BaseJump Architecture & Conventions

## Architecture Decision

**Hotwire/ERB is the primary rendering path.** The React SPA is archived. All new features are server-rendered ERB with Turbo Streams for interactivity.

## Styling Pipeline

- **SCSS via Propshaft + dartsass-rails** — no Node, no PostCSS, no Tailwind CLI.
- Compile: `bin/rails dartsass:build` (one-shot) or `bin/rails dartsass:watch` (watch mode).
- `bin/dev` starts both dartsass watch + Rails server.
- CSS URL is fingerprinted: `/assets/application-<digest>.css` — Propshaft handles this.
- Never reference `/stylesheets/` — that's the old Sprockets path.

## SCSS Design System (File Map)

All SCSS lives in `app/assets/stylesheets/` and is compiled via `application.scss`:

| File | What it provides |
|---|---|
| `base/colors.scss` | `$landing-blue`, `$basecamp-beige`, `$signup-blue`, `$submit-green`, `$landing-dark`, etc. |
| `base/fonts.scss` | `$sans-serif` (Noto Sans), `$serif` (Noto Serif) |
| `base/reset.scss` | CSS reset |
| `bootstrap_lite/buttons.scss` | `.btn`, `.btn-primary`, `.btn-submit`, `.btn-cancel`, `.btn-normal` — ~80 lines, NOT Twitter Bootstrap |
| `landing_page/main.scss` | `.landing-page-main`, `.landing-nav`, `.form-page` |
| `landing_page/navbar.scss` | `.landing-nav` — landing page nav bar |
| `landing_page/session_form.scss` | `.form-page` — auth form container with `.formHeader`, `.signup` badge, form inputs, `.barred-span` |
| `main_app/main.scss` | `.main-app` (beige background, min-height: 100vh), `.main-app-content` |
| `main_app/navbar.scss` | `.app-nav` — app nav bar (light beige, logo 37px, user dropdown) |
| `main_app/project_section.scss` | `.project-section` (775px wide), `.project-divider`, `.card-holder`, `.card`, `.project-card` |
| `main_app/project_show.scss` | `.project-page` (centered), `ul.tools`, `li.tool-card` (260x260) |
| `main_app/tool/tool_main.scss` | `.tool-page`, `.main-tool` (765px white card), `.todolists`, `.todolist-item`, `.todo` |
| `main_app/tool/todolist_form.scss` | `.tool-form`, `.tool-form.todolist`, `.input-fields`, `.submit-buttons` |

## Key CSS Classes for ERB Views

### Auth Pages (`.form-page`)
```
<div class="form-page">
  <a href="/"><img src="https://res.cloudinary.com/basejump/image/upload/v1580630789/basecamp-logo-mini.png" /></a>
  <form class="session-form [sign-up-form]">
    <div class="formHeader">
      <span class="signup">Sign up for Basejump</span>  ← signup only
      <p class="barred-span">Type your email address</p>
    </div>
    <div class="signup-fields">...</div>  ← signup only
    <label>...</label>
    <input ... />
    <br>
    <input class="btn btn-submit" type="submit" value="Login" />
  </form>
  <span>Don't have an account? <a href="/users/new">Sign up here!</a></span>
</div>
```

### App Pages (`.main-app`)
```
<div class="main-app">
  <nav class="app-nav">
    <div style="display: flex; align-items: center;">
      <a href="/home" class="logo">
        <img src="https://res.cloudinary.com/basejump/image/upload/v1580630789/basecamp-logo-mini.png" />
      </a>
      <a href="/home" class="logo" style="margin-left: 5px;"><span>Home</span></a>
    </div>
    <div>
      <span><%= current_user.name %></span>
      <%= button_to "Logout", session_path, method: :delete, class: "btn btn-normal" %>
    </div>
  </nav>
  <div class="main-app-content">...</div>  <!-- or .tool-page for tool views -->
</div>
```

### Tool Pages (`.tool-page`)
```
<div class="tool-page">
  <header><span><%= link_to "← #{@project.name}", project_path(@project) %></span></header>
  <div class="main-tool">
    <h1>Page Title</h1>
    <div class="tool-form [todolist]">...</div>
    <div class="todolists">
      <div class="todolist-item">...</div>
    </div>
  </div>
</div>
```

### Todo Item (`.todo` class, NOT Tailwind)
```
<div id="<%= dom_id(todo) %>" class="todo">
  <%= form_with model: todo, url: toggle_todo_path(todo), method: :patch, data: { turbo_stream: true } do |f| %>
    <%= f.check_box :done, { checked: todo.done, onchange: "this.form.requestSubmit()" }, "true", "false" %>
  <% end %>
  <div style="margin-left: 8px;">
    <span style="<%= 'text-decoration: line-through; color: #999;' if todo.done %>"><%= todo.title %></span>
  </div>
</div>
```

## Git Branch Topology

| Branch | Contents | Status |
|---|---|---|
| `master` | Original upstream with React SPA + Tailwind v4 + Storybook | Not for front-line work |
| `archive/react-spa-stack` | The React SPA codebase at `origin/master` | Archived reference only |
| `feature/hotwire-restoration` | Working Hotwire app with SCSS design system | **Active development** |

Do not commit to `master` — commit to `feature/hotwire-restoration` and PR from there.

## Common Gotchas (read these before coding)

1. **CSS not loading**: `stylesheet_link_tag "application"` generates fingerprint URL. Run `bin/rails dartsass:build` after SCSS changes. Verify with `curl -sI /assets/application-*.css`.
2. **Propshaft not installed**: `gem 'propshaft'` and `gem 'dartsass-rails'` are required. Without them, no CSS pipeline exists.
3. **Wrong logo URL**: Auth pages use `basecamp-logo-mini.png` (Cloudinary URL ending in `.../basecamp-logo-mini.png`). App nav also uses this. The SVG (`basecamp-logo.svg`) is only used on the landing nav.
4. **Form structure matters**: The `.signup` badge is INSIDE `.formHeader` which is INSIDE `<form>`. It floats above the form via `position: absolute; bottom: 97%; left: 29%`.
5. **Checkbox styling**: The SCSS has custom checkbox styles (`.done .check-box`) but they depend on specific label-checkbox sibling structure. For Turbo Stream forms, use simple checkboxes — the `.todo` class provides flex layout.
6. **No `get '*path'` catch-all**: The Hotwire branch does NOT have the React catch-all route. Unknown paths 404 normally.
7. **`assets:precompile` unavailable**: Propshaft doesn't have this Rake task. Use `rails dartsass:build` instead.
8. **SCSS deprecation warnings**: The SCSS uses `@import` (deprecated in Dart Sass 3.0) and `transparentize()`/`random()` (deprecated). These are warnings, not errors. Plan to migrate to `@use` and `color.adjust()` in Phase 5.

## Future CSS Strategy (per roadmap)

- SCSS + utility classes in `application.css` is the primary styling layer.
- If Tailwind is added, use v3 via `tailwindcss-rails` gem (standalone binary, no Node).
- Tailwind coexists with existing SCSS component classes — swap one class at a time.
- No Tailwind v4 until the environment supports Node 20+.

## Working with Turbo Streams

- `data: { turbo_stream: true }` on forms enables Turbo Stream responses.
- Controller actions respond with `.turbo_stream.erb` templates to update page content.
- Existing Turbo Stream templates: `app/views/todos/create.turbo_stream.erb`, `app/views/todos/toggle.turbo_stream.erb`.

## MoSCoW for Feature Work

When implementing a feature, prioritize:

| Priority | Definition |
|---|---|
| **Must** | App crashes or feature is completely unusable without it |
| **Should** | Feature works but UX is degraded (missing nav, wrong colors) |
| **Could** | Nice-to-have: polish, animations, responsive |
| **Won't** | Explicitly deferred to later phase per roadmap |

Do not spend time on "Could" until all "Must" and "Should" items are done. Do not start "Won't" without explicit approval.

## Decision Log (Added to Roadmap Updates)

| Topic | Decision | Rationale |
|---|---|---|
| Styling Pipeline | SCSS via Propshaft + dartsass-rails | Works now, no Node dependency |
| Future CSS | Tailwind v3 via `tailwindcss-rails` gem | Standalone binary, coexists with SCSS |
| Architecture | Hotwire/ERB (server-rendered) | Project roadmap's own destination |
| React SPA | Archived to `archive/react-spa-stack` | Preserved for unported features |
| Rich Text | Trix for Phase 1-3, TipTap for Phase 4 | Trix integrates with Hotwire; TipTap for graph |
| Realtime | ActionCable | Native Rails 8, works with Turbo Streams |
| DB | PostgreSQL (existing) | Already connected |
| Graph Library | D3.js via importmap | Good Hotwire compatibility |
| Search | pg_search | Postgres full-text search |

## Roadmap Reference

The canonical planning document is `.kilo/plans/rails-8-upgrade-with-hotwire-phased-tickets.md`. It defines all phases, acceptance criteria, and estimates. **Read this before starting any feature** — it tells you exactly what "done" looks like.

Every task below maps to a phase in that document. If a ticket doesn't match a roadmap item, flag it before coding.

---

## Phase-Indexed Patterns

### Phase 1: Loose Todos & Subtasks

**Stimulus controllers for drag-drop:**
```
# app/javascript/controllers/drag_todo_controller.js
import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() { this.element.setAttribute("draggable", "true") }
  dragStart(e) { e.dataTransfer.setData("text/plain", this.element.id) }
  dragOver(e) { e.preventDefault() }
  drop(e) { /* handle drop — POST to reorder endpoint */ }
}
```

Register in `app/javascript/controllers/index.js`:
```js
import { application } from "./application"
import DragTodoController from "./drag_todo_controller"
application.register("drag-todo", DragTodoController)
```

**Existing todo patterns to follow:**
- `app/views/todos/_todo.html.erb` — turbo stream toggle via `data: { turbo_stream: true }`
- `app/views/todos/create.turbo_stream.erb` — append new todo
- `app/views/todos/toggle.turbo_stream.erb` — update done state

### Phase 2: Message Board, Events, Calendar

**Trix editor via Action Text:**
```erb
<%= form.rich_text_area :body, data: { controller: "trix" } %>
```
Already in Gemfile via `actiontext` (bundled with Rails 8). No additional gems needed.

**Porting from React SPA:**
The archived React components are in `archive/react-spa-stack`:
```
git show archive/react-spa-stack:frontend/components/message_board/message_board_container.jsx
git show archive/react-spa-stack:frontend/components/schedule/events_index_container.jsx
```
Read the React component to understand the data model and UI flow, then implement the equivalent in ERB + Turbo Streams + Stimulus. Do NOT copy JSX — extract the data requirements and interaction patterns.

**Calendar SCSS:** `app/assets/stylesheets/main_app/tool/events.scss` already exists for the event list. The React SPA used `react_calendar/main.scss` — this can be adapted for a Hotwire calendar view.

### Phase 3: Hill Charts, Kanban, Everything Page

**Hill Charts (P3-02):**
Renders an SVG with curved hill + dot position. Plain Stimulus controller + SVG template in ERB:
```erb
<svg viewBox="0 0 300 150" data-controller="hill-chart">
  <!-- Hill curve: quadratic bezier from (0,150) to (150,0) to (300,150) -->
  <path d="M 0,150 Q 75,-30 150,15 Q 225,60 300,150" fill="none" stroke="#ccc" stroke-width="2"/>
  <!-- Dot at current progress -->
  <circle cx="<%= hill_x_position(@todo_list.progress_percent) %>" cy="<%= hill_y_position(@todo_list.progress_percent) %>" r="8" fill="#007BB6"/>
</svg>
```
Math for hill position: `x = progress/100 * 300`, `y = 150 - 2 * progress * (150 - progress) / 150`. No library needed.

**Kanban/Card Tables (P3-03):**
Stimulus controller for drag-drop between columns. Each column is a Turbo Frame. Cards are draggable elements. On drop, `POST` to a reorder endpoint that returns a Turbo Stream update.

**Importmap for JS libraries (P3-05+):**
```ruby
# config/importmap.rb
pin "d3", to: "https://cdn.jsdelivr.net/npm/d3@7/+esm"
```
Then in Stimulus controller: `import * as d3 from "d3"`. No npm/node needed.

### Phase 4: Knowledge Graph

**D3.js graph rendering:**
```erb
<div data-controller="knowledge-graph" data-knowledge-graph-nodes-value="<%= @nodes.to_json %>" data-knowledge-graph-edges-value="<%= @edges.to_json %>">
  <svg></svg>
</div>
```
Stimulus controller fetches data from `data-*` attributes, D3 renders force-directed layout inside the SVG. Keep the controller in `app/javascript/controllers/`.

**pg_search (P4-05):**
```ruby
# app/models/note.rb
include PgSearch::Model
pg_search_scope :search, against: [:title, :body], using: { tsearch: { dictionary: "english" } }
```

**TTipTap for structured JSON (P4-01):**
Added via importmap. Wraps a hidden textarea with JSON content. Only needed once TipTap-based note editing is required — Phase 1-3 uses Trix (Action Text).

### Phase 5: Polish & Deploy

**SCSS migration (deprecation fixes):**
Before Dart Sass 3.0 drops `@import`, migrate to `@use`:
```scss
// Before (DEPRECATED)
@import "base/colors";
// After
@use "base/colors" as *;
```
Same for `random()` → `math.random()` and `transparentize()` → `color.adjust()`.

**Mobile responsiveness:** The `.main-app`, `.project-section` (775px), `.main-tool` (765px), `.tool-card` (260px) all have fixed widths. Add `@media` queries to make them fluid:
```scss
@media (max-width: 800px) {
  .project-section { width: 100%; }
  .main-tool { width: 100%; }
}
```

---

## How to Port Features from the Archived React SPA

The archived React SPA (branch `archive/react-spa-stack`) contains the reference implementation for messages, events, calendar, and kanban. To port a feature:

1. Read the React container/component to understand the data model
2. Check the API controller (`app/controllers/api/<resource>_controller.rb`) for the backend endpoints
3. Create a Hotwire controller (ERB) following the existing pattern (e.g., `TodoListsController`)
4. Create views following the `.tool-page` / `.main-tool` SCSS structure
5. Add Stimulus controllers for interactivity (drag-drop, modals, live updates)
6. Style with existing SCSS classes from `main_app/tool/` — add new SCSS if needed

View the archived SPA files:
```bash
git show archive/react-spa-stack:frontend/components/<feature>/
git show archive/react-spa-stack:app/controllers/api/<resource>_controller.rb
```

Do NOT copy JSX directly. Extract the data requirements, UI states, and interaction patterns, then implement in ERB.

---

## Importmap Conventions

All JS dependencies are managed through `config/importmap.rb` (no package.json, no node_modules):
```ruby
# config/importmap.rb
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Third-party libraries (when needed):
pin "d3", to: "https://cdn.jsdelivr.net/npm/d3@7/+esm"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
```

To add a new library:
```bash
bin/rails importmap:pin <package-name>     # auto-resolves CDN URL
```

Stimulus controllers live in `app/javascript/controllers/` and auto-register via `controllers/index.js`.

---

## How This Skill Connects to Each Phase

| Phase | Skill Section to Read | What It Prevents |
|---|---|---|
| Sprint 0 (done) | SCSS Design System, Gotchas, CSS classes | Wrong form structure, wrong logo, CSS 404s |
| Phase 1 | Turbo Streams, Stimulus patterns, Todo examples | Reimplementing toggle from scratch |
| Phase 2 | Porting from React SPA, Trix, Message board SCSS | Copying JSX verbatim, missing SCSS files |
| Phase 3 | Hill Chart math, Importmap, Kanban drag patterns | Adding npm/webpack for simple SVG |
| Phase 4 | D3.js via importmap, pg_search, TipTap | Installing Node for graph rendering |
| Phase 5 | SCSS migration, Mobile responsiveness | Deprecation breakage in Dart Sass 3.0 |
