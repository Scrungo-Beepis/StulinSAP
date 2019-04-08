//
//  main.swift
//  StulinSAP
//
//  Created by Daniel Lacayo on 4/3/19.
//  Copyright © 2019 Daniel Lacayo. All rights reserved.
//

import Foundation
/*let ass = Assembler()
let assembly = """
Begin: .Integer #0
End: .Integer #20
NewLine: .Integer #10
IntroMess: .String "A Program To Print Doubles"
DoubleMess: .String " Doubled is "
Test: movmr Begin r8
movmr End r9
movmr NewLine r0
outs IntroMess
outcr r0
Do01: movrr r8 r1
addrr r8 r1
printi r8
outs DoubleMess
printi r1
outcr r0
cmprr r8 r9
addir #1 r8
jmpne Do01
wh01: halt
"""
var binbutt = [Int]()
do {
    try binbutt = ass.assemble(assembly)
} catch {
    print ((error as! CompilerError).message)
}
print(binbutt)
print("\n\(ass.symbolTable)")
var vm = VM()
vm.memory = binbutt
vm.setRunning()
vm.runVM()
*/
let sap = SAP()
sap.runUI()
