# kristal-i18n-example

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE) <img src="https://img.shields.io/github/repo-size/Bli-AIk/kristal-i18n-example.svg"/> <img src="https://img.shields.io/github/last-commit/Bli-AIk/kristal-i18n-example.svg"/> <img src="https://img.shields.io/github/v/release/Bli-AIk/kristal-i18n-example.svg"/> <br>
<img src="https://img.shields.io/badge/Deltarune-001225?style=for-the-badge&labelColor=001225&logo=undertale&logoColor=ff0000" /> <img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" /> <img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

![战斗内展示](./screenshot-battle.png)

<details>
<summary>更多截图（存档页面 / 角色能力 / 调试界面 / 光世界背包）</summary>

![存档页面](./screenshot.png)

![角色能力页面](./screenshot-ability.png)

![调试界面](./screenshot-debug.png)

![光世界背包](./screenshot-light-inventory.png)

</details>

**kristal-i18n-example** — [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) 的集成测试与演示模组。

本模组把 Kristal `v0.10.0` 模板的所有英文内容都按照 [好人汉化组](https://github.com/gm3dr/) 的翻译进行了汉化，并额外加入了一个光世界场景用于测试光世界对话，用于验证和展示库的各项本地化能力。玩家可以在游戏内的**设置菜单**中切换中英文。

| 简体中文 | English                |
| -------- | ---------------------- |
| 简体中文 | [English](./README.md) |

## Kristal 版本支持

| `kristal`                                                                                                                  | `kristal-i18n-example` |
| -------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| [v0.10.0](https://github.com/KristalTeam/Kristal/commit/752bc0688ba97ca8a256ba9125b7e05a1ca6edbd) (`752bc068`, 2026-06-23) | 0.0.0                  |

## 特性

- 🌐 中英双语，设置菜单一键切换
- 📝 文本用 `{id}` 内插本地化：`cutscene:text("{room1.hello}")`
- 🎬 传说过场示例：Debug → Play Legend → example（`scripts/legends/example.lua`）
- 🗺️ Tiled NPC / Interactable 的 `text1`/`text2` 属性直接写 `{key}`
- 🏷️ Tiled 地图名通过 `name_id` 属性本地化
- ⚔️ 物品、武器、防具、法术自动 key 化
- 🔤 混合字体：同一段文本中英文/ASCII 用原版 8bitOperator 字形，中文字符自动回落至 FZBitmap / Unifont 点阵字体

## 依赖

| 库                                                      | 说明                           |
| ------------------------------------------------------- | ------------------------------ |
| [Kristal](https://github.com/KristalTeam/Kristal)       | 游戏引擎，`v0.10.0` 或更高版本 |
| [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) | 中文本地化库                   |

## 使用方式

1. 安装 [Kristal](https://github.com/KristalTeam/Kristal) 引擎。
2. 将本仓库克隆到 Kristal 的 `mods/` 目录下。**注意：[kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) 库是以 git 子模块的形式引入的，普通的 `git clone` 不会下载它——克隆时记得拉取子模块。** 可以用 `--recurse-submodules` 一步到位：

   ```bash
   cd Kristal/mods
   git clone --recurse-submodules https://github.com/Bli-AIk/kristal-i18n-example.git
   ```

   如果已经克隆完成、发现没有子模块，事后补拉也可以：

   ```bash
   cd kristal-i18n-example
   git submodule update --init --recursive
   ```

3. 启动 Kristal，在模组选择中选择 **kristal-i18n-example**。

## 参考来源

汉化文本以 [好人汉化组（Goodman 3 Localization Group | UNDERTALE & DELTARUNE Chinese Localization）](https://github.com/gm3dr/) 为准。

## 参与贡献

欢迎提交 Issue 或 Pull Request。

我全力支持并欢迎为你的语言提交翻译 Pull Request！这正是我创建这个本地化库的初衷——让每个人都能用自己的母语制作游戏、翻译现有的游戏。

本模组侧重**模板翻译**——把原版 Kristal 模板的内容翻译成你的语言。贡献翻译请看 [贡献指南](CONTRIBUTING_zh_hans.md)（英文版：[CONTRIBUTING.md](CONTRIBUTING.md)）；框架内置文本的翻译则请看 [kristal-i18n 的贡献指南](https://github.com/Bli-AIk/kristal-i18n/blob/main/CONTRIBUTING_zh_hans.md)。

## 许可证

本项目采用双许可证授权，您可以选择以下任一许可证：

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) 或 http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) 或 http://opensource.org/licenses/MIT)
