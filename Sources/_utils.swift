extension String {
    subscript(_ i: Int) -> Character {
        self[index(startIndex, offsetBy: i)]
    }
}

extension StringProtocol {
    func toInts(separator: String = ",") -> [Int] {
        return self.split(separator: separator).map { Int($0)! }
    }
}

struct Point: Hashable, CustomStringConvertible {
    let x, y: Int

    var description: String {
        return "(\(x),\(y))"
    }

    func outOfBounds(width: Int, height: Int) -> Bool {
        return x < 0 || y < 0 || x >= width || y >= height
    }

    static func + (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func += (lhs: inout Point, rhs: Point) {
        lhs = lhs + rhs
    }

    static func -= (lhs: inout Point, rhs: Point) {
        lhs = lhs - rhs
    }

}

extension Array where Element: Collection, Element.Index == Int {
    subscript(_ p: Point) -> Element.Element {
        get {
            if p.x < 0 && p.y < 0 && p.y >= self.count && p.x >= self[p.y].count {
                fatalError("outOfBounds \(p)")
            }
            return self[p.y][p.x]
        }
    }
}

func noop() {}
