//
//  main.swift
//  AOC2022_05
//
//  Created by Kaštovský Lubomír on 06.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

/*
 [T]     [Q]             [S]
 [R]     [M]             [L] [V] [G]
 [D] [V] [V]             [Q] [N] [C]
 [H] [T] [S] [C]         [V] [D] [Z]
 [Q] [J] [D] [M]     [Z] [C] [M] [F]
 [N] [B] [H] [N] [B] [W] [N] [J] [M]
 [P] [G] [R] [Z] [Z] [C] [Z] [G] [P]
 [B] [W] [N] [P] [D] [V] [G] [L] [T]
  1   2   3   4   5   6   7   8   9
 
 */

import Foundation

typealias SuplyStackType = [Int: String]

var suplyStack: SuplyStackType = [
    1: "BPNQHDRT",
    2: "WGBJTV",
    3: "NRHDSVMQ",
    4: "PZNMC",
    5: "DZB",
    6: "VCWZ",
    7: "GZNCVQLS",
    8: "LGJMDNV",
    9: "TPMFZCG"
]

func stripInput(input: [String]) -> [String] {
    return input.filter { $0.contains("move") }
}

func moveCrates(stack: inout SuplyStackType, amount: Int, from: Int, to: Int, crane: Int) {
    let crates = stack[from]!
    let remains = crates.prefix(crates.count-amount)
    let moves = crane == 0 ? crates.suffix(amount).reversed() : crates.suffix(amount)
    stack[from] = String(remains)
    stack[to] = stack[to]! + String(moves)
}

func simulateMoving(directions: [String], stack: inout SuplyStackType, crane: Int) {
    directions.forEach { dir in
        let parts = dir.components(separatedBy: " ")
        let amount = Int(parts[1])!
        let from = Int(parts[3])!
        let to = Int(parts[5])!
        moveCrates(stack: &stack, amount: amount, from: from, to: to, crane: crane)
    }
}

func collectTopCrates(stack: SuplyStackType) -> String {
    var result = ""
    for i in 1...stack.count {
         result = result + String(stack[i]!.last!)
    }
    return result
}

let inputDirections = stripInput(input: readLinesRemoveEmpty(str: inputString))
var suplyStack_2 = suplyStack

simulateMoving(directions: inputDirections, stack: &suplyStack, crane: 0)
simulateMoving(directions: inputDirections, stack: &suplyStack_2, crane: 1)

print("Part 1: \(collectTopCrates(stack: suplyStack))")
print("Part 2: \(collectTopCrates(stack: suplyStack_2))")
