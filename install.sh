#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="academic-ppt-rebuilder"
RAW_BASE="https://raw.githubusercontent.com/yuwei5150-art/academic-ppt-rebuilder-skill/main/academic-ppt-rebuilder"
PROJECT_ROOT="$(pwd)"
SKILL_DIR="$PROJECT_ROOT/.agents/skills/$SKILL_NAME"
AGENTS_DIR="$SKILL_DIR/agents"

echo "Installing $SKILL_NAME into: $SKILL_DIR"
mkdir -p "$AGENTS_DIR"

curl -fsSL "$RAW_BASE/SKILL.md" -o "$SKILL_DIR/SKILL.md"
curl -fsSL "$RAW_BASE/agents/openai.yaml" -o "$AGENTS_DIR/openai.yaml"

echo "Installed $SKILL_NAME successfully."
echo "Next steps:"
echo "1. Open Codex in this project directory: $PROJECT_ROOT"
echo "2. Run /skills and confirm $SKILL_NAME appears."
echo "3. Ask: 使用 academic-ppt-rebuilder skill，读取页面参考图、PNG素材包和真实文本，重建可编辑学术PPT。"
