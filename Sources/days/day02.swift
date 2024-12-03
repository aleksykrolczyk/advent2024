class Day02: AdventDay {

  fileprivate func get_diffs(report: [Int]) -> ([Int], Direction) {
    let diffs = zip(report, report[1...]).map { $0 - $1 }
    let direction: Direction = diffs[0] > 0 ? .desc : .asc
    return (diffs, direction)
  }

  fileprivate func check_diff(diff: Int, direction: Direction) -> Bool {
    if diff == 0 || abs(diff) > 3 {
      return false
    }
    if direction == .desc && diff < 0 {
      return false
    }
    if direction == .asc && diff > 0 {
      return false
    }
    return true
  }

  func check_report(report: [Int]) -> Bool {
    let (diffs, direction) = get_diffs(report: report)
    for diff in diffs {
      if !check_diff(diff: diff, direction: direction) {
        return false
      }
    }
    return true
  }

  func part1() -> Any {
    let reports = Self.dataLines.map { line in
      return line.split(separator: " ").compactMap { x in Int(x) }
    }

    return
      reports
      .map { check_report(report: $0) ? 1 : 0 }
      .reduce(0, +)
  }

  func part2() -> Any {
    let reports = Self.dataLines.map { line in
      return line.split(separator: " ").compactMap { x in Int(x) }
    }

    var ok_reports = 0
    for report in reports {
      if check_report(report: report) {
        ok_reports += 1
        continue
      }

      var any_variation_ok = false
      for i in report.indices {
        var variation = report
        variation.remove(at: i)

        if check_report(report: variation) {
          any_variation_ok = true
          break
        }
      }

      ok_reports += any_variation_ok ? 1 : 0
    }

    return ok_reports
  }

}

private enum Direction {
  case asc, desc
}
