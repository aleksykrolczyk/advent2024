import Collections

var START = Point(x: -1, y: -1)
var END = Point(x: -1, y: -1)

class Day16: AdventDay {
    fileprivate func getData() -> [[Tile]] {
        return Self.dataLines.enumerated().map { row, line in
            return line.enumerated().map { col, character in
                switch character {
                case "#": return .wall
                case ".": return .empty
                case "S":
                    START = Point(x: col, y: row)
                    return .start
                case "E":
                    END = Point(x: col, y: row)
                    return .end
                default: fatalError("its bad")
                }
            }
        }
    }

    private func astar(maze: [[Tile]]) -> Int {
        var visited: Set<State> = []
        var queue: Heap<State> = [State(position: START, direction: .right, score: 0)]
        while let current = queue.popMin() {
            if current.position == END {
                return current.score
            }

            if visited.contains(current) {
                continue
            }
            visited.insert(current)

            let forwardPos = current.position + current.direction.delta
            if maze[forwardPos] != .wall {
                queue.insert(
                    State(
                        position: forwardPos, direction: current.direction,
                        score: current.score + 1
                    ))
            }
            if maze[current.position + current.direction.clockwise.delta] != .wall {
                queue.insert(
                    State(
                        position: current.position, direction: current.direction.clockwise,
                        score: current.score + 1000
                    ))
            }
            if maze[current.position + current.direction.counterClockwise.delta] != .wall {
                queue.insert(
                    State(
                        position: current.position, direction: current.direction.counterClockwise,
                        score: current.score + 1000
                    ))
            }
        }
        return -1
    }

    func part1() -> Any {
        let maze = getData()
        maze.printLines()

        let score = astar(maze: maze)

        return score
    }

    func part2() -> Any {
        return ""
    }
}

private struct State: Hashable, CustomStringConvertible, Comparable {
    let position: Point
    let direction: Direction
    let score: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(direction)
    }

    static func < (lhs: State, rhs: State) -> Bool {
        lhs.score + (END - lhs.position).manhattan < rhs.score + (END - rhs.position).manhattan
    }

    var description: String {
        "<\(position), \(direction), \(score)>"
    }
}

private enum Tile: CustomStringConvertible {
    case wall, empty, start, end
    var description: String {
        switch self {
        case .wall: "#"
        case .empty: "."
        case .start: "S"
        case .end: "E"
        }
    }
}

private enum Direction {
    case up, down, left, right
    var delta: Point {
        switch self {
        case .up: return Point(x: 0, y: -1)
        case .down: return Point(x: 0, y: 1)
        case .right: return Point(x: 1, y: 0)
        case .left: return Point(x: -1, y: 0)
        }
    }

    var clockwise: Direction {
        switch self {
        case .up: .right
        case .right: .down
        case .down: .left
        case .left: .up
        }
    }

    var counterClockwise: Direction {
        switch self {
        case .up: .left
        case .left: .down
        case .down: .right
        case .right: .up
        }
    }
}
