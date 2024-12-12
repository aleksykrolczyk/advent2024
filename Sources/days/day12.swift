private typealias Garden = [[String]]

private let DELTAS = [
    Point(x: 1, y: 0),
    Point(x: -1, y: 0),
    Point(x: 0, y: 1),
    Point(x: 0, y: -1),
]

class Day12: AdventDay {

    fileprivate func getGarden() -> Garden {
        return Self.dataLines.map { line in
            return line.map { String($0) }
        }
    }

    fileprivate func flood(garden: Garden, from startingPoint: Point) -> Set<Point> {
        var bounds = Set([startingPoint])
        var current = startingPoint
        var moves: Set<Point> = []

        while true {
            let nextMoves =
                DELTAS
                .map { current + $0 }
                .filter { !$0.outOfBounds(width: garden[0].count, height: garden.count) }
                .filter { garden[$0] == garden[startingPoint] }
                .filter { !bounds.contains($0) }

            moves = moves.union(nextMoves)
            guard let next = moves.popFirst() else {
                break
            }
            current = next

            bounds.insert(current)
            moves.remove(current)
        }

        return bounds
    }

    fileprivate func getRegions(for garden: Garden) -> [Region] {
        var regions: [Region] = []

        for i in 0..<garden.count {
            rows: for j in 0..<garden[i].count {
                let p = Point(x: j, y: i)
                for region in regions {
                    if region.contains(p) {
                        continue rows
                    }
                }

                let bounds = flood(garden: garden, from: p)
                regions.append(Region(label: garden[p], bounds: bounds))
            }
        }

        return regions
    }

    func part1() -> Any {
        let garden = getGarden()
        let regions = getRegions(for: garden)
        return
            regions
            .map { $0.bounds.count * $0.perimeterLength }
            .reduce(0, +)
    }

    func part2() -> Any {
        let garden = getGarden()
        let regions = getRegions(for: garden)
        return
            regions
            .map { $0.bounds.count * $0.corners }
            .reduce(0, +)
    }
}

private let DELTAS2: [(Point, Direction)] = [
    (Point(x: 1, y: 0), .right),
    (Point(x: -1, y: 0), .left),
    (Point(x: 0, y: 1), .down),
    (Point(x: 0, y: -1), .up),
]

struct Region {
    let label: String
    let bounds: Set<Point>

    func contains(_ p: Point) -> Bool {
        return bounds.contains(p)
    }

    fileprivate var perimeter: [PerimeterSection] {
        var temp: [PerimeterSection] = []
        for p in bounds {
            for (dp, direction) in DELTAS2 {
                let s = p + dp
                if bounds.contains(s) {
                    continue
                }
                if let index = temp.firstIndex(where: { $0.point == s }) {
                    temp[index].addDirection(from: direction)
                } else {
                    temp.append(PerimeterSection(point: s, directions: [direction]))
                }
            }
        }
        return temp
    }

    var perimeterLength: Int {
        return
            perimeter
            .map { $0.directions.count }
            .reduce(0, +)
    }

    var corners: Int {
        let per = perimeter
        let minX = per.min(by: { $0.point.x < $1.point.x })!.point.x
        let maxX = per.min(by: { $0.point.x > $1.point.x })!.point.x

        var verticalLines: [Int: [PerimeterSection]] = [:]
        for i in minX...maxX {
            let sections =
                per
                .filter { $0.point.x == i }
                .filter { $0.directions.contains(.left) || $0.directions.contains(.right) }
            if !sections.isEmpty {
                verticalLines[i] = sections
            }
        }

        var linesCount = 0
        for (_, lineFragments) in verticalLines {
            for direction in [Direction.left, Direction.right] {
                var segments = lineFragments.filter { $0.directions.contains(direction) }

                if segments.isEmpty {
                    continue
                }

                linesCount += 1

                var currentLine = [segments.popLast()!]
                while !segments.isEmpty {
                    var hit = false
                    outer: for (i, s) in segments.enumerated() {
                        for c in currentLine {
                            if abs(s.point.y - c.point.y) == 1 {
                                currentLine.append(s)
                                segments.remove(at: i)
                                hit = true
                                break outer
                            }
                        }
                    }

                    if !hit {
                        currentLine = [segments.popLast()!]
                        linesCount += 1
                    }

                }
            }
        }

        return linesCount * 2
    }
}

private enum Direction: Hashable, CustomStringConvertible {
    case up, down, left, right

    var description: String {
        switch self {
        case .up: return "^"
        case .down: return "v"
        case .left: return "<"
        case .right: return ">"
        }
    }
}

private struct PerimeterSection: CustomStringConvertible {
    let point: Point
    var directions: Set<Direction>

    mutating func addDirection(from dir: Direction) {
        self.directions.insert(dir)
    }

    var description: String {
        return "{point=\(point) dirs\(directions)}"
    }

}
