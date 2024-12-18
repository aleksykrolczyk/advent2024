class Day18: AdventDay {
    static let N = 1024
    static let GRID_SIZE = (71, 71)

    // static let N = 12
    // static let GRID_SIZE = (7, 7)

    static let START = Point(x: 0, y: 0)
    static let END = Point(x: GRID_SIZE.0 - 1, y: GRID_SIZE.1 - 1)

    func getCorruptedBytes(n: Int? = nil) -> Set<Point> {
        let bytes = Self.dataLines[..<(n ?? Self.dataLines.count)].map { line in
            let t = line.toInts(separator: ",")
            return Point(x: t[0], y: t[1])
        }
        return Set(bytes)
    }

    func traverse(dists: inout [[Int]], bytes: Set<Point>, currentPosition: Point, currentDist: Int)
    {
        if dists[currentPosition] <= currentDist {
            return
        }
        dists[currentPosition] = currentDist
        for dp in Point.orthogonalDeltas {
            let next = currentPosition + dp
            if bytes.contains(next) || next.outOfBounds(rectangularMatrix: dists) {
                continue
            }
            traverse(
                dists: &dists, bytes: bytes, currentPosition: next, currentDist: currentDist + 1)
        }

    }

    func pprint(dists: [[Int]]) {
        for i in dists.indices {
            for j in dists[i].indices {
                print(dists[i][j] == Int.max ? "." : dists[i][j], terminator: " ")
            }
            print()
        }
    }

    func part1() -> Any {
        let corruptedBytes = getCorruptedBytes(n: Self.N)
        var dists = Array(
            repeating: Array(repeating: Int.max, count: Self.GRID_SIZE.0), count: Self.GRID_SIZE.1
        )
        traverse(dists: &dists, bytes: corruptedBytes, currentPosition: Self.START, currentDist: 0)
        return dists[Self.END]
    }

    func part2() -> Any {
        for i in Self.N..<Self.dataLines.count {
            let corruptedBytes = getCorruptedBytes(n: i)
            var dists = Array(
                repeating: Array(repeating: Int.max, count: Self.GRID_SIZE.0),
                count: Self.GRID_SIZE.1
            )
            traverse(
                dists: &dists, bytes: corruptedBytes, currentPosition: Self.START, currentDist: 0)
            if dists[Self.END] == Int.max {
                return Self.dataLines[i - 1]
            }
        }
        return -1
    }
}
