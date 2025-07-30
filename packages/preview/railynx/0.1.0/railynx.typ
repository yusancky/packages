#let error(message) = {
  return block(
    stroke: 1.5pt + red,
    fill: luma(95%),
    inset: 8pt,
    radius: 6pt,
    text(red)[#strong([Error])] + "\n" + message,
  )
}

#let getChar(s, char, neg, step: 1) = {
  let posChar = s.position(char)
  if posChar + step < 0 or posChar + step >= s.len() {
    return error(
      "String index out of bounds when getting character after "
        + str(step)
        + " step(s) of \""
        + char
        + "\" in \""
        + s
        + "\"",
    )
  }
  return if s.at(posChar + step) == neg { -1 } else { 1 }
}

#let getIndex(s, char, base, count) = {
  let posChar = s.position(char)
  let res = int(s.slice(0, posChar)) - base
  if res < 0 or res >= count {
    return error(
      "Rail index out of bounds when getting index "
        + str(res + base)
        + " by \""
        + s
        + "\"",
    )
  }
  return res
}

#let railynx(
  rail,
  nodes,
  baseIndex: 1,
  railSpace: 1cm,
  nodeSpace: 1cm,
  breakable: true,
  fill: none,
  stroke: none,
  railStroke: 1.5pt + blue,
  switchTension: 0,
  platformFill: blue,
  arrowDx: 0.2,
  arrowFill: none,
  arrowStroke: blue,
) = {
  let isContent(v) = type(v) == content
  let getOpDir(s, char, neg: "l", step: 1) = getChar(s, char, neg, step: step)
  let getOpIndex(op, char) = getIndex(op, char, baseIndex, rail)
  let railPoint(point) = (point.at(0) * railSpace, point.at(1) * nodeSpace)
  let railPointXY(x, y) = (x * railSpace, y * nodeSpace)
  let drawRailway(start, end) = {
    return place(
      line(
        start: railPoint(start),
        end: railPoint(end),
        stroke: railStroke,
      ),
    )
  }
  let drawSwitch(start, end, ctrl1, ctrl2) = {
    return place(
      curve(
        curve.move(railPoint(start)),
        curve.cubic(
          railPointXY(
            start.at(0) + switchTension * ctrl1.at(0),
            start.at(1) + switchTension * ctrl1.at(1),
          ),
          railPointXY(
            end.at(0) + switchTension * ctrl2.at(0),
            end.at(1) + switchTension * ctrl2.at(1),
          ),
          railPoint(end),
        ),
        stroke: railStroke,
      ),
    )
  }
  let drawPlatform((dxy, size)) = {
    return place(
      dx: railPoint(dxy).at(0),
      dy: railPoint(dxy).at(1),
      rect(
        width: railPoint(size).at(0),
        height: railPoint(size).at(1),
        fill: platformFill,
        stroke: railStroke,
      ),
    )
  }
  let drawArrow(dxy, yminor) = {
    return place(
      dx: railPoint(dxy).at(0),
      dy: railPoint(dxy).at(1),
      curve(
        fill: arrowFill,
        stroke: arrowStroke,
        curve.move(railPointXY(0.4, 0.5 + 2 * yminor)),
        curve.line(railPointXY(0.5, 0.5 + yminor)),
        curve.line(railPointXY(0.6, 0.5 + 2 * yminor)),
      ),
    )
  }
  if type(rail) != int {
    return error("Argument rail: Expected int, found " + str(type(rail)))
  }
  if type(nodes) == str {
    nodes = nodes.split("\n")
  } else if type(nodes) != array {
    return error(
      "Argument nodes: Expected array or str, found " + str(type(nodes)),
    )
  }
  for (i, node) in nodes.enumerate() {
    if type(node) == str {
      nodes.at(i) = if node != "Auto" { node.split(regex("[\r ;]+")) } else {
        ()
      }
    } else if type(node) != array {
      return error(
        "Argument nodes: Expected array or str, found "
          + str(type(node))
          + " at nodes["
          + str(i)
          + "]",
      )
    }
  }
  let exists = range(0, rail).map(_ => 0)
  let railynxBlock = block(
    width: rail * railSpace,
    height: nodes.len() * nodeSpace,
    breakable: breakable,
    fill: fill,
    stroke: stroke,
    {
      for (i, node) in nodes.enumerate() {
        for j in range(0, rail) {
          if exists.at(j) == 2 {
            exists.at(j) = 1
          } else if exists.at(j) == 3 {
            exists.at(j) = 0
          }
        }
        if node != () {
          for op in node {
            if op == () or op == "" { continue }
            if "e" in op {
              let opIndex = getOpIndex(op, "e")
              if isContent(opIndex) { return opIndex }
              if exists.at(opIndex) == 0 or exists.at(opIndex) == 1 {
                exists.at(opIndex) = 1 - exists.at(opIndex)
              }
            } else if "E" in op {
              let opIndex = getOpIndex(op, "E")
              if isContent(opIndex) { return opIndex }
              if exists.at(opIndex) == 0 or exists.at(opIndex) == 1 {
                exists.at(opIndex) = exists.at(opIndex) + 2
              }
              if exists.at(opIndex) == 2 {
                drawRailway((opIndex + 0.5, i + 0.5), (opIndex + 0.5, i + 1))
              } else {
                drawRailway((opIndex + 0.5, i), (opIndex + 0.5, i + 0.5))
              }
              drawRailway((opIndex + 0.25, i + 0.5), (opIndex + 0.75, i + 0.5))
            } else if op.contains(regex("[sS]")) {
              let opChar = if op.find("s") != none { "s" } else { "S" }
              let (opIndex, opDir) = (
                getOpIndex(op, opChar),
                getOpDir(op, opChar),
              )
              if isContent(opIndex) { return opIndex }
              if isContent(opDir) { return opDir }
              if exists.at(opIndex) != 2 {
                if opChar == "S" { exists.at(opIndex) = 3 }
                if opIndex + opDir < 0 or opIndex + opDir >= rail {
                  return error(
                    "Rail index out of bounds when switching to "
                      + str(opIndex + opDir + baseIndex)
                      + " from "
                      + str(opIndex + baseIndex)
                      + " by \""
                      + op
                      + "\"",
                  )
                }
                if exists.at(opIndex + opDir) == 0 {
                  exists.at(opIndex + opDir) = 2
                }
                drawSwitch(
                  (opIndex + 0.5, i),
                  (opIndex + 0.5 + opDir, i + 1),
                  (0, 1),
                  (0, -1),
                )
              }
            } else if op.contains(regex("[pP]")) {
              let opChar = if op.find("p") != none { "p" } else { "P" }
              let (opIndex, opDir) = (
                getOpIndex(op, opChar),
                getOpDir(op, opChar),
              )
              if isContent(opIndex) { return opIndex }
              if isContent(opDir) { return opDir }
              drawPlatform(
                if opChar == "p"
                  or (
                    opChar == "P"
                      and (opIndex + opDir == -1 or opIndex + opDir == rail)
                  ) {
                  ((opIndex + 0.35 + 0.25 * opDir, i), (0.3, 1))
                } else {
                  ((opIndex + 0.1 + 0.5 * opDir, i), (0.8, 1))
                },
              )
            } else if "a" in op {
              let (opIndex, opDir1, opDir2) = (
                getOpIndex(op, "a"),
                0.15 * getOpDir(op, "a", neg: "d"),
                getOpDir(op, "a", step: 2),
              )
              if isContent(opIndex) { return opIndex }
              if isContent(opDir1) { return opDir1 }
              if isContent(opDir2) { return opDir2 }
              drawArrow(
                (opIndex + opDir2 * calc.abs(arrowDx), i),
                opDir1,
              )
            }
          }
        }
        for j in range(0, rail) {
          if exists.at(j) == 1 {
            drawRailway((j + 0.5, i), (j + 0.5, i + 1))
          }
        }
      }
    },
  )
  return railynxBlock
}
