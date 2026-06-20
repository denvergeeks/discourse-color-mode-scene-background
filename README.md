# Color Mode Scene Background

A Discourse theme component that adds a global illustrated day/night background scene which follows Discourse core light, dark, and auto color mode, then layers a glassy interface treatment over key Discourse surfaces.

## What it does

- Renders a global decorative scene through the `above-main-container` outlet using a `.gjs` connector.
- Uses Discourse core color mode behavior rather than replacing the built-in toggle.
- Cross-fades between authored day and night SVG scenes.
- Adds subtle motion with CSS-only clouds, stars, aurora, and haze.
- Applies a glass-style treatment to the header, sidebar, topic containers, menus, and composer.
- Respects `prefers-reduced-motion`.

## Why this architecture

This is implemented as a **theme component**, not a plugin, because it is a frontend customization and does not require backend behavior.

It uses:

- a supported plugin outlet connector in `javascripts/discourse/connectors/above-main-container/color-mode-scene-background.gjs`
- theme assets declared in `about.json`
- theme-upload URLs accessed in JS via `settings.theme_uploads`
- SCSS driven by Discourse CSS variables rather than hardcoded full-theme overrides

## Files

```text
color-mode-scene-background/
├─ about.json
├─ settings.yml
├─ README.md
├─ locales/
│  └─ en.yml
├─ assets/
│  ├─ day-scene.svg
│  └─ night-scene.svg
├─ common/
│  └─ common.scss
└─ javascripts/
   └─ discourse/
      ├─ components/
      │  └─ color-mode-scene-background.gjs
      └─ connectors/
         └─ above-main-container/
            └─ color-mode-scene-background.gjs
```

## Installation

### Remote theme component

1. Push this repository to GitHub.
2. In Discourse admin, go to **Customize → Themes**.
3. Choose **Install → From a git repository**.
4. Paste the repository URL.
5. Add the component to your active theme.

### Local development

Use the Discourse Theme CLI for local iteration if you prefer a live-reload workflow.

## Settings

- `enable_on_desktop`: show the component on desktop.
- `enable_on_mobile`: show the component on mobile.
- `day_scene_opacity`: opacity of the day SVG scene.
- `night_scene_opacity`: opacity of the night SVG scene.
- `motion_strength`: `subtle`, `normal`, or `enhanced`.
- `content_backdrop_strength`: readability wash behind main content.

## Notes on color mode detection

The component first checks the computed `--scheme-type` CSS variable, then falls back to root DOM indicators and finally `prefers-color-scheme`. That keeps it aligned with Discourse’s built-in light/dark/auto behavior without taking over the toggle UI.

## Safe customization points

Good next steps:

- swap the SVG artwork with your own illustrations
- tune blur strength and surface opacity in `common/common.scss`
- reduce the list of glass-treated selectors if a plugin UI needs a flatter surface

## Upgrade notes

The stable parts of this component are the plugin outlet, theme asset pipeline, and SCSS variable-driven styling.

The most likely future maintenance point is the small bit of effective color-mode detection in the Glimmer component, because Discourse may evolve how the active scheme is reflected in the DOM or computed CSS.

## Screenshots

Generate screenshots on your instance after install so they reflect your actual theme colors and plugin mix.


## Compatibility note

This version uses a `.gjs` connector instead of an API initializer, which keeps outlet rendering simpler and avoids an unnecessary runtime registration step.

The component imports `didInsert` from `@ember/render-modifiers/modifiers/did-insert`, which matches current Discourse core Glimmer component usage.


## QA checklist

- Confirm the component renders once through `above-main-container`.
- Toggle Discourse light, dark, and auto mode and verify the scene follows correctly.
- Check the header, sidebar, topic list, and composer on desktop and mobile.
- Test one admin screen and one plugin-heavy page to make sure the glass selectors are not too aggressive.
- Confirm `prefers-reduced-motion` disables the animated scene behavior.


## Uninstall

1. Remove the component from any themes that include it.
2. Delete the component from **Admin → Appearance → Components**.
3. Hard-refresh the browser after removal so any cached theme assets are reloaded.

## Publishing on Meta

When you publish this component, open a topic in the Meta theme or theme component area after the repository is on GitHub. Include a short summary, screenshots, the repository link, an install guide link, supported Discourse version notes, and any known limitations.

A practical topic template is:

- Summary: global illustrated day/night scene that follows Discourse light/dark/auto mode
- Repository: your GitHub repository URL
- Install: install from Git repository, then attach to active themes
- Supported: tested on `2026.6.0-latest`
- Notes: uses `above-main-container` and a `.gjs` connector, glass styling intentionally limited to core high-value surfaces

## Selector scope

This production pass intentionally limits the glass treatment to core high-value surfaces such as the header, sidebar, menus, topic list shell, topic body, timeline surfaces, and composer. It avoids broad styling of user pages, admin pages, review queues, and many plugin-specific cards so upgrade risk stays lower and third-party UI conflicts are less likely.


## Repository files

- `LICENSE`: MIT license text for public publishing.
- `CHANGELOG.md`: compact release history.
- `META-TOPIC.md`: a first-post draft you can adapt for a Meta release topic.


## Screenshots

This repo now includes a `screenshots/` folder stub and `about.json` screenshot entries for `screenshots/light.png` and `screenshots/dark.png`. Replace those placeholders with real captures from your own instance before publishing. Current Discourse metadata guidance allows up to two screenshots in a top-level `screenshots` folder, typically a light and dark preview.
