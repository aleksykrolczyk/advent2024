class Day20: AdventDay {
    static var START = Point(x: -1, y: -1)
    static var END = Point(x: -1, y: -1)

    fileprivate let maze: [[Tile]]

    init() {
        self.maze = Self.dataLines.enumerated().map { row, line in
            return line.enumerated().map { col, character in
                switch character {
                case "#": return .wall
                case ".": return .empty
                case "S":
                    Self.START = Point(x: col, y: row)
                    return .empty
                case "E":
                    Self.END = Point(x: col, y: row)
                    return .empty
                default: fatalError("its bad")
                }
            }
        }
    }

    private func traverse(dists: inout [[Int]], position: Point, distance: Int) {
        if dists[position] < distance {
            return
        }
        dists[position] = distance
        for dp in Point.orthogonalDeltas {
            let next = position + dp
            if maze[next] != .wall {
                traverse(dists: &dists, position: next, distance: distance + 1)
            }
        }
    }

    private func cheatTraverse(dists: [[Int]], from pos: Point, threshold: Int) -> Set<Cheat> {
        var cheats: Set<Cheat> = []

        for i in (-threshold...threshold) {
            for j in (-threshold...threshold) {
                if i == 0 && j == 0 {
                    continue
                }

                let p = Point(x: pos.x + i, y: pos.y + j)
                if p.outOfBounds(rectangularMatrix: dists)
                    || maze[p] == .wall
                    || pos.manhattan(other: p) > threshold
                {
                    continue
                }

                let cheat = Cheat(start: pos, end: p)
                if cheat.savedTime(in: dists) > 0 {
                    cheats.insert(cheat)
                }
            }
        }

        return cheats
    }

    func part1() -> Any {
        var dists: [[Int]] = Array(
            repeating: Array(repeating: Int.max, count: maze[0].count),
            count: maze.count
        )
        traverse(dists: &dists, position: Self.END, distance: 0)

        var path: [Point] = []
        for (col, row) in dists.matrixIndices() {
            if dists[row][col] != Int.max {
                path.append(Point(x: col, y: row))
            }
        }

        var cheats: Set<Cheat> = []
        for position in path {
            let c = cheatTraverse(dists: dists, from: position, threshold: 2)
            cheats = cheats.union(c)
        }
        return cheats.filter { $0.savedTime(in: dists) >= 100 }.count
    }

    func part2() -> Any {
        var dists: [[Int]] = Array(
            repeating: Array(repeating: Int.max, count: maze[0].count),
            count: maze.count
        )
        traverse(dists: &dists, position: Self.END, distance: 0)

        var path: [Point] = []
        for (col, row) in dists.matrixIndices() {
            if dists[row][col] != Int.max {
                path.append(Point(x: col, y: row))
            }
        }

        var cheats: Set<Cheat> = []
        for position in path {
            let c = cheatTraverse(dists: dists, from: position, threshold: 20)
            cheats = cheats.union(c)
        }
        return cheats.filter { $0.savedTime(in: dists) >= 100 }.count
    }
}

struct Cheat: Hashable {
    let start, end: Point

    func savedTime(in dists: [[Int]]) -> Int {
        return dists[start] - dists[end] - end.manhattan(other: start)
    }
}

private enum Tile: CustomStringConvertible {
    case wall, empty
    var description: String {
        switch self {
        case .wall: "#"
        case .empty: "."
        }
    }
}
