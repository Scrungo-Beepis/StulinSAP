//
//  Assembler.swift
//  StulinSAP
//
//  Created by Misha Lvovsky on 4/7/19.
//  Copyright © 2019 Daniel Lacayo. All rights reserved.
//

import Foundation

class Assembler {
    var symbolTable : [String:Int] = [:]
    let commands : [String:(bin: Int, argType: argType)] = [
        "halt":(0, argType.none),
        "clrr":(1, argType.r),
        "clrx":(2, argType.r),
        "clrm":(3, argType.l),
        "clrb":(4, argType.rr),
        "movir":(5, argType.rr),
        "movrr":(6, argType.rr),
        "movrm":(7, argType.rl),
        "movmr":(8, argType.lr),
        "movxr":(9, argType.rr),
        "movar":(10, argType.lr),
        "movb":(11, argType.rrr),
        "addir":(12, argType.rr),
        "addrr":(13, argType.rr),
        "addmr":(14, argType.lr),
        "addxr":(15, argType.rr),
        "subir":(16, argType.rr),
        "subrr":(17, argType.rr),
        "submr":(18, argType.lr),
        "subxr":(19, argType.rr),
        "mulir":(20, argType.rr),
        "mulrr":(21, argType.rr),
        "mulmr":(22, argType.lr),
        "mulxr":(23, argType.rr),
        "divir":(24, argType.rr),
        "divrr":(25, argType.rr),
        "divmr":(26, argType.lr),
        "divxr":(27, argType.rr),
        "jmp":(28, argType.l),
        "sojz":(29, argType.rl),
        "sojnz":(30, argType.rl),
        "aojz":(31, argType.rl),
        "aojnz":(32, argType.rl),
        "cmpir":(33, argType.rr),
        "cmprr":(34, argType.rr),
        "cmpmr":(35, argType.lr),
        "jmpn":(36, argType.l),
        "jmpz":(37, argType.l),
        "jmpp":(38, argType.l),
        "jsr":(39, argType.l),
        "ret":(40, argType.none),
        "push":(41, argType.r),
        "pop":(42, argType.r),
        "stackc":(43, argType.r),
        "outci":(44, argType.r),
        "outcr":(45, argType.r),
        "outcx":(46, argType.r),
        "outcb":(47, argType.rr),
        "readi":(48, argType.rr),
        "printi":(49, argType.r),
        "readc":(50, argType.r),
        "readln":(51, argType.lr),
        "brk":(52, argType.none),
        "movrx":(53, argType.rr),
        "movxx":(54, argType.rr),
        "outs":(55, argType.l),
        "nop":(56, argType.none),
        "jmpne":(57, argType.l)]
    /*let directives = [
        ".Integer",
        ".String",
        ".Tuple"]*/
    func assemble(_ assembly:String) throws -> (bin:[Int], lst:String, sym:String) {
        var start:Int? = nil
        var lst:[(lst:String, isLabel:Bool)] = []
        var result : [Int] = []
        let lines = assembly.components(separatedBy: "\n")
        for n in 0..<lines.count {
            if lines[n].contains(".Start") {
                start = n
                break
            }
        }
        symbolTable = [:]
        for lineNum in 0..<lines.count {
            lst.append(("\(result.count): ", false))
            var thisLine = lines[lineNum].components(separatedBy: ";").first!.components(separatedBy: " ").filter({$0 != ""})
            if thisLine.count > 0 {
                if !commands.keys.contains(thisLine[0]) && (directives(rawValue: thisLine[0]) == nil) {
                    let symbol = String(thisLine[0].dropLast())
                    guard !symbolTable.keys.contains(symbol) else {
                        throw CompilerError("Symbol \(symbol) already exists.", lineNum)
                    }
                    lst[lineNum].isLabel = true
                    addSymbol(symbol, result.count)
                    thisLine.remove(at: 0)
                }
                if !(thisLine.count > 0) {break}
                if let command = commands[thisLine[0]] {
                    if start == nil {start = result.count}
                    result.append(command.bin)
                    lst[lineNum].lst += "\(command.bin) "
                    do {
                        switch command.argType {
                        case .lr:
                            let l0 = try checkLineForL(thisLine, 1, lineNum)
                            result.append(l0)
                            lst[lineNum].lst += "\(l0) "
                            let r1 = try checkLineForR(thisLine, 2, lineNum)
                            result.append(r1)
                            lst[lineNum].lst += "\(r1) "
                            break
                        case .l:
                            let l0 = try checkLineForL(thisLine, 1, lineNum)
                            result.append(l0)
                            lst[lineNum].lst += "\(l0) "
                            break
                        case .r:
                            let r0 = try checkLineForR(thisLine, 1, lineNum)
                            result.append(r0)
                            lst[lineNum].lst += "\(r0) "
                            break
                        case .rr:
                            let r0 = try checkLineForR(thisLine, 1, lineNum)
                            result.append(r0)
                            lst[lineNum].lst += "\(r0) "
                            let r1 = try checkLineForR(thisLine, 2, lineNum)
                            result.append(r1)
                            lst[lineNum].lst += "\(r1) "
                            break
                        case .none: break
                        case .rrr:
                            let r0 = try checkLineForR(thisLine, 1, lineNum)
                            result.append(r0)
                            lst[lineNum].lst += "\(r0)"
                            let r1 = try checkLineForR(thisLine, 2, lineNum)
                            result.append(r1)
                            lst[lineNum].lst += "\(r1)"
                            let r2 = try checkLineForR(thisLine, 3, lineNum)
                            result.append(r2)
                            lst[lineNum].lst += "\(r2)"
                            break
                        case .rl:
                            let r0 = try checkLineForR(thisLine, 1, lineNum)
                            result.append(r0)
                            lst[lineNum].lst += "\(r0)"
                            let l1 = try checkLineForL(thisLine, 2, lineNum)
                            result.append(l1)
                            lst[lineNum].lst += "\(l1)"
                            break
                        }
                    } catch {
                        throw error
                    }
                } else {
                    switch directives(rawValue: thisLine[0]) {
                    case .Integer?:
                        if let lInt = Int(thisLine[1].dropFirst()) {
                            lst[lineNum].lst += "\(lInt) "
                            result.append(lInt)
                        } else {
                            throw CompilerError("\(lines[lineNum]) cannot define an Integer.", lineNum)
                        }
                        break
                    case .String?:
                        var string = assembly.components(separatedBy: "\n")[lineNum].components(separatedBy: "\"")[1]
                        result.append(string.count)
                        for char in string.unicodeScalars {
                            lst[lineNum].lst += "\(char.value) "
                            result.append(Int(char.value))
                        }
                        break
                    case .Start?:
                        break
                    case .Tuple?:
                        let valsString = lines[lineNum].components(separatedBy: "/")
                        guard valsString.count > 2 else {
                            throw CompilerError("\(lines[lineNum]) does not contain the right number of args and / to define a Tuple.", lineNum)
                        }
                        let vals = valsString[1].components(separatedBy: " ")
                        guard vals.count == 5 else {
                            throw CompilerError("\(lines[lineNum]) does not contain the right number of args between / to define a Tuple.", lineNum)
                        }
                        if vals[0] == "l" {
                            lst[lineNum].lst += "\(-1) "
                            result.append(-1)
                        } else if vals[0] == "r" {
                            lst[lineNum].lst += "\(1)"
                            result.append(1)
                        } else {
                            throw CompilerError("First value of Tuple must be l or r, not \(vals[0])", lineNum)
                        }
                        guard let cState = Int(vals[1]) else {
                            throw CompilerError("Second value of Tuple must be an Int, not \(vals[1])", lineNum)
                        }
                        lst[lineNum].lst += "\(cState) "
                        result.append(cState)
                        guard let nState = Int(vals[2]) else {
                            throw CompilerError("Third value of Tuple must be an Int, not \(vals[2])", lineNum)
                        }
                        lst[lineNum].lst += "\(nState) "
                        result.append(nState)
                        guard let cChar = vals[3].first else {
                            throw CompilerError("Fourth value of Tuple must be a char, not \(vals[3])", lineNum)
                        }
                        lst[lineNum].lst += "\(cChar) "
                        result.append(Int(cChar.unicodeScalars.first!.value))
                        guard let nChar = vals[4].first else {
                            throw CompilerError("Fifth value of Tuple must be a char, not \(vals[4])", lineNum)
                        }
                        lst[lineNum].lst += "\(nChar) "
                        result.append(Int(nChar.unicodeScalars.first!.value))
                        break
                        
                    default: break
                    }
                }
            }
            lst[lineNum].lst = fitToLeft(15, lst[lineNum].lst) + "     "
            lst[lineNum].lst += !lst[lineNum].isLabel ? "    " : ""
            lst[lineNum].lst += lines[lineNum].components(separatedBy: " ").filter({$0 != ""}).reduce("", {$0 + "\($1) "})
        }
        result.insert(result.count, at: 0)
        result.insert(start ?? 0, at: 1)
        return (result, lst.reduce("", {$0 + "\($1.lst)\n"}), symbolTable.reduce("", {"\($0) \($1.key): \($1.value)\n"}))
    }
    func checkLineForR(_ line:[String],_ argNum: Int, _ lineNum: Int) throws -> Int {
        guard line.indices.contains(argNum) else {
            throw CompilerError("Command \(line[0]) requires an arg which needs to be of Integer type.", lineNum)
        }
        guard let intArg = Int(String(line[argNum].last!)) else {
            throw CompilerError("Arg \(line[argNum]) is not a register index.", lineNum)
        }
        return intArg
    }
    func checkLineForL(_ line:[String],_ argNum: Int, _ lineNum: Int) throws -> Int {
        guard line.indices.contains(1) else {
            throw CompilerError("Command \(line[0]) requires an arg which needs to be a label.", lineNum)
        }
        guard let symLoc = symbolTable[line[1]] else {
            throw CompilerError("Symbol arg \(line[1]) isn't recognized in symbol table.", lineNum)
        }
        return symLoc
    }
    func addError(_ error: String, _ lineLocation: Int) {
        
    }
    func addSymbol(_ symbol: String, _ symLoc: Int) {
        symbolTable[symbol] = symLoc
    }
    enum argType {
        case lr
        case l
        case r
        case rr
        case rrr
        case rl
        case none
    }
    enum directives: String {
        case String = ".String"
        case Integer = ".Integer"
        case Tuple = ".Tuple"
        case Start = ".Start"
    }
    func fitToLeft(_ length: Int, _ str: String) -> String{
        if str.count > length {
            return String(str.dropLast(str.count-length))
        } else if (str.count < length) {
            var result = str
            for _ in str.count..<length {
                result += " "
            }
            return result
        } else {
            return str
        }
    }
}

class CompilerError: Error {
    var line:Int
    var message:String
    init(_ message: String, _ line: Int) {
        self.line = line
        self.message = message
    }
    
}
