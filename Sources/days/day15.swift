class Day15: AdventDay {

    private func getData() -> ([[Tile]], [Instruction]) {
        let x = Self.dataLines.split { $0.isEmpty }

        let map = x[0].map { line in
            return line.map { Tile($0) }
        }

        var instructions: [Instruction] = []
        for line in x[1] {
            instructions.append(contentsOf: line.map { Instruction($0) })
        }
        return (map, instructions)
    }

    private func getStartingPosition(map: [[Tile]]) -> Point {
        for row in 0..<map.count {
            for col in 0..<map[0].count {
                if map[row][col] == .robot {
                    return Point(x: col, y: row)
                }
            }
        }
        fatalError("starting position not found")
    }

    private func tryMove(
        in map: inout [[Tile]], from: Point, ins: Instruction, justCheck: Bool = false
    ) -> Bool {
        let to = from + ins.delta
        switch map[to] {
        case .wall, .robot:
            return false
        case .box:
            if tryMove(in: &map, from: to, ins: ins) {
                if !justCheck {
                    map[to] = map[from]
                    map[from] = .void
                }
                return true
            }
        case .void:
            if !justCheck {
                map[to] = map[from]
                map[from] = .void
            }
            return true
        case .boxLeft, .boxRight:
            if ins.isHorizontal {
                if tryMove(in: &map, from: to, ins: ins) {
                    if !justCheck {
                        map[to] = map[from]
                        map[from] = .void
                    }
                    return true
                }
            } else {
                let ds = map[to] == .boxLeft ? Point(x: 1, y: 0) : Point(x: -1, y: 0)
                let leftOk = tryMove(in: &map, from: to, ins: ins, justCheck: true)
                let rightOk = tryMove(in: &map, from: to + ds, ins: ins, justCheck: true)
                if leftOk && rightOk {
                    if !justCheck {
                        _ = tryMove(in: &map, from: to, ins: ins, justCheck: false)
                        _ = tryMove(in: &map, from: to + ds, ins: ins, justCheck: false)
                        map[to] = map[from]
                        map[from] = .void
                    }

                    return true
                }
            }
        }
        return false
    }

    private func simulate(map: inout [[Tile]], instructions: [Instruction]) {
        var pos = getStartingPosition(map: map)
        for ins in instructions {
            if tryMove(in: &map, from: pos, ins: ins) {
                pos = pos + ins.delta
            }
        }
    }

    private func gpsCordinates(map: [[Tile]]) -> Int {
        var total = 0
        for row in 0..<map.count {
            for col in 0..<map[0].count {
                if map[row][col] == .box || map[row][col] == .boxLeft {
                    total += row * 100 + col
                }
            }
        }
        return total
    }

    private func resize(map: [[Tile]]) -> [[Tile]] {
        var resized: [[Tile]] = []
        for row in 0..<map.count {
            resized.append([])
            for col in 0..<map[0].count {
                switch map[row][col] {
                case .wall: resized[row].append(contentsOf: [.wall, .wall])
                case .box: resized[row].append(contentsOf: [.boxLeft, .boxRight])
                case .void: resized[row].append(contentsOf: [.void, .void])
                case .robot: resized[row].append(contentsOf: [.robot, .void])
                default: noop()
                }
            }
        }
        return resized
    }

    func part1() -> Any {
        var (map, instructions) = getData()
        simulate(map: &map, instructions: instructions)
        return gpsCordinates(map: map)
    }

    func part2() -> Any {
        let (map, instructions) = getData()
        var resized = resize(map: map)
        simulate(map: &resized, instructions: instructions)
        return gpsCordinates(map: resized)
    }

}

private enum Tile: CustomStringConvertible {
    case robot, wall, box, void, boxLeft, boxRight
    init(_ char: Character) {
        switch char {
        case "@": self = .robot
        case "#": self = .wall
        case "O": self = .box
        case ".": self = .void
        case "[": self = .boxLeft
        case "]": self = .boxRight
        default: fatalError("unkown char")
        }
    }

    var description: String {
        switch self {
        case .robot: return "@"
        case .wall: return "#"
        case .box: return "O"
        case .void: return "."
        case .boxLeft: return "["
        case .boxRight: return "]"
        }
    }

}

private enum Instruction: CustomStringConvertible {
    case up, down, left, right
    init(_ char: Character) {
        switch char {
        case "^": self = .up
        case "v": self = .down
        case "<": self = .left
        case ">": self = .right
        default: fatalError("unkown char")
        }
    }

    var description: String {
        switch self {
        case .up: "^"
        case .down: "v"
        case .left: "<"
        case .right: ">"
        }
    }

    var isHorizontal: Bool {
        self == .left || self == .right
    }

    var delta: Point {
        switch self {
        case .up: Point(x: 0, y: -1)
        case .down: Point(x: 0, y: 1)
        case .left: Point(x: -1, y: 0)
        case .right: Point(x: 1, y: 0)
        }
    }

}
