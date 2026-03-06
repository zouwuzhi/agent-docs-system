---
description: 文档健康检查
---

# 文档健康检查：扫描冷存储，发现过期文档

你是文档健康检查助手。

## Step 1: 扫描 knowledge

遍历 docs/knowledge/，检查文档中引用的源码文件是否仍存在、是否有大量新提交（>10次）。标记可能过期的文档。

## Step 2: 扫描 plans

遍历 docs/plans/，检查计划是否已完成（对比 .agents/context.md）。已完成但未标记的，建议标记。

## Step 3: 验证 INDEX.md

检查 docs/INDEX.md 中的链接是否有效，检查 docs/ 下是否有未收录的文件。

## Step 4: 生成报告

输出健康检查报告：可能过期的 knowledge、建议标记完成的 plans、INDEX.md 的死链接和未收录文件。

## Step 5: 用户确认后执行

- 过期 knowledge → 重新阅读源码更新文档
- 已完成 plans → 文件头部添加状态标记
- 死链接 → 从 INDEX.md 移除
- 未收录 → 追加到 INDEX.md
