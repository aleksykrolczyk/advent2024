private let aButtonRegex = #/A: X\+(\d+), Y\+(\d+)/#
private let bButtonRegex = #/B: X\+(\d+), Y\+(\d+)/#
private let prizeRegex = #/X\=(\d+), Y\=(\d+)/#

class Day13: AdventDay {

   private func getClawMachines() -> [ClawMachine] {
      let aButtons = Self.data.matches(of: aButtonRegex)
      let bButtons = Self.data.matches(of: bButtonRegex)
      let prizes = Self.data.matches(of: prizeRegex)

      var machines: [ClawMachine] = []
      for i in 0..<aButtons.count {
         let (aX, aY) = (Int(aButtons[i].output.1)!, Int(aButtons[i].output.2)!)
         let (bX, bY) = (Int(bButtons[i].output.1)!, Int(bButtons[i].output.2)!)
         let (prizeX, prizeY) = (Int(prizes[i].output.1)!, Int(prizes[i].output.2)!)
         machines.append(
            ClawMachine(aX: aX, aY: aY, bX: bX, bY: bY, prizeX: prizeX, prizeY: prizeY))
      }
      return machines
   }

   private func getGigaClawMachines() -> [ClawMachine] {
      let offset = 10_000_000_000_000
      let aButtons = Self.data.matches(of: aButtonRegex)
      let bButtons = Self.data.matches(of: bButtonRegex)
      let prizes = Self.data.matches(of: prizeRegex)

      var machines: [ClawMachine] = []
      for i in 0..<aButtons.count {
         let (aX, aY) = (Int(aButtons[i].output.1)!, Int(aButtons[i].output.2)!)
         let (bX, bY) = (Int(bButtons[i].output.1)!, Int(bButtons[i].output.2)!)
         let (prizeX, prizeY) = (
            Int(prizes[i].output.1)! + offset, Int(prizes[i].output.2)! + offset
         )
         machines.append(
            ClawMachine(aX: aX, aY: aY, bX: bX, bY: bY, prizeX: prizeX, prizeY: prizeY))
      }
      return machines
   }

   func part1() -> Any {
      let machines = getClawMachines()
      var total = 0
      for m in machines {
         if let (tokensA, tokensB) = m.play() {
            total += 3 * tokensA + tokensB
         }
      }
      return total
   }

   func part2() -> Any {
      let machines = getGigaClawMachines()
      var total = 0
      for m in machines {
         if let (tokensA, tokensB) = m.play() {
            total += 3 * tokensA + tokensB
         }
      }
      return total
   }
}

private struct ClawMachine: CustomStringConvertible {
   let aX, aY, bX, bY: Int
   let prizeX, prizeY: Int

   var description: String {
      return "<A(\(aX),\(aY)), B(\(bX),\(bY)), P(\(prizeX),\(prizeY))>"
   }

   func play() -> (Int, Int)? {
      let j = (prizeX * aY - prizeY * aX) / (bX * aY - bY * aX)
      let i = (prizeY - j * bY) / aY

      let recreatedX = i * aX + j * bX
      let recreatedY = i * aY + j * bY

      if recreatedX != prizeX || recreatedY != prizeY {
         return nil
      }

      return (i, j)
   }
}
