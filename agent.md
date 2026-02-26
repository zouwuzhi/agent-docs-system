# Agent 文档规范

## 新会话启动

每次新会话开始时，必须依次读取以下文件：
1. `agent.md`（本文件，已读）
2. `.agents/context.md`（项目当前状态）
3. `.agents/gotchas.md`（活跃踩坑）
4. `.agents/decisions.md`（近期决策）
5. `docs/INDEX.md`（冷存储索引，按需深入）

## 热/冷文件分层

**热文件**（`.agents/` 目录，每次会话必读）：

| 文件 | 用途 | 更新方式 |
|------|------|----------|
| `.agents/context.md` | 项目当前状态快照 | 覆盖更新（始终保持最新） |
| `.agents/gotchas.md` | 活跃踩坑记录 | 追加，>100 行归档 |
| `.agents/decisions.md` | 近期技术决策 | 追加，>100 行归档 |

**冷文件**（`docs/` 目录，按需通过 INDEX.md 索引访问）：
- `docs/adr/` — 技术决策记录（ADR）
- `docs/devlog/` — 开发日志
- `docs/knowledge/` — 架构概览、术语表、踩坑归档
- `docs/plans/` — 设计文档、实施计划
- `docs/research/` — 技术调研
- `docs/postmortem/` — 错误复盘

## 热文件更新时机

**实时触发（开发过程中立即更新）：**

| 事件 | 更新目标 |
|------|----------|
| 踩到新坑 / 发现新陷阱 | `.agents/gotchas.md` 追加 |
| 做出技术决策（选型、方案选择等） | `.agents/decisions.md` 追加 |

**里程碑触发（阶段性变化时）：**

| 事件 | 更新目标 |
|------|----------|
| 完成一个功能模块 | `.agents/context.md` 更新"正在进行"和"待启动" |
| 新增/移除依赖、变更技术栈 | `.agents/context.md` 更新"技术栈" |
| 项目阶段发生变化 | `.agents/context.md` 更新"当前阶段" |

**会话结束时（收尾检查）：**
- 检查本次会话是否有未记录的踩坑或决策
- 检查 `.agents/context.md` 是否反映了最新状态
- 检查热文件是否超过 100 行，超过则执行归档

## 归档规则

当热文件超过 100 行时：
- `.agents/gotchas.md` → 已解决/低频条目移至 `docs/knowledge/gotchas.md`
- `.agents/decisions.md` → 30 天前的条目移至对应 ADR 或 devlog
- 归档后同步更新 `docs/INDEX.md`（如有新文件）

## 冷文件更新规则

- **新增 docs/ 下任何文件时，必须同步更新 `docs/INDEX.md`**
- 重要技术决策 → 新增 ADR（`docs/adr/NNNN-标题.md`，编号递增）
- 每日开发结束 → 更新或新增 devlog（`docs/devlog/YYYY-MM-DD.md`）
- 遇到重大 bug/故障 → 新增 postmortem（`docs/postmortem/NNNN-标题.md`）
- 技术调研产出 → 新增 research（`docs/research/YYYY-MM-DD-主题.md`）

## ADR 规则

- ADR 一旦写入不修改原文，如需废弃则新增一条记录并标注"被 ADR-XXXX 取代"
- 编号递增，文件名格式：`docs/adr/NNNN-标题.md`
- 格式参考 `docs/adr/TEMPLATE.md`
