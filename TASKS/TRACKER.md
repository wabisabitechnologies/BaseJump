# Ticket Tracker

Auto-generated progress tracker. Use `bin/tickets` to update.

---

## Summary

- **Total:** 33 tickets
- **Done:** 11 (33%)
- **Remaining:** 22
- **Next:** None (use `bin/tickets start <ID>` to set)

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
| P1-02 | Port Database Schema | ✅ Done | All 10 tables exist |
| P1-03 | Core Models | ✅ Done | 12 models with associations |
| P1-04 | Authentication & Session Flow | ✅ Done | Custom bcrypt auth |
| P1-05 | Loose Todos & Subtasks | ✅ Done | Drag-drop Stimulus controller, subtask checklist UI |

## Phase 2: Core Feature Parity

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P2-01 | Project Dashboard / Home Page | ✅ Done | Sprint 0 delivered |
| P2-02 | Message Board with Trix Editor | ✅ Done | Port from React SPA, Action Text + Trix |
| P2-03 | Todo System with Assignments | ✅ Done | UserTodo join, reordering, due dates |
| P2-04 | Events & Calendar | ✅ Done | Calendar view, event CRUD, port from React |
| P2-05 | User Management & Company HQ | ✅ Done | Profile page, project membership |
| P2-06 | Tailwind v3 Integration | ⚪ Pending | Optional, after core parity |

## Phase 3: Modern Features

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P3-01 | References Feature | ⚪ Pending | Auto-detect links, `[[` mentions |
| P3-02 | Hill Charts | ✅ Done | SVG visualization, progress tracking |
| P3-03 | Card Tables (Kanban) | ⚪ Pending | Drag-drop columns, card CRUD |
| P3-04 | Project Templates | ✅ Done | Save/create from template |
| P3-05 | Everything Page & My Bar | ✅ Done | Cross-project view, sidebar |
| P3-06 | Markdown Support & Tables | ✅ Done | Markdown input, preview toggle |

## Phase 4: Knowledge Graph

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P4-01 | Docs/Pages | ⚪ Pending | Polymorphic notes, TipTap editor |
| P4-02 | Bi-Directional Linking | ⚪ Pending | `[[` auto-complete, backlinks |
| P4-03 | Tag System | ✅ Done | Tags, taggings, filtering |
| P4-04 | Graph Visualization | ⚪ Pending | D3.js force-directed graph |
| P4-05 | Full-Text Search | ✅ Done | pg_search, CMD+K modal |

## Phase 5: Polish & Deploy

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| P5-01 | Performance & Optimization | ✅ Done | N+1 queries, indexes, Turbo batching |
| P5-02 | Mobile Responsiveness | ✅ Done | Responsive layouts, touch drag-drop |
| P5-03 | Authentication & Security | ✅ Done | 2FA, rate limiting, secure headers |
| P5-04 | Deploy to Production | ⚪ Pending | Kamal, Dockerfile, monitoring |

## Quick Fixes

| ID | Ticket | Status | Notes |
|----|--------|--------|-------|
| FIX-1 | Fix Turbo gap in todo creation | ✅ Done | Drop `local: true` from todo create form |
