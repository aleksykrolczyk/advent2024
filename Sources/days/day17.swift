// 40028141000
// 281470828800000
import Foundation

class Day17: AdventDay {

    fileprivate func getData() -> (Computer, [Int]) {
        let opcodes = Self.dataLines[4].trimmingPrefix("Program: ").toInts()
        var instructions: [Instruction] = []
        for i in stride(from: 0, through: opcodes.count - 1, by: 2) {
            instructions.append(Instruction(opcode: opcodes[i], operand: opcodes[i + 1]))
        }
        let comp = Computer(
            regA: Int(Self.dataLines[0].trimmingPrefix("Register A: "))!,
            regB: Int(Self.dataLines[1].trimmingPrefix("Register B: "))!,
            regC: Int(Self.dataLines[2].trimmingPrefix("Register C: "))!,
            instructions: instructions
        )

        return (comp, opcodes)
    }

    func part1() -> Any {
        let (comp, _) = getData()
        print("brrr")

        var output: [Int] = []
        while !comp.isDone {
            if let ret = comp.step() {
                output.append(ret)
            }
        }
        return output.map { String($0) }.joined(separator: ",")
    }

    func recreate(_ out: [Int]) -> Int {
        var recreated = 0
        var pow = 1
        for a in out {
            recreated += (8 ** pow) * a
            pow += 1
        }
        return recreated
    }

    func part2() -> Any {
        let (comp, opcodes) = getData()
        let (origB, origC) = (comp.regB, comp.regC)
        let out = [2, 4, 1, 1, 7, 5, 0, 3, 4, 3, 1, 6, 5, 5, 3, 0]
        var regA = 8 ** (out.count)
        while true {
            if regA % 100000 == 0 {
                print(regA)
            }
            var opcodeIndex = 0
            var tempOut: [Int] = []

            comp.reset(regA: regA, regB: origB, regC: origC)

            while !comp.isDone {
                if opcodeIndex > opcodes.count - 1 {
                    return regA
                }
                if let ret = comp.step() {
                    tempOut.append(ret)
                    if ret != opcodes[opcodeIndex] {
                        break
                    }
                    opcodeIndex += 1
                }
            }
            regA -= 1
        }
        return -1
    }
}

private class Computer: CustomStringConvertible {
    var regA, regB, regC: Int
    var instructions: [Instruction]
    var pointer: Int = 0

    init(regA: Int, regB: Int, regC: Int, instructions: [Instruction]) {
        self.regA = regA
        self.regB = regB
        self.regC = regC
        self.instructions = instructions
    }

    var isDone: Bool {
        pointer > instructions.count - 1
    }

    var description: String {
        "A=\(regA), B=\(regB), C=\(regC)"
    }

    func getComboValue(_ operand: Int) -> Int {
        switch operand {
        case let x where x <= 3:
            return x
        case 4:
            return regA
        case 5:
            return regB
        case 6:
            return regC
        default:
            fatalError("its bad")
        }
    }

    func step() -> Int? {
        if isDone {
            print("already done")
            return nil
        }
        var retVal: Int? = nil
        switch instructions[pointer] {
        case .adv(let combo):
            regA = regA / (2 << (getComboValue(combo) - 1))
        case .blx(let lit):
            regB = regB ^ lit
        case .bst(let combo):
            regB = getComboValue(combo) % 8
        case .jnz(let lit):
            if regA != 0 {
                pointer = lit / 2
                return nil
            }
        case .bxc(_):
            regB = regB ^ regC
        case .out(let combo):
            retVal = getComboValue(combo) % 8
        case .bdv(let combo):
            regB = regA / (2 << (getComboValue(combo) - 1))
        case .cdv(let combo):
            regC = regA / (2 << (getComboValue(combo) - 1))
        }
        pointer += 1
        return retVal
    }

    func reset(regA: Int, regB: Int, regC: Int) {
        self.regA = regA
        self.regB = regB
        self.regC = regC
        self.pointer = 0
    }
}

private enum Instruction {
    case adv(Int)
    case blx(Int)
    case bst(Int)
    case jnz(Int)
    case bxc(Int)
    case out(Int)
    case bdv(Int)
    case cdv(Int)

    init(opcode: Int, operand: Int) {
        switch opcode {
        case 0: self = .adv(operand)
        case 1: self = .blx(operand)
        case 2: self = .bst(operand)
        case 3: self = .jnz(operand)
        case 4: self = .bxc(operand)
        case 5: self = .out(operand)
        case 6: self = .bdv(operand)
        case 7: self = .cdv(operand)
        default: fatalError("its bad")
        }
    }
}
