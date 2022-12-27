//
//  main.swift
//  AOC2022_25
//
//  Created by Lubomir Kastovsky on 25.12.2022.
//  Copyright © 2022 Lubomir Kastovsky. All rights reserved.
//

import Foundation

func powerOfFive(power: Int) -> Int {
    var result = 1
    for _ in 0..<power {
        result *= 5
    }
    return result
}

func decodeNumber(number: String) -> Int {
    let chars = Array(number)
    var value = 0
    for i in 0..<chars.count {
        let char = chars[i]
        var multiplier = 1
        if char.isNumber {
            multiplier = Int(String(char))!
        } else if char == "-" {
            multiplier = -1
        } else if char == "=" {
            multiplier = -2
        }
        value = value + (multiplier * powerOfFive(power: (chars.count-1) - i))
    }
    return value
}

func codeNumber(number: Int) -> String {
    var pow = 0
    while (powerOfFive(power: pow) * 2) <= number {
        pow += 1
    }
    
    let shifted = number + (powerOfFive(power: pow+1)/2)
    
    let radix5String = String(shifted, radix: 5)
    var result = ""
    Array(radix5String).forEach {
        switch $0 {
        case "4": result += "2"
        case "3": result += "1"
        case "2": result += "0"
        case "1": result += "-"
        case "0": result += "="
        default:break
        }
    }
    return result
}

func sumNumbers(input: [String]) -> Int {
    input.reduce(0, { result, number in
        result + decodeNumber(number: number)
    })
}

let input = readLinesRemoveEmpty(str: inputString)
let sum = sumNumbers(input: input)
let coded = codeNumber(number: sum)
print("Part 1: \(codeNumber(number: sum))")
