# Rails 8 Upgrade + Hotwire Rebuild - Phased Ticket Breakdown

## Overview
Split into 5 phases over ~8-10 weeks. Phase 1-3 rebuilds and enhances core functionality with Hotwire + modern Basecamp 5 features, Phase 4 ties everything together with knowledge-graph features, Phase 5 finalizes polish and deployment.

---

## Phase 1: Foundation, Rails 8 Setup & Loose Todos (Days 1-7)

### P1-01: Generate Rails 8 Application
**Estimate:** 1-2 hours
**Acceptance Criteria:**
- [ ] Fresh Rails 8.0 app generated with `--database=postgresql --javascript=importmap --css=tailwind`
- [ ] Connected to Supabase local via `DATABASE_URL` in `config/database.yml`
- [ ] Basic authentication scaffold (`has_secure_password`) working
- [ ] `bin/dev` Procfile running Puma + importmap
- [ ] Initial commit pushed to main branch

### P1-02: Port Database Schema
**Estimate:** 1-2 days
**Acceptance Criteria:**
- [ ] All 7 tables exist with correct columns (users, companies, projects, todo_lists, todos, messages, events, comments)
- [ ] Foreign key constraints verified
- [ ] All 17 migrations ported to work with Rails 8 syntax
- [ ] `rails db:migrate:reset` runs cleanly
- [ ] Seed data loads successfully

### P1-03: Core Models with Modern Rails Features
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] All models ported with `normalizes` validations instead of `before_validation` hooks
- [ ] `belongs_to :author` relationships use `optional: true` where appropriate
- [ ] Polymorphic association for comments implemented correctly
- [ ] Model tests pass with `rails test`
- [ ] RuboCop passes with no model-specific warnings

### P1-04: Authentication & Session Flow
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] User signup creates user + auto-creates Company HQ project
- [ ] Login/logout works with Turbo-driven forms
- [ ] `current_user` helper works across all controllers
- [ ] Session maintained across Turbo navigation
- [ ] Protected routes return proper redirects

### P1-05: Loose Todos & Subtasks (Basecamp 5 Feature)
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] Loose todos display at top of todo list page without requiring a list
- [ ] Todo creation inline for loose todos (no parent list required)
- [ ] Drag loose todo into existing todo list
- [ ] Drag todo out of list to make it loose
- [ ] Subtasks on individual todos with checklist UI
- [ ] Subtask completion status saved independently
- [ ] Loose todos assignable to users

---

## Phase 2: Core Feature Parity (Days 8-15)

### P2-01: Project Dashboard (Home Page)
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Home page shows Company HQ, Teams, Projects tabs (styled like Basecamp)
- [ ] Project cards display name, description, user avatars
- [ ] Turbo Frame navigation between project types
- [ ] Project creation form works inline or via modal
- [ ] Responsive on mobile (Tailwind breakpoints)

### P2-02: Message Board with Trix Editor
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] Messages index shows all messages with author/timestamp
- [ ] Message creation uses Trix editor via Action Text
- [ ] Message body stored as rich HTML (Action Text)
- [ ] Comments on messages work with Turbo Streams
- [ ] Real-time updates when new comments added (ActionCable)

### P2-03: Todo System with Assignments
**Estimate:** 3-4 days
**Acceptance Criteria:**
- [ ] TodoLists index with all lists per project
- [ ] Todo creation with title/description/due_date
- [ ] Todo assignment to multiple users (UserTodo join table)
- [ ] Todo completion toggles via checkbox (Turbo Stream)
- [ ] Todo reordering via drag-drop (Stimulus controller)

### P2-04: Events & Calendar
**Estimate:** 3-4 days
**Acceptance Criteria:**
- [ ] Calendar view showing all events by month
- [ ] Events display on correct dates
- [ ] Event creation with date pickers and optional video link field (Basecamp 5 style)
- [ ] Events clickable to show detail page
- [ ] Comments on events work with Turbo Streams

### P2-05: User Management & Company HQ
**Estimate:** 1-2 days
**Acceptance Criteria:**
- [ ] User profile page shows avatar, job_title
- [ ] Users can be added to projects
- [ ] Company HQ auto-created on signup
- [ ] Company-wide announcements work

---

## Phase 3: Modern Basecamp 5 Features (Days 16-25)

### P3-01: References Feature (Basecamp 5 Style)
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
- [ ] Hill Chart visualization for TodoLists
- [ ] Tasks can be marked "figuring it out" or "done"
- [ ] Progress saved as percentage
- [ ] History of hill chart changes tracked
- [ ] Hilltop View showing all charts (Basecamp 5 style)

### P3-03: Card Tables (Kanban)
**Estimate:** 4-5 days
**Acceptance Criteria:**
- [ ] Card Tables as new project tool type
- [ ] Cards with title/description/assignee/due_date
- [ ] Drag-drop between columns via Stimulus/Turbo Streams
- [ ] Card creation inline or modal
- [ ] Activity feed showing card movements

### P3-04: Project Templates
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] Save existing project as template
- [ ] Template includes: todos, messages, docs, card tables
- [ ] Client visibility settings on template items (Basecamp 5 style)
- [ ] Create new project from template
- [ ] Template duplication support

### P3-05: Everything Page & My Bar
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] `/everything` page showing all objects across all projects
- [ ] Filter by type: all messages, all todos, all events, etc.
- [ ] "My Bar" persistent sidebar showing:
  - My assignments
  - My upcoming events
  - My bookmarks
  - My recent activity

### P3-06: Markdown Support & Tables
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Markdown input supported in all text areas
- [ ] Auto-conversion of pasted Markdown to formatted text
- [ ] Basic table support in Trix editor
- [ ] Code block syntax highlighting
- [ ] Preview toggle (raw Markdown vs formatted)

---

## Phase 4: Knowledge Graph & Capacities Twist (Days 26-35)

### P4-01: Note Polymorphic Model
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] New `notes` table created with `noteable` polymorphic reference
- [ ] Migration that backfills existing messages/todos/events into notes table
- [ ] Each entity (message, todo, event, todolist) has associated Note record
- [ ] Note body stored as TipTap JSON format (for structured parsing)
- [ ] Backward compatibility - existing data still accessible

### P4-02: Bi-Directional Linking System
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] `note_links` table for bi-directional edges
- [ ] UI to reference other notes using `[[` auto-complete (like Obsidian)
- [ ] Typing `[[` opens modal with fuzzy search
- [ ] Creating a link automatically creates backlink
- [ ] Link validation prevents circular references

### P4-03: Tag System
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] `tags` table with name/color
- [ ] `taggings` join table (acts-as-taggable-on or custom)
- [ ] Tag editing inline on notes
- [ ] Tag filtering on project pages
- [ ] Tags appear on graph visualization

### P4-04: Graph Visualization
**Estimate:** 4-5 days
**Acceptance Criteria:**
- [ ] Force-directed graph using D3.js via importmap
- [ ] Nodes = Notes (color-coded by type: message=blue, todo=green, event=orange, etc.)
- [ ] Edges = Links (label with relationship type)
- [ ] Graph scoped to current project or company-wide
- [ ] Clicking node expands to show detail + backlinks
- [ ] Graph updates in real-time via Turbo Streams
- [ ] Floating "Graph" button on all project tool views

### P4-05: Full-Text Search
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Search across all note bodies and titles
- [ ] Search results highlight matching terms
- [ ] Search by tag filters results
- [ ] Fuzzy search with typo tolerance (pg_search gem)
- [ ] Keyboard shortcut `CMD+K` opens search modal
- [ ] Graph view updates based on search query

---

## Phase 5: Polish & Deploy (Days 36-40)

### P5-01: Performance & Optimization
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] N+1 queries eliminated via `includes` or `select`
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
- [ ] Two-factor authentication option (optional sign-up)
- [ ] Session timeout with warning
- [ ] Secure headers via secure_headers gem
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
| Rich Text Editor | Trix for Phase 1-3, TipTap for Phase 4 | Trix integrates with Hotwire out of the box; TipTap needed for structured JSON parsing for graph |
| Realtime | ActionCable | Native Rails 8 support, works with Turbo Streams |
| Database | Supabase Local | Easy local testing with pg adapter, seamless migration to cloud Supabase |
| Deployment | Kamal | Rails 8 native, no vendor lock-in |
| Graph Library | D3.js via importmap | Mature, good Hotwire compatibility, force-directed layout works in ERB templates |
| Search | pg_search | Postgres full-text search, integrates cleanly with Supabase |

---

## Timeline Summary

| Phase | Duration | Total Lines Changed | Risk Level |
|-------|----------|---------------------|------------|
| Phase 1 | 7 days | ~2,000 (new models/controllers) | Low |
| Phase 2 | 8 days | ~4,000 (views, controllers, Hotwire) | Medium |
| Phase 3 | 10 days | ~3,000 (new features, references, templates) | Medium |
| Phase 4 | 10 days | ~3,000 (graph, linking, tags) | Medium-High |
| Phase 5 | 5 days | ~1,000 (polish/deploy) | Low |
| **Total** | **30-40 days** | **~13,000 lines** | Medium |

**Conservative estimate:** 6-8 weeks of part-time work (evenings/weekends).
**Aggressive estimate:** 4-5 weeks of focused full-time work.

---

---

# ═══════════════════════════════════════════════════════
# APPENDIX: React SPA Implementation (chosen path)
# ═══════════════════════════════════════════════════════

## Why this appendix exists
The plan above was written for a **Rails 8 + Hotwire** rewrite — throw away the React SPA and rebuild server-rendered.

The **chosen path** keeps the existing React SPA, Redux entity cache, and Rails JSON API. The same feature tickets (Loose Todos, Subtasks, Assignments, Hill Charts, etc.) are built as **React components**, not Hotwire views. This appendix maps each Hotwire ticket to its React equivalent and adds a Foundation sprint for the prerequisite work the existing codebase needs.

**Key difference:** The Hotwire plan is a rewrite. This plan is an incremental build on top of what exists.

---

## Sprint 0: Foundation (prerequisite, NOT in original Hotwire plan)

**Goal:** Remove blocking debt so every feature ticket is faster to build.

**Estimate:** 5-7 days

### F-01: Kill jQuery — `$.ajax` → `fetch` in all API utils
**Files:** `frontend/util/*_api_util.js` (10 files)
**Estimate:** 1 day
**Acceptance Criteria:**
- [ ] All 10 API util files use `fetch` instead of `$.ajax`
- [ ] All async/await, no callback chains
- [ ] Error responses throw consistently for thunk `.fail()` handlers
- [ ] No remaining `$` references in API utils

### F-02: Kill jQuery — class toggles → React state in components
**Files:** `frontend/components/app/*/*.jsx` (7 files: todo_form, todolist_form, todolist_index, todolist_index_item, comment_form, message_form, project_section)
**Estimate:** 1 day
**Acceptance Criteria:**
- [ ] No `$().addClass` / `$().removeClass` / `$().toggleClass` anywhere in React components
- [ ] Error highlighting driven by state, not DOM queries
- [ ] Show/hide toggles use conditional rendering or state-driven classes

### F-03: Consume `src/ui/` primitives in auth forms
**Files:** `frontend/components/auth/AuthForm.jsx`, `frontend/components/session/session_form.jsx`, `frontend/stories/AuthForm.stories.jsx`, new `frontend/stories/SessionForm.stories.jsx`
**Estimate:** 1 day
**Acceptance Criteria:**
- [ ] AuthForm uses `<Button>` for submit + demo buttons, `<Input>` for signup fields
- [ ] SessionForm uses `<Button>` for submit, `<Input>` for all fields
- [ ] Both have Storybook stories rendering all variants (default, loading, errors)
- [ ] Tailwind classes removed from raw HTML elements, handled by the primitives

### F-04: Build `useFormSubmit` hook
**Files:** new `frontend/components/hooks/useFormSubmit.js` (or similar)
**Estimate:** 1 day
**Acceptance Criteria:**
- [ ] Hook accepts an async function + `{ onSuccess, onError }` callbacks
- [ ] Returns `{ submit, loading, errors, reset }`
- [ ] `submit` calls the async fn, catches errors, sets `loading`/`errors` state
- [ ] All new forms use this hook instead of duplicating loading/error state

### F-05: Build `useFormSubmit` story + integration test
**Files:** new `frontend/stories/hooks/useFormSubmit.stories.jsx`
**Estimate:** 0.5 day
**Acceptance Criteria:**
- [ ] Story shows loading state (with loading spinner on Button)
- [ ] Story shows error state (with error messages displayed)
- [ ] Story shows success state (with confirmation message)

### F-06: Remove jQuery from package.json
**Estimate:** 0.5 day
**Acceptance Criteria:**
- [ ] `jquery`, `jquery-ujs` removed from `package.json` (if present)
- [ ] App bundle no longer includes jQuery
- [ ] No runtime errors from missing `$`

---

## Phase 1: Auth & Todo Foundation (React SPA version)

**Goal:** Auth forms use primitives + Storybook. Todo system extended with loose todos and subtasks.

**Estimate:** 5-7 days
**Original Hotwire tickets:** P1-04, P1-05

### R1-04: Authentication Views (React, not Devise/Hotwire)
**Files:** `frontend/components/session/session_form.jsx`, `frontend/components/auth/AuthForm.jsx`, `frontend/stories/SessionForm.stories.jsx`, `frontend/stories/AuthForm.stories.jsx`
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Login form uses `<Button>` + `<Input>` from `src/ui/` (F-03 already handles this)
- [ ] Signup form uses `<Button>` + `<Input>` from `src/ui/` (F-03 already handles this)
- [ ] Loading state shows spinner on Button, disables form
- [ ] Error state shows field-level messages (works already via `useState(errors)`)
- [ ] Storybook stories for: login default, signup default, login with errors, loading
- [ ] Demo login button works in Storybook via action logger

### R1-05: Loose Todos & Subtasks
**Files:** New `frontend/components/app/todolist/loose_todo_list.jsx`, extend `todo_item.jsx`, new `subtask_form.jsx` + `subtask_item.jsx`, extend Redux actions + reducer
**Estimate:** 3-4 days
**Acceptance Criteria:**
- [ ] `/projects/:id` shows loose todos (todos with `todo_list_id: null`) at top of todo section
- [ ] Inline todo creation for loose todos (no list required)
- [ ] Drag loose todo into existing todo list (HTML5 drag-drop or react-dnd)
- [ ] Drag todo out of list makes it loose
- [ ] Subtasks render as checklist under each todo
- [ ] Subtask completion toggles independently
- [ ] Loose todos assignable to users (user picker dropdown)
- [ ] Storybook story for loose todo list with empty/with-items states
- [ ] Storybook story for subtask checklist

---

## Phase 2: Core Feature Parity (React SPA version)

**Goal:** Existing features polished with primitives + states. No Hotwire, no ActionCable.

**Estimate:** 8-10 days
**Original Hotwire tickets:** P2-01 through P2-05

### R2-01: Project Dashboard / Home Page
**Existing component:** `frontend/components/landing_page/page_content.jsx` + `frontend/components/app/project_section.jsx` + `project_card.jsx`
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Home page shows Company HQ + project cards (already works)
- [ ] Project cards use `src/ui/` primitives (`Button`, possibly `Checkbox`)
- [ ] Empty state when no projects exist (currently renders nothing)
- [ ] Loading state with skeleton cards (currently only `<Loading />` bar)
- [ ] Project creation form refactored to use `useFormSubmit` + `src/ui/` primitives
- [ ] Storybook story for home page with 3 states: loading, empty, with projects

### R2-02: Message Board
**Existing components:** `message_board.jsx`, `message_show.jsx`, `message_form.jsx`, `message_board_item.jsx`
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Message form refactored to use `useFormSubmit` + `src/ui/` primitives
- [ ] Message type selector (Announcement, FYI, etc.) uses `<select>` or styled buttons, not jQuery class toggles
- [ ] Empty state: "No messages yet" with create button
- [ ] Loading state: skeleton cards
- [ ] Error state: inline error display
- [ ] Storybook story for message board with all 3 states
- [ ] Storybook story for message form with create + error states

### R2-03: Todo System with Assignments
**Existing components:** `todolist_index.jsx`, `todolist_show.jsx`, `todolist_index_item.jsx`, `todo_item.jsx`, `todo_form.jsx`, `todolist_form.jsx`
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] TodoForm refactored to use `useFormSubmit` + `src/ui/` primitives
- [ ] TodoListForm refactored to use `useFormSubmit` + `src/ui/` primitives
- [ ] Assignees: replace free-text comma input with user picker/popover
- [ ] Assignee avatars display on todo items (not just stored in string array)
- [ ] Todo completion checkbox uses `<Checkbox>` from `src/ui/`
- [ ] Due date display on todo items
- [ ] Empty state: "No todos yet" with create button
- [ ] Loading state: skeleton cards
- [ ] Error state: inline errors
- [ ] Storybook story for todo list with loading/empty/with-items states
- [ ] Storybook story for todo form with create + error states
- [ ] Storybook story for todolist form with create + error states

### R2-04: Events & Calendar
**Existing components:** `events_index.jsx`, `event_show.jsx`, `event_form.jsx`
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] EventForm refactored to use `useFormSubmit` + `src/ui/` primitives
- [ ] Events index shows month calendar + event list (already works)
- [ ] Month navigation works (prev/next month)
- [ ] Empty state: "No events this month"
- [ ] Loading state: skeleton
- [ ] Error state: inline errors
- [ ] Storybook story for events index with 3 states
- [ ] Storybook story for event form with create + error states

### R2-05: User Management & Company HQ
**Existing component:** Partial — user avatar in `user_icon_display.jsx`, user list in `user_list.jsx`
**Estimate:** 1-2 days
**Acceptance Criteria:**
- [ ] User profile page with avatar, name, email, projects
- [ ] User picker reusable component (needed by R2-03 assignments)
- [ ] Company HQ page with member list
- [ ] Storybook story for user picker
- [ ] Storybook story for user profile

---

## Phase 3: Modern Features (React SPA version)

**Goal:** New Basecamp-5-style features as React components. No rich-text editor dependency at this stage.

**Estimate:** 8-12 days
**Original Hotwire tickets:** P3-01 through P3-06

### R3-02: Hill Charts
**Files:** New `frontend/components/app/hill_chart/` — `hill_chart.jsx`, `hill_chart_container.jsx`, `hill_top_view.jsx`
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] Hill Chart SVG visualization for each TodoList (simple SVG curve with dot)
- [ ] Tasks can be marked "figuring it out" or "done"
- [ ] Progress saved as percentage to backend
- [ ] Hilltop View showing all charts across project
- [ ] Storybook story with sample data

### R3-03: Card Tables (Kanban)
**Files:** New `frontend/components/app/card_table/` — `kanban_board.jsx`, `kanban_column.jsx`, `kanban_card.jsx`, `card_form.jsx`
**Estimate:** 4-5 days
**Acceptance Criteria:**
- [ ] Card Tables as new project tool type
- [ ] Columns: Backlog, In Progress, Done (or project-configured)
- [ ] Drag-drop between columns using HTML5 DnD or @dnd-kit
- [ ] Card creation inline
- [ ] Card detail: title, description, assignee, due date
- [ ] Storybook story for kanban board

### R3-05: Everything Page & My Bar
**Files:** New `frontend/components/app/everything/` — `everything_page.jsx`, `everything_page_container.jsx`, `my_bar.jsx`. New Rails API endpoint if needed for aggregated feed.
**Estimate:** 3 days
**Acceptance Criteria:**
- [ ] `/everything` page showing all objects across all projects
- [ ] Filter by type: messages, todos, events
- [ ] "My Bar" persistent sidebar showing:
  - My assignments
  - My upcoming events
  - My recent activity
- [ ] Storybook story for Everything page
- [ ] Storybook story for My Bar

### R3-06: Markdown Support
**Estimate:** 2 days
**Acceptance Criteria:**
- [ ] Text areas in forms accept markdown (no rich text editor — plain textareas with preview)
- [ ] Preview toggle: raw markdown vs rendered (using `react-markdown` or similar)
- [ ] Rendered markdown in display components (todo descriptions, messages, event descriptions)
- [ ] Storybook story for markdown preview component

---

## Phase 4: Search & Polish (React SPA version)

**Goal:** Cross-cutting features. Phases 4-5 from original plan (knowledge graph, tags) are deferred — not in scope for initial build.

**Estimate:** 4-6 days
**Original Hotwire tickets:** P4-05, P5-01, P5-02, P5-03

### R4-05: Full-Text Search
**Files:** New `frontend/components/app/search/search_modal.jsx` + Rails API endpoint `/api/search`
**Estimate:** 2-3 days
**Acceptance Criteria:**
- [ ] `CMD+K` opens search modal (modal component with overlay)
- [ ] Search input with debounced API calls
- [ ] Results grouped by type (messages, todos, events, projects)
- [ ] Click result navigates to the object
- [ ] Storybook story for search modal with empty/results/loading states

### R5-01: Performance & Bundle Optimization
**Estimate:** 1 day
**Acceptance Criteria:**
- [ ] Webpack bundle analyzed (`webpack-bundle-analyzer`)
- [ ] Large dependencies (moment, datepicker libraries) evaluated for replacement
- [ ] Code-split route-level chunks where practical
- [ ] N+1 queries checked in API controllers

### R5-02: Storybook Completion
**Estimate:** 1-2 days
**Acceptance Criteria:**
- [ ] Every component used in phases 1-3 has a Storybook story
- [ ] Stories cover: default/loading/empty/error states for each component
- [ ] Storybook static build deploys alongside the app

### R5-03: Mobile Responsiveness
**Estimate:** 1 day
**Acceptance Criteria:**
- [ ] Auth forms stack on mobile (already mostly work via Tailwind)
- [ ] Todo lists responsive
- [ ] Events calendar responsive
- [ ] Navigation collapses to hamburger menu

---

## Key Decisions Log (React SPA Version)

| Topic | Decision | Rationale |
|-------|----------|-----------|
| **Architecture** | Keep React SPA + Rails JSON API | Existing codebase. Hotwire would be a full rewrite. |
| **Data fetching** | Keep Redux thunks, but swap `$.ajax` → `fetch` | Entity cache works. jQuery is the only problem. |
| **UI primitives** | Use existing `src/ui/` (Button, Input, Checkbox) | Already built, zero consumers. Fastest path to consistency. |
| **Form pattern** | Build `useFormSubmit` hook | Every ticket has forms. Shared pattern eliminates duplication. |
| **Rich text editor** | Skip for now — plain textareas + markdown preview | Trix/TipTap add complexity. Markdown is enough. |
| **Realtime** | Skip for now — polling or manual refresh | ActionCable adds backend complexity. Add when shipping realtime is the bottleneck. |
| **State coverage** | Every component gets loading/empty/error states | Currently only loading bars exist. Empty/error states are the biggest UX gap. |
| **Drag-drop** | HTML5 native DnD or `@dnd-kit` (when needed) | `@dnd-kit` is lightweight, React-native. Needed for kanban + loose todos. |

---

## Timeline Summary (React SPA Version)

| Phase | Duration | What it covers | Risk Level |
|-------|----------|----------------|------------|
| Sprint 0: Foundation | 5-7 days | Kill jQuery, adopt `src/ui/`, build form hook | Low |
| Phase 1: Auth + Todos | 5-7 days | Auth views, loose todos, subtasks | Low |
| Phase 2: Core Parity | 8-10 days | Dashboard, messages, todos, events, users | Medium |
| Phase 3: Modern Features | 8-12 days | Hill charts, kanban, everything page, markdown | Medium |
| Phase 4: Search + Polish | 4-6 days | Search, bundle, Storybook completion, mobile | Low |
| **Total** | **30-42 days** | **Feature-complete React SPA** | **Medium** |

**Key difference from Hotwire plan:** Same features, same order, same estimates. But uses the existing React SPA instead of rebuilding from scratch. Sprints 0 is the only new work — it's debt payoff that makes everything after it faster.