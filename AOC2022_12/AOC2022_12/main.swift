//
//  main.swift
//  AOC2022_12
//
//  Created by Kaštovský Lubomír on 12.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

typealias Map = [[UInt8]]

let start = Character("S").asciiValue!
let end = Character("E").asciiValue!
let endMark = Character("z").asciiValue! + 1

let additions = [(-1,0),(1,0),(0,-1),(0,1)]

@inline(__always) func getId(x: Int, y: Int) ->  Int {
    return x*10000 + y
}

func loadMap(input: [String]) -> Map {
    var result = Map()
    input.forEach {
        let bytes = getStringBytes(str: $0)
        let modified = bytes.compactMap { byte in
            if byte == end {
                return endMark
            } else {
                return byte
            }
        }
        result.append(modified)
    }
    return result
}

func findPath(startX: Int, startY: Int, map: inout Map, length: Int, tested: inout [Int: Int]) -> Int {
    let level = map[startY][startX]
    guard level != endMark else {
        return length
    }
    var bestLength = Int.max
    let newLevel = level + 1
    let id = getId(x: startX, y: startY)
    if let testedLength = tested[id] {
        if testedLength > length {
            tested[id] = length
        } else {
            return bestLength
        }
    } else {
        tested[id] = length
    }
    additions.forEach {
        let x = startX + $0.0
        let y = startY + $0.1
        if x >= 0 && x < maxX && y >= 0 && y < maxY {
            if map[y][x] <= newLevel || level == start {
                let pathLength = findPath(startX: x, startY: y, map: &map, length: length + 1, tested: &tested)
                if pathLength < bestLength {
                    bestLength = pathLength
                }
            }
        }
    }
    return bestLength
}

func findStart(map: Map) -> (x: Int, y: Int) {
    for y in 0..<map.count {
        for x in 0..<map[0].count {
            if map[y][x] == UInt8(83) {
                return (x, y)
            }
        }
    }
    return (0, 0)
}

func findPossibleStarts(map: Map) -> [(x: Int, y: Int)] {
    var result = [(x: Int, y: Int)]()
    for y in 0..<map.count {
        for x in 0..<map[0].count {
            if map[y][x] == UInt8(83) || map[y][x] == UInt8(97) {
                result.append((x, y))
            }
        }
    }
    return result
}

func bestHike(map: inout Map) -> Int {
    let starts = findPossibleStarts(map: map)
    var bestHikeDistance = Int.max
    print("Starting positions: \(starts.count)")
    starts.forEach { start in
        var tested = [Int:Int]()
        let distance = findPath(startX: start.x, startY: start.y, map: &map, length: 0, tested: &tested)
        if distance < bestHikeDistance {
            bestHikeDistance = distance
        }
    }
    return bestHikeDistance
}

let input = readLinesRemoveEmpty(str: inputString)
var map = loadMap(input: input)
let maxX = map[0].count
let maxY = map.count

let startPos = findStart(map: map)
var tested = [Int:Int]()

let startTime = DispatchTime.now()
let part1 = findPath(startX: startPos.x, startY: startPos.y, map: &map, length: 0, tested: &tested)
let endTime = DispatchTime.now()
let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000

print("Part 1: \(part1), time: \(timeInterval)")

let start2 = DispatchTime.now()
let part2 = bestHike(map: &map)
let end2 = DispatchTime.now()
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000

print("Part 2: \(part2), time: \(timeInterval2)")
