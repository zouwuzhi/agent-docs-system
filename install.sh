#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL=""
FORCE=false
UPGRADE=false
TARGET_DIR="$(pwd)"

usage() {
    echo "Usage: $0 --tool <claude|gemini|opencode|antigravity|cursor> [--force] [--upgrade] [--target <dir>]"
    echo ""
    echo "Options:"
    echo "  --tool     Target AI tool (required)"
    echo "  --force    Overwrite existing files (full reinstall)"
    echo "  --upgrade  Upgrade: overwrite system files, remove deprecated commands, keep user content"
    echo "  --target   Target project directory (default: current directory)"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --tool)    TOOL="$2";       shift 2 ;;
        --force)   FORCE=true;      shift   ;;
        --upgrade) UPGRADE=true;    shift   ;;
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

# --upgrade implies --force for system files
if [[ "$UPGRADE" == true ]]; then
    FORCE=true
fi

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

copy_user_file() {
    local src="$1"
    local dst="$2"
    if [[ -f "$dst" ]]; then
        echo "  SKIP (user content): $dst"
        return
    fi
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  COPY: $dst"
}

remove_deprecated() {
    local file="$1"
    if [[ -f "$file" ]]; then
        rm "$file"
        echo "  REMOVE (deprecated): $file"
    fi
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

if [[ "$UPGRADE" == true ]]; then
    echo "Upgrading agent-docs-system for: $TOOL"
else
    echo "Installing agent-docs-system for: $TOOL"
fi
echo "Target directory: $TARGET_DIR"
echo ""

# 1. agent.md (system file, always overwrite on upgrade)
copy_file "$SCRIPT_DIR/agent.md" "$TARGET_DIR/agent.md"

# 2. hot files (user content, never overwrite on upgrade)
if [[ "$UPGRADE" == true ]]; then
    copy_user_file "$SCRIPT_DIR/templates/context.md"   "$TARGET_DIR/.agents/context.md"
    copy_user_file "$SCRIPT_DIR/templates/gotchas.md"   "$TARGET_DIR/.agents/gotchas.md"
    copy_user_file "$SCRIPT_DIR/templates/decisions.md" "$TARGET_DIR/.agents/decisions.md"
else
    copy_file "$SCRIPT_DIR/templates/context.md"   "$TARGET_DIR/.agents/context.md"
    copy_file "$SCRIPT_DIR/templates/gotchas.md"   "$TARGET_DIR/.agents/gotchas.md"
    copy_file "$SCRIPT_DIR/templates/decisions.md" "$TARGET_DIR/.agents/decisions.md"
fi

# 3. cold files (user content for INDEX.md, template for TEMPLATE.md)
if [[ "$UPGRADE" == true ]]; then
    copy_user_file "$SCRIPT_DIR/templates/docs-INDEX.md" "$TARGET_DIR/docs/INDEX.md"
else
    copy_file "$SCRIPT_DIR/templates/docs-INDEX.md" "$TARGET_DIR/docs/INDEX.md"
fi
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
        for cmd in start init wrap adr doc-review; do
            copy_file "$SCRIPT_DIR/adapters/claude/commands/$cmd.md" \
                      "$TARGET_DIR/.claude/commands/$cmd.md"
        done
        # remove deprecated commands
        remove_deprecated "$TARGET_DIR/.claude/commands/archive.md"
        ;;
    gemini)
        append_if_missing "$TARGET_DIR/GEMINI.md" "agent.md" "$REFERENCE_SNIPPET"
        for cmd in start init wrap adr doc-review; do
            copy_file "$SCRIPT_DIR/adapters/gemini/commands/$cmd.toml" \
                      "$TARGET_DIR/.gemini/commands/$cmd.toml"
        done
        remove_deprecated "$TARGET_DIR/.gemini/commands/archive.toml"
        ;;
    opencode)
        append_if_missing "$TARGET_DIR/AGENTS.md" "agent.md" "$REFERENCE_SNIPPET"
        for cmd in start init wrap adr doc-review; do
            copy_file "$SCRIPT_DIR/adapters/opencode/commands/$cmd.md" \
                      "$TARGET_DIR/.opencode/commands/$cmd.md"
        done
        remove_deprecated "$TARGET_DIR/.opencode/commands/archive.md"
        ;;
    antigravity)
        copy_file "$SCRIPT_DIR/adapters/antigravity/rules/agent-docs.md" \
                  "$TARGET_DIR/.agents/rules/agent-docs.md"
        for wf in start init wrap adr doc-review; do
            copy_file "$SCRIPT_DIR/adapters/antigravity/workflows/$wf.md" \
                      "$TARGET_DIR/.agents/workflows/$wf.md"
        done
        remove_deprecated "$TARGET_DIR/.agents/workflows/archive.md"
        ;;
    cursor)
        for rule in agent-docs start init wrap adr doc-review; do
            copy_file "$SCRIPT_DIR/adapters/cursor/rules/$rule.mdc" \
                      "$TARGET_DIR/.cursor/rules/$rule.mdc"
        done
        remove_deprecated "$TARGET_DIR/.cursor/rules/archive.mdc"
        ;;
esac

echo ""
if [[ "$UPGRADE" == true ]]; then
    echo "Done! agent-docs-system upgraded for $TOOL."
else
    echo "Done! agent-docs-system installed for $TOOL."
fi
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
