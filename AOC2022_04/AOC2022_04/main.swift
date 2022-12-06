//
//  main.swift
//  AOC2022_04
//
//  Created by Lubomir Kastovsky on 04.12.2022.
//  Copyright © 2022 Lubomir Kastovsky. All rights reserved.
//

import Foundation

func isFullyContained(a1: Int, b1: Int, a2: Int, b2: Int) -> Bool {
    return (a1 <= a2 && b2 <= b1) || (a2 <= a1 && b1 <= b2)
}

func isSomehowOverlaping(a1: Int, b1: Int, a2: Int, b2: Int) -> Bool {
    guard !isFullyContained(a1: a1, b1: b1, a2: a2, b2: b2) else {
        return true
    }
    return (a1 <= a2 && a2 <= b1) || (a1 <= b2 && b2 <= b1)
}

func elvenPair(input: String) -> (a1: Int, b1: Int, a2: Int, b2: Int) {
    let parts = input.components(separatedBy: ",")
    let first = parts[0].components(separatedBy: "-")
    let second = parts[1].components(separatedBy: "-")
    return (Int(first[0])!, Int(first[1])!, Int(second[0])!, Int(second[1])!)
}

func fullyOverlapingPairs(input: [String]) -> Int {
    var result = 0
    input.forEach { pair in
        let intervals = elvenPair(input: pair)
        if isFullyContained(a1: intervals.a1, b1: intervals.b1, a2: intervals.a2, b2: intervals.b2) {
            result += 1
        }
    }
    return result
}

func somehowOverlaping(input: [String]) -> Int {
    var result = 0
    input.forEach { pair in
        let intervals = elvenPair(input: pair)
        if isSomehowOverlaping(a1: intervals.a1, b1: intervals.b1, a2: intervals.a2, b2: intervals.b2) {
            result += 1
        }
    }
    return result
}

let input = readLinesRemoveEmpty(str: inputString)

print("Part 1: \(fullyOverlapingPairs(input: input))")
print("Part 2: \(somehowOverlaping(input: input))")
