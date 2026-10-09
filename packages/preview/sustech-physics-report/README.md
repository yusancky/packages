# sustech-physics-report

A Typst template for physics lab reports at the Southern University of Science and Technology (SUSTech). It renders a lab-report header (title, university logo, motto, underlined student-info line) and auto-numbered Chinese sections (一、二、三……).

南方科技大学物理实验报告 Typst 模板。可生成实验报告纸页眉（报告纸标题、校徽、校训、带下划线的学生信息行），并提供中文自动编号的一级小节（一、二、三……）。

---

## English

### Features

- Pre-built lab-report header (report-paper title, SUSTech logo, motto, and an underlined
  student-info line: 学号 / 姓名 / 日期 / 实验地点 / 星期 / 上午·下午).
- Centered experiment title.
- First-level sections written as Markdown headings (`= 实验目的`, `= 实验原理`, …).
- Document-wide page & text settings applied via a single `show` rule, with a configurable `font`.
- Pure Typst, no extra dependencies.

### Installation

This is a Typst **template package**. You can start a new project with:

```sh
typst init @preview/sustech-physics-report:0.1.0
```

Or click **“Start from template”** in the Typst web app and pick `sustech-physics-report`.

### Usage

The generated `main.typ` already shows the full setup:

```typ
#import "@preview/sustech-physics-report:0.1.0": doc, report-header

#show: doc

#report-header(
  student-id: "1xxxxxxx",
  name: "张三",
  date: "9 月 1 日",
  location: "P4116",
  weekday: "一",
  period: "上午",
  title: "实验标题",
)

= 实验目的

= 实验原理
```

### API

- `doc(body, font: "Noto Sans CJK SC", size: 12pt)` — applies the page (`a4`, 1.2 cm margins)
  and text settings to the whole document. Use it as `#show: doc.with(font: "…")`.
  Change `font` to switch the typeface (e.g. `"SimSun"`).
- `report-header(student-id:, name:, date:, location:, weekday:, period:, title:)` — renders the
  report-paper header. Every underlined field is a named argument you can override.
- Sections are written as level-1 Markdown headings (`= 实验目的`).
- `to-chinese(num)` — converts an Arabic number (1–99) to Chinese.
- `section-counter` — the underlying counter (you may `section-counter.update()` to reset).

### Compile

```sh
typst compile main.typ example.pdf
```

---

## 中文

### 功能特性

- 内置实验报告纸页眉：报告纸标题、南科大校徽、校训，以及带下划线的学生信息行
  （学号 / 姓名 / 日期 / 实验地点 / 星期 / 上午·下午）。
- 居中的实验标题。
- 以 Markdown 一级标题书写的小节（`= 实验目的`、`= 实验原理`……）。
- 通过一条 `show` 规则统一设置页面与正文，并开放可自定义的 `font` 参数。
- 纯 Typst 实现，无额外依赖。

### 安装

这是一个 Typst **模板包**。你可用以下命令新建项目：

```sh
typst init @preview/sustech-physics-report:0.1.0
```

或在 Typst Web 端点击 **“Start from template”** 选择 `sustech-physics-report`。

### 使用方法

生成后的 `main.typ` 已包含完整示例：

```typ
#import "@preview/sustech-physics-report:0.1.0": doc, report-header

#show: doc

#report-header(
  student-id: "1xxxxxxx",
  name: "张三",
  date: "9 月 1 日",
  location: "P4116",
  weekday: "一",
  period: "上午",
  title: "实验标题",
)

= 实验目的

= 实验原理
```

### 接口说明

- `doc(body, font: "Noto Sans CJK SC", size: 12pt)` — 对整篇文档应用页面（`a4`、页边距 1.2 cm）
  与正文字体设置。以 `#show: doc.with(font: "…")` 形式使用；修改 `font` 即可更换字体（如 `"SimSun"`）。
- `report-header(student-id:, name:, date:, location:, weekday:, period:, title:)` — 渲染报告纸页眉，
  所有下划线字段都是可覆盖的具名参数。
- 小节以 Markdown 一级标题书写（`= 实验目的`）。
- `to-chinese(num)` — 阿拉伯数字（1–99）转中文数字。
- `section-counter` — 底层计数器，可用 `section-counter.update()` 重置编号。

### 编译

```sh
typst compile main.typ example.pdf
```
