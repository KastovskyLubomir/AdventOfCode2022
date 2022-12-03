//
//  main.swift
//  AOC2022_03
//
//  Created by Lubomir Kastovsky on 03.12.2022.
//  Copyright © 2022 Lubomir Kastovsky. All rights reserved.
//

import Foundation


func findCommonItem(input: String) -> Int {
    let items = getStringBytes(str: input)
    let part1 = items[0..<items.count/2]
    let part2 = items[items.count/2..<items.count]
    for i in 0..<part1.count {
        if part2.contains(part1[i]) {
            if part1[i] > 96 {
                return Int(part1[i]) - 96
            } else {
                return Int(part1[i]) - 38
            }
            
        }
    }
    return 0
}

func commonItemsSum(input: [String]) -> Int {
    return input.reduce(0, { a,b in
        a + findCommonItem(input: b)
    })
}

func groupBadges(input: [String]) -> Int {
    var i = 0
    var result = 0
    while i < input.count {
        let bag1 = getStringBytes(str: input[i])
        let bag2 = getStringBytes(str: input[i+1])
        let bag3 = getStringBytes(str: input[i+2])
        for j in 0..<bag1.count {
            if bag2.contains(bag1[j]) && bag3.contains(bag1[j]) {
                if bag1[j] > 96 {
                    result += Int(bag1[j]) - 96
                } else {
                    result += Int(bag1[j]) - 38
                }
                break
            }
        }
        i += 3
    }
    return result
}

let input = readLinesRemoveEmpty(str: inputString)
print("Part 1: \(commonItemsSum(input: input))")
print("Part 2: \(groupBadges(input: input))")
