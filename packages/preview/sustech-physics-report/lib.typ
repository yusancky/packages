// lib.typ - sustech-physics-report
//
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 yusancky


// 标题层级（均无需调用任何函数）：
//   一级标题 `= 实验目的`   → 自动编号的小节「一、实验目的」
//   二级标题 `== 小球直径`  → 小节内的分项（加粗、13pt）

// 一级小节计数器（每遇到一个一级标题 `= ...` 自动 +1）
#let section-counter = counter("exp-section")

// 文档级设置：页面大小/页边距与正文字体/字号
// body 放在第一个参数，配合 using 文件里的 `#show: doc.with(font: ...)` 使用，即可把 #set page / #set text 收进模板，且无需把内容包进 doc[...]
// 参数：
//   body              整篇报告内容（由 show 规则自动传入，无需手写）
//   font              正文字体（默认 "Noto Sans CJK SC"，可自行替换）
//   section-numbering 小节编号格式（默认 "一、"；"一/壹/1/a/A/i/I" 等 Typst numbering 均可）
#let doc(body, font: "Noto Sans CJK SC", section-numbering: "一、") = {
  set page("a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1cm))
  set par(spacing: 10pt)
  set text(font: font, size: 12pt)

  // 一级标题（`= 实验目的`）自动编号并渲染为「一、实验目的」，无需调用任何函数
  show heading.where(level: 1): it => {
    block(above: 12pt)
    section-counter.step()
    context {
      text(size: 18pt)[#numbering(section-numbering, section-counter.get().first())#it.body]
      parbreak()
    }
    block(above: 4pt)
  }

  // 二级标题（`== 分项标题`）作为小节内的分项：加粗、字号略小于小节标题
  show heading.where(level: 2): it => {
    block(above: 6pt)
    text(size: 16pt, weight: "bold")[#it.body]
    parbreak()
  }

  // 三级标题（`=== 分项标题`）作为小节内的分项：加粗、字号略小于二级标题
  show heading.where(level: 3): it => {
    block(above: 10pt, below: 2.5pt)
    text(size: 14pt, weight: "bold")[#it.body]
    parbreak()
  }

  // 三级标题（`=== 分项标题`）作为小节内的分项：加粗、字号略小于二级标题
  show heading.where(level: 4): it => {
    block(above: 10pt, below: 2pt)
    text(size: 12pt, weight: "bold")[#it.body]
    parbreak()
  }

  body
}

// 报告纸页眉
// 参数（均可在调用处覆盖）：
//   student-id  学号
//   name        姓名
//   date        日期
//   location    实验地点
//   weekday     星期（几）
//   period      上午 / 下午
//   title       实验标题
#let report-header(
  student-id: "1xxxxxxx",
  name: "张三",
  date: "9 月 1 日",
  location: "P4116",
  weekday: "一",
  period: "上午",
  title: "实验标题",
) = {
  // 报告纸标题 + 校徽 + 校训
  box(width: 100%, height: 2cm)[
    #align(center + horizon, grid(
      columns: (auto, auto, auto),
      column-gutter: (1.2cm, 0.2cm),
      align: horizon,
      text(size: 30pt)[*物理实验报告纸*],
      image("images/SUSTech.png", height: 34pt),
      text(size: 14pt)[明德求是\ #h(56pt) 日新自强],
    ))

    #v(1fr)

    #line(length: 100%)
  ]

  // 学生信息行（underline 中的内容由上述参数控制）
  [
    学号：#underline(student-id) #h(1fr) 姓名：#underline(name) #h(1fr) 日期：#underline(date) #h(1fr) 实验地点：#underline(location) #h(1fr) 星期#underline(weekday) #h(1fr) #underline(period)
  ]

  v(12pt)

  // 实验标题
  align(center, text(size: 20pt)[*#title*])
}
