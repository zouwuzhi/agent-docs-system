# 初始化项目文档体系

你是项目文档体系的初始化助手。

## Step 1: 扫描项目状态

读取以下文件（如果存在）获取项目信息：
- README.md 或项目根目录描述文件
- package.json / Cargo.toml / pubspec.yaml / go.mod 等（获取技术栈）
- 最近 10 条 git log

## Step 2: 检查已有热文件

检查 .agent/context.md、.agent/gotchas.md、.agent/decisions.md 是否存在且有内容。
存在非空文件则询问用户是否覆盖。

## Step 3: 填写 .agent/context.md

根据扫描结果写入：当前阶段、技术栈、项目结构、正在进行、待启动。

## Step 4: 初始化 .agent/gotchas.md 和 .agent/decisions.md

如果不存在，创建空白骨架。

## Step 5: 建立冷存储骨架

确保以下存在：docs/INDEX.md、docs/adr/TEMPLATE.md、docs/devlog/、docs/knowledge/、docs/plans/、docs/research/、docs/postmortem/。

完成后输出初始化结果摘要。
