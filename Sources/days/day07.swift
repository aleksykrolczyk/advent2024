class Day07: AdventDay {

  private func getData() -> [Equation] {
    return Self.dataLines.map { line in
      let t = line.split(separator: ":")
      let (result, numbers) = (t[0], t[1])
      return Equation(
        result: Int(result)!, numbers: numbers.toInts(separator: " "))
    }
  }

  private func fold(
    current: Int, results: inout Set<Int>, numbers: any Collection<Int>, operations: [Operation],
    threshold: Int
  ) {
    if current > threshold {
      return
    }
    if let next = numbers.first {
      for operation in operations {
        fold(
          current: operation.operate(lhs: current, rhs: next),
          results: &results,
          numbers: numbers.dropFirst(),
          operations: operations,
          threshold: threshold
        )
      }
    } else {
      results.insert(current)
    }
  }

  private func canBeConstructed(eq: Equation, operations: [Operation]) -> Bool {
    if eq.numbers.count == 0 {
      return false
    }
    if eq.numbers.count == 1 {
      return eq.result == eq.numbers.first!
    }

    var results: Set<Int> = Set()
    fold(
      current: eq.numbers.first!,
      results: &results,
      numbers: eq.numbers.dropFirst(),
      operations: operations,
      threshold: eq.result
    )
    return results.contains(eq.result)
  }

  func part1() -> Any {
    let equations = getData()
    return
      equations
      .filter { canBeConstructed(eq: $0, operations: [.add, .mul]) }
      .map { $0.result }
      .reduce(0, +)
  }

  func part2() -> Any {
    let equations = getData()
    return
      equations
      .filter { canBeConstructed(eq: $0, operations: [.add, .mul, .conc]) }
      .map { $0.result }
      .reduce(0, +)
  }
}

private struct Equation {
  let result: Int
  let numbers: [Int]
}

private enum Operation {
  case add, mul, conc

  func operate(lhs: Int, rhs: Int) -> Int {
    switch self {
    case .add:
      return lhs + rhs
    case .mul:
      return lhs * rhs
    case .conc:
      return Int("\(lhs)\(rhs)")!
    }
  }
}
