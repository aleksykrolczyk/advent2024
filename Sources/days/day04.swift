class Day04: AdventDay {

  func seekPattern(matrix: [[Character]], position: (Int, Int), word: String) -> Int {
    if word.count == 0 {
      return 0
    }

    var total = 0
    for i in -1...1 {
      for j in -1...1 {
        if i == 0 && j == 0 {
          continue
        }

        var temp_word = ""
        for q in 0...word.count - 1 {
          let temp_pos = (position.0 + i * q, position.1 + j * q)
          if !(temp_pos.0 >= 0 && temp_pos.1 >= 0 && temp_pos.0 <= matrix.count - 1
            && temp_pos.1 <= matrix[0].count - 1)
          {
            break
          }
          if matrix[temp_pos.0][temp_pos.1] != word[q] {
            break
          }
          temp_word += String(word[q])
        }
        if temp_word == word {
          total += 1
        }
      }
    }

    return total
  }

  func countOccurences(matrix: [[Character]], word: String) -> Int {
    var total = 0
    for row in matrix.indices {
      for col in matrix[0].indices {
        let current = matrix[row][col]
        if current == word[0] {
          total += seekPattern(matrix: matrix, position: (row, col), word: word)
        }
      }
    }
    return total
  }

  func countOccurences(matrix: [[Character]], mask: [[String?]]) -> Int {
    var total = 0
    for row in 0...(matrix.count - mask.count) {
      for col in 0...(matrix[0].count - mask[0].count) {

        var found = true
        outer: for i in 0..<mask.count {
          for j in 0..<mask[0].count {
            if let element = mask[i][j], String(matrix[row + i][col + j]) != element {
              found = false
              break outer
            }
          }
        }
        total += found ? 1 : 0
      }
    }

    return total
  }

  func part1() -> Any {
    let matrix = Self.dataLines.map { line in
      return Array(line)
    }
    return countOccurences(matrix: matrix, word: "XMAS")
  }

  func part2() -> Any {
    let matrix = Self.dataLines.map { line in
      return Array(line)
    }
    let masks = [
      [
        ["M", nil, "S"],
        [nil, "A", nil],
        ["M", nil, "S"],
      ],
      [
        ["S", nil, "M"],
        [nil, "A", nil],
        ["S", nil, "M"],
      ],
      [
        ["M", nil, "M"],
        [nil, "A", nil],
        ["S", nil, "S"],
      ],
      [
        ["S", nil, "S"],
        [nil, "A", nil],
        ["M", nil, "M"],
      ],
    ]

    return masks.map {
      countOccurences(matrix: matrix, mask: $0)
    }
    .reduce(0, +)
  }
}
