import Foundation
import SwiftGD

private typealias Vector = Point

class Day14: AdventDay {

    fileprivate func getRobots() -> [Robot] {
        let robotRegex = #/-?\d+/#
        return Self.dataLines.map { line in
            let matches = line.matches(of: robotRegex)
            let pos = Point(x: Int(matches[0].output)!, y: Int(matches[1].output)!)
            let vel = Vector(x: Int(matches[2].output)!, y: Int(matches[3].output)!)
            return Robot(position: pos, velocity: vel)
        }
    }
    fileprivate func getQuadrant(p: Point, space: (width: Int, height: Int)) -> Quadrant? {
        let (midX, midY) = (space.width / 2, space.height / 2)
        if p.x == midX || p.y == midY {
            return nil
        }
        if p.x > midX && p.y < midY {
            return .first
        } else if p.x < midX && p.y < midY {
            return .second
        } else if p.x < midX && p.y > midY {
            return .third
        } else {
            return .fourth
        }
    }

    func part1() -> Any {
        let robots = getRobots()
        let (width, height) = (101, 103)

        var quadrants: [Quadrant: Int] = [
            .first: 0,
            .second: 0,
            .third: 0,
            .fourth: 0,
        ]

        for robot in robots {
            let pos = robot.move(space: (width, height), n: 100)
            if let q = getQuadrant(p: pos, space: (width, height)) {
                quadrants[q]! += 1
            }
        }

        print(quadrants)
        return
            quadrants
            .map { $0.value }
            .reduce(1, *)
    }

    func drawPNG(positions: Set<Point>, space: (width: Int, height: Int), fileName: String) {
        guard let image = Image(width: space.width, height: space.height) else {
            print("Failed to create image.")
            return
        }

        for i in 0..<space.width {
            for j in 0..<space.height {
                let color: Color = positions.contains(Point(x: i, y: j)) ? .black : .white
                image.set(pixel: SwiftGD.Point(x: i, y: j), to: color)
            }
        }

        let filePath = "images/\(fileName).png"
        image.write(to: URL(fileURLWithPath: filePath), quality: 100)
    }

    func part2() -> Any {
        let robots = getRobots()
        let (width, height) = (101, 103)

        let PLEASE_STOP = 10000

        for i in 0..<PLEASE_STOP {
            let positions = Set(robots.map { $0.move(space: (width, height), n: i) })
            drawPNG(
                positions: positions, space: (width, height), fileName: String(format: "%04d", i))
        }
        return ""
    }
}

private struct Robot: CustomStringConvertible {
    let position: Point
    let velocity: Vector

    var description: String {
        return "<Robot p=\(position) v=\(velocity)>"
    }

    func move(space: (width: Int, height: Int), n: Int) -> Point {
        let x = (position.x + n * velocity.x) % space.width
        let y = (position.y + n * velocity.y) % space.height
        return Point(
            x: x >= 0 ? x : x + space.width,
            y: y >= 0 ? y : y + space.height
        )
    }

}

private enum Quadrant: CustomStringConvertible {
    case first, second, third, fourth

    var description: String {
        switch self {
        case .first: ".first"
        case .second: ".second"
        case .third: ".third"
        case .fourth: ".fourth"
        }
    }
}
