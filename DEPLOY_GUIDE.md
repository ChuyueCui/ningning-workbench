# ningning workbench 部署与使用指南

## 1. 修改完成 ✅

优先级选择器与图例已更新为莫兰迪浅色系：

| 颜色 | 英文 | 含义 |
|------|------|------|
| 🔴 浅玫瑰 | Do | 重要且紧急 |
| 🔵 浅蓝灰 | Schedule | 重要不紧急 |
| 🟡 浅米黄 | Delegate | 紧急不重要 |
| ⚪ 浅灰 | Delete | 不重要不紧急 |

- 上方选择器只显示「颜色圆点 + 英文」
- 下方图例显示「颜色圆点 + 英文（中文解释）」
- 已删除旧的「官方待办」等选项

## 2. 部署到 GitHub Pages（推荐：永久在线 + 手机/电脑通用）

### 第一步：安装并登录 GitHub CLI

打开终端（Terminal），运行：

```bash
gh auth login
```

按提示选择：
- What account do you want to log into? → **GitHub.com**
- What is your preferred protocol for Git operations on this host? → **HTTPS**
- Authenticate Git with your GitHub credentials? → **Yes**
- How would you like to authenticate GitHub CLI? → **Login with a web browser**

浏览器会打开授权页面，点击 **Authorize github** 即可。

### 第二步：运行一键部署脚本

```bash
cd /Users/ciaaa/WorkBuddy/2026-08-01-15-18-05
./deploy.sh
```

脚本会自动：
1. 在 GitHub 创建公开仓库 `ningning-workbench`
2. 推送当前代码
3. 开启 GitHub Pages
4. 输出可访问的网址

### 第三步：添加到 Mac 程序坞

#### 方式 A：Safari（最稳定，推荐）
1. 用 Safari 打开部署后的网址
2. 点击顶部菜单 **文件 → 添加到程序坞**
3. 在弹窗里可以重命名为「ningning」
4. 点击添加

#### 方式 B：Chrome
1. 用 Chrome 打开部署后的网址
2. 点击右上角 **⋮ → 投射、保存和分享 → 安装 page 为应用…**
3. 按提示安装

> 注意：macOS 上 Safari 的「添加到程序坞」会把网页变成一个独立 app 图标，点击即用，和原生 app 体验最接近。

## 3. 数据互通方案

当前版本使用浏览器 **localStorage** 存储数据，特点是：
- ✅ 免费、无需密钥、打开即用
- ❌ 数据只保存在当前设备的当前浏览器里，**手机和电脑不互通**

### 方案 A：JSON 手动导出/导入（已实现，零成本）

工作台里有 **导出数据 / 导入数据** 按钮。你可以：
- 在电脑上导出 JSON 备份
- 通过 iCloud / 微信 / 邮件 发送到手机
- 在手机上打开工作台，导入 JSON

适合数据量不大、不介意手动同步的情况。

### 方案 B：Firebase Realtime Database（免费，真正实时互通）

这是目前最适合你的方案：不需要自己买服务器，Google 提供免费额度，只需要一个 API key（不是服务器密钥）。

#### 开通步骤：

1. 打开 [Firebase 控制台](https://console.firebase.google.com/)
2. 用 Google 账号登录，点击「创建项目」
3. 项目名称随便写，比如 `ningning-workbench`
4. 创建后点击「构建 → Realtime Database」
5. 选择位置（美国或新加坡都可以），点击「下一步」
6. 安全规则先选择「以锁定模式开始」
7. 进入数据库后，点击「规则」标签，把规则改成：

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

8. 点击「项目设置 → 通用」
9. 在最下面「你的应用」里选择「Web」图标（`</>`）
10. 注册应用，名字写 `ningning-workbench`
11. 复制那段 `firebaseConfig`（里面包含 `apiKey`）
12. 把这段配置发给我，我帮你接进去

#### Firebase 认证方式（没有密钥也能用）：

Firebase 可以开启 **匿名登录（Anonymous Auth）**：
- 用户第一次打开网页，自动生成一个匿名 UID
- 数据绑定到这个 UID
- 在同一台设备/浏览器上，UID 会保持不变
- 换设备时需要导出/导入一次来「迁移」UID，或者我帮你做邮箱登录

如果你愿意，我可以直接帮你写一份带 Firebase 同步的代码，你只需要把 `apiKey` 等配置填进去就行。

### 方案 C：Supabase（替代 Firebase）

类似 Firebase，也是免费后端。如果你更想用 Supabase，我可以帮你接。

### 方案 D：GitHub Gist 同步（轻量免费）

用 GitHub Personal Access Token 把数据存到 Gist，实现跨设备读取。这个需要你先创建一个 token，步骤稍复杂，但完全免费。

## 4. 推荐组合

对于你现在的情况，我建议：

1. **先用 GitHub Pages 部署**（永久在线，打开即用）
2. **Mac 程序坞添加 Safari 快捷方式**（像 app 一样用）
3. **手机用 Safari 把网页「添加到主屏幕」**（iOS PWA）
4. **数据同步先用 JSON 导出/导入过渡**
5. **等你有空注册 Firebase 后，我帮你接入实时数据库**，实现真正的跨设备自动同步

## 5. 常见问题

### Q：每天自动更新是早上 8 点吗？
A：目前是按「日期首次打开」自动轮播内容池，不是严格定时 8 点。比如你 8 月 1 日第一次打开会显示 8 月 1 日的内容，8 月 2 日第一次打开会显示 8 月 2 日的内容。如果你需要严格 8 点刷新，我可以改成按 UTC/本地时间判断。

### Q：GitHub Pages 需要付费吗？
A：公开仓库 + GitHub Pages 完全免费。

### Q：数据会丢吗？
A：localStorage 数据不会因为 GitHub Pages 更新而丢失，但如果清除浏览器缓存/换设备会丢失。所以务必定期用「导出数据」备份。
