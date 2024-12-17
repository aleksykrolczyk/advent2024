import CoreFoundation

let day: AdventDay = Day17()

let start1 = CFAbsoluteTimeGetCurrent()
let res1 = day.part1()
let formatted1 = String(format: "%.10f", CFAbsoluteTimeGetCurrent() - start1)
print("=======  Part 1 solution (took \(formatted1) seconds =======")
print(res1)

print("\n")

let start2 = CFAbsoluteTimeGetCurrent()
let res2 = day.part2()
let formatted2 = String(format: "%.10f", CFAbsoluteTimeGetCurrent() - start2)
print("=======  Part 2 solution (took \(formatted2) seconds =======")
print(res2)
