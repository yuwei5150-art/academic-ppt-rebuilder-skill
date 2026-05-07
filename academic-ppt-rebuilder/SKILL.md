---
name: academic-ppt-rebuilder
description: 当用户需要围绕“论文/材料/要求 -> 内容满意的页面参考图并经主人审核 -> 按模板统一风格 -> 抠图拆元素并统一转为PNG素材包 -> Codex读取PNG素材包、页面参考图和真实文本 -> 重建为可编辑学术PPT -> 输出PPTX和可编辑性报告”的流程，生成高质量、学术风格、可编辑的 PowerPoint 文件时使用本skill。适用于论文、Word、PDF、markdown、大纲、PPT模板、AI页面图和GPT抠图PNG素材包驱动的学术PPT重建任务，重点避免整页截图式PPT，并强制要求阶段2审核通过后才能进入后续阶段。
---

# Academic PPT Rebuilder

## 使用场景

使用本 skill 处理阶段化学术 PPT 生成与重建任务。这个 skill 不假设 Codex 一步直接完成全部视觉创作，而是围绕以下流程工作：

1. 输入论文、材料和要求。
2. GPT 先生成内容结构满意的页面图，并通过主人审核。
3. GPT 再根据目标模板统一色系、风格和学术感。
4. GPT 从最终页面图中抠图拆出独立元素，并统一转为 PNG 素材包。
5. Codex 读取 PNG 素材包、页面参考图和真实文本。
6. Codex 临摹重建为可编辑 PowerPoint。
7. 输出 `.pptx` 和可编辑性报告。

核心目标是：把 AI 生成的“页面图”转化为真实可编辑、风格统一、逻辑清晰的学术 PPT。优先保证学术汇报逻辑清晰、风格统一、可继续修改；不要承诺 100% 完美还原参考图。

## 阶段化执行铁律

本 skill 必须按阶段工作，不要把“分析材料”和“生成 PPTX”合并成一步。

- 严格按 1 -> 7 顺序推进。每个阶段完全结束、产物保存并通过检查后，才能进入下一个阶段。
- 阶段之间尽量独立。下一阶段主要依赖上一阶段保存下来的文件，而不是临时聊天记忆。
- 每完成一个阶段，必须更新 `output/stage_status.md`，记录：当前阶段、已保存产物、质量检查结果、主人审核状态、待确认问题、下一阶段是否可以开始。
- 所有阶段检查都是硬门槛。只要产物缺失、质量不合格、审核状态为 `pending/rejected/unknown`，或 `next_stage_allowed` 不是明确的 `yes`，就必须停在当前阶段。
- 阶段 2 是最高优先级审核闸门。阶段 2 没有通过主人审核时，严禁进入阶段 3，严禁统一模板风格，严禁抠图拆元素，严禁开始做 PPTX。
- 阶段 2 审核未通过时，必须回到阶段 1/2 重新分析内容规划、修改页面草图需求、重新生成页面图，并把修改记录写入 `output/stage_02_content_pages/revision_log.md`。重复此循环，直到主人明确审核通过。
- 不要在只有论文、素材或模板时直接做 PPTX。只有当页面参考图、最终风格图、PNG 素材包和真实文本映射已经准备好后，Codex 才进入可编辑 PPT 重建阶段。
- 如果用户要求一次跑完整流程，可以连续执行，但仍必须逐阶段保存中间结果并做阶段检查。
- 阶段 2 默认必须请求主人审核。只有用户在任务开始时明确说明“不需要人工审核、自动推进”，才能用严格自评报告代替主人审核；否则不能跳过。
- 阶段 3 的“满意”默认也需要用户确认；若用户明确授权自动推进，则用自评报告代替确认，但仍要保存报告。

`output/stage_status.md` 至少包含以下字段：

```text
current_stage:
completed_artifacts:
quality_check:
owner_review_for_current_stage: pending | approved | rejected | not_required
stage_02_owner_review: pending | approved | rejected | not_required
next_stage_allowed: yes | no
blockers:
next_action:
```

除非 `owner_review_for_current_stage` 为 `approved/not_required` 且 `next_stage_allowed` 为 `yes`，否则必须继续处理当前阶段。阶段 2 还必须额外满足 `stage_02_owner_review: approved`。

## 输入材料说明

常见输入包括：

- `source/`：论文、PDF、Word、markdown、实验材料、原始文本。
- `outline/`：每页内容规划、汇报大纲、页数要求、讲述顺序。
- `template/`：目标 PPT 模板、母版、已有学术汇报样例。
- `refs/`：GPT 生成的页面参考图，包括内容满意版和模板风格统一版。
- `extracted_assets/`：GPT 抠图拆出的 PNG 素材包，包括图标、色块、箭头、线条、背景装饰、logo、公式卡片、论文图、仿真图等独立素材。
- `PPT_RULES.md`：项目级 PPT 规则，必须优先读取并遵守。
- `output/`：最终 PPTX、预览图、可编辑性报告。

若多个来源冲突，优先级通常为：用户明确要求 > `PPT_RULES.md` > 目标模板风格 > 真实文本内容 > 页面参考图 > 通用审美判断。

## 推荐项目文件夹结构

```text
project/
  PPT_RULES.md
  source/
  outline/
  template/
  refs/
    content_pages/
    styled_pages/
  extracted_assets/
    slide_01/
      slide01_icon_01.png
      slide01_arrow_01.png
  output/
    stage_status.md
    stage_01_content_plan/
    stage_02_content_pages/
    stage_03_style_unified/
    stage_04_assets/
    stage_05_rebuild_inputs/
    preview/
    academic_presentation.pptx
    editability_report.md
```

## 工作流程

### 1. 输入论文/材料/要求

先理解用户提供的论文、材料、汇报目标和模板要求。此阶段只做内容规划和页面草图需求，不做最终 PPT。

需要产出或确认：

- 每页讲什么。
- 每页核心观点是什么。
- 哪些内容需要图示化。
- 哪些页面需要论文图、公式、实验图或结果对比。
- 每页页面草图需求是什么。

必须保存：

- `output/stage_01_content_plan/deck_content_plan.md`：完整汇报逻辑、页数、讲述顺序。
- `output/stage_01_content_plan/slide_briefs.md`：逐页内容规划、核心观点、页面草图需求。

进入下一阶段前检查：

- 每页都有明确标题、核心观点和支撑内容。
- 每页都说明需要什么图、表、公式、实验图或视觉模块。
- 页面内容不空洞，能支撑一次学术汇报。

### 2. GPT 生成内容满意的页面图

此阶段先不强求风格完全一致，重点看：

- 内容结构是否正确。
- 版面逻辑是否清楚。
- 模块关系是否合理。
- 图文比例是否适合汇报。
- 页面是否能支撑讲述。

如果页面内容结构不满意，应先调整页面图，而不是急着做 PPT。

此阶段必须包含审核循环：

1. 生成页面图：根据阶段 1 的 `deck_content_plan.md` 和 `slide_briefs.md` 生成逐页内容页面图。
2. 自检页面图：逐页检查内容结构、版面逻辑、信息密度、模块关系和讲述顺序。
3. 请求主人审核：把页面图和 `content_page_review.md` 提交给主人审核，只询问内容结构和版面逻辑是否满意，不要求此时评价最终风格。
4. 审核通过：在 `output/stage_status.md` 标记 `owner_review_for_current_stage: approved`、`stage_02_owner_review: approved` 和 `next_stage_allowed: yes`，然后才能进入阶段 3。
5. 审核不通过：在 `revision_log.md` 记录主人指出的问题，重新分析阶段 1 内容规划，修正页面草图需求，重新生成页面图，再次请求审核。重复直到通过。

必须保存：

- `refs/content_pages/slide_XX_content.png`：内容结构满意版页面图。
- `output/stage_02_content_pages/content_page_review.md`：逐页说明内容结构、版面逻辑和需要修改的问题。
- `output/stage_02_content_pages/owner_review_request.md`：提交给主人审核的说明，列出每页需要看的重点和需要确认的问题。
- `output/stage_02_content_pages/revision_log.md`：记录每次审核不通过的原因、重新分析结论、修改动作和新版本页面图。
- 如果当前环境不能直接生成图片，保存 `output/stage_02_content_pages/image_prompts.md`，提供可交给 GPT 或图像模型生成页面图的逐页 prompt，并停在本阶段等待页面图。

进入下一阶段前检查：

- 每页页面图都和阶段 1 的内容规划对应。
- 先只评价内容结构、版面逻辑、信息密度和讲述顺序，不因风格不统一而提前否定页面。
- `content_page_review.md` 已完成逐页自检。
- `owner_review_request.md` 已提交给主人审核。
- `output/stage_status.md` 中 `owner_review_for_current_stage` 和 `stage_02_owner_review` 必须都是 `approved`，且 `next_stage_allowed` 必须是 `yes`。
- 如果主人审核没通过，必须停留在阶段 2 并继续重做，不得进入阶段 3。

### 3. GPT 根据模板统一风格

当内容结构满意且阶段 2 已审核通过后，再让 GPT 根据目标模板统一：

- 色系。
- 字体气质。
- 学术感。
- 模块样式。
- 图表风格。
- 页眉页脚。
- 标题和正文层级。

目标是得到“内容满意 + 风格接近目标模板”的最终页面参考图。

必须保存：

- `refs/styled_pages/slide_XX_final.png`：内容满意且模板风格统一后的最终页面参考图。
- `output/stage_03_style_unified/style_mapping.md`：模板色系、字体气质、模块样式、页眉页脚和图表风格如何映射到页面。
- `output/stage_03_style_unified/style_review.md`：逐页说明是否已达到目标模板的学术感和统一性。

进入下一阶段前检查：

- 最终页面图没有改变阶段 2 已确认的内容结构。
- 色系、模块风格、标题层级、图表气质接近目标模板。
- 用户或自评报告明确认为最终页面参考图可作为重建依据。

### 4. GPT 抠图拆元素并转为 PNG

从最终页面图中拆出独立素材，统一转为 PNG 格式后放入 `extracted_assets/`。

可拆元素包括：图标、色块、箭头、线条、背景装饰、logo、公式卡片、复杂纹理、论文图、仿真图、实验截图。

素材格式要求：

- 抠图元素必须转为 `.png`。
- 优先使用透明背景 PNG。
- 保留元素原始比例，不要拉伸变形。
- 文件名应表达页码、来源和用途，例如 `slide03_arrow_01.png`、`slide05_logo_school.png`、`slide08_formula_card.png`。
- 不要只提供整页截图；必须拆出可复用的独立 PNG 元素。

必须保存：

- `extracted_assets/slide_XX/*.png`：逐页独立 PNG 素材。
- `output/stage_04_assets/asset_manifest.md`：每个 PNG 的来源页、用途、是否透明背景、建议插入位置、是否可替换为 PPT 原生对象。
- 如果当前环境不能直接抠图，保存 `output/stage_04_assets/extraction_prompts.md`，提供逐页抠图拆元素要求，并停在本阶段等待素材包。

### 5. Codex 读取 PNG 素材包 + 页面参考图 + 真实文本

Codex 阶段必须同时读取：

- 页面参考图：用于临摹布局、层级、颜色和视觉关系。
- PNG 素材包：用于插入复杂图标、logo、论文图、纹理等独立图片。
- 真实文本：用于替换页面图里的图片文字。

必须保存：

- `output/stage_05_rebuild_inputs/rebuild_manifest.md`：逐页列出最终页面参考图、可用 PNG 素材、真实文本来源和缺失项。
- `output/stage_05_rebuild_inputs/text_map.md`：页面图中的图片文字与真实可编辑文本的对应关系。

进入下一阶段前检查：

- 每页都有最终页面参考图。
- 每页需要用到的 PNG 素材已存在或已说明缺失。
- 所有标题、正文、图注、标签和页码都有真实文本来源，不能直接照抄图片里的不清晰文字。

### 6. Codex 临摹重建为可编辑 PPT

Codex 需要把页面参考图临摹为可编辑 PowerPoint。

必须尽量可编辑化：标题、正文、模块标题、图注、基本形状、色块、线条、箭头、流程框、简单示意图、页面编号。

可以作为独立图片插入：复杂图标、logo、复杂纹理、论文图、仿真图、实验图、照片、难以合理重建的复杂装饰。

不要把整页图片直接贴进 PPT。不要做整页截图式 PPT。

必须保存：

- `output/academic_presentation.pptx`：可编辑 PowerPoint。
- `output/preview/`：必要时保存预览图或 PDF，用于检查页面是否跑版、文字是否重叠、图片是否清晰。

进入下一阶段前检查：

- 标题、正文、模块标题、图注、图例、标签和页码是可编辑文本。
- 基本形状、线条、箭头、流程框和简单示意图尽量是 PPT 原生对象。
- 没有把最终页面参考图作为整页背景或整页截图贴进 PPT。

### 7. 输出 PPTX + 可编辑性报告

最终输出：

- `.pptx` 文件。
- 必要时输出预览图或 PDF。
- 可编辑性报告。

报告必须说明：

- 哪些内容是真实可编辑文本。
- 哪些内容是 PPT 原生形状。
- 哪些内容仍然是图片。
- 哪些复杂元素无法完全可编辑化。
- 是否存在与参考图不完全一致的地方。
- 不要承诺 100% 完美还原。

必须保存：

- `output/academic_presentation.pptx`。
- `output/editability_report.md`。
- `output/stage_status.md` 中标记阶段 7 完成。

## PPT 生成原则

- 优先使用 16:9。
- 默认白底、深蓝主色、浅蓝辅助色。
- 风格正式、简洁、学术。
- 页面不能太空洞。
- 内容模块必须清楚。
- 学术汇报逻辑优先于装饰还原。
- 风格统一优先于逐像素复刻。
- 后续可修改性优先于视觉偷懒。
- 标题、正文、模块标题、图注必须是真实可编辑文本。
- 形状、线条、箭头、简单示意图尽量使用 PPT 可编辑对象。
- 复杂图标、logo、仿真图、论文图可以作为独立 PNG 图片插入。

## 如何处理 AI 页面图

AI 页面图是参考，不是最终 PPT 页面。

正确做法：

- 读取页面图的布局、模块、颜色、层级和视觉关系。
- 用 PPT 文本框重建所有文字。
- 用 PPT 形状重建基本视觉元素。
- 用独立 PNG 素材替代复杂局部元素。
- 页面图不能作为整页背景。
- 页面图不能整页贴进 PPT。

## 如何处理抠图 PNG 素材包

使用素材包时遵守：

- 素材包中的抠图元素必须是 PNG 格式，优先透明背景 PNG。
- logo、复杂图标、论文图、仿真图、实验图、照片、复杂纹理可作为独立 PNG 图片插入。
- 简单箭头、色块、线条、模块框如果适合重建，仍应优先用 PPT 原生对象制作，而不是直接使用 PNG。
- PNG 素材必须服务于页面内容和讲述逻辑。
- 插入 PNG 时保持清晰度和原始比例，不拉伸、不压扁、不模糊。
- 不使用低清晰度、边缘粗糙、背景残留明显或风格冲突严重的 PNG。
- 不用 PNG 素材替代真实可编辑文本。
- 不要用素材包里的整页截图作为最终 PPT 页面。

## 如何保证文字可编辑

必须使用 PPT 文本框或占位符制作：标题、正文、模块标题、图注、图例、坐标轴标签、页码、结论句、参考文献短注。

如果论文图内部文字不可编辑，可以保留论文图为图片，但旁边必须添加可编辑说明文字。

## 如何避免整页截图式 PPT

禁止：

- 把整页 AI 页面图贴进 PPT。
- 把整页截图作为背景。
- 用图片文字代替真实文本。
- 用一张大图冒充可编辑页面。

判断标准：用户想改标题、正文、图注、箭头、模块位置或颜色时，不应需要重新生成整页图片。

## 最终报告要求

完成后报告：

- 修改或生成了哪些文件。
- 输出 PPTX 路径。
- 使用了哪些页面参考图和 PNG 素材包。
- 哪些部分是可编辑文本。
- 哪些部分是 PPT 原生对象。
- 哪些部分仍是 PNG 图片或其他图片。
- 哪些复杂元素没有完全可编辑化。
- 是否进行了预览或渲染检查。
