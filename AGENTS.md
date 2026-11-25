# AGENTS.md

本仓库是软件工程课程设计项目「基于 RAG 的校园学习生活信息问答系统」。项目章程、工程规范与团队分工见 [README.md](README.md)，文档目录与编号约定见 [docs/README.md](docs/README.md)。课程规则里和 agent 直接相关的三条：不在仓库里发生的事视为没有发生；AI 产出必须声明；架构决策、需求确认、合并放行由人签字。

## 分支与 PR

- 不直推 `main`。功能走 `feat/<模块>-<简述>`，修复走 `fix/<编号>`，仓库配置走 `chore/<简述>`。
- 开 PR 用 `gh pr create`，正文必须包含 `.github/PULL_REQUEST_TEMPLATE.md` 的五段，标题照抄：
  1. 第一行写 `关联 Issue：Closes #N`。没有对应 Issue 的先建 Issue，纯仓库配置写「无」。
  2. `## 变更内容`
  3. `## 变更类型`
  4. `## 自查`。CI 没配置时如实留空。
  5. `## AI 使用声明`，写明工具、用途、人工评审要点。
- 每张图、每份规约单独一个 PR。PR 至少 1 人评审后由人合并，agent 不执行 `gh pr merge`。
- 不改写提交历史，不伪造提交日期。补交材料在正文里写明「补交」。

## Issue

`gh issue create` 建的 Issue 不走网页表单，正文按对应表单的字段写，字段用二级标题：

- 需求，标签 `需求`，标题前缀 `[REQ]`：需求描述、类型、验收标准（Given / When / Then）、来源、目标增量。
- 需求变更申请，标签 `变更`，前缀 `[变更]`：涉及的需求编号、变更原因、变更内容、影响评估、流程。
- 缺陷，标签 `缺陷`，前缀 `[缺陷]`：现象（对应的 UC 编号）、复现步骤、环境、日志或截图。

SRS v1.0 之前直接改 `docs/02-SRS/`。之后的需求改动一律先开变更申请 Issue，批准后再开 PR。

## 文档与编号

- REQ-F / REQ-N 是需求，UC / UNF 是用例，DES 是设计条目，TC 是测试用例，Q 是待确认事项。规则见 [docs/README.md](docs/README.md)。
- 改 `docs/02-SRS/SRS-*.md` 时同步更新 `docs/02-SRS/追溯矩阵-*.md`，并在文档末尾的变更记录登记。
- 每份新文档末尾加「AI 使用声明」：工具、用途、人工审定人。
- 模型图源放 `models/`。PlantUML 加 `!pragma layout smetana`，不依赖 Graphviz。

## 代码约定

骨架尚未搭建。第一个可运行版本落地后在本节补：目录结构、安装与运行命令、测试命令与覆盖率要求、lint 与 format、本地和 CI 的检查命令。技术栈以 [README.md](README.md) §7 为准：Vue 3 + TypeScript，FastAPI，PostgreSQL + pgvector，大模型与 Embedding 走 API。目录规划见 README §13。

现在就生效的几条：

- 密钥只放环境变量或 GitHub Secrets，不进代码、提示词、日志和文档。
- 问答日志不写学工号、手机号等个人信息。
- 核心算法与关键模块要能被人手讲，答辩会问。

## 维护

- 仓库约定变了就改本文：新增目录、命令、检查项时在对应小节补一行，不写教程。
- 课程要求原文和 README 才是依据，本文只写 agent 每次都要知道的事。
