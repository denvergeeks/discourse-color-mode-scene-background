import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import I18n from "discourse-i18n";

export default class ColorModeSceneBackground extends Component {
  @service site;

  @tracked effectiveMode = "light";

  mediaQueryList = null;
  mutationObserver = null;

  constructor() {
    super(...arguments);
    this.syncEffectiveMode();
    this.setupMediaListener();
    this.setupMutationObserver();
  }

  get shouldRender() {
    if (this.site.mobileView) {
      return settings.enable_on_mobile;
    }

    return settings.enable_on_desktop;
  }

  get sceneClasses() {
    const classes = ["color-mode-scene-background", `motion-${settings.motion_strength}`];

    if (this.effectiveMode === "dark") {
      classes.push("is-dark-scene");
    } else {
      classes.push("is-light-scene");
    }

    return classes.join(" ");
  }

  get sceneStyle() {
    return [
      `--scene-day-opacity:${settings.day_scene_opacity}`,
      `--scene-night-opacity:${settings.night_scene_opacity}`,
      `--scene-content-backdrop-strength:${settings.content_backdrop_strength}`,
    ].join("; ");
  }

  get daySceneUrl() {
    return settings.theme_uploads?.day_scene;
  }

  get nightSceneUrl() {
    return settings.theme_uploads?.night_scene;
  }

  get decorativeLabel() {
    return I18n.t("color_mode_scene_background.decorative_label");
  }

  syncEffectiveMode() {
    const html = document.documentElement;
    const schemeType = getComputedStyle(html).getPropertyValue("--scheme-type").trim();

    if (schemeType === "dark") {
      this.effectiveMode = "dark";
      return;
    }

    if (schemeType === "light") {
      this.effectiveMode = "light";
      return;
    }

    const dataScheme = html.dataset.themeColorScheme;

    if (dataScheme === "dark" || html.classList.contains("dark")) {
      this.effectiveMode = "dark";
      return;
    }

    if (dataScheme === "light") {
      this.effectiveMode = "light";
      return;
    }

    this.effectiveMode = window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light";
  }

  setupMediaListener() {
    if (this.mediaQueryList) {
      return;
    }

    this.mediaQueryList = window.matchMedia("(prefers-color-scheme: dark)");
    this.mediaQueryList.addEventListener("change", this.syncEffectiveModeBound);
  }

  setupMutationObserver() {
    if (this.mutationObserver) {
      return;
    }

    this.mutationObserver = new MutationObserver(() => this.syncEffectiveMode());
    this.mutationObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class", "data-theme-color-scheme", "style"],
    });
  }

  syncEffectiveModeBound = () => {
    this.syncEffectiveMode();
  };

  willDestroy() {
    super.willDestroy(...arguments);
    this.mediaQueryList?.removeEventListener("change", this.syncEffectiveModeBound);
    this.mutationObserver?.disconnect();
    document.documentElement.classList.remove("has-color-mode-scene-background");
  }

  @action
  setupSceneElement() {
    document.documentElement.classList.add("has-color-mode-scene-background");
    this.syncEffectiveMode();
  }

  <template>
    {{#if this.shouldRender}}
      <div
        class={{this.sceneClasses}}
        style={{this.sceneStyle}}
        aria-hidden="true"
        title={{this.decorativeLabel}}
        {{didInsert this.setupSceneElement}}
      >
        <div class="color-mode-scene-background__fixed-layer">
          <div class="color-mode-scene-background__scene color-mode-scene-background__scene--day">
            <img
              class="color-mode-scene-background__art"
              src={{this.daySceneUrl}}
              alt=""
              loading="eager"
              decoding="async"
            />
            <div class="color-mode-scene-background__clouds color-mode-scene-background__clouds--1"></div>
            <div class="color-mode-scene-background__clouds color-mode-scene-background__clouds--2"></div>
            <div class="color-mode-scene-background__light-haze"></div>
          </div>

          <div class="color-mode-scene-background__scene color-mode-scene-background__scene--night">
            <img
              class="color-mode-scene-background__art"
              src={{this.nightSceneUrl}}
              alt=""
              loading="eager"
              decoding="async"
            />
            <div class="color-mode-scene-background__stars color-mode-scene-background__stars--1"></div>
            <div class="color-mode-scene-background__stars color-mode-scene-background__stars--2"></div>
            <div class="color-mode-scene-background__aurora"></div>
            <div class="color-mode-scene-background__night-glow"></div>
          </div>

          <div class="color-mode-scene-background__content-wash"></div>
        </div>
      </div>
    {{/if}}
  </template>
}
