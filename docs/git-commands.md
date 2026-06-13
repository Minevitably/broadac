# Git 常用命令速查手册

> 发表于 2026-05-20 | 分类：工具效率 | 标签：Git · 版本控制 · 效率工具

---

## 前言

Git 是现代软件开发中不可或缺的版本控制工具。虽然图形化工具（VS Code Git、Sourcetree、GitHub Desktop）越来越方便，但掌握 Git 命令行仍然是每个开发者的基本功。

本文整理了一份实用的 Git 命令速查表，涵盖日常开发中的高频使用场景。

---

## 1. 基础配置

```bash
# 设置用户名和邮箱
git config --global user.name "小张"
git config --global user.email "3309575853@qq.com"

# 查看当前配置
git config --list

# 设置默认分支名为 main
git config --global init.defaultBranch main
```

---

## 2. 仓库操作

```bash
# 初始化仓库
git init

# 克隆仓库
git clone https://github.com/user/repo.git

# 查看远程仓库
git remote -v

# 添加远程仓库
git remote add origin https://github.com/user/repo.git
```

---

## 3. 日常提交流程

```bash
# 查看状态（最常用的命令）
git status
git status -s             # 简洁模式

# 查看改动内容
git diff                  # 工作区 vs 暂存区
git diff --staged         # 暂存区 vs 最后一次提交
git diff HEAD             # 工作区 vs 最后一次提交

# 添加文件到暂存区
git add <file>            # 添加指定文件
git add .                 # 添加所有改动
git add -p                # 交互式选择要添加的改动（推荐）

# 提交
git commit -m "feat: 添加用户登录功能"
git commit -am "fix: 修复分页bug"   # 跳过 add（仅 tracked 文件）

# 推送
git push origin main
git push -u origin main   # 首次推送，设置上游分支
```

---

## 4. 分支管理

```bash
# 查看分支
git branch                 # 本地分支列表
git branch -r              # 远程分支列表
git branch -a              # 所有分支

# 创建分支
git branch feature-login   # 创建分支但不切换
git checkout -b feature-login  # 创建并切换
git switch -c feature-login    # 同上（Git 2.23+，推荐）

# 切换分支
git checkout main          # 传统方式
git switch main            # 新版方式（Git 2.23+）

# 删除分支
git branch -d feature-login        # 安全删除（已合并）
git branch -D feature-login        # 强制删除
git push origin --delete feature-login  # 删除远程分支

# 重命名分支
git branch -m old-name new-name
```

---

## 5. 合并与变基

```bash
# 合并分支（保留完整历史）
git checkout main
git merge feature-login

# 变基（线性历史，更整洁）
git checkout feature-login
git rebase main

# 解决冲突后继续
git rebase --continue

# 放弃变基
git rebase --abort

# 交互式变基（合并提交）
git rebase -i HEAD~3    # 处理最近 3 次提交
```

### Merge vs Rebase

| 特性 | Merge | Rebase |
|------|-------|--------|
| 历史记录 | 保留分支结构 | 线性历史 |
| 冲突处理 | 一次性解决 | 可能多次解决 |
| 适用场景 | 公共分支 | 个人分支 |
| **黄金法则** | — | **不要 rebase 已推送的分支** |

---

## 6. 撤销操作

```bash
# 撤销工作区改动
git checkout -- <file>           # 丢弃单个文件的改动（旧）
git restore <file>               # 同上（Git 2.23+，推荐）

# 取消暂存
git reset HEAD <file>            # 旧
git restore --staged <file>      # 新，推荐

# 修改最后一次提交（未推送时）
git commit --amend -m "新的提交信息"
git commit --amend --no-edit     # 只追加改动，不改信息

# 回退版本
git reset --soft HEAD~1   # 回退提交，保留暂存区和工作区
git reset --mixed HEAD~1  # 回退提交和暂存区，保留工作区（默认）
git reset --hard HEAD~1   # 全部回退 ⚠️ 危险操作

# 安全回退（生成新提交来撤销）
git revert HEAD            # 撤销最近一次提交
git revert <commit-hash>   # 撤销指定提交
```

---

## 7. 查看历史

```bash
# 查看提交日志
git log
git log --oneline          # 简洁模式
git log --graph --oneline  # 图形化展示分支
git log -p                 # 显示每次提交的 diff

# 查看特定文件的改动历史
git log -- <file>
git log -p -- <file>       # 带具体改动内容

# 查看谁改了什么
git blame <file>
git blame -L 10,20 <file>  # 只看第 10-20 行
```

---

## 8. 暂存工作

```bash
# 暂存当前改动
git stash
git stash save "暂存信息"

# 查看暂存列表
git stash list

# 恢复最近一次暂存
git stash pop              # 恢复并删除
git stash apply            # 恢复但保留

# 恢复指定暂存
git stash pop stash@{1}

# 删除暂存
git stash drop stash@{1}
git stash clear            # 清空所有暂存
```

---

## 9. 常用协作命令

```bash
# 拉取并合并
git pull origin main
git pull --rebase origin main  # 拉取并变基（推荐）

# 查看某次提交
git show <commit-hash>

# 查看某次提交改了哪些文件
git diff-tree --no-commit-id --name-only -r <commit-hash>

# 挑选提交（cherry-pick）
git cherry-pick <commit-hash>

# 打标签
git tag v1.0.0
git tag -a v1.0.0 -m "版本 1.0.0 发布"
git push origin v1.0.0
git push origin --tags     # 推送所有标签
```

---

## 10. 推荐的提交信息规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```bash
<type>(<scope>): <subject>

# type 类型：
feat     # 新功能
fix      # 修复 Bug
docs     # 文档更新
style    # 代码格式（不影响功能）
refactor # 重构
test     # 测试相关
chore    # 构建/工具变更

# 示例：
git commit -m "feat(auth): 添加 JWT 登录功能"
git commit -m "fix(pagination): 修复页码计算错误"
git commit -m "docs(readme): 更新安装说明"
```

---

## 结语

Git 命令很多，但日常开发中 80% 的时间只用到 20% 的命令。掌握上面这些，基本可以应对绝大多数场景。遇到复杂情况时，再查阅文档也不迟。

---

*本文为个人学习笔记，持续更新中。*
