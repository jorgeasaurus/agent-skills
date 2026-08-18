---
name: jorgeasaurus-glass-ui
description: "Use this skill when creating or modifying React/Vite pages, components, social-card views, or app screens that should match the Jorgeasaurus blog glass UI style: fixed translucent nav, forest/mint palette, liquid glass panels, card grids, and screenshot-verified responsive layouts."
---

# Jorgeasaurus Glass UI

## Use When

Build pages that should feel native to the Jorgeasaurus blog: dark forest backdrop, mint highlights, fixed glass navigation, translucent panels, crisp white type, and compact content-first layouts.

## Source Of Truth

In this repo, inspect these files before editing:

- `src/styles/App.css`: glass panel, topbar, hero, post card, article, and responsive rules.
- `src/hooks/useLiquidGlassSurface.ts`: optional WebGL rim/refraction enhancement.
- `src/vendor/liquid-glass-js/glass.css`: vendor glass canvas classes.
- Existing pages/components using `glass-panel`: `Topbar`, `Home`, `Post`, `About`, `PostCard`.

Prefer local tokens and existing classes over new abstractions. Extend the style only when the existing pattern cannot express the page.

## Visual Recipe

- Use a full-page fixed background stage with a real image plus subtle dark/mint overlays.
- Put main content in one constrained column, usually `minmax(0, 880px)`.
- Keep the nav fixed, centered, pill-shaped, and above content; content scrolls behind it.
- Use `.glass-panel` for major surfaces: translucent dark green fill, mint/white border, backdrop blur, inner highlight, deep shadow.
- Add a `::before` highlight layer on glass panels; keep real content above it with `z-index: 1`.
- Use bright white headings with strong shadow, mint monospace uppercase signals, and soft mint body text.
- Use small chips, icon buttons, and compact controls. Give fixed dimensions to icons, nav buttons, counters, toolbars, grids, and cards.
- Keep cards for repeated items or tools. Do not put cards inside cards or make every section a floating card.

## React Pattern

Use the CSS glass as the fallback, then opt into liquid glass when the app already has the hook.

```tsx
import useLiquidGlassSurface from '../hooks/useLiquidGlassSurface'

export default function ExamplePanel() {
  const glassRef = useLiquidGlassSurface<HTMLElement>({
    borderRadius: 30,
    type: 'rounded',
  })

  return (
    <section className="example-panel glass-panel" ref={glassRef}>
      <p className="hero-signal">Field note</p>
      <h1>Build the real page, not a marketing placeholder</h1>
      <p className="panel-copy">Dense, scannable, useful content belongs inside the glass.</p>
    </section>
  )
}
```

Only add the hook to stable panel-like elements. Avoid attaching it to rapidly changing lists, tiny controls, or elements whose size changes on hover.

## CSS Pattern

Start from the existing `.glass-panel` rules. If adding a new surface, keep it scoped.

```css
.example-panel {
  min-height: 360px;
  border-radius: 34px;
  padding: clamp(24px, 4vw, 38px);
  overflow: hidden;
}

.example-panel::after {
  content: '';
  position: absolute;
  right: -120px;
  bottom: -160px;
  width: 360px;
  aspect-ratio: 1;
  border-radius: 999px;
  background: radial-gradient(circle, rgba(157, 240, 182, 0.18), transparent 68%);
  pointer-events: none;
}
```

Use scoped overrides for variants. Do not change `.glass-panel`, `.liquid-glass-surface`, or `.topbar` globally unless the requested change is truly site-wide.

## Layout Rules

- Reserve fixed-nav space with CSS variables like `--fixed-nav-block-size`, `--fixed-nav-gap`, and `--fixed-nav-offset`.
- Use `min-height`, `aspect-ratio`, `grid-template-columns`, and `minmax(0, 1fr)` to prevent text or controls from resizing layouts.
- On mobile, reduce panel radius/padding and hide nonessential labels behind icon-only buttons if the existing nav pattern does so.
- Never let text overlap, clip awkwardly, or resize a button/card on hover.

## Accessibility And Fallbacks

- Keep semantic regions: `nav`, `main`, `section`, `article`, real headings, and descriptive labels.
- Preserve visible focus states for links, cards, and buttons.
- Keep CSS glass usable without WebGL. The hook should enhance, not own, the design.
- Keep `@media (prefers-reduced-transparency: reduce)` fallbacks: remove backdrop filters, use opaque dark backgrounds, and simplify shadows.

## Verification

Before calling the work done:

- Run the project checks, usually `npm run lint`, `npm run build`, and `git diff --check`.
- Inspect desktop and mobile screenshots with Browser or Playwright.
- Check the fixed nav, panel edges, text wrapping, hover/focus states, and reduced viewport widths.
- For social-card pages, verify the exact output dimensions and inspect the rendered image for collisions.

If the page looks like a generic purple/blue glass dashboard, a gradient-orb landing page, or a card stack, revise it back toward the Jorgeasaurus pattern: forest image, dark green glass, mint rim light, compact scannable content.
