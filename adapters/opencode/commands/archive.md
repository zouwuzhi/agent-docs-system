---
description: 归档热文件：将超量的已解决踩坑和旧决策移至 docs/ 冷存储
---

你是文档归档助手。

## Step 1: 分析需要归档的内容

读取 `.agent/gotchas.md` 和 `.agent/decisions.md`，识别：
- **gotchas.md**：已解决的、低频的条目（不再是活跃问题的）
- **decisions.md**：距今超过 30 天的条目

向用户展示建议归档的条目列表，等待确认。

## Step 2: 归档 gotchas

将确认的条目从 `.agent/gotchas.md` 移至 `docs/knowledge/gotchas.md`：
- `docs/knowledge/gotchas.md` 不存在则先创建（带 `# 踩坑归档` 标题）
- 在目标文件末尾追加内容
- 从源文件删除对应条目

## Step 3: 归档 decisions

将确认的条目从 `.agent/decisions.md` 移至：
- 有明确技术决策的 → 询问用户是否创建 ADR（运行 `/adr`）
- 日常开发记录 → 追加到 `docs/devlog/YYYY-MM-DD.md`（对应日期）

## Step 4: 更新 docs/INDEX.md

如果新增了 `docs/knowledge/gotchas.md` 或新 devlog 文件，更新 `docs/INDEX.md`。

## 输出确认

```
归档完成：

gotchas.md   N 条 → docs/knowledge/gotchas.md（剩余 M 条）
decisions.md N 条已归档（剩余 M 条）
INDEX.md     ✓
```
