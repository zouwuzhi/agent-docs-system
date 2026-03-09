# agent-docs-system

为 AI 编程工具提供统一的项目文档规范，一键安装，支持 5 个主流工具。

## 什么是 agent-docs-system？

当你用 AI agent（Claude Code、Gemini CLI、Cursor 等）开发项目时，agent 每次新会话都需要重新了解项目状态。

agent-docs-system 提供一套**AI agent 操作手册 + 热/冷分离文档体系**：
- **agent.md**：agent 的操作手册——行为准则、文档维护规则、质量策略
- **热文件**（`.agents/`）：每次会话必读，包含项目状态、项目约定、活跃踩坑和决策
- **冷文件**（`docs/`）：通过索引按需访问，包含开发日志、技术调研、模块知识、实施计划等

## 支持的工具

| 工具 | 命令触发方式 |
|------|------------|
| [Claude Code](https://claude.ai/code) | `/start`、`/init`、`/wrap`、`/adr`、`/doc-review` |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `/start`、`/init`、`/wrap`、`/adr`、`/doc-review` |
| [OpenCode](https://github.com/opencode-ai/opencode) | `/start`、`/init`、`/wrap`、`/adr`、`/doc-review` |
| [Antigravity](https://antigravity.google) | `/start`、`/init`、`/wrap`、`/adr`、`/doc-review` |
| [Cursor](https://cursor.com) | `@start`、`@init`、`@wrap`、`@adr`、`@doc-review` |

## 安装

在你的项目根目录运行：

```bash
# 克隆本仓库
git clone https://github.com/zouwuzhi/agent-docs-system.git /tmp/agent-docs-system

# 安装到当前项目（指定你使用的工具）
bash /tmp/agent-docs-system/install.sh --tool claude
```

其他工具替换 `claude` 为 `gemini`、`opencode`、`antigravity`、`cursor`。

**Windows 用户：** 请使用 [Git Bash](https://git-scm.com/downloads) 运行上述命令。

**可选参数：**

```bash
--force          # 覆盖已存在的文件（全量重装）
--upgrade        # 升级：覆盖系统文件，清理废弃命令，保留用户内容
--target <dir>   # 安装到指定目录（默认为当前目录）
```

## 安装后的目录结构

```
your-project/
├── agent.md                    ← agent 操作手册（行为准则 + 文档规则）
├── CLAUDE.md                   ← 追加了引用 agent.md 的段落
├── .agents/
│   ├── context.md              ← 项目状态 + 项目约定（每次会话必读）
│   ├── gotchas.md              ← 活跃踩坑记录
│   └── decisions.md            ← 近期技术决策
├── .claude/commands/           ← Claude Code 命令（仅 --tool claude）
│   ├── init.md
│   ├── start.md
│   ├── wrap.md
│   ├── adr.md
│   └── doc-review.md
└── docs/
    ├── INDEX.md                ← 冷存储索引
    ├── adr/TEMPLATE.md
    ├── devlog/
    ├── knowledge/
    ├── plans/
    └── research/
```

## 使用流程

运行 `/start`（或 `@start`）让 AI 读取所有热文件，输出项目状态摘要，恢复上下文。

### 首次安装后

运行 `/init`（或 `@init`）让 AI 扫描你的项目，自动填写项目状态和项目约定到 `.agents/context.md`。

### 日常开发中

AI 会自动在适当时机维护文档：
- 踩到高价值的坑 → 追加到 `.agents/gotchas.md`
- 做出重要技术决策 → 追加到 `.agents/decisions.md`
- 完成功能模块 → 更新 `.agents/context.md`
- 做了技术调研 → 写入 `docs/research/`
- 深入理解了模块 → 写入 `docs/knowledge/`
- 制定了实施计划 → 写入 `docs/plans/`

### 会话结束时

运行 `/wrap` 让 AI 做收尾检查，生成开发日志到 `docs/devlog/`。

### 定期检查文档健康

运行 `/doc-review` 清理热文件中不再相关的内容，检查冷存储是否过期、INDEX.md 是否有死链接。

### 记录重要架构决策时

运行 `/adr [决策标题]` 创建 ADR 文档。

## 5 个核心命令

| 命令 | 功能 |
|------|------|
| `start` | 新会话启动，读取项目记忆，输出状态摘要 |
| `init` | 初始化文档体系，扫描项目自动填写状态和约定 |
| `wrap` | 会话收尾，更新热文件并生成开发日志 |
| `adr` | 创建架构决策记录（ADR） |
| `doc-review` | 检查热文件和冷存储健康状态，清理过期文档 |

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
- **热/冷分离**：频繁更新的上下文（`.agents/`）与归档知识（`docs/`）分开
- **渐进式披露**：devlog 串联所有文档，一句话摘要 + 链接，按需深入
- **工具中立**：核心规范不依赖任何特定 AI 工具
- **幂等安装**：重复运行 install.sh 不会覆盖已有文件或重复追加内容

## License

MIT
