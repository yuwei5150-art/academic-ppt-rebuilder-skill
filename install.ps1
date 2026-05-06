$ErrorActionPreference = "Stop"

$SkillName = "academic-ppt-rebuilder"
$RawBase = "https://raw.githubusercontent.com/yuwei5150-art/academic-ppt-rebuilder-skill/main/academic-ppt-rebuilder"
$ProjectRoot = (Get-Location).Path
$SkillDir = Join-Path $ProjectRoot ".agents\skills\$SkillName"
$AgentsDir = Join-Path $SkillDir "agents"

Write-Host "Installing $SkillName into: $SkillDir"
New-Item -ItemType Directory -Force -Path $AgentsDir | Out-Null

$SkillUrl = "$RawBase/SKILL.md"
$OpenAIYamlUrl = "$RawBase/agents/openai.yaml"
$SkillPath = Join-Path $SkillDir "SKILL.md"
$OpenAIYamlPath = Join-Path $AgentsDir "openai.yaml"

Invoke-WebRequest -Uri $SkillUrl -OutFile $SkillPath -UseBasicParsing
Invoke-WebRequest -Uri $OpenAIYamlUrl -OutFile $OpenAIYamlPath -UseBasicParsing

Write-Host "Installed $SkillName successfully."
Write-Host "Next steps:"
Write-Host "1. Open Codex in this project directory: $ProjectRoot"
Write-Host "2. Run /skills and confirm $SkillName appears."
Write-Host "3. Ask: 使用 academic-ppt-rebuilder skill，读取页面参考图、PNG素材包和真实文本，重建可编辑学术PPT。"
