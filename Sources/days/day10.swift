private let DELTAS = [
  Point(x: 1, y: 0),
  Point(x: -1, y: 0),
  Point(x: 0, y: 1),
  Point(x: 0, y: -1),
]

class Day10: AdventDay {

  func getMap() -> ([[Int]], [Point]) {
    var startingPoints: [Point] = []
    let map = Self.dataLines.map {
      $0.toInts(separator: "")
    }

    for (row, line) in map.enumerated() {
      for (col, element) in line.enumerated() {
        if element == 0 {
          startingPoints.append(Point(x: col, y: row))
        }
      }
    }
    return (map, startingPoints)
  }

  func findTrails(map: [[Int]], currentTrail: [Point]) -> [[Point]] {
    let currentPosition = currentTrail.last!

    if map[currentPosition] == 9 {
      return [currentTrail]
    }

    let nextSteps = DELTAS.map { currentPosition + $0 }
      .filter { !$0.outOfBounds(width: map[0].count, height: map.count) }
      .filter { map[$0] - map[currentPosition] == 1 }

    var trails: [[Point]] = []
    for step in nextSteps {
      trails.append(contentsOf: findTrails(map: map, currentTrail: currentTrail + [step]))
    }

    return trails
  }

  func part1() -> Any {
    let (map, startingPoints) = getMap()

    var trailheads = 0
    for startingPoint in startingPoints {
      let trails = findTrails(map: map, currentTrail: [startingPoint])
      let peaks = trails.map { $0.last! }
      trailheads += Set(peaks).count
    }

    return trailheads
  }

  func part2() -> Any {
    let (map, startingPoints) = getMap()

    var rating = 0
    for startingPoint in startingPoints {
      let trails = findTrails(map: map, currentTrail: [startingPoint])
      rating += trails.count
    }

    return rating
  }
}
