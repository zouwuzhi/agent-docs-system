---
description: 归档热文件到冷存储
---

# 归档热文件

你是文档归档助手。

## Step 1: 分析需要归档的内容

读取 .agents/gotchas.md（找已解决/低频条目）和 .agents/decisions.md（找 30 天前条目），展示建议归档列表，等待用户确认。

## Step 2: 归档 gotchas

确认条目从 .agents/gotchas.md 移至 docs/knowledge/gotchas.md（不存在则创建），从源文件删除。

## Step 3: 归档 decisions

有明确技术决策的询问是否创建 ADR，日常记录追加到 docs/devlog/YYYY-MM-DD.md。

## Step 4: 更新 docs/INDEX.md

如有新文件则同步更新。

输出归档结果摘要。
