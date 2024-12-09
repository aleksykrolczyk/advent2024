class Day09: AdventDay {

  fileprivate func getFragments() -> [Fragment] {
    var currentId = 0
    let diskFragments = Self.dataLines.first!.enumerated().map { i, character in
      let isEmptySpace = i % 2 == 0
      if isEmptySpace {
        let f = Fragment(id: currentId, length: character.hexDigitValue!)
        currentId += 1
        return f
      } else {
        return Fragment(id: nil, length: character.hexDigitValue!)
      }
    }
    return diskFragments
  }

  func subtotal(memIndex: Int, blockLength: Int, id: Int?) -> Int {
    guard let id else {
      return 0
    }
    var subtotal = 0
    for i in 0..<blockLength {
      subtotal += (memIndex + i) * id
    }
    return subtotal

  }

  fileprivate func calculateChecksum(fragments: inout [Fragment]) -> Int {
    var total = 0
    var memIndex = 0
    for fragment in fragments {
      let sub = subtotal(memIndex: memIndex, blockLength: fragment.length, id: fragment.id)
      total += sub
      memIndex += fragment.length

    }
    return total
  }

  func part1() -> Any {
    var fragments = getFragments()
    var (i, j) = (0, fragments.count - 1)

    var defragmented: [Fragment] = []
    while i < j {
      if !fragments[i].isEmpty {
        defragmented.append(fragments[i])
        (i, j) = (i + 1, j - 0)
        continue
      }

      if fragments[j].isEmpty {
        (i, j) = (i + 0, j - 1)
        continue
      }

      if fragments[i].length > fragments[j].length {
        defragmented.append(fragments[j])
        fragments[i].length -= fragments[j].length
        fragments[j].id = nil
        (i, j) = (i + 0, j - 1)
      } else if fragments[i].length < fragments[j].length {
        defragmented.append(Fragment(id: fragments[j].id, length: fragments[i].length))
        fragments[j].length -= fragments[i].length
        (i, j) = (i + 1, j - 0)
      } else {
        defragmented.append(fragments[j])
        fragments[j].id = nil
        (i, j) = (i + 1, j - 1)
      }
    }

    while !fragments[i].isEmpty {
      defragmented.append(fragments[i])
      i += 1
    }

    return calculateChecksum(fragments: &defragmented)
  }

  func part2() -> Any {
    var fragments = getFragments()
    var j = fragments.count - 1

    while j > 0 {
      if fragments[j].isEmpty {
        j -= 1
        continue
      }

      let hit = fragments.enumerated().first { (i, fragment) in
        fragment.isEmpty && i < j && fragment.length >= fragments[j].length
      }

      if let (emptyBlockIndex, _) = hit {
        fragments[emptyBlockIndex].length -= fragments[j].length
        fragments.insert(fragments[j], at: emptyBlockIndex)
        fragments[j + 1].id = nil
      }

      j -= 1
    }

    return calculateChecksum(fragments: &fragments)
  }
}

private struct Fragment: CustomStringConvertible {
  var id: Int?
  var length: Int

  var isEmpty: Bool {
    id == nil
  }

  var description: String {
    return "\(id ?? -1)x\(length)"
  }

}
