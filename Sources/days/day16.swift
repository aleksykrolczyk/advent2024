import Collections

var START = Point(x: -1, y: -1)
var END = Point(x: -1, y: -1)

let MIN_DIST = 83432
var MIN_PATHS: Set<Point> = []

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

    private func traverse(
        maze: [[Tile]],
        dists: inout [Point: [Direction: Int]],
        position: Point,
        direction: Direction,
        distance: Int,
        path: [Point]
    ) {
        if position == END && distance == MIN_DIST {
            MIN_PATHS = MIN_PATHS.union(path)
        }
        if let x = dists[position], let y = x[direction], y < distance {
            return
        }
        if dists[position] == nil {
            dists[position] = [:]
        }
        dists[position]![direction] = distance

        if maze[position + direction.delta] != .wall {
            let next = position + direction.delta
            traverse(
                maze: maze,
                dists: &dists,
                position: next,
                direction: direction,
                distance: distance + 1,
                path: path + [next]
            )
        }

        for newDir in [direction.clockwise, direction.counterClockwise] {
            let next = position + newDir.delta
            if maze[next] != .wall {
                traverse(
                    maze: maze,
                    dists: &dists,
                    position: next,
                    direction: newDir,
                    distance: distance + 1000 + 1,
                    path: path + [next]
                )
            }
        }
    }

    func part1() -> Any {
        let maze = getData()
        var dists: [Point: [Direction: Int]] = [:]
        traverse(
            maze: maze, dists: &dists, position: START, direction: .right, distance: 0,
            path: [START])
        return dists[END]?.values.min() ?? "its bad"
    }

    func part2() -> Any {
        return MIN_PATHS.count
    }
}

private struct State: Hashable, CustomStringConvertible {
    let position: Point
    let direction: Direction

    var description: String {
        "<\(position), \(direction)>"
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
