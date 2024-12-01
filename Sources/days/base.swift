import Foundation

protocol AdventDay {

  static var day: String { get }

  static var data: String { get }
  static var dataLines: [String] { get }

  func part1() -> Any
  func part2() -> Any
}

extension AdventDay {

  static var data: String {
    return try! String(contentsOfFile: "./Sources/Data/day\(Self.day).txt")
  }

  static var dataLines: [String] {
    var lines = Self.data.components(separatedBy: "\n")
    if lines.last!.isEmpty {
      lines = lines.dropLast()
    }
    return lines
  }

  static var day: String {
    let name = String(describing: type(of: self))
    return name.filter { $0.isWholeNumber }
  }

}

extension String {

  subscript(_ i: Int) -> Character {
    self[index(startIndex, offsetBy: i)]
  }
}
