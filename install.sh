#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL=""
FORCE=false
TARGET_DIR="$(pwd)"

usage() {
    echo "Usage: $0 --tool <claude|gemini|opencode|antigravity|cursor> [--force] [--target <dir>]"
    echo ""
    echo "Options:"
    echo "  --tool     Target AI tool (required)"
    echo "  --force    Overwrite existing files"
    echo "  --target   Target project directory (default: current directory)"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --tool)    TOOL="$2";       shift 2 ;;
        --force)   FORCE=true;      shift   ;;
        --target)  TARGET_DIR="$2"; shift 2 ;;
        -h|--help) usage ;;
        *)         echo "Unknown argument: $1"; usage ;;
    esac
done

[[ -z "$TOOL" ]] && { echo "Error: --tool is required"; usage; }

case "$TOOL" in
    claude|gemini|opencode|antigravity|cursor) ;;
    *) echo "Error: Unknown tool '$TOOL'"; usage ;;
esac

copy_file() {
    local src="$1"
    local dst="$2"
    if [[ -f "$dst" && "$FORCE" != true ]]; then
        echo "  SKIP (exists): $dst"
        return
    fi
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  COPY: $dst"
}

append_if_missing() {
    local file="$1"
    local marker="$2"
    local content="$3"
    mkdir -p "$(dirname "$file")"
    if [[ -f "$file" ]] && grep -qF "$marker" "$file"; then
        echo "  SKIP (already present): $file"
        return
    fi
    printf '\n%s\n' "$content" >> "$file"
    echo "  APPEND: $file"
}

REFERENCE_SNIPPET='## 文档规范

项目使用统一的 Agent 文档规范，位于 `agent.md`。
每次新会话开始时请读取该文件，按其中的指令操作。'

echo "Installing agent-docs-system for: $TOOL"
echo "Target directory: $TARGET_DIR"
echo ""

# 1. agent.md
copy_file "$SCRIPT_DIR/agent.md" "$TARGET_DIR/agent.md"

# 2. hot files
copy_file "$SCRIPT_DIR/templates/context.md"   "$TARGET_DIR/.agents/context.md"
copy_file "$SCRIPT_DIR/templates/gotchas.md"   "$TARGET_DIR/.agents/gotchas.md"
copy_file "$SCRIPT_DIR/templates/decisions.md" "$TARGET_DIR/.agents/decisions.md"

# 3. cold files
copy_file "$SCRIPT_DIR/templates/docs-INDEX.md"   "$TARGET_DIR/docs/INDEX.md"
copy_file "$SCRIPT_DIR/templates/adr-TEMPLATE.md" "$TARGET_DIR/docs/adr/TEMPLATE.md"
for dir in devlog knowledge plans research postmortem; do
    mkdir -p "$TARGET_DIR/docs/$dir"
    if [[ ! -f "$TARGET_DIR/docs/$dir/.gitkeep" ]]; then
        touch "$TARGET_DIR/docs/$dir/.gitkeep"
        echo "  MKDIR: docs/$dir/"
    fi
done

# 4. tool-specific adapter
echo ""
echo "Installing $TOOL adapter..."

case "$TOOL" in
    claude)
        append_if_missing "$TARGET_DIR/CLAUDE.md" "agent.md" "$REFERENCE_SNIPPET"
        for cmd in init wrap archive adr; do
            copy_file "$SCRIPT_DIR/adapters/claude/commands/$cmd.md" \
                      "$TARGET_DIR/.claude/commands/$cmd.md"
        done
        ;;
    gemini)
        append_if_missing "$TARGET_DIR/GEMINI.md" "agent.md" "$REFERENCE_SNIPPET"
        for cmd in init wrap archive adr; do
            copy_file "$SCRIPT_DIR/adapters/gemini/commands/$cmd.toml" \
                      "$TARGET_DIR/.gemini/commands/$cmd.toml"
        done
        ;;
    opencode)
        append_if_missing "$TARGET_DIR/AGENTS.md" "agent.md" "$REFERENCE_SNIPPET"
        for cmd in init wrap archive adr; do
            copy_file "$SCRIPT_DIR/adapters/opencode/commands/$cmd.md" \
                      "$TARGET_DIR/.opencode/commands/$cmd.md"
        done
        ;;
    antigravity)
        copy_file "$SCRIPT_DIR/adapters/antigravity/rules/agent-docs.md" \
                  "$TARGET_DIR/.agents/rules/agent-docs.md"
        for wf in init wrap archive adr; do
            copy_file "$SCRIPT_DIR/adapters/antigravity/workflows/$wf.md" \
                      "$TARGET_DIR/.agents/workflows/$wf.md"
        done
        ;;
    cursor)
        for rule in agent-docs init wrap archive adr; do
            copy_file "$SCRIPT_DIR/adapters/cursor/rules/$rule.mdc" \
                      "$TARGET_DIR/.cursor/rules/$rule.mdc"
        done
        ;;
esac

echo ""
echo "Done! agent-docs-system installed for $TOOL."
echo ""
echo "Next steps:"
case "$TOOL" in
    cursor)
        echo "  1. Use @init in Cursor chat to initialize your project context"
        ;;
    *)
        echo "  1. Run /init to initialize your project context"
        ;;
esac
echo "  2. Commit the new files to your repository"
