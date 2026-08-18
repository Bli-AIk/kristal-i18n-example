# Contributing to kristal-i18n-example

Thank you for wanting to contribute! 🌍

## What this mod is about: translating the vanilla template

**kristal-i18n-example** is an integration test and demo mod for [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n). Its content is the entire vanilla Kristal `0.11.0-dev` template, and the heavy lifting is already done:

- **Every template text has been extracted.** Dialogue, cutscenes, choices, items, weapons, armors, spells, menus, the save screen, the shop, the debug menu, battle results, light/dark world UI — the English originals live in `lang/en.json` and the translated reference in `lang/zh_hans.json`.
- **All hooks are already in place.** The [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) library handles every hook — you don't need to write a single line of Lua.
- **Simplified Chinese is the complete reference.** The `lang/zh_hans.json` translation (based on the [Goodman 3 Localization Group](https://github.com/gm3dr/) localization) covers the whole template, showing exactly what a finished translation looks like.

So this mod's contribution focus is **template translation**: translating the vanilla template content into your language. Translators only need to **translate** — copy any existing language file, translate the values into your language, register your language — done. Players can switch to it from the in-game settings menu immediately.

I fully support and welcome pull requests for translations in your language! That's exactly why I created this localization library—to help everyone make games and translate existing ones in their native languages.

> **What this guide covers:** the **vanilla template content** of this demo mod. Translating the **framework's built-in texts** (everything the engine itself displays) is the focus of the [kristal-i18n contributing guide](https://github.com/Bli-AIk/kristal-i18n/blob/main/CONTRIBUTING.md).

## Adding a new language

1. **Pick a starting file.** Copy any existing language file to `lang/<your_language>.json` (e.g. `lang/fr.json` for French, `lang/ja.json` for Japanese). `lang/zh_hans.json` is the most complete reference, but you can start from whichever language you read best.
2. **Translate the values.** Translate every value into your language. Keep the **keys unchanged** — the game looks up text by key, and the keys are shared across all languages.
3. **Register the language.** In `mod.json`, under `config.kristalI18n`, add your language ID to `languages` and its display name to `languageNames`:
   ```json
   "languages": ["en", "zh_hans", "fr"],
   "languageNames": {
       "en": "English",
       "zh_hans": "简体中文",
       "fr": "Français"
   }
   ```
4. **(Optional) Names and assets.** Add character names for your language to `lang/names.json`, and drop texture/font/audio overrides under `lang/<your_language>/...` if your language needs them (see the README's features section).
5. **Test in-game.** Launch the mod in Kristal and switch languages instantly with the toggle key (default `F7`) to check your work in both directions.
6. **Open a pull request.** 🎉

## Translation guidelines

- **Keys never change — only values.** Renaming a key breaks lookups in every language.
- **Keep placeholders intact.** `{key}` interpolation and `[var:name]` / `[name:kris]` markers must be preserved. You may move them within the sentence to fit your grammar, but don't drop them.
- **Match the tone.** The vanilla template texts are short and typewriter-paced. Keep your translations concise so they read well at the game's typing speed.
- **Check the context.** Some keys are shared across menus. When a translation feels ambiguous, look at how `lang/zh_hans.json` renders it, or run the mod to see it in-game.

## Other ways to contribute

- **Report untranslated text** — if any hooked text shows up raw in-game, file an issue with a screenshot and the steps to reproduce.
- **Improve an existing translation** — wording, tone, or consistency fixes are always welcome.
- **Suggest new demo scenes** — to exercise library features that the mod doesn't cover yet.
- **Library-level contributions** — new hooks or built-in texts belong in [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) (see its contributing guide).

## License

By contributing, you agree that your contribution is dual-licensed under the MIT License and the Apache License, Version 2.0 (same as the project).
