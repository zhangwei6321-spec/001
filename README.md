## 🎤 协理员面试练习

> 浏览器端面试模拟工具 — 摄像头录制 / 计时器 / 语音实时转文字 / 文字稿导出。

🔗 在线访问：[zhangwei6321-spec.github.io/001](https://zhangwei6321-spec.github.io/001/)

---

## ✨ 功能

- 📹 **摄像头录制** — 浏览器调用摄像头，录制面试答题视频，支持暂停/继续/停止
- ⏱️ **计时器** — 画面实时显示录制时长
- 🗣 **语音转文字** — 基于 Web Speech API，录制中实时转写（推荐 Chrome / Edge）
- 📝 **文字稿导出** — 一键导出 `.txt` 文字稿，附带题目和日期
- 📋 **面试题库** — 内置 20 道协理员面试常见题，随机出题
- 📼 **录制记录** — 历史录制列表，支持回放和导出

---

## 🛠 技术栈

纯 HTML / CSS / JavaScript，无框架依赖

- MediaRecorder API — 视频录制
- Web Speech API — 语音实时转写
- GitHub Pages — 静态部署

---

## ⚠ 浏览器兼容

| 功能 | Chrome | Edge | Safari | Firefox |
|------|--------|------|--------|---------|
| 摄像头录制 | ✅ | ✅ | ✅ | ✅ |
| 计时器 | ✅ | ✅ | ✅ | ✅ |
| 语音转文字 | ✅ | ✅ | ❌ | ❌ |

语音转文字需 Chromium 内核浏览器。

---

## 📂 本地使用

```bash
git clone https://github.com/zhangwei6321-spec/001.git
cd 001
open index.html
```
