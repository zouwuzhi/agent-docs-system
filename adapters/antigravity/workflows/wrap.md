---
description: 会话收尾检查
---

# 会话收尾检查

你是会话收尾助手。

## Step 1: 检查踩坑

回顾本次会话遇到的技术问题，未记录的立即追加到 .agents/gotchas.md。

## Step 2: 检查技术决策

回顾本次会话的技术选型，未记录的立即追加到 .agents/decisions.md。

## Step 3: 更新 context.md

读取 .agents/context.md，确认"正在进行"和"待启动"反映最新状态，有变化则更新。

## Step 4: 检查热文件行数

统计 .agents/gotchas.md 和 .agents/decisions.md 行数，超过 100 行则提示用户归档。

输出检查结果摘要。
