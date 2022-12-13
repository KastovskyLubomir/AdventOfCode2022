//
//  main.swift
//  AOC2022_13
//
//  Created by Kaštovský Lubomír on 13.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

func comparePackets(first: [Character], second: [Character]) -> Bool {
    var left = first
    var right = second
    while !left.isEmpty {
        if left.first! == right.first! && !left.first!.isNumber {
            left.removeFirst()
            right.removeFirst()
        } else {
            if left.first! == "[" && right.first!.isNumber {
                var rightNumber = 0
                while right.first!.isNumber {
                    rightNumber = rightNumber * 10 + Int(String(right.removeFirst()))!
                }
                right = "[" + String(rightNumber) + "]" + right
            } else if right.first! == "[" && left.first!.isNumber {
                var leftNumber = 0
                while left.first!.isNumber {
                    leftNumber = leftNumber * 10 + Int(String(left.removeFirst()))!
                }
                left = "[" + String(leftNumber) + "]" + left
            } else if left.first!.isNumber && right.first!.isNumber {
                var leftNumber = 0
                while left.first!.isNumber {
                    leftNumber = leftNumber * 10 + Int(String(left.removeFirst()))!
                }
                var rightNumber = 0
                while right.first!.isNumber {
                    rightNumber = rightNumber * 10 + Int(String(right.removeFirst()))!
                }
                if leftNumber < rightNumber {
                    // right number is higher
                    return true
                } else if leftNumber > rightNumber {
                    // left number is higher
                    return false
                }
            } else if (left.first! != "]" && right.first! == "]") {
                // right list out of items
                return false
            } else if (left.first! == "]" && right.first! != "]") {
                // left list out of items
                return true
            }
        }
    }
    return true
}

func rightOrderPairs(input: [String]) -> Int {
    var result = 0
    var i = 0
    while i < input.count {
        let first = input[i]
        let second = input[i+1]
        if comparePackets(first: Array(first), second: Array(second)) {
            result += i/2 + 1
        }
        i += 2
    }
    return result
}

/*
let a = "[[1],[2,3,4]]"
let b = "[[1],4]"
print(comparePackets(first: Array(a), second: Array(b)))

let c = "[[10,9,2],[7,7,9,[3,2]],[7,[6,8],8]]"
let d = "[[[1,3,8],5,[[4,7],[4,5,0],[],[5,2]],5],[7,[[2,0,0,10,6],8,[9],6],[],1,10],[[]],[[[4,10],[5],[8,6,3,10],6,[10,0,0]],0,[9],[[2,8,0],[0],5,[10,8,2,10]]]]"
print(comparePackets(first: Array(c), second: Array(d)))
*/

var input = readLinesRemoveEmpty(str: inputString)
print("Part 1: \(rightOrderPairs(input: input))")

let divPacket1 = "[[2]]"
let divPacket2 = "[[6]]"
input.append(divPacket1)
input.append(divPacket2)
let sorted = input.sorted(by: { first, second in
    comparePackets(first: Array(first), second: Array(second))
})
let div1 = sorted.firstIndex(where: { $0 == divPacket1 } )! + 1
let div2 = sorted.firstIndex(where: { $0 == divPacket2 } )! + 1
print("Part 2: \(div1*div2)")
