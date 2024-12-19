class Day19: AdventDay {

    func getData() -> ([String], [String]) {
        let t = Self.dataLines.split { $0.isEmpty }
        var patterns: [String] = []
        t[0].forEach { line in
            let ps = line.split(separator: ", ").map { String($0) }
            patterns.insert(contentsOf: ps, at: 0)
        }

        let designs = t[1].map { String($0) }

        patterns = patterns.sorted { $0.count > $1.count }
        return (patterns, designs)
    }

    func checkDesign(design: any StringProtocol, patterns: [String], memo: inout [String: Int])
        -> Int
    {
        if design.count == 0 {
            return 1
        }
        if let r = memo[String(design)] {
            return r
        }

        var total = 0
        for pattern in patterns {
            if design.hasPrefix(pattern) {
                total += checkDesign(
                    design: design.trimmingPrefix(pattern), patterns: patterns, memo: &memo
                )
            }
        }

        memo[String(design)] = total
        return total

    }

    func part1() -> Any {
        let (patterns, designs) = getData()
        var memo: [String: Int] = [:]
        return
            designs
            .map { checkDesign(design: $0, patterns: patterns, memo: &memo) > 0 ? 1 : 0 }
            .reduce(0, +)

    }

    func part2() -> Any {
        let (patterns, designs) = getData()
        var memo: [String: Int] = [:]
        return
            designs
            .map { checkDesign(design: $0, patterns: patterns, memo: &memo) }
            .reduce(0, +)
    }
}
