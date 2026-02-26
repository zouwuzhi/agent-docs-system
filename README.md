# agent-docs-system

为 AI 编程工具提供统一的项目文档规范，一键安装，支持 5 个主流工具。

## 什么是 agent-docs-system？

当你用 AI agent（Claude Code、Gemini CLI、Cursor 等）开发项目时，agent 每次新会话都需要重新了解项目状态。

agent-docs-system 提供一套**热/冷分离文档体系**：
- **热文件**（`.agent/`）：每次会话必读，保持项目状态、踩坑、决策的实时快照
- **冷文件**（`docs/`）：归档知识，通过索引按需访问
- **agent.md**：告诉 AI 在每次新会话开始时读什么、怎么维护文档

## 支持的工具

| 工具 | 命令触发方式 |
|------|------------|
| [Claude Code](https://claude.ai/code) | `/init`、`/wrap`、`/archive`、`/adr` |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `/init`、`/wrap`、`/archive`、`/adr` |
| [OpenCode](https://github.com/opencode-ai/opencode) | `/init`、`/wrap`、`/archive`、`/adr` |
| [Antigravity](https://antigravity.google) | `/init`、`/wrap`、`/archive`、`/adr` |
| [Cursor](https://cursor.com) | `@init`、`@wrap`、`@archive`、`@adr` |

## 安装

在你的项目根目录运行：

```bash
# 克隆本仓库
git clone https://github.com/zouwuzhi/agent-docs-system.git /tmp/agent-docs-system

# 安装到当前项目（指定你使用的工具）
bash /tmp/agent-docs-system/install.sh --tool claude
```

其他工具替换 `claude` 为 `gemini`、`opencode`、`antigravity`、`cursor`。

**可选参数：**

```bash
--force          # 覆盖已存在的文件
--target <dir>   # 安装到指定目录（默认为当前目录）
```

## 安装后的目录结构

```
your-project/
├── agent.md                    ← 文档规范（所有工具共享）
├── CLAUDE.md                   ← 追加了引用 agent.md 的段落
├── .agent/
│   ├── context.md              ← 项目状态快照（每次会话必读）
│   ├── gotchas.md              ← 活跃踩坑记录
│   └── decisions.md            ← 近期技术决策
├── .claude/commands/           ← Claude Code 命令（仅 --tool claude）
│   ├── init.md
│   ├── wrap.md
│   ├── archive.md
│   └── adr.md
└── docs/
    ├── INDEX.md                ← 冷存储索引
    ├── adr/TEMPLATE.md
    ├── devlog/
    ├── knowledge/
    ├── plans/
    └── research/
```

## 使用流程

### 首次安装后

运行 `/init`（或 `@init`）让 AI 扫描你的项目，填写 `.agent/context.md`。

### 日常开发中

AI 会自动在适当时机更新热文件：
- 踩到新坑 → 追加到 `.agent/gotchas.md`
- 做出技术决策 → 追加到 `.agent/decisions.md`
- 完成功能模块 → 更新 `.agent/context.md`

### 会话结束时

运行 `/wrap` 让 AI 做收尾检查，确保没有遗漏的踩坑或决策。

### 热文件超过 100 行时

运行 `/archive` 将旧内容归档到 `docs/` 冷存储。

### 记录重要架构决策时

运行 `/adr [决策标题]` 创建 ADR 文档。

## 4 个核心命令

| 命令 | 功能 |
|------|------|
| `init` | 初始化文档体系，扫描项目填写 context.md |
| `wrap` | 会话收尾检查，确保踩坑/决策已记录 |
| `archive` | 归档超量热文件到 docs/ 冷存储 |
| `adr` | 创建架构决策记录（ADR） |

## 工具适配对比

| 工具 | 命令目录 | 触发方式 | 规则文件 |
|------|---------|---------|---------|
| Claude Code | `.claude/commands/*.md` | `/command` | `CLAUDE.md` |
| Gemini CLI | `.gemini/commands/*.toml` | `/command` | `GEMINI.md` |
| OpenCode | `.opencode/commands/*.md` | `/command` | `AGENTS.md` |
| Antigravity | `.agents/workflows/*.md` | `/workflow` | `.agents/rules/*.md` |
| Cursor | `.cursor/rules/*.mdc` | `@ruleName` | `.cursor/rules/*.mdc` |

## 设计原则

- **SSOT**：`agent.md` 是所有规范的唯一来源，各工具指令文件只加一句引用
- **热/冷分离**：频繁更新的上下文（`.agent/`）与归档知识（`docs/`）分开
- **工具中立**：核心规范不依赖任何特定 AI 工具
- **幂等安装**：重复运行 install.sh 不会覆盖已有文件或重复追加内容

## License

MIT
