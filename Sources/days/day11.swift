class Day11: AdventDay {

    static var memo: [String: Int] = [:]

    func transform(stone: Int) -> [Int] {
        if stone == 0 {
            return [1]
        }
        if stone.length % 2 == 0 {
            let (left, right) = stone.split()
            return [left, right]
        }
        return [stone * 2024]
    }

    func blink(stone: Int, n: Int = 1) -> Int {
        let key = "\(stone)-\(n)"
        if let hit = Self.memo[key] {
            return hit
        }

        if n == 0 {
            return stone
        }

        var result: Int
        if n == 1 {
            result = transform(stone: stone).count
        } else {
            result = transform(stone: stone)
                .map { blink(stone: $0, n: n - 1) }
                .reduce(0, +)
        }

        Self.memo[key] = result
        return result
    }

    func part1() -> Any {
        let stones = Self.dataLines.first!.toInts(separator: " ")
        return
            stones
            .map { blink(stone: $0, n: 25) }
            .reduce(0, +)
    }

    func part2() -> Any {
        let stones = Self.dataLines.first!.toInts(separator: " ")
        return
            stones
            .map { blink(stone: $0, n: 75) }
            .reduce(0, +)
    }
}
