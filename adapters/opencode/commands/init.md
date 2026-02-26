---
description: 初始化项目文档体系：扫描项目状态，填写热文件，建立冷存储骨架
---

你是项目文档体系的初始化助手。

## Step 1: 扫描项目状态

读取以下文件（如果存在）获取项目信息：
- README.md 或项目根目录描述文件
- package.json / Cargo.toml / pubspec.yaml / go.mod 等（获取技术栈）
- `git log --oneline -10`（了解近期开发进度）

## Step 2: 检查已有热文件

检查 `.agent/context.md`、`.agent/gotchas.md`、`.agent/decisions.md` 是否存在且有内容。
如果存在非空文件，询问用户是否覆盖。

## Step 3: 填写 .agent/context.md

根据扫描结果，写入 `.agent/context.md`，包括：
- 当前阶段（简短描述）
- 技术栈（列出主要技术）
- 项目结构（目录/模块说明）
- 正在进行（当前任务）
- 待启动（已规划但未开始的工作）

## Step 4: 初始化 .agent/gotchas.md 和 .agent/decisions.md

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

.agent/context.md    ✓（已填写项目状态）
.agent/gotchas.md    ✓
.agent/decisions.md  ✓
docs/INDEX.md        ✓
docs/adr/TEMPLATE.md ✓
```
