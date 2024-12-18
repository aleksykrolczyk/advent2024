import Foundation

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

    var manhattan: Int {
        return abs(x) + abs(y)
    }

    func outOfBounds(width: Int, height: Int) -> Bool {
        return x < 0 || y < 0 || x >= width || y >= height
    }

    func outOfBounds<T>(rectangularMatrix m: [[T]]) -> Bool {
        return x < 0 || y < 0 || x >= m[0].count || y >= m.count
    }

    static var orthogonalDeltas: [Point] {
        return [
            Point(x: 1, y: 0),
            Point(x: -1, y: 0),
            Point(x: 0, y: 1),
            Point(x: 0, y: -1),
        ]
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

precedencegroup Exponentiative {
    associativity: left
    higherThan: MultiplicationPrecedence
}
infix operator ** : Exponentiative

extension Int {
    var length: Int {
        var (c, length) = (self, 0)
        while c > 0 {
            length += 1
            c = c / 10
        }
        return length
    }

    func split() -> (Int, Int) {
        let str = String(self)
        let mid = str.index(str.startIndex, offsetBy: length / 2)
        let left = Int(String(str[..<mid]))!
        let right = Int(String(str[mid...]))!
        return (left, right)
    }

    static func ** (num: Int, power: Int) -> Int {
        var res = 1
        for _ in 0..<power {
            res *= num
        }
        return res
    }
}
