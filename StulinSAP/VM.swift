//
//  VM.swift
//  StulinSAP
//
//  Created by Misha Lvovsky on 4/7/19.
//  Copyright © 2019 Daniel Lacayo. All rights reserved.
//

import Foundation

class VM {
    var isRunning = false
    var programCounter = 0
    var registers:[Int] = Array(repeating: 0, count: 10)
    var memory:[Int] = []
    var reachDist = 0
    var compReg = 0//0: less than; 1: greater than; 2: equals
    var stack: [Int] = []
    var stackLimit: Int = 1024
    var instructions = ["halt": 0, "clrr": 1, "clrx": 2, "clrm": 3, "clrb": 4, "movir": 5, "movrr": 6, "movrm": 7, "movmr": 8, "movxr": 9, "movar": 10, "movb": 11, "addir": 12, "addrr": 13, "addmr": 13, "addxr": 15, "subir": 16, "subrr": 17, "submr": 18, "subxr": 19, "mulir": 20, "mulrr": 21, "mulmr": 22, "milxr": 23, "divir": 24, "divrr": 25, "divmr": 26, "divxr": 27, "jmp": 28, "sojz": 29, "sojnz": 30, "aojz": 31, "aojnz": 32, "cmpir": 33, "cmprr": 34, "cmpmr": 35, "jmpn": 36, "jmpz": 37, "jmpp": 38, "jsr": 39, "ret": 40, "push": 41, "pop": 42, "stackc": 43, "outci": 44, "outcr": 45, "outcx": 46, "outcb": 47, "readi": 48, "printi": 49, "readc": 50, "readln": 51, "brk": 52, "movrx": 53, "movxx": 54, "outs": 55, "nop": 56, "jmpne": 57]
    func runCommand(_ command:Int) {
        switch command {
        case instructions["halt"]: haltVM()
        case instructions["clrr"]: clrr()
        case instructions["clrx"]: clrx()
        case instructions["clrm"]: clrm()
        case instructions["clrb"]: clrb()
        case instructions["movir"]: movir()
        case instructions["movrr"]: movrr()
        case instructions["movrm"]: movrm()
        case instructions["movmr"]: movmr()
        case instructions["movxr"]: movxr()
        case instructions["movar"]: movar()
        case instructions["movb"]: movb()
        case instructions["addir"]: addir()
        case instructions["addrr"]: addrr()
        case instructions["addmr"]: addmr()
        case instructions["addxr"]: addxr()
        case instructions["subir"]: subir()
        case instructions["subrr"]: subrr()
        case instructions["submr"]: submr()
        case instructions["subxr"]: subxr()
        case instructions["mulir"]: mulir()
        case instructions["mulrr"]: mulrr()
        case instructions["mulmr"]: mulmr()
        case instructions["mulxr"]: mulxr()
        case instructions["divir"]: divir()
        case instructions["divrr"]: divrr()
        case instructions["divmr"]: divmr()
        case instructions["divxr"]: divxr()
        case instructions["jmp"]: jmp()
        case instructions["sojz"]: sojz()
        case instructions["sojnz"]: sojnz()
        case instructions["aojz"]: aojz()
        case instructions["cmpir"]: cmpir()
        case instructions["cmprr"]: cmprr()
        case instructions["cmpmr"]: cmpmr()
        case instructions["jmpn"]: jmpn()
        case instructions["jmpz"]: jmpz()
        case instructions["jmpp"]: jmpp()
        case instructions["jsr"]: jsr()
        case instructions["ret"]: ret()
        case instructions["push"]: push()
        case instructions["pop"]: pop()
        case instructions["stackc"]: stackc()
        case instructions["outci"]: outci()
        case instructions["outcr"]: outcr()
        case instructions["outcx"]: outcx()
        case instructions["outcb"]: outcb()
        case instructions["readi"]: readi()
        case instructions["printi"]: printi()
        case instructions["readc"]: readc()
        case instructions["readln"]: readln()
        case instructions["brk"]: brk()
        case instructions["movrx"]: movrx()
        case instructions["movxx"]: movxx()
        case instructions["outs"]: outs()
        case instructions["nop"]: nop()
        case instructions["jmpne"]: jmpne()
        default: break
        }
    }
    func doNext() {
            runCommand(memory[programCounter])
            incrementCounter()
    }
    func clrr() {
        registers[getPointAfterNum(1)] = 0
    }
    func clrx() {
        memory[registers[getPointAfterNum(1)]] = 0
    }
    func clrm() {
        memory[getPointAfterNum(1)] = 0
    }
    func clrb() {
        memory[registers[getPointAfterNum(1)]..<(registers[getPointAfterNum(1)] + registers[getPointAfterNum(2)])] = ArraySlice.init(repeating: 0, count: registers[getPointAfterNum(2)])
    }
    func movir() {
        registers[getPointAfterNum(2)] = getPointAfterNum(1)
    }
    func movrr() {
        registers[getPointAfterNum(2)] = registers[getPointAfterNum(1)]
    }
    func movrm() {
        memory[getPointAfterNum(2)] = registers[getPointAfterNum(1)]
    }
    func movmr() {
        registers[getPointAfterNum(2)] = memory[getPointAfterNum(1)]
    }
    func movxr() {
        registers[getPointAfterNum(2)] = memory[registers[getPointAfterNum(1)]]
    }
    func movar() {
        registers[getPointAfterNum(2)] = memory[getPointAfterNum(1)]
    }
    func movb() {
        memory[registers[getPointAfterNum(2)]..<(registers[getPointAfterNum(2)] + registers[getPointAfterNum(3)])] = memory[registers[getPointAfterNum(1)]..<(registers[getPointAfterNum(1)] + registers[getPointAfterNum(3)])]
    }
    func addir() {
        registers[getPointAfterNum(2)] += getPointAfterNum(1)
    }
    func addmr() {
        registers[getPointAfterNum(2)] += memory[getPointAfterNum(1)]
    }
    func addxr() {
        registers[getPointAfterNum(2)] += memory[registers[getPointAfterNum(1)]]
    }
    func subir() {
        registers[getPointAfterNum(2)] -=  getPointAfterNum(1)
    }
    func subrr() {
        registers[getPointAfterNum(2)] -= registers[getPointAfterNum(1)]
    }
    func submr() {
        registers[getPointAfterNum(2)] -= memory[getPointAfterNum(2)]
    }
    func subxr() {
        registers[getPointAfterNum(2)] -= memory[registers[getPointAfterNum(1)]]
    }
    func mulir() {
        registers[getPointAfterNum(2)] *= getPointAfterNum(1)
    }
    func mulrr() {
        registers[getPointAfterNum(2)] *= registers[getPointAfterNum(1)]
    }
    func mulmr() {
        registers[getPointAfterNum(2)] *= memory[getPointAfterNum(1)]
    }
    func mulxr() {
        registers[getPointAfterNum(2)] = memory[registers[getPointAfterNum(1)]]
    }
    func divir() {
        registers[getPointAfterNum(2)] /= getPointAfterNum(1)
    }
    func divrr() {
        registers[getPointAfterNum(2)] /= registers[getPointAfterNum(1)]
    }
    func divmr() {
        registers[getPointAfterNum(2)] /= memory[getPointAfterNum(1)]
    }
    func divxr() {
        registers[getPointAfterNum(2)] /= memory[registers[getPointAfterNum(1)]]
    }
    func jmp() {
        jump(getPointAfterNum(1))
    }
    func sojz() {
        registers[getPointAfterNum(1)] -= 1
        let dest = getPointAfterNum(2)
        if registers[getPointAfterNum(1)] == 0 {
            jump(dest)
        }
    }
    func sojnz() {
        registers[getPointAfterNum(1)] -= 1
        let dest = getPointAfterNum(2)
        if registers[getPointAfterNum(1)] != 0 {
            jump(dest)
        }
    }
    func aojz() {
        registers[getPointAfterNum(1)] += 1
        let dest = getPointAfterNum(2)
        if registers[getPointAfterNum(1)] == 0 {
            jump(dest)
        }
    }
    func aojnz() {
        registers[getPointAfterNum(1)] += 1
        let dest = getPointAfterNum(2)
        if registers[getPointAfterNum(1)] != 0 {
            jump(dest)
        }
    }
    func cmpir() {
        let num = getPointAfterNum(1)
        let reg = registers[getPointAfterNum(2)]
        if  num > reg {
            compReg = 1
        } else if num == reg {
            compReg = 2
        } else {
            compReg = 0
        }
    }
    func cmpmr() {
        let lab = memory[getPointAfterNum(1)]
        let reg = registers[getPointAfterNum(2)]
        if  lab > reg {
            compReg = 1
        } else if lab == reg {
            compReg = 2
        } else {
            compReg = 0
        }
    }
    func jmpn() {
        let dest = getPointAfterNum(1)
        if compReg == 0 {
            jump(dest)
        }
    }
    func jmpz() {
        let dest = getPointAfterNum(1)
        if compReg == 2 {
            jump(dest)
        }
    }
    func jmpp() {
        let dest = getPointAfterNum(1)
        if compReg == 1 {
            jump(dest)
        }
    }
    func jsr() {
        for r in [9, 8, 7, 6, 5] {
            stack.append(registers[r])
        }
        stack.append(programCounter + 2)
        jump(getPointAfterNum(1))
    }
    func ret() {
        jump(stack.popLast()!)
        for r in 5...9 {
            registers[r] = stack.popLast()!
        }
    }
    func push() {
        stack.append(registers[getPointAfterNum(1)])
    }
    func pop() {
        registers[getPointAfterNum(1)] = stack.popLast()!
    }
    func stackc() {
        if stackLimit == stack.count {
            registers[getPointAfterNum(1)] = 1
        } else if stack.count == 0  {
            registers[getPointAfterNum(1)] = 2
        } else {
            registers[getPointAfterNum(1)] = 0
        }
    }
    func outci() {
        print(UnicodeScalar(getPointAfterNum(1))!, terminator: "")
    }
    func outcx() {
        print(UnicodeScalar(memory[registers[getPointAfterNum(1)]])!, terminator: "")
    }
    func outcb() {
        for n in registers[getPointAfterNum(1)]..<(registers[getPointAfterNum(1)]+registers[getPointAfterNum(2)]) {
            print(UnicodeScalar(memory[n])!, terminator: "")
        }
    }
    func readi() {
        let errReg = getPointAfterNum(2)
        let targetReg = getPointAfterNum(1)
        guard let i = Int(readLine() ?? "") else {
            registers[errReg] = 1
            return
        }
        registers[targetReg] = i
        registers[errReg] = 0
    }
    func readc() {
        guard let c = readLine()?.first else {
            return
        }
        registers[getPointAfterNum(1)] = Int(UnicodeScalar(String(c))!.value)
    }
    func readln() {
        guard let line = readLine() else {
            return
        }
        let start = getPointAfterNum(1)
        registers[getPointAfterNum(2)] = line.count
        for n in 0..<line.count {
            memory[start + n] = Int(UnicodeScalar(String(line[line.index(line.startIndex, offsetBy: n)]))!.value)
        }
    }
    func brk() {
        
    }
    func movrx() {
        memory[registers[getPointAfterNum(2)]] = registers[getPointAfterNum(1)]
    }
    func movxx() {
        memory[registers[getPointAfterNum(2)]] = memory[registers[getPointAfterNum(1)]]
    }
    func nop() {
        return
    }
    func outs() {
        print(getString(getPointAfterNum(1)), terminator: "")
    }
    func printi() {
        print(registers[getPointAfterNum(1)], terminator: "")
    }
    func outcr() {
        print(Character(UnicodeScalar(getPointAfterNum(1))!), terminator: "")
    }
    func cmprr() {
        let reg0 = registers[getPointAfterNum(1)]
        let reg1 = registers[getPointAfterNum(2)]
        if  reg0 > reg1 {
            compReg = 1
        } else if reg0 == reg1 {
            compReg = 2
        } else {
            compReg = 0
        }
    }
    func jmpne() {
        let dest = getPointAfterNum(1)
        if compReg != 2 {
            jump(dest-1)
        }
    }
    func jump(_ destination: Int) {
        programCounter = destination - 1
        reachDist = 0
    }
    func addrr() {
        registers[getPointAfterNum(2)] += registers[getPointAfterNum(1)]
    }
    func getString(_ memLoc: Int) -> String {
        return memory[memLoc+1...memLoc+memory[memLoc]].reduce("", {$0 + String(UnicodeScalar($1)!)})
    }
    func incrementCounter() {
        incrementCounter(reachDist + 1)
    }
    func incrementCounter(_ num:Int) {
        programCounter += num
        reachDist = 0
    }
    func getPointAfterNum(_ num:Int) -> Int {
        if reachDist < num {reachDist = num}
        return memory[programCounter + num]
    }
    func haltVM() {
        setSleeping()
    }
    func runVM() {
        let iPC = memory[1]
        programCounter = iPC
        memory.remove(at: 1)
        let iL = memory[0]
        memory.remove(at: 0)
        while (isRunning) {
            if (programCounter < memory.count) {
                doNext()
            } else {
                isRunning = false
            }
        }
        memory.insert(iPC, at: 0)
        memory.insert(iL, at: 0)
    }
    func setRunning() {
        isRunning = true
    }
    func setSleeping() {
        isRunning = false
    }
}
