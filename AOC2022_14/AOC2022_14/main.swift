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
    var xx = Set<Int>()
    var yy = Set<Int>()
    input.forEach { line in
        let parts = line.components(separatedBy: ["-", ">", " "]).filter { !$0.isEmpty }
        parts.forEach { part in
            let pos = part.components(separatedBy: ",")
            xx.insert(Int(pos[0])!)
            yy.insert(Int(pos[1])!)
        }
    }
    return (xx.min()!, 0, xx.max()!, yy.max()!)
}

func createMap(input: [String], bigMap: Bool = false) -> Map {
    var map = Map()
    let dimensions = getDimensions(input: input)
    if bigMap {
        for _ in dimensions.miny...(dimensions.maxy+3)  {
            map.append([Int].init(repeating: 0, count: dimensions.maxx - dimensions.minx + 2*(dimensions.maxy-dimensions.miny)))
        }
    } else {
        
        for _ in dimensions.miny...dimensions.maxy {
            map.append([Int].init(repeating: 0, count: dimensions.maxx - dimensions.minx + 1))
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
                swap(&x, &x2)
            }
            if y > y2 {
                swap(&y, &y2)
            }
            for xx in x...x2 {
                for yy in y...y2 {
                    let nx = xx - dimensions.minx + (bigMap ? map[0].count/2 : 0)
                    let ny = yy - dimensions.miny
                    map[ny][nx] = 1
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

func printMap(map: Map) -> String {
    var result = ""
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
        result.append(String(strline.joined()))
        result.append("\n")
    }
    result.append("----\n")
    return result
}

let input = readLinesRemoveEmpty(str: inputString)

let dimensions = getDimensions(input: input)

let startTime = DispatchTime.now()
var map = createMap(input: input)
let part1 = sandPouring(minx: dimensions.minx, map: &map)
let endTime = DispatchTime.now()
let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000

print("Part 1: \(part1), time: \(timeInterval)")

let startTime2 = DispatchTime.now()
var bigMap = createMap(input: input, bigMap: true)
let part2 = sandPouring(minx: dimensions.minx, map: &bigMap, bigMap: true)
let endTime2 = DispatchTime.now()
let nanoTime2 = endTime2.uptimeNanoseconds - startTime2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000

print("Part 2: \(part2), time: \(timeInterval2)")

let output = printMap(map: bigMap)
outputToFile(output: output)
