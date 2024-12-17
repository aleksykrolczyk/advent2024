class Day17: AdventDay {

    fileprivate func getData() -> (Computer, [Instruction]) {
        let comp = Computer(
            regA: Int(Self.dataLines[0].trimmingPrefix("Register A: "))!,
            regB: Int(Self.dataLines[1].trimmingPrefix("Register B: "))!,
            regC: Int(Self.dataLines[2].trimmingPrefix("Register C: "))!
        )

        let opcodes = Self.dataLines[4].trimmingPrefix("Program: ").toInts()
        var instructions: [Instruction] = []
        for i in stride(from: 0, through: opcodes.count - 1, by: 2) {
            instructions.append(Instruction(opcode: opcodes[i], operand: opcodes[i + 1]))
        }

        return (comp, instructions)
    }

    func part1() -> Any {
        let (comp, instructions) = getData()
        print("brrr")
        comp.process(instructions: instructions)
        return comp.output.map { String($0) }.joined(separator: ",")
    }

    func part2() -> Any {
        return ""
    }
}

private class Computer: CustomStringConvertible {
    var regA, regB, regC: Int
    var instructions: [Instruction]
    var pointer: Int = 0
    var output: [Int] = []



    init(regA: Int, regB: Int, regC: Int) {
        self.regA = regA
        self.regB = regB
        self.regC = regC
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

    func process(instructions: [Instruction]) {
        var pointer = 0
        while pointer < instructions.count {
            print(pointer)
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
                    continue
                }
            case .bxc(_):
                regB = regB ^ regC
            case .out(let combo):
                output.append(getComboValue(combo) % 8)
            case .bdv(let combo):
                regB = regA / (2 << (getComboValue(combo) - 1))
            case .cdv(let combo):
                regC = regA / (2 << (getComboValue(combo) - 1))
            }
            pointer += 1
        }
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
