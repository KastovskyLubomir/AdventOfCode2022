//
//  main.swift
//  AOC2022_14
//
//  Created by Kaštovský Lubomír on 14.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

typealias Map = [[Int]]

func getDimensions(input: [String]) -> (minx: Int, miny: Int, maxx: Int, maxy: Int) {
    var minx = Int.max
    var miny = Int.max
    var maxx = Int.min
    var maxy = Int.min
    
    input.forEach { line in
        let parts = line.components(separatedBy: ["-", ">", " "]).filter { !$0.isEmpty }
        parts.forEach { part in
            let pos = part.components(separatedBy: ",")
            let x = Int(pos[0])!
            let y = Int(pos[1])!
            if x < minx {
                minx = x
            }
            if x > maxx {
                maxx = x
            }
            if y < miny {
                miny = y
            }
            if y > maxy {
                maxy = y
            }
        }
    }
    return (minx, 0, maxx, maxy)
}

func createMap(input: [String], bigMap: Bool = false) -> Map {
    var map = Map()
    let dimensions = getDimensions(input: input)
    if !bigMap {
        for _ in dimensions.miny...dimensions.maxy {
            map.append([Int].init(repeating: 0, count: dimensions.maxx - dimensions.minx + 1))
        }
    } else {
        for _ in dimensions.miny...(dimensions.maxy+3)  {
            map.append([Int].init(repeating: 0, count: dimensions.maxx - dimensions.minx + 2*(dimensions.maxy-dimensions.miny)))
        }
    }
    input.forEach { line in
        let parts = line.components(separatedBy: ["-", ">", " "]).filter { !$0.isEmpty }
        for i in 0..<(parts.count-1) {
            let pos = parts[i].components(separatedBy: ",")
            var x = Int(pos[0])!
            var y = Int(pos[1])!
            let pos2 = parts[i+1].components(separatedBy: ",")
            var x2 = Int(pos2[0])!
            var y2 = Int(pos2[1])!
            if x > x2 {
                let tmp = x
                x = x2
                x2 = tmp
            }
            if y > y2 {
                let tmp = y
                y = y2
                y2 = tmp
            }
            for xx in x...x2 {
                for yy in y...y2 {
                    if !bigMap {
                        let nx = xx - dimensions.minx
                        let ny = yy - dimensions.miny
                        map[ny][nx] = 1
                    } else {
                        let nx = xx - dimensions.minx + map[0].count/2
                        let ny = yy - dimensions.miny
                        map[ny][nx] = 1
                    }
                }
            }
        }
    }
    
    if bigMap {
        for i in 0..<map[0].count {
            map[dimensions.maxy+2][i] = 1
        }
    }
    
    return map
}

func sandPouring(minx: Int, map: inout Map, bigMap: Bool = false) -> Int {
    let xStartPos = 500 - minx + (bigMap ? map[0].count/2 : 0)
    var sandx = xStartPos
    var sandy = 0
    var sandCounter = 0
    while true {
        if map[sandy+1][sandx] == 0 {
            sandy += 1
        } else if map[sandy+1][sandx-1] == 0 {
            sandy += 1
            sandx -= 1
        } else if map[sandy+1][sandx+1] == 0 {
            sandy += 1
            sandx += 1
        } else if sandy == 0 && sandx == xStartPos {
            // rest at start, we finished
            map[sandy][sandx] = 2
            sandCounter += 1
            break
        } else {
            map[sandy][sandx] = 2
            sandx = xStartPos
            sandy = 0
            sandCounter += 1
        }
        if sandy == map.count-1 || sandx == 0 || sandx == map[0].count - 1 {
            break
        }
    }
    //printMap(map: map)
    return sandCounter
}

func printMap(map: Map) {
    map.forEach { line in
        let strline = line.map {
            if $0 == 0 {
                return " "
            }
            if $0 == 1 {
                return "+"
            } else {
                return "O"
            }
        }
        print("\(String(strline.joined()))")
    }
    print("---")
}

let input = readLinesRemoveEmpty(str: inputString)

let dimensions = getDimensions(input: input)
var map = createMap(input: input)
print("Part 1: \(sandPouring(minx: dimensions.minx, map: &map))")

var bigMap = createMap(input: input, bigMap: true)
print("Part 2: \(sandPouring(minx: dimensions.minx, map: &bigMap, bigMap: true))")
