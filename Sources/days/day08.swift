class Day08: AdventDay {

    private func getAntennas() -> [String: Set<Point>] {
        var antennas: [String: Set<Point>] = [:]
        Self.dataLines.enumerated().forEach { row, line in
            line.enumerated().forEach { col, element in
                let s = String(element)
                if element != "." {
                    if antennas[s] == nil {
                        antennas[s] = Set()
                    }
                    antennas[s]!.insert(Point(x: col, y: row))
                }
            }
        }
        return antennas
    }

    func getSizes() -> (width: Int, height: Int) {
        return (width: Self.dataLines[0].count, height: Self.dataLines.count)
    }

    func part1() -> Any {
        let antennas = getAntennas()
        let (width, height) = getSizes()

        var antinodes: Set<Point> = Set()
        for (_, positions) in antennas {
            for (a1, a2) in positions.pairs() {
                let diff = a2 - a1
                let posAntinode = a2 + diff
                if !posAntinode.outOfBounds(width: width, height: height) {
                    antinodes.insert(posAntinode)
                }
                let negAntinode = a1 - diff
                if !negAntinode.outOfBounds(width: width, height: height) {
                    antinodes.insert(negAntinode)
                }
            }
        }

        return antinodes.count
    }

    func part2() -> Any {
        let antennas = getAntennas()
        let (width, height) = getSizes()

        var antinodes: Set<Point> = Set()
        for (_, positions) in antennas {
            for (a1, a2) in positions.pairs() {
                antinodes.insert(a2)
                let diff = a2 - a1
                var posAntinode = a2
                while !posAntinode.outOfBounds(width: width, height: height) {
                    antinodes.insert(posAntinode)
                    posAntinode += diff
                }

                var negAntinode = a1
                while !negAntinode.outOfBounds(width: width, height: height) {
                    antinodes.insert(negAntinode)
                    negAntinode -= diff
                }
            }
        }

        return antinodes.count
    }
}

extension Collection {
    fileprivate func pairs() -> [(Element, Element)] {
        guard count >= 2 else { return [] }
        var pairs: [(Element, Element)] = []

        for (i, first) in self.enumerated() {
            for second in self.dropFirst(i + 1) {
                pairs.append((first, second))
            }
        }
        return pairs
    }
}
