---
description: 文档健康检查：扫描热文件和冷存储，发现过期、失效、需更新的文档
---

你是文档健康检查助手。全面扫描项目文档的健康状态，生成报告。

## Step 1: 检查热文件

**gotchas.md**：
- 读取 `.agents/gotchas.md`，逐条检查
- 条目引用的文件/库/模块是否仍然存在于项目中
- 不再相关的条目 → 标记为"建议归档到 docs/knowledge/ 或删除"

**decisions.md**：
- 读取 `.agents/decisions.md`，逐条检查
- 超过 30 天的决策 → 标记为"建议归档"（移至对应 devlog 或升级为 ADR）

**context.md**：
- 读取 `.agents/context.md`
- 对比最近的 devlog 文件，检查"正在进行"和"待启动"是否与实际状态一致
- 不一致 → 标记为"建议更新"

## Step 2: 扫描 knowledge 文件

遍历 `docs/knowledge/` 下所有文件，对每个文件：
- 读取文档内容，提取其中引用的源码文件路径
- 检查这些源码文件是否仍然存在
- 如果存在，用 `git log --oneline` 检查源码自文档最后修改日期以来的提交次数
- 提交次数 > 10 或源码文件已删除 → 标记为"可能过期"

## Step 3: 扫描 plans 文件

遍历 `docs/plans/` 下所有文件，对每个文件：
- 读取文档内容，检查是否已有状态标记（`状态：已完成` / `状态：已废弃`）
- 如果没有状态标记，对比 `.agents/context.md` 的"正在进行"和"待启动"，判断计划目标是否已完成
- 已完成 → 标记为"建议标记完成"

## Step 4: 验证 INDEX.md

读取 `docs/INDEX.md`，检查每个链接指向的文件是否存在：
- 文件不存在 → 标记为"死链接"
- `docs/` 下有文件但未被 INDEX.md 收录 → 标记为"未收录"

## Step 5: 生成报告

向用户输出报告：

```
文档健康检查报告：

热文件：
  gotchas.md    N 条活跃 / N 条建议归档或删除
  decisions.md  N 条活跃 / N 条超过 30 天建议归档
  context.md    ✓ 状态一致 / ✗ 需要更新

冷存储：
  knowledge     N 篇正常 / N 篇可能过期
  plans         N 篇进行中 / N 篇建议标记完成
  research      N 篇（仅统计）
  devlog        N 篇（仅统计）

INDEX.md：
  死链接 N 个 / 未收录 N 个
```

如果所有文档都健康，输出"所有文档状态正常，无需处理"。

## Step 6: 等待用户确认后执行

根据用户选择：
- 过期的 gotchas → 移至 `docs/knowledge/` 归档或直接删除
- 过期的 decisions → 移至对应 devlog 或通过 `/adr` 升级为 ADR
- context.md 不一致 → 更新为最新状态
- 过期的 knowledge → 重新阅读对应源码，更新文档内容
- 已完成的 plans → 在文件头部添加 `> 状态：已完成（YYYY-MM-DD）`
- 死链接 → 从 INDEX.md 移除
- 未收录文件 → 追加到 INDEX.md
