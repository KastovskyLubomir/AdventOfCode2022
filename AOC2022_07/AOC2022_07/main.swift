//
//  main.swift
//  AOC2022_07
//
//  Created by Kaštovský Lubomír on 07.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

let smallDirLimit = 100000
let diskSize = 70000000
let upgradeImageSize = 30000000

func directorySizesSum(input: [String]) -> (Int, Int) {
    var smallDirSizeSum = 0
    var stack = [Int]()
    var dirSizes = [Int]() // store sizes for part 2
    
    for line in input {
        let parts = line.components(separatedBy: " ")
        if parts[0] == "$" {
            if parts[1] == "cd" {
                if parts[2] == ".." {
                    if stack.last! < smallDirLimit {
                        smallDirSizeSum += stack.last!
                    }
                    dirSizes.append(stack.last!) // for part 2
                    stack.append(stack.removeLast() + stack.removeLast())
                } else {
                    stack.append(0)
                }
            }
        } else if parts[0] != "dir" {
            stack.append(stack.removeLast() + Int(parts[0])!)
        }
    }
    
    // go back to top level directory
    while !stack.isEmpty {
        if stack.last! < smallDirLimit {
            smallDirSizeSum += stack.last!
        }
        dirSizes.append(stack.last!) // for part 2
        if stack.count == 1 {
            print("Space occupied: \(stack.last!)")
            break
        }
        stack.append(stack.removeLast() + stack.removeLast())
    }
    
    // part 2 - find best dir size to delete
    let freeSpace = diskSize - stack.last!
    print("Free space: \(freeSpace)")
    let mustFree = upgradeImageSize - freeSpace
    print("Space needed to free: \(mustFree)")
    
    var bestSizeToDelete = Int.max
    var bestDiff = Int.max
    dirSizes.forEach {
        if $0 > mustFree && ($0 - mustFree) < bestDiff {
            bestDiff = $0 - mustFree
            bestSizeToDelete = $0
        }
    }
    
    print("----")
    return (smallDirSizeSum, bestSizeToDelete)
}

let input = readLinesRemoveEmpty(str: inputString)
let result = directorySizesSum(input: input)

print("Part 1: \(result.0)")
print("Part 2: \(result.1)")
