---
name: ui-design-and-polish
description: "Use when designing, building, or polishing any frontend interface, component library, design system, or SVG/brand visual."
---

# Ui Design And Polish

## Pre-Build Rules, Art Direction & References

- Load your project's `DESIGN_RULES.md` / UI skills before touching UI code, and ground every design in the product's real subject matter, audience, and surface mode (`Persuade`, `Operate`, `Read`, or `Experience`) (@jonathan_wilke / eliakuratli, @Yohanansoltd, @burkeholland, @X1Kafadzhy / impeccable / frontend-design).
- Never start from a blank page: anchor on a strong existing component library, real product UI, reference screenshots, or `imagegen` redesign concepts, and explore 3 distinct directions when visual direction is open (@jonathan_wilke / eliakuratli, @steipete, @X1Kafadzhy / oil-ui).
- Commit to a single clear art direction per build (varying themes, fonts, palettes, and layouts across generations) and invent one functional signature element—never a center hero + 3 rounded cards + icon row (@JoePro, @X1Kafadzhy / frontend-design).
- Write real copy and a fact sheet before layout—never use Lorem ipsum, fake metrics, invented testimonials, or fake company logos; keep pages concise (~80 words per screen, hero headline + 1 sentence + primary CTA visible at 1280x800) (@JoePro, @X1Kafadzhy / hallmark, @milesdeutscher / taste-skill).
- Never claim an extracted design system from a single page covers a whole product, and never modify existing styles without confirmation (@X1Kafadzhy / extract-design-system).

## Banned AI Visual Tropes

- Ban default AI chrome: purple-to-blue gradients on white, glowing buttons/blobs, sparkle/emoji icons, icons inside rounded boxes, nested cards inside cards, decorative status dots or pills, middle-dot-joined meta strings (`A · B · C`), arrows glued to link text, fanning avatar stacks on hover, colored left bars on selected rows, green checkmarks in circles, and arbitrary `01 / 02 / 03` numbering when content isn't sequential (@jonathan_wilke / eliakuratli, @JoePro, @X1Kafadzhy / unslop / hallmark / frontend-design).
- Keep chrome quiet and concentrate richness into 1–2 focal product moments; finish every UI pass by cutting subtitles that repeat headings, helper text, secondary labels, and unnecessary badges—if a screen needs labels to make sense, fix the layout (@Voxyz_ai, @jonathan_wilke / eliakuratli, @X1Kafadzhy / unslop).
- Contradiction note — ALL-CAPS labels & shadows & captions: default UI rules ban ALL-CAPS/eyebrow labels (`@jonathan_wilke`, `@X1Kafadzhy / hallmark / frontend-design`), allow shadows only on floating elements or layered depth (`@jonathan_wilke`, `@jakubkrehel`), and omit captions under product visuals (`@milesdeutscher / taste-skill`); exceptions apply when explicitly building a Nothing-style monochrome UI (uses Space Mono ALL-CAPS tertiary labels and zero shadows/blur, `@X1Kafadzhy / nothing-design`) or an editorial data report (uses figures with captions, `@jshguo / vercel design.md`).

## Tokens, Color & Typography

- Define semantic CSS tokens (`background`, `surface`, `foreground`, `text-secondary`, `border`, `accent`, spacing, type, motion) before writing layout; ban raw hex codes in components and avoid mixing tinted greys in `oklch` if build transforms shift hues (@jonathan_wilke / eliakuratli, @JoePro, @X1Kafadzhy / hallmark, @jshguo / vercel design.md).
- Avoid overused defaults (Inter, Roboto, Arial); cap to 1–2 distinct font families, a strict type scale, `<80` char line lengths, `text-wrap: balance` on headings, `text-wrap: pretty` on body, `tabular-nums` for dynamic numbers, and `-webkit-font-smoothing: antialiased` on macOS (@JoePro, @jakubkrehel, @X1Kafadzhy / frontend-design / nothing-design).
- Contradiction note — font weights: `@jonathan_wilke` bans bold (`Regular and medium only`), `@X1Kafadzhy / nothing-design` limits to 2 weights (rarely bold), and general UI skills allow standard hierarchy weights. Prefer at most two weights per screen unless display contrast requires bold.
- Use pure neutral black/white 1px low-opacity outlines (`oklch(0 0 0 / 0.1)` / `oklch(1 0 0 / 0.1)`) on images rather than tinted greys so edges don't look muddy (@jakubkrehel).

## Layout, Motion, Icons & Accessibility

- Match concentric border radii (`outer = inner + padding`), align asymmetrically/optically where geometric centering looks off, use `overflow-x: clip` (never `100vw`), `minmax(0, 1fr)` on image grids, and `min-width: 0` on flex/grid children (@jakubkrehel, @X1Kafadzhy / hallmark, @jshguo / vercel design.md).
- Enforce strict motion discipline: keep UI transitions under 300ms (exits faster than entries, `ease-out`, zero bounce), use `scale(0.96)`–`0.97` on button press, never use `transition: all` or animate layout properties (`width`, `height`, `top`, `left`), never animate high-frequency/keyboard actions, use `initial={false}` on load, and always support `prefers-reduced-motion: reduce` (@jonathan_wilke / eliakuratli, @jakubkrehel, @X1Kafadzhy / unslop / hallmark / emil-design-eng).
- Use a single `currentColor` SVG per icon (CSS for states, outline default / fill active), match stroke weight to adjacent text (`1.5px` beside 400, `2px` beside 600), and never mix icon libraries on one surface (@jakubkrehel).
- Meet WCAG AA accessibility and responsive floors everywhere: contrast >=4.5:1, semantic HTML, visible instant `:focus-visible`, full keyboard navigation, `44x44px` mobile (`40x40px` dense desktop) touch targets, explicit breakpoints down to 390px, preserved pinch-zoom/text-selection, and zero-safe-area-inset support (@JoePro, @jakubkrehel, @X1Kafadzhy / ui-ux-pro-max, @joebell_ / apple-web-app).
