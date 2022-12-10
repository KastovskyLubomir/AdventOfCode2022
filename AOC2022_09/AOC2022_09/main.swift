//
//  main.swift
//  AOC2022_09
//
//  Created by Kaštovský Lubomír on 09.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

typealias Position = (x: Int, y: Int)

func moveHead(direction: String, pos: Position) -> Position {
    switch direction {
    case "U": return (pos.0, pos.1+1)
    case "D": return (pos.0, pos.1-1)
    case "L": return (pos.0-1, pos.1)
    case "R": return (pos.0+1, pos.1)
    default: return (0,0)
    }
}

func simulateHead(input: [String]) -> [Position] {
    var resultPath = [(0,0)]
    input.forEach { line in
        let parts = line.components(separatedBy: " ")
        let repeating = Int(parts[1])!
        for _ in 0..<repeating {
            let newStep = moveHead(direction: parts[0], pos: resultPath.last!)
            resultPath.append(newStep)
        }
    }
    return resultPath
}

func isTouching(tail: Position, head: Position) -> Bool {
    for x in head.x-1...head.x+1 {
        for y in head.y-1...head.y+1 {
            if tail.x == x && tail.y == y {
                return true
            }
        }
    }
    return false
}

func moveTail(tail: Position, head: Position) -> Position {
    if tail.x == head.x {
        if tail.y < head.y {
            return (tail.x, tail.y+1)
        } else {
            return (tail.x, tail.y-1)
        }
    }
    if tail.y == head.y {
        if tail.x < head.x {
            return (tail.x+1, tail.y)
        } else {
            return (tail.x-1, tail.y)
        }
    }
    if tail.x < head.x {
        if tail.y < head.y {
            return (tail.x+1, tail.y+1)
        } else {
            return (tail.x+1, tail.y-1)
        }
    } else {
        if tail.y > head.y {
            return (tail.x-1, tail.y-1)
        } else {
            return (tail.x-1, tail.y+1)
        }
    }
}

// input is simulated head
func followHead(input: [Position]) -> [Position] {
    var resultPath = [(0,0)]
    input.forEach { head in
        if !isTouching(tail: resultPath.last!, head: head) {
            let newStep = moveTail(tail: resultPath.last!, head: head)
            resultPath.append(newStep)
        }
    }
    return resultPath
}

// input is simulated head
// every knot follows the knot before like it is the head and tail
func longRope(input: [Position]) -> [Position] {
    var path = input
    for _ in 0..<9 {
        path = followHead(input: path)
    }
    return path
}

let input = readLinesRemoveEmpty(str: inputString)

let headPath = simulateHead(input: input)
let tailPath = followHead(input: headPath)
let visitedSet = Set(tailPath.map { String($0.x) + "," + String($0.y) })
print("Part 1: \(visitedSet.count)")

let longRopePath = longRope(input: headPath)
let endOfRopeSet = Set(longRopePath.map { String($0.x) + "," + String($0.y) })
print("Part 2: \(endOfRopeSet.count)")
