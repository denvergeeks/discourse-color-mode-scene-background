# Color Mode Scene Background

| | |
|-|-|
| Summary | Adds a global illustrated day/night background scene that follows Discourse light, dark, and auto color mode, then layers a restrained glass-style treatment over core forum surfaces. |
| Repository | `https://github.com/YOUR-ORG/color-mode-scene-background` |
| Install | Admin → Appearance → Components → Install → From a git repository |
| Supported | Tested on `2026.6.0-latest` |
| Component type | Theme component |

## Features

- Global day/night illustrated background scene rendered through `above-main-container`
- Follows core Discourse light, dark, and auto color mode
- SVG scene assets with subtle CSS motion layers
- Restrained glass treatment for the header, sidebar, menus, topic shells, timeline surfaces, and composer
- `prefers-reduced-motion` support
- Theme settings for desktop/mobile enablement, scene opacity, motion strength, and content wash strength

## Why this approach

This is a theme component rather than a plugin because the feature is entirely frontend-oriented and does not require backend behavior.

It uses a supported plugin outlet and keeps styling scoped to a small allowlist of core surfaces so it is less likely to conflict with plugin UIs and future core updates.

## Install

1. Push this repo to GitHub.
2. In Discourse, go to **Admin → Appearance → Components**.
3. Click **Install → From a git repository**.
4. Paste the repository URL.
5. Attach the component to your active theme.

See also: the standard Discourse install guide for themes and theme components.

## Settings

- `enable_on_desktop`
- `enable_on_mobile`
- `day_scene_opacity`
- `night_scene_opacity`
- `motion_strength`
- `content_backdrop_strength`

## Notes

- The `.gjs` connector renders through `above-main-container`.
- The component avoids `modifyClass` and backend plugin code.
- The glass treatment is intentionally limited to core surfaces instead of broad page-wide overrides.
- Admin pages and many third-party plugin screens are intentionally left flatter to reduce upgrade and compatibility risk.

## Known limitations

- The connector is modern and practical, but `.gjs` connectors are less explicitly documented than classic connector template examples.
- Very heavily customized themes or plugins may still want additional local selector adjustments.
- You should generate screenshots on your own instance so the preview reflects your active color palette and plugin mix.

## Screenshots

Add light and dark screenshots from your own instance before publishing.
