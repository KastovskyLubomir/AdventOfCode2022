//
//  main.swift
//  AOC2022_24
//
//  Created by Lubomir Kastovsky on 24.12.2022.
//  Copyright © 2022 Lubomir Kastovsky. All rights reserved.
//

import Foundation


enum VortexDirection: Int {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
}

typealias Map = [[[VortexDirection]]]

struct Position: Hashable {
    let x: Int
    let y: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

func loadMap(input: [String]) -> Map {
    var map = Map()
    for y in 1...input.count - 2 {
        var row = [[VortexDirection]]()
        let array = Array(input[y])
        for x in 1...array.count - 2 {
            if array[x] == "." {
                row.append([])
            } else {
                switch array[x] {
                case "^": row.append([.up])
                case "v": row.append([.down])
                case ">": row.append([.right])
                case "<": row.append([.left])
                default: break
                }
            }
            
        }
        map.append(row)
    }
    return map
}

func emptyMap(rows: Int, cols: Int) -> Map {
    let row = [[VortexDirection]].init(repeating: [], count: cols)
    let newMap = Map.init(repeating: row, count: rows)
    return newMap
}

func moveVortex(map: Map) -> Map {
    var newMap = emptyMap(rows: map.count, cols: map[0].count)
    for y in 0..<map.count {
        for x in 0..<map[y].count {
            for direction in map[y][x] {
                switch direction {
                case .up:
                    if y-1 < 0 {
                        newMap[newMap.count-1][x].append(.up)
                    } else {
                        newMap[y-1][x].append(.up)
                    }
                case .down:
                    if y+1 == map.count  {
                        newMap[0][x].append(.down)
                    } else {
                        newMap[y+1][x].append(.down)
                    }
                case .left:
                    if x-1 < 0 {
                        newMap[y][map[y].count-1].append(.left)
                    } else {
                        newMap[y][x-1].append(.left)
                    }
                case .right:
                    if x+1 == map[y].count  {
                        newMap[y][0].append(.right)
                    } else {
                        newMap[y][x+1].append(.right)
                    }
                }
                
            }
        }
    }
    return newMap
}

func mapsEqual(map1: Map, map2: Map) -> Bool {
    for y in 0..<map1.count {
        for x in 0..<map1[y].count {
            let content1 = map1[y][x].sorted(by: { $0.rawValue < $1.rawValue })
            let content2 = map2[y][x].sorted(by: { $0.rawValue < $1.rawValue })
            if content1.count != content2.count {
                return false
            }
            for i in 0..<content1.count {
                if content1[i] != content2[i] {
                    return false
                }
            }
        }
    }
    return true
}

// map state will repeat after some steps, this will save time later
// don't need to compute new positions repeatedly, we have fixed size array of map sequence
func findMapsUntilRepeat(map: Map) -> [Map] {
    var result = [map]
    while true {
        let tmpMap = moveVortex(map: result.last!)
        if !mapsEqual(map1: result.first!, map2: tmpMap) {
            result.append(tmpMap)
        } else {
            break
        }
    }
    return result
}

func getPossiblePositions(position: Position, map: Map, reversed: Bool) -> [Position] {
    var result = [Position]()
    let additions = [(-1,0), (1,0), (0,-1), (0,1), (0,0)]
    for addition in additions {
        let x = position.x + addition.0
        let y = position.y + addition.1
        if x >= 0 && x <= map[0].count-1 && y >= 0 && y <= map.count-1 {
            if map[y][x].isEmpty {
                result.append(Position(x: x, y: y))
            }
        }
        if reversed {
            if x == 0 && y == -1 {
                result.append(Position(x: x, y: y))
            }
        } else {
            if x == map[0].count-1 && y == map.count {
                result.append(Position(x: x, y: y))
            }
        }
    }
    return result
}

func pathSearching(start: Position, end: Position, startMapIndex: Int, maps: [Map], reversed: Bool = false) -> Int {
    var i = startMapIndex
    var positions = Set<Position>()
    positions.insert(start)
    var newPositions = Set<Position>()
    while true {
        for position in positions {
            // generate possible positions
            let newPossiblePositions = getPossiblePositions(position: position, map: maps[i % maps.count], reversed: reversed)
            for newPossiblePosition in newPossiblePositions {
                if newPossiblePosition.x == end.x && newPossiblePosition.y == end.y {
                    return i
                }
                newPositions.insert(newPossiblePosition)
            }
        }
        positions = newPositions
        newPositions.removeAll()
        
        // still try to go from start
        positions.insert(start)
        
        i += 1
    }
    
    return i
}

func printMap(map: Map) {
    print("size: x: \(map[0].count), y: \(map.count)")
    for row in map {
        var str = ""
        for col in row {
            if col.isEmpty {
                str.append(".")
            } else {
                str.append(String(col.count))
            }
        }
        print(str)
    }
    print("------")
}

let input = readLinesRemoveEmpty(str: inputString)
var map = loadMap(input: input)

let maps = findMapsUntilRepeat(map: map)
let firstPathSteps = pathSearching(start: Position(x: 0, y: -1), end: Position(x: maps[0][0].count-1, y: maps[0].count), startMapIndex: 1, maps: maps)
print("Part 1: \(firstPathSteps)")

let secondPathSteps = pathSearching(start: Position(x: maps[0][0].count-1, y: maps[0].count), end: Position(x: 0, y: -1), startMapIndex: firstPathSteps+1, maps: maps, reversed: true)
let thirdPathSteps = pathSearching(start: Position(x: 0, y: -1), end: Position(x: maps[0][0].count-1, y: maps[0].count), startMapIndex: secondPathSteps+1, maps: maps)
print("Part 2: \(thirdPathSteps)")
