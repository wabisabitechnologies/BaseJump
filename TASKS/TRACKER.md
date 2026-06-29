# Ticket Tracker

Auto-generated progress tracker. Use `bin/tickets` to update.

---

## Summary

- **Total:** 33 tickets
- **Done:** 28 (85%)
- **Remaining:** 5
- **Next:** None (use `bin/tickets start <ID>` to set)

### Test Suite
- **Model Specs:** 86 examples, 0 failures
- **Request Specs:** 34 examples, 0 failures
- **System Specs:** 12 examples, 0 failures
- **Total:** 132 examples, 0 failures

---

## Sprint 0: SCSS Design System Restoration

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| S0-01 | Route root/home back to Hotwire | ✅ Done | Fixed in commit 00c66f2 |
| S0-02 | Fix SessionsController to render template | ✅ Done | |
| S0-03 | Style auth forms with landing page SCSS | ✅ Done | |
| S0-04 | Style home/dashboard with main-app SCSS | ✅ Done | |
| S0-05 | Style todo list views with tool-page SCSS | ✅ Done | |
| S0-06 | Create minimal ProjectsController#show | ✅ Done | |
| S0-07 | NeonDB + Doppler secrets | ✅ Done | |

## Phase 1: Foundation

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P1-02 | Port Database Schema | ✅ Done | All tables exist |
| P1-03 | Core Models | ✅ Done | 12+ models with associations |
| P1-04 | Authentication & Session Flow | ✅ Done | Custom bcrypt auth, rate limiting |
| P1-05 | Loose Todos & Subtasks | ✅ Done | Drag-drop Stimulus controller, subtask checklist UI |

## Phase 2: Core Feature Parity

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P2-01 | Project Dashboard / Home Page | ✅ Done | Sprint 0 delivered |
| P2-02 | Message Board with Trix Editor | ✅ Done | Port from React SPA, Action Text + Trix |
| P2-03 | Todo System with Assignments | ✅ Done | UserTodo join, reordering, due dates |
| P2-04 | Events & Calendar | ✅ Done | Calendar view, event CRUD, port from React |
| P2-05 | User Management & Company HQ | ✅ Done | Profile page, project membership |
| P2-06 | Tailwind v3 Integration | 🔶 Partial | Tailwind v4 installed for React/frontend only. Rails views still use SCSS via dartsass-rails. 31 SCSS files untouched. |

## Phase 3: Modern Features

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P3-01 | References Feature | 🔶 Partial | Note-specific wiki-linking exists (NoteLink model, [[syntax]] parsing). No general-purpose Reference model, no auto-detect across content types, no controller. |
| P3-02 | Hill Charts | ✅ Done | SVG visualization, progress tracking |
| P3-03 | Card Tables (Kanban) | 🔶 Stub Only | Route stub exists. No model, controller, views, migration, or drag-drop implementation. |
| P3-04 | Project Templates | ✅ Done | Save/create from template |
| P3-05 | Everything Page & My Bar | ✅ Done | Cross-project view, sidebar |
| P3-06 | Markdown Support & Tables | ✅ Done | Markdown input, preview toggle, redcarpet gem |

## Phase 4: Knowledge Graph

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P4-01 | Docs/Pages | ✅ Done | Polymorphic Note model, wiki-link parsing, breadcrumbs |
| P4-02 | Bi-Directional Linking | ✅ Done | NoteLink model, [[auto-complete]], backlinks, reverse link creation |
| P4-03 | Tag System | ✅ Done | Tags, taggings, color picker, filtering |
| P4-04 | Graph Visualization | ⚪ Not Started | No code exists. Needs D3.js force-directed graph or similar. |
| P4-05 | Full-Text Search | ✅ Done | pg_search with pg_trgm, CMD+K search controller |

## Phase 5: Polish & Deploy

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P5-01 | Performance & Optimization | ✅ Done | Eager loading, N+1 fixes, indexes |
| P5-02 | Mobile Responsiveness | ✅ Done | Responsive layouts, touch drag-drop |
| P5-03 | Authentication & Security | ✅ Done | Rate limiting, secure session tokens |
| P5-04 | Deploy to Production | ⚪ Not Started | No Dockerfile, no Kamal config, no deployment scripts. |

## Quick Fixes

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| FIX-1 | Fix Turbo gap in todo creation | ✅ Done | Drop `local: true` from todo create form |
