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
| 踩到新坑 / 发现新陷阱 | 判断价值后写入（见下方规则） |
| 做出技术决策（选型、方案选择等） | 判断价值后写入（见下方规则） |
| 对比了多个技术方案或库 | 写入 `docs/research/YYYY-MM-DD-主题.md` |
| 深入理解了某个模块/系统的工作原理 | 写入 `docs/knowledge/模块名.md` |
| 制定了多步骤的实施计划 | 写入 `docs/plans/YYYY-MM-DD-主题.md` |

**热/冷写入判断**：踩坑和决策在写入时判断是否值得放在热文件：

| 写入热文件（`.agents/`） | 直接写入冷存储（devlog 记录即可） |
|--------------------------|----------------------------------|
| 跨会话容易再犯的坑 | 已解决的一次性 bug |
| 影响开发流程的决策 | 局部实现细节的选择 |
| 所有任务都需要知道的 | 只跟特定功能相关的 |

**里程碑触发（阶段性变化时）：**

| 事件 | 更新目标 |
|------|----------|
| 完成一个功能模块 | `.agents/context.md` 更新"正在进行"和"待启动" |
| 新增/移除依赖、变更技术栈 | `.agents/context.md` 更新"技术栈" |
| 项目阶段发生变化 | `.agents/context.md` 更新"当前阶段" |

**会话结束时（收尾检查）：**
- 检查本次会话是否有未记录的踩坑或决策
- 检查 `.agents/context.md` 是否反映了最新状态
- 生成开发日志 `docs/devlog/YYYY-MM-DD-N-简短主题.md`
- 兜底检查：本次会话是否做过技术调研、深入理解模块、制定计划但未落盘
- 检查热文件是否超过 100 行，超过则执行归档

## 归档规则

当热文件超过 100 行时：
- `.agents/gotchas.md` → 已解决/低频条目移至 `docs/knowledge/gotchas.md`
- `.agents/decisions.md` → 30 天前的条目移至对应 ADR 或 devlog
- 归档后同步更新 `docs/INDEX.md`（如有新文件）

## 冷文件更新规则

- **新增 docs/ 下任何文件时，必须同步更新 `docs/INDEX.md`**
- 重要技术决策 → 新增 ADR（`docs/adr/NNNN-标题.md`，编号递增）
- 每次会话结束 → 新增 devlog（`docs/devlog/YYYY-MM-DD-N-简短主题.md`，N 为当天会话序号）
  - 涉及已有冷存储文档的条目：一句话描述 + 链接（渐进式披露）
  - 无对应文档的条目：正常记录细节
- 技术调研/方案对比 → 新增 research（`docs/research/YYYY-MM-DD-主题.md`），记录调研背景、对比的方案、结论
- 深入理解模块/系统 → 新增或更新 knowledge（`docs/knowledge/模块名.md`），记录工作原理、关键流程、注意事项
- 制定实施计划 → 新增 plans（`docs/plans/YYYY-MM-DD-主题.md`），记录目标、步骤、预期产出
- 遇到重大 bug/故障 → 新增 postmortem（`docs/postmortem/NNNN-标题.md`）

## 文档健康检查

定期运行 `doc-review` 命令检查冷存储文档的健康状态：
- `docs/knowledge/` — 检查文档引用的源码是否已大幅变更或删除
- `docs/plans/` — 检查计划目标是否已完成，已完成则标记 `> 状态：已完成（YYYY-MM-DD）`
- `docs/INDEX.md` — 检查死链接和未收录文件

## ADR 规则

- ADR 一旦写入不修改原文，如需废弃则新增一条记录并标注"被 ADR-XXXX 取代"
- 编号递增，文件名格式：`docs/adr/NNNN-标题.md`
- 格式参考 `docs/adr/TEMPLATE.md`
