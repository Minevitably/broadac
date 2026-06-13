# 小张的学习笔记

个人静态博客，记录编程学习、摄影练习和生活随笔。

## 技术栈

纯静态页面：HTML + CSS + JavaScript，使用 [marked.js](https://marked.js.org/) 在浏览器端渲染 Markdown 文章。

## 目录结构

```
broadac/
├── index.html          # 首页
├── notes.html          # 文章列表
├── about.html          # 关于我
├── article.html        # 文章渲染模板
├── style.css           # 样式
├── docs/               # Markdown 文章
│   ├── javascript-async.md
│   ├── photography-basics.md
│   ├── persistence.md
│   ├── git-commands.md
│   └── slow-down.md
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## 运行方式

### Docker（推荐）

```bash
docker compose up -d
```

访问 http://localhost:5000

### 手动构建

```bash
docker build -t broadac .
docker run -d --name broadac -p 5000:80 broadac
```

### 本地开发

直接用浏览器打开 `index.html`，或用任意静态文件服务器：

```bash
# Python 3
python -m http.server 5000

# Node.js（需要安装 serve）
npx serve -l 5000
```

## 备案信息

- 网站名称：小张的学习笔记
- ICP 备案号：湘ICP备2026022903号-1
- 网站用途：个人技术笔记、生活随笔
