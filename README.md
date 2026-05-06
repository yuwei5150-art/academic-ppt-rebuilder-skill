# academic-ppt-rebuilder

A Codex skill/plugin for rebuilding academic PowerPoint decks from papers, outlines, templates, AI-generated slide reference images, and GPT-extracted PNG asset packs.

## Recommended Online Install

This is the most reliable online install path today. It does not require downloading a zip file manually.

### Windows PowerShell

Open PowerShell in the project where you want to use the skill, then run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/yuwei5150-art/academic-ppt-rebuilder-skill/main/install.ps1 | iex"
```

This installs the skill into:

```text
.agents/skills/academic-ppt-rebuilder/
```

### macOS / Linux

Open a terminal in the project where you want to use the skill, then run:

```bash
curl -fsSL https://raw.githubusercontent.com/yuwei5150-art/academic-ppt-rebuilder-skill/main/install.sh | bash
```

## Use In Codex

After installing, open Codex in that project and run:

```text
/skills
```

Confirm `academic-ppt-rebuilder` appears, then ask:

```text
使用 academic-ppt-rebuilder skill，读取页面参考图、PNG素材包和真实文本，临摹重建为可编辑学术PPT，并输出PPTX和可编辑性报告。
```

## Experimental Codex Plugin Marketplace

This repository also includes a Codex plugin marketplace structure. Current Codex CLI versions can add and upgrade the marketplace, but may not expose install/list UI in every environment yet.

```powershell
codex.cmd plugin marketplace add yuwei5150-art/academic-ppt-rebuilder-skill
codex.cmd plugin marketplace upgrade yuwei5150-art-codex-plugins
```

If the plugin does not appear in `/plugins` or `/skills`, use the online installer above.

## What It Does

This skill supports a staged workflow:

1. Start from papers, source materials, and presentation requirements.
2. Use GPT to create content-satisfactory slide reference images.
3. Use GPT to restyle those images according to a target PPT template.
4. Use GPT to extract slide elements into PNG assets, preferably transparent-background PNG files.
5. Use Codex to read the PNG asset pack, slide reference images, and real text.
6. Rebuild the deck as an editable academic PowerPoint file.
7. Output a PPTX plus an editability report.

The skill emphasizes editable text, PPT-native shapes, academic clarity, consistent style, and avoiding full-slide screenshot decks.

## Repository Layout

```text
academic-ppt-rebuilder-skill/
  README.md
  install.ps1
  install.sh
  .agents/
    plugins/
      marketplace.json
  plugins/
    academic-ppt-rebuilder/
      .codex-plugin/
        plugin.json
      skills/
        academic-ppt-rebuilder/
          SKILL.md
  academic-ppt-rebuilder/
    SKILL.md
    agents/
      openai.yaml
```

The `academic-ppt-rebuilder/` folder is the stable skill package. The `plugins/` folder is kept for Codex plugin marketplace support.

## Manual Skill Install

Copy the `academic-ppt-rebuilder/` folder into a Codex skills directory, for example:

```text
.agents/skills/academic-ppt-rebuilder/
```

## Notes

- Extracted visual elements should be PNG files, preferably transparent-background PNG.
- Titles, body text, module headings, captions, labels, and page numbers should be real editable PowerPoint text.
- Simple shapes, lines, arrows, and diagrams should be rebuilt as PPT-native editable objects where practical.
- Complex icons, logos, simulation figures, paper figures, photos, and textures may remain independent PNG images.
- Do not use a full-slide image as the final PowerPoint page.
