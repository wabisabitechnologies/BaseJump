# COSS UI Migration Skill

## Purpose
Provides a structured approach to migrate an existing React frontend to COSS UI using Storybook for component development while maintaining consistency.

## Prerequisites
- Node.js >= 18
- Yarn or npm
- Git
- Existing React project (React 16.8+ recommended, but will upgrade to 18)

## Steps

### 1. Audit & Baseline
1. List all existing React components (`src/components/**/*.jsx` or similar).
2. Identify UI library usage (e.g., Bootstrap, custom CSS).
3. Capture current visual state: run Storybook if exists, or take screenshots of key pages.
4. Record current React version and dependencies.

### 2. Upgrade React & Tooling
1. Upgrade to React 18 (if not already):
   ```bash
   npm install react@^18 react-dom@^18
   ```
2. Update Babel/Webpack config to support JSX modern transform if needed.
3. Ensure ESLint plugins are up-to-date (`eslint-plugin-react`, `eslint-plugin-react-hooks`).

### 3. Set Up COSS UI Dependencies
1. Install COSS UI (follow https://coss.com/ui/docs#get-started):
   ```bash
   # COSS UI is source‑copy; you can clone the repo or copy components
   git clone https://github.com/cosscom/coss-ui.git ui-src
   # Or copy the components you need into src/ui/
   ```
2. Install Tailwind CSS (required by COSS UI):
   ```bash
   npm install -D tailwindcss@latest postcss@latest autoprefixer@latest
   npx tailwindcss init -p
   ```
3. Configure `tailwind.config.js` to include your source files:
   ```js
   module.exports = {
     content: [
       "./src/**/*.{js,jsx,ts,tsx}",
       "./ui-src/**/*.{js,jsx,ts,tsx}" // if you copied COSS UI
     ],
     theme: {
       extend: {},
     },
     plugins: [],
   }
   ```
4. Add Tailwind directives to your main CSS file (e.g., `src/index.css`):
   ```css
   @tailwind base;
   @tailwind components;
   @tailwind utilities;
   ```

### 4. Initialize Storybook
1. Install Storybook:
   ```bash
   npx sb init --type react_scripts
   ```
   (Adjust type if using Vite, Next.js, etc.)
2. Verify Storybook runs:
   ```bash
   npm run storybook
   ```
3. Add COSS UI parameters to Storybook preview (optional):
   ```js
   // .storybook/preview.js
   import '../src/index.css'; // ensure Tailwind is loaded
   export const parameters = {
     actions: { argTypesRegex: "^on[A-Z].*" },
     controls: {
       matchers: {
         color: /(background|color)$/i,
         date: /Date$/,
       },
     },
   };
   ```

### 5. Establish Design Token Mapping
1. Extract your existing design tokens (colors, spacing, font sizes) from current CSS/SCSS.
2. Map them to Tailwind config or CSS variables:
   ```js
   // tailwind.config.js
   theme: {
     extend: {
       colors: {
         landing: {
           blue: '#YOUR_EXISTING_BLUE',
           dark: '#YOUR_EXISTING_DARK',
         },
       },
       spacing: {
         '100': '25rem',
       },
       fontSize: {
         'h1': ['3.125rem', '1.2'],
       },
     },
   }
   ```
3. Create a token file if you prefer CSS variables:
   ```css
   :root {
     --color-landing-blue: #YOUR_EXISTING_BLUE;
     --color-landing-dark: #YOUR_EXISTING_DARK;
   }
   ```
   Then use `var(--color-landing-blue)` in your components or Tailwind via `theme('colors.landing.blue')`.

### 6. Create Wrapper / Adapter Components
1. For each COSS primitive you plan to use, create a thin wrapper that applies your project defaults:
   ```jsx
   // src/ui/Button.jsx
   import { Button as COSSButton } from '../ui-src/Button';
   export const Button = ({ variant = 'primary', size = 'md', ...props }) => (
     <COSSButton variant={variant} size={size} {...props} />
   );
   ```
2. Export wrappers from a single UI barrel (`src/ui/index.js`) for consistent imports.

### 7. Migration Planning
1. Prioritize components by:
   - High reuse (buttons, inputs, modals)
   - Visual complexity
   - Frequency of change
2. Create a migration spreadsheet:
   | Component | Status | Storybook URL | Notes |
   |-----------|--------|---------------|-------|
   | Button    | todo   |               |       |
   | Modal     | in-progress |          |       |
3. For each component:
   - Write the Storybook story using the COSS wrapper.
   - Achieve visual match with existing component (use Chromatic or Storyshots for regression).
   - Replace usage in the codebase with the new wrapper.
   - Remove old component files once all usages are migrated.

### 8. Visual Regression & Testing
1. Add Chromatic (or Storyshots) to CI:
   ```bash
   npm install -D chromatic
   ```
2. Configure `chromatic.json` with your project token.
3. Run Chromatic on each PR to detect visual drift.
4. Keep existing unit/integration tests; update them to render new wrappers.

### 9. Linting & Enforcement
1. Add ESLint rule to ban old UI classes (if using CSS modules or utility classes):
   ```json
   // .eslintrc.json
   {
     "rules": {
       "no-restricted-classes": [
         "error",
         {
           "className": "btn",
           "message": "Use the new Button wrapper from @/ui instead"
         }
       ]
     }
   }
   ```
2. Add Stylelint rule to disallow hardcoded colors/spacing that violate tokens.

### 10. Documentation & Knowledge Transfer
1. Update `CONTRIBUTING.md` with migration steps and how to add new components.
2. Ensure Storybook is the canonical source for UI component documentation.
3. Conduct a walkthrough with the team on using the new UI library and wrappers.

## Expected Outcome
- A fully functional Storybook library of COSS UI wrappers matching the existing visual design.
- All components migrated from old implementations to the new COSS‑based wrappers.
- Consistent styling enforced via Tailwind design token mapping and linting.
- Upgraded React 18 enabling modern patterns (hooks, concurrent features).
- Reduced UI drift through visual regression testing in CI.

## Troubleshooting
- **Tailwind not applying**: Ensure Tailwind directives are imported in a CSS file that is included in the app entry.
- **Storybook not showing components**: Verify webpack/Babel alias for `@/` or relative paths.
- **React version warnings**: Check for duplicate React versions in `node_modules` (run `npm ls react`).
