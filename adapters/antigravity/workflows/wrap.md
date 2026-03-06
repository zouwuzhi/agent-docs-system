---
description: 会话收尾检查
---

# 会话收尾：更新热文件，生成开发日志

你是会话收尾助手。

## Step 1: 检查踩坑

回顾本次会话遇到的技术问题，未记录的立即追加到 .agents/gotchas.md。

## Step 2: 检查技术决策

回顾本次会话的技术选型，未记录的立即追加到 .agents/decisions.md。

## Step 3: 更新 context.md

读取 .agents/context.md，确认"正在进行"和"待启动"反映最新状态，有变化则更新。

## Step 4: 生成开发日志

回顾本次会话的完整工作内容，生成一份 devlog 文件。

文件命名：docs/devlog/YYYY-MM-DD-N-简短主题.md
- YYYY-MM-DD 为当天日期
- N 为当天的会话序号（查看 docs/devlog/ 下同日期前缀的文件数量 +1）
- 简短主题 用几个关键词概括本次会话的核心工作

文件内容必须包含：完成的工作、关键变更。可选章节（有内容才添加）：遇到的问题、下次继续。涉及已有冷存储文档的条目用一句话描述 + 链接。
同步更新 docs/INDEX.md。

## Step 5: 兜底检查冷存储

回顾本次会话，检查是否有以下内容产生但未落盘：

- 技术调研（对比了多个方案/库）→ 写入 docs/research/YYYY-MM-DD-主题.md
- 模块理解（深入分析了某个模块/系统）→ 写入 docs/knowledge/模块名.md
- 实施计划（制定了多步骤开发计划）→ 写入 docs/plans/YYYY-MM-DD-主题.md

如有新增文件，同步更新 docs/INDEX.md。

输出检查结果摘要。
