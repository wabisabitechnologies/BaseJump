# Rails 8 + Hotwire Restoration — Phased Ticket Breakdown

## Overview

This plan rebuilds BaseJump as a Hotwire/ERB application using the existing SCSS design system compiled through Propshaft. Phases 1-3 migrate and enhance core functionality, Phase 4 adds knowledge-graph features, Phase 5 polishes and deploys.

The React SPA, Storybook, and Tailwind v4 work from commit `5b5df88` have been archived to `archive/react-spa-stack`. The feature branch `feature/hotwire-restoration` (based on `5ba4cc7` + `c7a3bcb`) contains the Hotwire foundation, ERB controllers/views, and the Propshaft-backed SCSS pipeline. Future work builds on that branch.

---

## Sprint 0: SCSS Design System Restoration (Days 1-2)

**Goal:** Apply the existing SCSS design system (Basecamp beige/blue from the original fork) to the Hotwire ERB views so they match the original app's visual design. This is prerequisite for every subsequent phase.

**Estimate:** 1-2 days

### S0-01: Route root/home back to Hotwire
**Files:** `config/routes.rb`
**Estimate:** 10 min
**Acceptance Criteria:**
- [ ] `root` points to `sessions#new` (or `static_pages#root` if landing page exists)
- [ ] `/home` points to `pages#home` (authenticated dashboard)
- [ ] React SPA remains addressable at a side path (e.g., `/app/*path`) for unported features
- [ ] Catch-all `get '*path'` removed or narrowed to prevent silent React handoff

### S0-02: Fix SessionsController to render template
**Files:** `app/controllers/sessions_controller.rb`
**Estimate:** 5 min
**Acceptance Criteria:**
- [ ] `SessionsController#new` renders the ERB template instead of `render plain:`
- [ ] Login form uses `application` layout with full SCSS

### S0-03: Style auth forms with landing page SCSS
**Files:** `app/views/sessions/new.html.erb`, `app/views/users/new.html.erb`
**Estimate:** 2 hours
**Acceptance Criteria:**
- [ ] Login form uses `application` layout
- [ ] Login form uses `.form-page`, `.landing-nav`, `.btn`, `.btn-primary` classes from existing `landing_page/` SCSS
- [ ] Signup form uses `application` layout
- [ ] Signup form uses the same landing page class system
- [ ] Both match the original fork's sign-in/sign-up page visual (see `docs/sign_in.png`, `docs/sign_up.png`)

### S0-04: Style home/dashboard with main-app SCSS
**Files:** `app/views/pages/home.html.erb`
**Estimate:** 1 hour
**Acceptance Criteria:**
- [ ] Home page wraps in `<div class="main-app">` for Basecamp beige background
- [ ] Nav uses `<nav class="app-nav">` for light beige nav bar
- [ ] Project cards and sections maintain the existing layout
- [ ] Matches the original fork's home page visual (see `docs/home_page.png`)

### S0-05: Style todo list views with tool-page SCSS
**Files:** `app/views/todo_lists/index.html.erb`, `app/views/todo_lists/show.html.erb`
**Estimate:** 1 hour
**Acceptance Criteria:**
- [ ] Todo pages use `.main-app` wrapper, `.app-nav` nav, `.tool-page` content container
- [ ] Buttons use `.btn`, `.btn-primary`, `.btn-submit` classes from `bootstrap_lite/buttons.scss`
- [ ] Matches the original fork's todo list visuals (see `docs/todolist_index.png`, `docs/todolist_view.png`)

### S0-06: Create minimal ProjectsController#show
**Files:** `app/controllers/projects_controller.rb`, `app/views/projects/show.html.erb`
**Estimate:** 1 hour
**Acceptance Criteria:**
- [ ] `ProjectsController#show` loads project + associated tools (todo_lists, messages, events)
- [ ] Project show page renders tool cards using `.project-page` and `.tool-card` SCSS classes

### S0-07: NeonDB + Doppler secrets
**Files:** `bin/dev`, `config/database.yml`
**Estimate:** 30 min
**Acceptance Criteria:**
- [ ] Doppler project `basejump` exists with `DATABASE_URL` pointing to Neon
- [ ] Doppler CLI scoped to project directory (`doppler setup --project basejump --config dev`)
- [ ] `bin/dev` runs both dartsass and Rails through `doppler run --`
- [ ] All 13 schema migrations run on Neon (tables: users, projects, todo_lists, todos, etc.)
- [ ] Skill file (`.skills/rule/basejump-architecture.md`) documents the setup
- [ ] Links to todo lists, messages, events work
- [ ] Matches the original fork's project page visual (see `docs/project_view.png`)

---

## Phase 1: Foundation — Models, Auth, Loose Todos (Days 3-9)

### P1-02: Port Database Schema (already done)
**Status:** Complete. All 7 tables exist with correct columns, foreign keys, migrations.

### P1-03: Core Models (already done)
**Status:** Complete. Models ported with `normalizes`, proper associations, polymorphic comments.

### P1-04: Authentication & Session Flow (Sprint 0 covers this)
**Status:** Sprint 0 S0-01 through S0-03 deliver this. ERB auth forms working with Turbo.

### P1-05: Loose Todos & Subtasks
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] Loose todos display at top of todo list page without requiring a list
- [ ] Todo creation inline for loose todos (no parent list required)
- [ ] Drag loose todo into existing todo list (Stimulus controller)
- [ ] Drag todo out of list to make it loose
- [ ] Subtasks on individual todos with checklist UI
- [ ] Subtask completion toggles independently
- [ ] Loose todos assignable to users
- [ ] Styled with existing SCSS design system

---

## Phase 2: Core Feature Parity (Days 10-18)

### P2-01: Project Dashboard / Home Page (Sprint 0 delivers this)
**Status:** Sprint 0 S0-04 delivers the initial version. Future enhancements: Turbo Frame nav between project types, project creation form inline/modal, responsive breakpoints.

### P2-02: Message Board with Trix Editor
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] Messages index shows all messages with author/timestamp (port from React SPA)
- [ ] Message creation uses Trix editor via Action Text
- [ ] Comments on messages work with Turbo Streams
- [ ] Styled with existing SCSS (`main_app/tool/message_board.scss`, `message_form.scss`, `comments.scss`)

### P2-03: Todo System with Assignments
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] Todo assignment to multiple users (UserTodo join table)
- [ ] Todo creation with title/description/due_date
- [ ] Todo completion toggles via Turbo Stream (already working)
- [ ] Todo reordering via drag-drop (Stimulus controller)
- [ ] Styled with existing SCSS

### P2-04: Events & Calendar (port from React SPA)
**Estimate:** 3-4 days
**Acceptance Criteria:**
- [ ] Calendar view showing all events by month (port from React `react_calendar/main.scss`)
- [ ] Events display on correct dates
- [ ] Event creation with date pickers
- [ ] Comments on events work with Turbo Streams

### P2-05: User Management & Company HQ
**Estimate:** 1-2 days
**Acceptance Criteria:**
- [ ] User profile page shows avatar, job_title
- [ ] Users can be added to projects
- [ ] Company HQ auto-created on signup (already working)
- [ ] Company-wide announcements

### P2-06: Tailwind v3 Integration (optional, after core parity)
**Estimate:** 1 day
**Acceptance Criteria:**
- [ ] Add `tailwindcss-rails` gem (standalone binary, no Node required)
- [ ] Tailwind utilities coexist with existing SCSS component classes
- [ ] No regressions in existing styled views
- [ ] Formatter (`bin/rails tailwindcss:build`) works in CI

---

## Phase 3: Modern Basecamp 5 Features (Days 19-28)

### P3-01: References Feature
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] Auto-detecting links in rich text content
- [ ] Creating Reference when `[[` or URL mention detected
- [ ] References tab alongside comments on each object
- [ ] Backfilling references for existing cross-mentions
- [ ] Real-time Reference updates via Turbo Streams

### P3-02: Hill Charts
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Hill Chart SVG visualization for TodoLists
- [ ] Tasks can be marked "figuring it out" or "done"
- [ ] Progress saved as percentage
- [ ] Hilltop View showing all charts (Basecamp 5 style)

### P3-03: Card Tables (Kanban)
**Estimate:** 4-5 days
**Acceptance Criteria:**
- [ ] Card Tables as new project tool type
- [ ] Cards with title/description/assignee/due_date
- [ ] Drag-drop between columns via Stimulus
- [ ] Card creation inline or modal
- [ ] Activity feed showing card movements

### P3-04: Project Templates
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] Save existing project as template
- [ ] Templates include: todos, messages, docs, card tables
- [ ] Create new project from template
- [ ] Template duplication support

### P3-05: Everything Page & My Bar
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] `/everything` page showing all objects across all projects
- [ ] Filter by type: messages, todos, events
- [ ] "My Bar" persistent sidebar showing assignments, events, bookmarks, recent activity

### P3-06: Markdown Support & Tables
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Markdown input in all text areas
- [ ] Auto-conversion of pasted Markdown to formatted text
- [ ] Basic table support in Trix editor
- [ ] Preview toggle (raw Markdown vs formatted)

---

## Phase 4: Knowledge Graph & Capacities Twist (Days 29-39)

### P4-01: Docs/Pages — Polymorphic Note Model + Page Tool
**Estimate:** 4 days
**Acceptance Criteria:**
- [ ] `notes` table with `noteable` polymorphic reference + `parent_id` (self-referential FK for nesting)
- [ ] New "Docs" project tool alongside TodoLists, Messages, Events (`.tool-page` / `.main-tool` SCSS)
- [ ] DocsController for index (page tree) + NotesController for CRUD on individual pages
- [ ] TipTap editor for page body (structured JSON) — importmap, no Node
- [ ] Page tree sidebar with expand/collapse nesting (Stimulus controller)
- [ ] Backfill existing messages/todos/events into notes table
- [ ] Bi-directional links work across both Docs and structured entities (P4-02)
- [ ] Tags apply to Docs pages (P4-03)

### P4-02: Bi-Directional Linking System
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] `note_links` table for bi-directional edges
- [ ] UI to reference other notes using `[[` auto-complete (Obsidian-style)
- [ ] Creating a link automatically creates backlink
- [ ] Link validation prevents circular references

### P4-03: Tag System
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] `tags` table with name/color
- [ ] `taggings` join table
- [ ] Tag editing inline on notes
- [ ] Tag filtering on project pages
- [ ] Tags appear on graph visualization

### P4-04: Graph Visualization
**Estimate:** 4-5 days
**Acceptance Criteria:**
- [ ] Force-directed graph using D3.js via importmap
- [ ] Nodes colored by type (message=blue, todo=green, event=orange)
- [ ] Edges labeled with relationship type
- [ ] Graph scoped to current project or company-wide
- [ ] Clicking node expands to show detail + backlinks
- [ ] Floating "Graph" button on all project tool views

### P4-05: Full-Text Search
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Search across all note bodies and titles
- [ ] Search results highlight matching terms
- [ ] Search by tag filters results
- [ ] Fuzzy search with typo tolerance (pg_search gem)
- [ ] Keyboard shortcut `CMD+K` opens search modal

---

## Phase 5: Polish & Deploy (Days 40-45)

### P5-01: Performance & Optimization
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] N+1 queries eliminated via `includes`
- [ ] Database indexes added for common queries
- [ ] Turbo Stream batching for real-time updates
- [ ] Image optimization via Active Storage variants
- [ ] Eager loading of associations in controllers

### P5-02: Mobile Responsiveness
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Mobile navigation menu (hamburger)
- [ ] Stacked layout on small screens
- [ ] Touch-friendly drag-drop for todos/cards
- [ ] Calendar mobile view optimized
- [ ] Graph view on mobile (read-only mode)

### P5-03: Authentication & Security
**Estimate:** 1-2 days
**Acceptance Criteria:**
- [ ] Two-factor authentication option
- [ ] Session timeout with warning
- [ ] Secure headers
- [ ] Rate limiting on login attempts
- [ ] Admin role management

### P5-04: Deploy to Production
**Estimate:** 1-2 days
**Acceptance Criteria:**
- [ ] Kamal.yml configured for VPS deployment
- [ ] Dockerfile generates successfully
- [ ] Production environment variables set
- [ ] Deploy script works
- [ ] Monitoring/logging configured

---

## Key Decisions Log

| Topic | Decision | Rationale |
|-------|----------|-----------|
| **Styling Pipeline** | SCSS via Propshaft (existing) | Already works, full design system compiled. No Node/PostCSS dependency. |
| **Future CSS Addition** | Tailwind v3 via `tailwindcss-rails` gem | Standalone binary, no Node. Coexists with SCSS classes. Upgrade to v4 later when environment supports it. |
| **Architecture** | Hotwire/ERB (server-rendered) | Project's own roadmap selects this. Turbo+Stimulus already in Gemfile. |
| **React SPA** | Archived to `archive/react-spa-stack` | Preserved for reference. Side path `/app/*` keeps it addressable for unported features. |
| **Rich Text Editor** | Trix for Phase 1-3, TipTap for Phase 4 | Trix integrates with Hotwire out of the box; TipTap needed for structured JSON for graph |
| **Realtime** | ActionCable | Native Rails 8 support, works with Turbo Streams |
| **Database** | PostgreSQL (existing) | Already connected. Supabase Local optional. |
| **Graph Library** | D3.js via importmap | Mature, good Hotwire compatibility, force-directed layout in ERB |
| **Search** | pg_search | Postgres full-text search |
| **Form Builder** | `form_with` (Rails standard) | No need for Simple Form or Formtastic with Hotwire |

---

## Timeline Summary

| Phase | Duration | What it covers | Risk Level |
|-------|----------|----------------|------------|
| Sprint 0: SCSS Restoration | 1-2 days | Apply existing SCSS to ERB views, fix routes, create ProjectsController | Low |
| Phase 1: Foundation | 6-7 days | Loose todos, subtasks, Turbo Stream interactions | Low |
| Phase 2: Core Parity | 8-10 days | Messages, todos with assignments, events, user management | Medium |
| Phase 3: Modern Features | 10-12 days | Hill charts, kanban, everything page, markdown | Medium |
| Phase 4: Knowledge Graph | 10-12 days | Notes, linking, tags, D3 graph, full-text search | Medium-High |
| Phase 5: Polish & Deploy | 5-6 days | Performance, mobile, security, deploy | Low |
| **Total** | **30-40 days** | **Feature-complete Hotwire app** | **Medium** |

**Conservative estimate:** 8-10 weeks of part-time work.
**Aggressive estimate:** 5-6 weeks of focused full-time work.

---

## Appendix: React SPA Archive

The React SPA + Storybook + Tailwind v4 work (commit `5b5df88`) has been archived to `archive/react-spa-stack`. That branch retains the full React implementation with:

- `src/ui/` COSS primitives (Button, Input, Checkbox)
- Storybook stories and static build
- Tailwind v4 configuration
- React Router v7 routes
- Redux store and entity cache

The archived React SPA serves as reference for porting features. The app-level React code at `frontend/` remains in the working tree but is no longer the primary rendering path. API controllers (`namespace :api`) and `ReactAppController` are preserved for unported features (calendar, message board, kanban) until they are rebuilt in Hotwire per the phase plan above.

**Not ported to archive:** The `app/views/`, `app/controllers/` (sessions, users, pages, todo_lists, todos), `app/assets/stylesheets/`, and `config/routes.rb` Hotwire additions from commits `e64406d` and `5ba4cc7` — these are the foundation this plan builds on.
