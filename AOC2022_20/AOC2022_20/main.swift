//
//  main.swift
//  AOC2022_20
//
//  Created by Kaštovský Lubomír on 20.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

func mixNumbers2(pattern: [(index: Int, value: Int)], numbers: [(Int, Int)]) -> [(Int, Int)] {
    var newNumbers = numbers
    pattern.forEach { patternNumber in
        if let position = newNumbers.firstIndex(where: { $0.0 == patternNumber.0 }) {
            let movingNumber = newNumbers[position]
            newNumbers.remove(at: position)
            let shift = abs(movingNumber.1) % newNumbers.count
            if movingNumber.1 < 0 {
                var pos = position - shift
                if pos <= 0 {
                    pos = newNumbers.count + pos
                }
                newNumbers.insert(movingNumber, at: pos)
                
            } else {
                var pos = position + shift
                if pos >= newNumbers.count {
                    pos = pos - newNumbers.count
                }
                newNumbers.insert(movingNumber, at: pos)
            }
        } else {
            print("error")
            return
        }
    }
    return newNumbers
}

func getNumberAfterZero(position: Int, numbers: [(Int, Int)]) -> Int {
    if let shift = numbers.firstIndex(where: { $0.1 == 0 }) {
        let number = numbers[(position+shift) % numbers.count]
        return number.1
    }
    return Int.max
}

func prepareNumbers(intArray: [Int]) -> [(index: Int, value: Int)] {
    var result = [(index: Int, value: Int)]()
    for i in 0..<intArray.count {
        result.append((i, intArray[i]))
    }
    return result
}

func prepareNumbers(intArray: [Int], with key: Int) -> [(index: Int, value: Int)] {
    var result = [(index: Int, value: Int)]()
    for i in 0..<intArray.count {
        result.append((i, intArray[i] * key))
    }
    return result
}

func coordnatesSum(numbers: [(index: Int, value: Int)]) -> Int {
    var result = 0
    [1000,2000,3000].forEach {
        let number = getNumberAfterZero(position: $0, numbers: mixed)
        result += number
    }
    return result
}

func repeatedMix(pattern: [(index: Int, value: Int)], numbers: [(index: Int, value: Int)], repeatCount: Int) -> Int {
    var mixed = numbers
    for _ in 0..<repeatCount {
        mixed = mixNumbers2(pattern: pattern, numbers: mixed)
    }
    var result = 0
    [1000,2000,3000].forEach {
        let number = getNumberAfterZero(position: $0, numbers: mixed)
        result += number
    }
    return result
}

let input = readLinesRemoveEmpty(str: inputString)
let intArray = input.map { Int($0)! }
var numbers = prepareNumbers(intArray: intArray)
let mixed = mixNumbers2(pattern: numbers, numbers: numbers)
print("Part 1: \(coordnatesSum(numbers: mixed))")
let key = 811589153
var bigNumbers = prepareNumbers(intArray: intArray, with: key)
print("Part 2: \(repeatedMix(pattern: bigNumbers, numbers: bigNumbers, repeatCount: 10))")
