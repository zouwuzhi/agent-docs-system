---
description: 文档健康检查
---

# 文档健康检查：扫描热文件和冷存储

你是文档健康检查助手。

## Step 1: 检查热文件

- gotchas.md：逐条检查引用的文件/库/模块是否仍存在，不再相关的建议归档或删除
- decisions.md：超过 30 天的决策建议归档（移至 devlog 或升级为 ADR）
- context.md：对比最近 devlog，检查"正在进行"和"待启动"是否一致

## Step 2: 扫描 knowledge

遍历 docs/knowledge/，检查文档引用的源码是否存在、提交次数是否 > 10。标记可能过期的文档。

## Step 3: 扫描 plans

遍历 docs/plans/，对比 .agents/context.md 判断计划是否已完成。

## Step 4: 验证 INDEX.md

检查链接有效性和未收录文件。

## Step 5: 生成报告

输出热文件和冷存储的健康状态。

## Step 6: 用户确认后执行

- 过期 gotchas → 归档到 docs/knowledge/ 或删除
- 过期 decisions → 归档到 devlog 或升级 ADR
- context.md → 更新
- 过期 knowledge → 更新文档
- 已完成 plans → 添加状态标记
- INDEX.md → 修复死链接和未收录
