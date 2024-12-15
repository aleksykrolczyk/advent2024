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

    var absMagnitude: Int {
        return abs(x) + abs(y)
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
        set {
            if p.x < 0 && p.y < 0 && p.y >= self.count && p.x >= self[p.y].count {
                fatalError("outOfBounds \(p)")
            }
            var row = self[p.y] as! [Element.Element]
            row[p.x] = newValue
            self[p.y] = row as! Element
        }
    }

    func printLines() {
        for line in self {
            print(line)
        }
    }

}

func noop() {}

func greatestCommonDivisor(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)

    while r != 0 {
        (a, b, r) = (b, r, a % b)
    }
    return b
}

func leastCommonMultiple(_ x: Int, _ y: Int) -> Int {
    return x / greatestCommonDivisor(x, y) * y
}
