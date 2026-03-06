---
description: 初始化项目文档体系：扫描项目状态，填写热文件，建立冷存储骨架
---

你是项目文档体系的初始化助手。

## Step 1: 扫描项目状态

读取以下文件（如果存在）获取项目信息：
- README.md 或项目根目录描述文件
- package.json / Cargo.toml / pubspec.yaml / go.mod 等（获取技术栈）
- `git log --oneline -10`（了解近期开发进度）

同时扫描项目约定信息：
- `.editorconfig`、`.prettierrc`、`eslint.config.*`、`rustfmt.toml` 等（代码风格）
- `git log --oneline -5` 的 commit message 格式（Git 约定）
- `package.json` 的 scripts 字段、`Makefile`、`justfile` 等（测试/构建命令）

## Step 2: 检查已有热文件

检查 `.agents/context.md`、`.agents/gotchas.md`、`.agents/decisions.md` 是否存在且有内容。
如果存在非空文件，询问用户是否覆盖。

## Step 3: 填写 .agents/context.md

根据扫描结果，写入 `.agents/context.md`，包括：

**项目状态：**
- 当前阶段（简短描述）
- 技术栈（列出主要技术）
- 项目结构（目录/模块说明）
- 正在进行（当前任务）
- 待启动（已规划但未开始的工作）

**项目约定：**
- 代码约定（从 linter/formatter 配置推断：命名风格、import 顺序、错误处理方式等）
- Git 约定（从 commit 历史推断：message 格式、分支策略等）
- 测试约定（从 scripts/Makefile 推断：测试框架、运行命令、覆盖率要求等）

如果某项约定无法从项目中推断，保留模板占位符让用户后续补充。

## Step 4: 初始化 .agents/gotchas.md 和 .agents/decisions.md

如果不存在，创建空白骨架（标题 + 格式说明注释）。

## Step 5: 确保冷存储结构完整

确保以下文件和目录存在（不存在则创建）：
- `docs/INDEX.md`
- `docs/adr/TEMPLATE.md`
- `docs/devlog/`
- `docs/knowledge/`
- `docs/plans/`
- `docs/research/`
- `docs/postmortem/`

## 输出确认

完成后输出：

```
文档体系初始化完成：

.agents/context.md    ✓（已填写项目状态）
.agents/gotchas.md    ✓
.agents/decisions.md  ✓
docs/INDEX.md        ✓
docs/adr/TEMPLATE.md ✓
```
