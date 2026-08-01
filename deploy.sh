#!/bin/bash
# 一键部署 ningning workbench 到 GitHub Pages
# 前置条件：已安装 gh CLI 并已登录（运行 gh auth login）

set -e

REPO_NAME="ningning-workbench"

echo "🚀 开始部署 ningning workbench 到 GitHub Pages..."

# 检查 gh 是否登录
if ! gh auth status >/dev/null 2>&1; then
  echo "❌ 你还没有登录 GitHub CLI。请先运行："
  echo "   gh auth login"
  echo "然后重新执行本脚本。"
  exit 1
fi

# 创建仓库（如果不存在）
if ! gh repo view "$REPO_NAME" >/dev/null 2>&1; then
  echo "📦 创建 GitHub 仓库: $REPO_NAME"
  gh repo create "$REPO_NAME" --public --source=. --push --description "ningning workbench PWA"
else
  echo "📦 仓库已存在，推送到 origin..."
  git remote add origin "https://github.com/$(gh api user -q .login)/$REPO_NAME.git" 2>/dev/null || true
  git push -u origin main
fi

# 开启 GitHub Pages
USERNAME=$(gh api user -q .login)
echo "🌐 开启 GitHub Pages..."
gh api "repos/$USERNAME/$REPO_NAME/pages" \
  --method POST \
  --input - <<< '{"source":{"branch":"main","path":"/"}}' \
  2>/dev/null || echo "   Pages 可能已开启，跳过。"
echo ""
echo "✅ 部署完成！"
echo "🌍 访问地址：https://$USERNAME.github.io/$REPO_NAME/ningning_workbench.html"
echo ""
echo "下一步："
echo "1. 用 Safari/Chrome 打开上面的地址"
echo "2. Safari: 文件 → 添加到程序坞"
echo "3. Chrome: 右上角 ⋮ → 投射/保存/分享 → 安装 page 为应用"
