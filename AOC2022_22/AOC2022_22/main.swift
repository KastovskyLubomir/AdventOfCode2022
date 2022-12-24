//
//  main.swift
//  AOC2022_22
//
//  Created by Lubomir Kastovsky on 22.12.2022.
//  Copyright © 2022 Lubomir Kastovsky. All rights reserved.
//

import Foundation

typealias Map = [[Character]]

enum Direction {
    case up
    case down
    case left
    case right
}

typealias Position = (x: Int, y: Int)

func loadMap(input: [String]) -> Map {
    var result = Map()
    let mapInput = input.filter { !$0.contains("L") }
    let maxLength = mapInput.max(by: { $0.count < $1.count })!.count
    mapInput.forEach { line in
        if !line.contains("L") {
            var row = [Character].init(repeating: " ", count: maxLength)
            let pattern = Array(line)
            for x in 0..<pattern.count {
                if pattern[x] != " " {
                    row[x] = pattern[x]
                }
            }
            result.append(row)
        }
    }
    return result
}

func loadInstructions(input: [String]) -> String {
    return input.filter { $0.contains("L") }.first!
}

func moveToNextPosition(position: Position, direction: Direction, map: inout Map) -> Position? {
    switch direction {
    case .up:
        var y = position.y - 1
        if y < 0 {
            y = map.count - 1
        }
        let fieldContent = map[y][position.x]
        if fieldContent == "." {
            return Position(x: position.x, y: y)
        } else if fieldContent == "#" {
            return Position(x: position.x, y: position.y)
        } else if fieldContent == " " {
            var i = y
            while map[i][position.x] == " " {
                if i == 0 {
                    i = map.count - 1
                } else {
                    i -= 1
                }
            }
            if map[i][position.x] == "." {
                return Position(x: position.x, y: i)
            } else if map[i][position.x] == "#" {
                return Position(x: position.x, y: position.y)
            }
        }
        return nil
    case .down:
        var y = position.y + 1
        if y > map.count - 1 {
            y = 0
        }
        let fieldContent = map[y][position.x]
        if fieldContent == "." {
            return Position(x: position.x, y: y)
        } else if fieldContent == "#" {
            return Position(x: position.x, y: position.y)
        } else if fieldContent == " " {
            var i = y
            while map[i][position.x] == " " {
                if i == map.count - 1 {
                    i = 0
                } else {
                    i += 1
                }
            }
            if map[i][position.x] == "." {
                return Position(x: position.x, y: i)
            } else if map[i][position.x] == "#" {
                return Position(x: position.x, y: position.y)
            }
        }
        return nil
    case .left:
        var x = position.x - 1
        if x < 0 {
            x = map[position.y].count - 1
        }
        let fieldContent = map[position.y][x]
        if fieldContent == "." {
            return Position(x: x, y: position.y)
        } else if fieldContent == "#" {
            return Position(x: position.x, y: position.y)
        } else if fieldContent == " " {
            var i = x
            while map[position.y][i] == " " {
                if i == 0 {
                    i = map[position.y].count - 1
                } else {
                    i -= 1
                }
            }
            if map[position.y][i] == "." {
                return Position(x: i, y: position.y)
            } else if map[position.y][i] == "#" {
                return Position(x: position.x, y: position.y)
            } else {
                return nil
            }
        }
        return nil
    case .right:
        var x = position.x + 1
        if x > map[position.y].count - 1 {
            x = 0
        }
        let fieldContent = map[position.y][x]
        if fieldContent == "." {
            return Position(x: x, y: position.y)
        } else if fieldContent == "#" {
            return Position(x: position.x, y: position.y)
        } else if fieldContent == " " {
            var i = x
            while map[position.y][i] == " " {
                if i == map[position.y].count - 1 {
                    i = 0
                } else {
                    i += 1
                }
            }
            if map[position.y][i] == "." {
                return Position(x: i, y: position.y)
            } else if map[position.y][i] == "#" {
                return Position(x: position.x, y: position.y)
            }
        }
        return nil
    }
    return nil
}

/*
     -----
     |A|B|
     -----
     |C|
   -----
   |D|E|
   -----
   |F|
   ---
 */

func getSide(position: Position) -> String {
    let x = position.x
    let y = position.y
    if x >= 50 && x <= 99 && y >= 0 && y <= 49 {
        return "A"
    }
    if x >= 100 && x <= 149 && y >= 0 && y <= 49 {
        return "B"
    }
    if x >= 50 && x <= 99 && y >= 50 && y <= 99 {
        return "C"
    }
    if x >= 0 && x <= 49 && y >= 100 && y <= 149 {
        return "D"
    }
    if x >= 50 && x <= 99 && y >= 100 && y <= 149 {
        return "E"
    }
    if x >= 0 && x <= 49 && y >= 150 && y <= 199 {
        return "F"
    }
    return ""
}

func mapToNewPosition(position: Position, direction: Direction,  side: String) -> (Position, Direction)? {
    let side = getSide(position: position)
    if side == "A" {
        switch direction {
        case .up: return (Position(x: 0, y: position.x + 100), .right)
        case .left: return (Position(x: 0, y: 149 - position.y), .right)
        default: break
        }
    }
    if side == "B" {
        switch direction {
        case .up: return (Position(x: position.x - 100, y: 199), .up)
        case .right: return (Position(x: 99, y: 149 - position.y), .left)
        case .down: return (Position(x: 99, y: position.x - 50), .left)
        default: break
        }
    }
    if side == "C" {
        switch direction {
        case .left: return (Position(x: position.y - 50, y: 100), .down)
        case .right: return (Position(x: position.y + 50, y: 49), .up)
        default: break
        }
    }
    if side == "D" {
        switch direction {
        case .up: return (Position(x: 50, y: position.x + 50), .right)
        case .left: return (Position(x: 50, y: 149 - position.y), .right)
        default: break
        }
    }
    if side == "E" {
        switch direction {
        case .right: return (Position(x: 149, y: 149 - position.y), .left)
        case .down: return (Position(x: 49, y: position.x + 100), .left)
        default: break
        }
    }
    if side == "F" {
        switch direction {
        case .right: return (Position(x: position.y - 100, y: 149), .up)
        case .down: return (Position(x: position.x + 100, y: 0), .down)
        case .left: return (Position(x: position.y - 100, y: 0), .down)
        default: break
        }
    }
    return nil
}

func moveToNextPositionOnCube(position: Position, direction: Direction, map: inout Map) -> (Position, Direction)? {
    switch direction {
    case .up:
        var y = position.y - 1
        var newPosition: (Position, Direction)? = nil
        if y < 0 || map[y][position.x] == " " {
            newPosition = mapToNewPosition(position: position, direction: direction, side: getSide(position: position))
        } else {
            newPosition = (Position(x: position.x, y: y), direction)
        }
        if let newPosition = newPosition {
            let fieldContent = map[newPosition.0.y][newPosition.0.x]
            if fieldContent == "." {
                return newPosition
            } else if fieldContent == "#" {
                return (position, direction)
            }
        }
        return nil
    case .down:
        var y = position.y + 1
        var newPosition: (Position, Direction)? = nil
        if y > map.count - 1 || map[y][position.x] == " " {
            newPosition = mapToNewPosition(position: position, direction: direction, side: getSide(position: position))
        } else {
            newPosition = (Position(x: position.x, y: y), direction)
        }
        if let newPosition = newPosition {
            let fieldContent = map[newPosition.0.y][newPosition.0.x]
            if fieldContent == "." {
                return newPosition
            } else if fieldContent == "#" {
                return (position, direction)
            }
        }
        return nil
    case .left:
        var x = position.x - 1
        var newPosition: (Position, Direction)? = nil
        if x < 0 || map[position.y][x] == " " {
            newPosition = mapToNewPosition(position: position, direction: direction, side: getSide(position: position))
        } else {
            newPosition = (Position(x: x, y: position.y), direction)
        }
        if let newPosition = newPosition {
            let fieldContent = map[newPosition.0.y][newPosition.0.x]
            if fieldContent == "." {
                return newPosition
            } else if fieldContent == "#" {
                return (position, direction)
            }
        }
        return nil
    case .right:
        var x = position.x + 1
        var newPosition: (Position, Direction)? = nil
        if x > map[position.y].count - 1 || map[position.y][x] == " " {
            newPosition = mapToNewPosition(position: position, direction: direction, side: getSide(position: position))
        } else {
            newPosition = (Position(x: x, y: position.y), direction)
        }
        if let newPosition = newPosition {
            let fieldContent = map[newPosition.0.y][newPosition.0.x]
            if fieldContent == "." {
                return newPosition
            } else if fieldContent == "#" {
                return (position, direction)
            }
        }
        return nil
    }
    return nil
}

func moving(instructions: String, map: inout Map, cube: Bool) -> Int {
    let startX = map[0].firstIndex(of: ".")!
    print(map.count, map[0].count)
    var position = Position(x: startX, y: 0)
    var direction: Direction = .right
    var instr = Array(instructions)
    
    while !instr.isEmpty {
        if instr.first!.isNumber {
            var count = 0
            while instr.first!.isNumber {
                let num = Int(String(instr.removeFirst()))!
                count = count * 10 + num
                if instr.isEmpty {
                    break
                }
            }
            for _ in 0..<count {
                if cube {
                    if let pos = moveToNextPositionOnCube(position: position, direction: direction, map: &map) {
                        position = pos.0
                        direction = pos.1
                    } else {
                        print("ERROR")
                        return 0
                    }
                } else {
                    if let pos = moveToNextPosition(position: position, direction: direction, map: &map) {
                        position = pos
                    } else {
                        print("ERROR")
                        return 0
                    }
                }
            }
        } else if instr.first == "L" {
            switch direction {
            case .up: direction = .left
            case .down: direction = .right
            case .left: direction = .down
            case .right: direction = .up
            }
            instr.removeFirst()
        } else if instr.first == "R" {
            switch direction {
            case .up: direction = .right
            case .down: direction = .left
            case .left: direction = .up
            case .right: direction = .down
            }
            instr.removeFirst()
        }
    }
    
    var directionValue = 0
    switch direction {
    case .up: directionValue = 3
    case .down: directionValue = 1
    case .left: directionValue = 2
    case .right: directionValue = 0
    }

    return ((position.y+1) * 1000) + (4 * (position.x+1)) + directionValue
}

let input = readLinesRemoveEmpty(str: inputString)

var map = loadMap(input: input)
let instructions = loadInstructions(input: input)

print(moving(instructions: instructions, map: &map, cube: false))
print(moving(instructions: instructions, map: &map, cube: true))
