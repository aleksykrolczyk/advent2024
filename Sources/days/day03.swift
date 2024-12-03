class Day03: AdventDay {
  func part1() -> Any {
    let muls = #/mul\((\d{1,3},\d{1,3})\)/#

    return Self.data.matches(of: muls).map { match in
      let numbers = match.1.toInts()
      print(numbers)
      return numbers.reduce(1, *)
    }
    .reduce(0, +)
  }

  func part2() -> Any {
    let reg = #/(mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\))/#

    var total = 0
    var enabled = true
    for match in Self.data.matches(of: reg) {
      switch match.0 {
      case "do()":
        enabled = true
      case "don't()":
        enabled = false
      default:
        if enabled {
          let nums = match.0.trimmingPrefix("mul(").dropLast()
          total += nums.toInts().reduce(1, *)
        }
      }
    }
    return total
  }
}
