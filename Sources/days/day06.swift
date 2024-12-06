class Day06: AdventDay {

    fileprivate func loadMap() -> ([[Field]], Vector) {
        var initialPosition = Vector(x: -1, y: -1)
        let map: [[Field]] = Self.dataLines.enumerated().map { row, line in
            return line.enumerated().map { col, character in
                switch character {
                case ".":
                    return .empty
                case "#":
                    return .obstacle
                case "^":
                    initialPosition = Vector(x: col, y: row)
                    return .visited
                default:
                    fatalError("unknown character \(character)")
                }
            }
        }
        return (map, initialPosition)
    }

    fileprivate func trace(map: [[Field]], initialVector: Vector) -> Int {
        var pos = Position(vec: initialVector, direction: .up)
        let (height, width) = (map.count, map[0].count)

        var visited: Set<Vector> = Set()
        while true {
            visited.insert(pos.vec)
            let newVec = pos.vec + pos.direction.step()
            if newVec.isOutOfBounds(bounds: (height, width)) {
                break
            }

            switch map[newVec.y][newVec.x] {
            case .empty, .visited:
                pos.vec = newVec
            case .obstacle:
                pos.direction.turn()
            }
        }

        return visited.count
    }

    fileprivate func hasLoop(map: [[Field]], initialVector: Vector) -> Bool {
        var pos = Position(vec: initialVector, direction: .up)
        let (height, width) = (map.count, map[0].count)

        var visited: Set<Position> = Set()
        while true {
            visited.insert(pos)
            let newVec = pos.vec + pos.direction.step()
            if visited.contains(Position(vec: newVec, direction: pos.direction)) {
                return true
            }
            if newVec.isOutOfBounds(bounds: (height, width)) {
                break
            }

            switch map[newVec.y][newVec.x] {
            case .empty, .visited:
                pos.vec = newVec
            case .obstacle:
                pos.direction.turn()
            }
        }

        return false
    }

    func part1() -> Any {
        let (map, initialVec) = loadMap()
        return trace(map: map, initialVector: initialVec)

    }

    func part2() -> Any {
        var (map, vec) = loadMap()
        let (height, width) = (map.count, map[0].count)

        var loops = 0

        for i in 0..<height {
            for j in 0..<width {
                switch map[i][j] {
                case .empty, .visited:
                    map[i][j] = .obstacle
                    if hasLoop(map: map, initialVector: vec) {
                        loops += 1
                    }
                    map[i][j] = .empty
                case .obstacle:
                    continue
                }
            }
        }

        return loops
    }
}

private struct Position: Hashable {
    var vec: Vector
    var direction: Direction
}

private enum TraceResult {
    case oob(steps: Int)
    case loop
}

private struct Vector: Hashable, Equatable {
    var x, y: Int

    static func + (lhs: Vector, rhs: (Int, Int)) -> Vector {
        return Vector(x: lhs.x + rhs.0, y: lhs.y + rhs.1)
    }

    func isOutOfBounds(bounds: (Int, Int)) -> Bool {
        return self.y < 0 || self.x < 0 || self.y >= bounds.0 || self.x >= bounds.1
    }

}

private enum Direction: Hashable, CustomStringConvertible {
    case up, down, left, right

    var description: String {
        switch self {
        case .up: return "^"
        case .down: return "v"
        case .right: return ">"
        case .left: return "<"
        }
    }

    func step() -> (Int, Int) {
        switch self {
        case .up: return (0, -1)
        case .down: return (0, 1)
        case .right: return (1, 0)
        case .left: return (-1, 0)
        }
    }

    mutating func turn() {
        switch self {
        case .up: self = .right
        case .right: self = .down
        case .down: self = .left
        case .left: self = .up
        }
    }

}

private enum Field: CustomStringConvertible {
    case empty, visited, obstacle

    var description: String {
        switch self {
        case .empty:
            return "."
        case .visited:
            return "X"
        case .obstacle:
            return "#"
        }
    }
}
