//
//  main.swift
//  AOC2022_01
//
//  Created by Kaštovský Lubomír on 01.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

typealias ElfCalories = [Int]

var elves: [ElfCalories] = []

func getElves(inputString: String) -> [ElfCalories] {
    var result = [ElfCalories]()
    var x = inputString.components(separatedBy: ["\n"])
    var elf = ElfCalories()
    for i in x.indices {
        if x[i].isEmpty {
            result.append(elf)
            elf = ElfCalories()
        } else {
            elf.append(Int(x[i])!)
        }
    }
    return result
}

func mostCalories(elves: [ElfCalories]) -> Int {
    var caloriesSum = Int.min
    elves.forEach {
        let sum = $0.reduce(0, { a,b in a+b })
        if sum > caloriesSum {
            caloriesSum = sum
        }
    }
    return caloriesSum
}

func mostCaloriesIndex(elves: [ElfCalories]) -> Int {
    var caloriesSum = Int.min
    var index = 0
    var i = 0
    elves.forEach {
        let sum = $0.reduce(0, { a,b in a+b })
        if sum > caloriesSum {
            caloriesSum = sum
            index = i
        }
        i += 1
    }
    return index
}

func topThreeElves(elves: [ElfCalories]) -> Int {
    var result = 0
    var tmp = elves
    for _ in 0..<3 {
        result += mostCalories(elves: tmp)
        let index = mostCaloriesIndex(elves: tmp)
        tmp.remove(at: index)
    }
    return result
}

elves = getElves(inputString: inputString)

print("Part 1: \(mostCalories(elves: elves))")
print("Part 2: \(topThreeElves(elves: elves))")
