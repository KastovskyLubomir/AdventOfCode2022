//
//  main.swift
//  AOC2022_06
//
//  Created by Kaštovský Lubomír on 06.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

let input = readLinesRemoveEmpty(str: inputString)
let inputArray = getStringBytes(str: input[0])

func hasDuplicate(array: [UInt8]) -> Bool {
    let mySet = Set(array)
    return array.count != mySet.count
}

func findPacketStart(array: [UInt8], size: Int) -> Int {
    var fifo = [UInt8]()
    for i in 0..<array.count {
        if fifo.count < size {
            fifo.append(array[i])
        } else {
            if hasDuplicate(array: fifo) {
                fifo.removeFirst()
                fifo.append(array[i])
            } else {
                return i
            }
        }
    }
    return 0
}

print("Part 1: \(findPacketStart(array: inputArray, size: 4))")
print("Part 2: \(findPacketStart(array: inputArray, size: 14))")
