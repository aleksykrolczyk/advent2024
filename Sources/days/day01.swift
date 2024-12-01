class Day01: AdventDay {

    func part1() -> Any {

        var lefts: [Int] = []
        var rights: [Int] = []

        for line in Self.dataLines {
            let s = line.split(separator: " ").map { Int($0)! }
            lefts.append(s[0])
            rights.append(s[1])
        }

        lefts.sort()
        rights.sort()

        return zip(lefts, rights).map { abs($0 - $1) }.reduce(0, +)
    }

    func part2() -> Any {

        var lefts: [Int] = []
        var occurrences: [Int: Int] = [:]

        for line in Self.dataLines {
            let s = line.split(separator: " ").map { Int($0)! }
            lefts.append(s[0])

            let right = s[1]
            if occurrences[right] != nil {
                occurrences[right]! += 1
            } else {
                occurrences[right] = 1
            }
        }

        return lefts.map { $0 * (occurrences[$0] ?? 0) }.reduce(0, +)
    }

}
