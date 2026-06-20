# Authentication Views Ticket (COSS UI First)

**Estimate:** 3-5 days

## Description
Redesign and implement the authentication views (login, signup, password reset, etc.) using COSS UI primitives wrapped with our design system, developed first in Storybook for consistency and visual regression testing. This ticket focuses purely on the UI layer; the underlying Devise controllers and routes remain unchanged but will be consumed via Turbo/Hotwire forms.

## Goals
- Replace existing ERB/HTML authentication pages with COSS‑UI‑based components.
- Ensure visual consistency with the rest of the application (colors, spacing, typography) via Tailwind token mapping.
- Develop each component in Storybook first, achieving visual match with current designs.
- Add Storybook stories and visual regression tests (Chromatic) to prevent drift.
- Enforce usage of COSS wrappers via ESLint/Stylelint rules to avoid old UI classes.
- Keep the existing Devise authentication flow (session handling, redirects) intact.

## Acceptance Criteria
- [ ] **Design Token Mapping**: Tailwind config includes variables for `$landing-blue`, `$landing-dark`, `$serif`, `$sans-serif` etc., derived from existing SCSS.
- [ ] **COSS Wrapper Components**: Created `src/ui/` with wrappers for Button, Input, Checkbox, Form, etc., applying default variants/sizes.
- [ ] **Storybook Stories**: Each wrapper has at least one story showing default, loading, error states.
- [ ] **Visual Match**: Storybook screenshots of auth pages match the current authentication UI within 5% pixel diff (Chromatic baseline).
- [ ] **Integration**: Auth pages (`/login`, `/signup`, `/password/edit`, etc.) render using the new COSS‑UI wrappers and are fully functional (form submission, validation errors, flash messages).
- [ ] **Linting**: ESLint/Stylelint rules flag any direct use of old UI classes (e.g., `btn`, `form-control`) or hardcoded colors/spacings.
- [ ] **No Regression**: Existing Devise tests (requests, system tests) continue to pass.
- [ ] **Documentation**: Updated `CONTRIBUTING.md` with instructions on adding new auth UI components and running Storybook.

## Steps
1. **Setup Design Tokens**
   - Extract colors, fonts, spacing from `app/assets/stylesheets/landing_page/*.scss` and `base/*.scss`.
   - Populate `tailwind.config.js` theme.extend with matching values.
   - Ensure `src/index.css` includes `@tailwind base; @tailwind components; @tailwind utilities;`.
2. **Create COSS UI Wrapper Barrel**
   - Copy needed COSS primitives (Button, Input, Checkbox, Form, Label, etc.) into `src/ui/` (or reference via submodule).
   - For each primitive, create a wrapper component that applies default props (variant, size, className) from our design token mapping.
   - Export all wrappers from `src/ui/index.js`.
3. **Initialize Storybook for COSS Wrappers**
   - Run `npx sb init --type react_scripts` if not already.
   - Add Tailwind import to `.storybook/preview.js`.
   - Write stories for each wrapper (e.g., Button.stories.jsx) showcasing primary, secondary, disabled, loading states.
4. **Develop Authentication Pages in Storybook**
   - Create a Storybook `AuthPage.stories.jsx` that assembles login/signup forms using the wrappers.
   - Mirror the existing layout (logo, links, background image) using COSS Layout primitives or custom CSS.
   - Use Storybook’s `args` to simulate loading, error, and success states.
5. **Visual Regression Baseline**
   - Add Chromatic (or Storyshots) config.
   - Run initial baseline capture of auth stories.
6. **Integrate into Rails Views**
   - Replace `app/views/devise/sessions/new.html.erb`, `registrations/new.html.erb`, `passwords/edit.html.erb`, etc. with React‑rendered components via `react_on_rails` or similar, OR render the React components directly via a container div and mount them with Rails UJS (choose based on existing setup).
   - Ensure the mounting point receives the current user state (if needed) via data attributes or gon.
   - Keep the same form URLs and Devise parameters; only change the markup.
7. **Add Linting Rules**
   - ESLint: `no-restricted-classes` for `btn`, `form-control`, `input-lg`, etc.
   - Stylelint: disallow hardcoded colors that don’t map to `theme('colors.landing.*')` and disallow hardcoded spacing not using `theme('spacing.*')`.
8. **Run Tests**
   - Execute Rails test suite (`rails test`) to ensure no authentication flow regression.
   - Run Storybook test script (`npm run test-storybook`) to verify story snapshots.
   - Run Chromatic CI check (if configured) to confirm no visual drift.
9. **Final Review**
   - Confirm all acceptance criteria checked.
   - Squash commits and prepare for next ticket (e.g., Task List UI).

## Notes
- Keep authentication state (Devise session) unchanged; the React components rely on standard form submission.
- If using Turbo, ensure forms submit with `data-turbo="false"` or wrap in Turbo Frame as appropriate.
- Consider future expansion: after auth views are solid, apply same COSS‑UI wrapper strategy to other UI tickets (Task List, Project Dashboard, etc.).