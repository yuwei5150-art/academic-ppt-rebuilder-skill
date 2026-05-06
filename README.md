# academic-ppt-rebuilder

A Codex skill/plugin for rebuilding academic PowerPoint decks from papers, outlines, templates, AI-generated slide reference images, and GPT-extracted PNG asset packs.

## Recommended Install

This method requires **Node.js**, **Codex CLI**, and **Git**.

On Windows, if `codex` or `npm` is blocked by PowerShell script policy, use the `.cmd` form, for example `codex.cmd` and `npm.cmd`.

### 1. Install prerequisites

Install Node.js LTS from <https://nodejs.org>.

Install Git for Windows from <https://git-scm.com/download/win>. During setup, keep the default option that lets Git run from the command line.

Then install and log in to Codex CLI:

```powershell
npm.cmd install -g @openai/codex
codex.cmd login
```

Check that both commands work:

```powershell
git --version
codex.cmd --version
```

### 2. Add this plugin marketplace

```powershell
codex.cmd plugin marketplace add yuwei5150-art/academic-ppt-rebuilder-skill
```

Then open Codex plugins, find **Academic PPT Rebuilder**, and install or enable it.

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

The `plugins/` folder is the recommended Codex plugin marketplace package. The top-level `academic-ppt-rebuilder/` folder is kept for manual skill installation.

## Manual Skill Install

Copy the `academic-ppt-rebuilder/` folder into a Codex skills directory, for example:

```text
.agents/skills/academic-ppt-rebuilder/
```

## Use

Example prompt:

```text
使用 academic-ppt-rebuilder skill，读取页面参考图、PNG素材包和真实文本，临摹重建为可编辑学术PPT，并输出PPTX和可编辑性报告。
```

## Notes

- Extracted visual elements should be PNG files, preferably transparent-background PNG.
- Titles, body text, module headings, captions, labels, and page numbers should be real editable PowerPoint text.
- Simple shapes, lines, arrows, and diagrams should be rebuilt as PPT-native editable objects where practical.
- Complex icons, logos, simulation figures, paper figures, photos, and textures may remain independent PNG images.
- Do not use a full-slide image as the final PowerPoint page.
