//
//  main.swift
//  AOC2022_17
//
//  Created by Kaštovský Lubomír on 17.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

/*
 
 ####

 .#.
 ###
 .#.

 ..#
 ..#
 ###

 #
 #
 #
 #

 ##
 ##
 
 */

/*
 
 012345678
 |..@@@@.|  4
 |.......|  3
 |.......|  2
 |.......|  1
 +-------+  0
 
 012345678
 |..@@@@.|  y
 |.......|
 |.......|
 |.......|
 +-------+
 
 012345678
 |...@...|  y+2
 |..@@@..|  y+1
 |...@...|  y
 |.......|
 +-------+
 
 012345678
 |....@..|  y+2
 |....@..|  y+1
 |..@@@..|  y
 |.......|
 +-------+
 
 012345678
 |..@....|  y+3
 |..@....|  y+2
 |..@....|  y+1
 |..@....|  y
 |.......|
 +-------+
 
 012345678
 |..@@...|  y+1
 |..@@...|  y
 |.......|
 |.......|
 +-------+
 
 */

enum Shape: String {
    case horLine
    case cross
    case corner
    case verLine
    case square
}

struct Position: Hashable {
    var x: Int
    var y: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

typealias Rock = Set<Position>
typealias Chamber = Set<Position>

func shapeStartPosition(shape: Shape, offset y: Int) -> Rock {
    switch shape {
    case .horLine:
        return [Position(x: 3, y: y), Position(x: 4, y: y), Position(x: 5, y: y), Position(x: 6, y: y)]
    case .cross:
        return [Position(x: 4, y: y+2), Position(x: 3, y: y+1), Position(x: 4, y: y+1), Position(x: 5, y: y+1), Position(x: 4, y: y)]
    case .corner:
        return [Position(x: 3, y: y), Position(x: 4, y: y), Position(x: 5, y: y), Position(x: 5, y: y+1), Position(x: 5, y: y+2)]
    case .verLine:
        return [Position(x: 3, y: y), Position(x: 3, y: y+1), Position(x: 3, y: y+2), Position(x: 3, y: y+3)]
    case .square:
        return [Position(x: 3,y: y), Position(x: 4, y: y), Position(x: 3, y: y+1), Position(x: 4, y: y+1)]
    }
}

func moveRight(rock: Rock) -> Rock {
    return Set(rock.compactMap( { Position(x: $0.x+1, y: $0.y) }))
}

func moveLeft(rock: Rock) -> Rock {
    return Set(rock.compactMap( { Position(x: $0.x-1, y: $0.y) }))
}

func moveDown(rock: Rock) -> Rock {
    return Set(rock.compactMap( { Position(x: $0.x, y: $0.y-1) }))
}

func canMoveRight(rock: Rock, chamber: inout Chamber) -> Bool {
    for pos in rock {
        if pos.x + 1 == 8 {
            return false
        }
        if chamber.contains(where: { $0.x == pos.x + 1 && $0.y == pos.y}) {
            return false
        }
    }
    return true
}

func canMoveLeft(rock: Rock, chamber: inout Chamber) -> Bool {
    for pos in rock {
        if pos.x - 1 == 0 {
            return false
        }
        if chamber.contains(where: { $0.x == pos.x - 1 && $0.y == pos.y}) {
            return false
        }
    }
    return true
}

func canMoveDown(rock: Rock, chamber: inout Chamber) -> Bool {
    for pos in rock {
        if pos.y - 1 == 0 {
            return false
        }
        if chamber.contains(where: { $0.x == pos.x && $0.y == pos.y - 1 }) {
            return false
        }
    }
    return true
}

func rockTopPosition(rock: Rock) -> Int {
    return rock.max(by: { $0.y < $1.y })!.y
}

func rocksFalling(instructions: [Character], rockCount: Int, startY: Int) -> Int {
    let shapes: [Shape] = [.horLine, .cross, .corner, .verLine, .square]
    var chamber = Chamber()
    var shapeIndex = 0
    var instructionsIndex = 0
    var y = startY
    for i in 1...rockCount {
        var rock = shapeStartPosition(shape: shapes[shapeIndex], offset: y)
        shapeIndex += 1
        if shapeIndex == shapes.count {
            shapeIndex = 0
        }
        var side = true
        while true {
            if side {
                if instructions[instructionsIndex] == ">" && canMoveRight(rock: rock, chamber: &chamber){
                    rock = moveRight(rock: rock)
                }
                if instructions[instructionsIndex] == "<" && canMoveLeft(rock: rock, chamber: &chamber){
                    rock = moveLeft(rock: rock)
                }
                instructionsIndex += 1
                if instructionsIndex == instructions.count {
                    instructionsIndex = 0
                }
                side = false
            } else {
                if canMoveDown(rock: rock, chamber: &chamber) {
                    rock = moveDown(rock: rock)
                } else {
                    break
                }
                side = true
            }
        }
        chamber = chamber.union(rock)
        let newTop = rockTopPosition(rock: rock)
        if newTop > (y-4) {
            y = newTop + 4
        }
    }
    return y - 4
}

func rocksFallingFindCycle(instructions: [Character], rockCount: Int, startY: Int) -> Int {
    let shapes: [Shape] = [.horLine, .cross, .corner, .verLine, .square]
    var endStates = [(Int, String, Shape, Int)]() // index to instructions, 4 top lines of chamber, next shape, height
    var chamber = Chamber()
    var shapeIndex = 0
    var instructionsIndex = 0
    var y = startY
    var i = 0
    while i < rockCount {
        print(i, endStates.count)
        let endState = (instructionsIndex, topRowsToString(chamber: &chamber, y: y, count: 4), shapes[shapeIndex], y - 4)
        //print(endState)
        
        if let found = endStates.firstIndex(where: { $0.0 == endState.0 && $0.1 == endState.1 && $0.2 == endState.2 }) {
            print(endState)
            let foundState = endStates[found]
            let heightDiff = endState.3 - foundState.3
            print(found, heightDiff, endStates[found])
            
            let xx = 1000000000000 // (rockCount)
            let fullCyclesCount = (xx - found) / (i - found)
            let fullCyclesHeight = fullCyclesCount * heightDiff
            let heightWithBeggining = fullCyclesHeight + foundState.3
            // must add remaining height
            let zz = xx - (fullCyclesCount * (i - found) + found)
            let remainingHeight = endStates[found + zz].3 - foundState.3
            let result = heightWithBeggining + remainingHeight
            return result
        }
        endStates.append(endState)
        
        var rock = shapeStartPosition(shape: shapes[shapeIndex], offset: y)
        shapeIndex += 1
        if shapeIndex == shapes.count {
            shapeIndex = 0
        }
        var side = true
        while true {
            if side {
                if instructions[instructionsIndex] == ">" && canMoveRight(rock: rock, chamber: &chamber){
                    rock = moveRight(rock: rock)
                }
                if instructions[instructionsIndex] == "<" && canMoveLeft(rock: rock, chamber: &chamber){
                    rock = moveLeft(rock: rock)
                }
                instructionsIndex += 1
                if instructionsIndex == instructions.count {
                    instructionsIndex = 0
                }
                side = false
            } else {
                if canMoveDown(rock: rock, chamber: &chamber) {
                    rock = moveDown(rock: rock)
                } else {
                    break
                }
                side = true
            }
        }
        chamber = chamber.union(rock)
        let newTop = rockTopPosition(rock: rock)
        if newTop > (y-4) {
            y = newTop + 4
        }
        
        i += 1
    }
    return y - 4
}

func topRowsToString(chamber: inout Chamber, y: Int, count: Int) -> String {
    var resultStr = ""
    for yy in y-4-(count-1)...y-4 {
        let array = chamber.compactMap{ Position(x: $0.x, y: $0.y) }
        let filtered = array.filter { $0.y == yy }
        let pos = filtered.sorted(by: { $0.x < $1.x })
        var str = ""
        for x in 1...7 {
            if pos.contains(where: { $0.x == x }) {
                str += "#"
            } else {
                str += "."
            }
        }
        resultStr += str
    }
    return resultStr
}

/*
func printChamber(rock: Rock, chamber: Chamber) {
    var resultStr = ""
    let chamber = chamber + rock
    let maxy = chamber.max(by: { $0.y < $1.y })!.y
    for y in 0...maxy+2 {
        let pos = chamber.filter { $0.y == y }.sorted(by: { $0.x < $1.x })
        var str = ""
        for x in 0...10 {
            if x == 10 {
                str += String(y)
            } else if x == 9 {
                str += " "
            } else if y == 0 {
                str += "-"
            } else if x == 0 || x == 8 {
                str += "|"
            } else if pos.contains(where: { $0.x == x }) {
                str += "#"
            } else {
                str += "."
            }
        }
        resultStr = str + "\n" + resultStr
    }
    print(resultStr)
}
*/
 
let input = readLinesRemoveEmpty(str: inputString)
let instructions = Array(input[0])

//print(rocksFalling(instructions: instructions, rockCount: 2022, startY: 4))

print(rocksFallingFindCycle(instructions: instructions, rockCount: 1000000000000, startY: 4))
