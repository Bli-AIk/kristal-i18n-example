# kristal-i18n-example

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE)
<br>
<img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" />
<img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

![In battle](./screenshot-battle.png)

<details>
<summary>More screenshots (save screen / ability / debug / light world inventory)</summary>

![Save screen](./screenshot.png)

![Ability screen](./screenshot-ability.png)

![Debug screen](./screenshot-debug.png)

![Light world inventory](./screenshot-light-inventory.png)

</details>

**kristal-i18n-example** — an integration test and demo mod for [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n).

This mod translates all English content of the Kristal `v0.10.0` template into Chinese following the [Goodman 3 Localization Group](https://github.com/gm3dr/) translations, and adds an extra light world area to test light world dialogue. It is used to verify and demonstrate the library's localization capabilities. Players can switch between Chinese and English in the in-game **settings menu**.

| English | 简体中文                |
| ------- | ----------------------- |
| English | [简体中文](./README.md) |

## Features

- 🌐 Bilingual (Chinese/English), switchable in the settings menu
- 📝 Text localized via `{id}` interpolation: `cutscene:text("{room1.hello}")`
- 🗺️ Tiled NPC / Interactable `text1`/`text2` properties accept `{key}` directly
- 🏷️ Tiled map names localized via the `name_id` property
- ⚔️ Items, weapons, armors, and spells auto-keyed
- 🔤 Hybrid fonts: within the same text, English/ASCII uses the original 8bitOperator glyphs while Chinese characters automatically fall back to the FZBitmap / Unifont bitmap fonts

## Dependencies

| Library                                                               | Description                     |
| --------------------------------------------------------------------- | ------------------------------- |
| [Kristal](https://github.com/KristalTeam/Kristal)                     | Game engine, `v0.10.0` or later |
| [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) | Chinese localization library    |

## How to Use

1. Install the [Kristal](https://github.com/KristalTeam/Kristal) engine.
2. Clone this repository into Kristal's `mods/` directory and initialize submodules:

   ```bash
   cd Kristal/mods
   git clone https://github.com/Bli-AIk/kristal-i18n-example.git
   cd kristal-i18n-example
   git submodule update --init
   ```

3. Launch Kristal and select **kristal-i18n-example** from the mod menu.

## References

Localized text follows the [Goodman 3 Localization Group | UNDERTALE & DELTARUNE Chinese Localization](https://github.com/gm3dr/) translations.

## Contributing

Issues and Pull Requests are welcome.

## License

This project is licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.
