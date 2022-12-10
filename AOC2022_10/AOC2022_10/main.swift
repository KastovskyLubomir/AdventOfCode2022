//
//  main.swift
//  AOC2022_10
//
//  Created by Kaštovský Lubomír on 10.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

func prepareInput(input: String) -> [String] {
    input.components(separatedBy: [" ", "\n"]).filter {!$0.isEmpty}
}

func sumSignals(input: [String]) -> Int {
    var regX = 1
    var result = 0
    var counter = 1
    input.forEach { step in
        if (counter-20) % 40 == 0 {
            result += counter * regX
        }
        if let x = Int(step) {
            regX += x
        }
        counter += 1
    }
    return result
}

func drawing(input: [String]) -> [String] {
    var result = [String].init(repeating: " ", count: 240)
    var regX = 1
    var counter = 0
    input.forEach { step in
        if (counter % 40) == regX-1 || (counter % 40) == regX || (counter % 40) == regX+1  {
            result[counter] = "@"
        }
        if let x = Int(step) {
            regX += x
        }
        counter += 1
    }
    return result
}

func printDisplay(input: [String]) {
    for i in [40, 80, 120, 160, 200, 240] {
        let line = input[i-40..<i].joined()
        print(line)
    }
}

let string = "Jack,John,Frank"
print(stringWordArrayToArrayOfWords(input: string, separators: [","]))

let program = prepareInput(input: inputString)
print("Part 1: \(sumSignals(input: program))")
let display = drawing(input: program)
print("Part 2:")
printDisplay(input: display)
