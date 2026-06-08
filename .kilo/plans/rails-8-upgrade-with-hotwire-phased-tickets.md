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