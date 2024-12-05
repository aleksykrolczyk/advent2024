typealias Ruleset = [Int: Set<Int>]

class Day05: AdventDay {
  func getData() -> (Ruleset, [[Int]]) {
    let x = Self.dataLines.split { $0.isEmpty }
    let rulesTuples = x[0]
      .map { $0.split(separator: "|") }
      .map { (Int($0[0])!, Int($0[1])!) }

    var rules: Ruleset = [:]
    for (x, y) in rulesTuples {
      if rules[y] == nil {
        rules[y] = Set()
      }
      rules[y]?.insert(x)
    }

    let updates = x[1].map { $0.toInts() }
    return (rules, updates)
  }

  func verifyUpdate(update: [Int], rules: Ruleset) -> Bool {
    for (i, currentValue) in update.enumerated() {
      if i == update.count - 1 { break }
      for valueAfter in update[(i + 1)...] {
        if rules[currentValue]?.contains(valueAfter) ?? false {
          return false
        }
      }
    }
    return true
  }

  func fixUpdate(update: [Int], rules: Ruleset) -> [Int] {
    return update.sorted { left, right in
      return rules[right]?.contains(left) ?? false
    }
  }

  func part1() -> Any {
    let (rules, updates) = getData()
    return
      updates
      .filter { verifyUpdate(update: $0, rules: rules) }
      .map { $0[$0.count / 2] }
      .reduce(0, +)
  }

  func part2() -> Any {
    let (rules, updates) = getData()
    return
      updates
      .filter { !verifyUpdate(update: $0, rules: rules) }
      .map { fixUpdate(update: $0, rules: rules) }
      .map { $0[$0.count / 2] }
      .reduce(0, +)
  }
}
