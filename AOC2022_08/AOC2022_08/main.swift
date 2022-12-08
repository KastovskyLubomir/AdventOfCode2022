//
//  main.swift
//  AOC2022_08
//
//  Created by Kaštovský Lubomír on 08.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

typealias GridType = [[UInt8]]

func loadGrid(input: [String]) -> GridType {
    var result = GridType()
    input.forEach {
        let bytes = getStringBytes(str: $0)
        result.append(bytes)
    }
    return result
}

func findViewBlocker(xIn: Int, yIn: Int, addX: Int, addY: Int, grid: GridType) -> (x: Int, y: Int) {
    let height = grid[yIn][xIn]
    var x = xIn
    var y = yIn
    while x > 0 && x < grid[yIn].count-1 && y > 0 && y < grid.count-1 {
        x += addX
        y += addY
        if grid[y][x] >= height {
            break
        }
    }
    return (x, y)
}

func findDistance(xIn: Int, yIn: Int, addX: Int, addY: Int, grid: GridType) -> Int {
    let blockerPosition = findViewBlocker(xIn: xIn, yIn: yIn, addX: addX, addY: addY, grid: grid)
    return abs(blockerPosition.y - yIn) + abs(blockerPosition.x - xIn)
}

func canSee(xIn: Int, yIn: Int, addX: Int, addY: Int, grid: GridType) -> Bool {
    let pos = findViewBlocker(xIn: xIn, yIn: yIn, addX: addX, addY: addY, grid: grid)
    return (pos.x == 0 || pos.x == grid[yIn].count-1 || pos.y == 0 || pos.y == grid.count-1)
        && (grid[yIn][xIn] > grid[pos.y][pos.x])
}

func treeVisible(xIn: Int, yIn: Int, grid: GridType) -> Bool {
    guard !(xIn == 0 || yIn == 0 || xIn == grid[yIn].count-1 || yIn == grid.count-1) else {
        return true
    }
    return canSee(xIn: xIn, yIn: yIn, addX: -1, addY: 0, grid: grid)
        || canSee(xIn: xIn, yIn: yIn, addX: 1, addY: 0, grid: grid)
        || canSee(xIn: xIn, yIn: yIn, addX: 0, addY: -1, grid: grid)
        || canSee(xIn: xIn, yIn: yIn, addX: 0, addY: 1, grid: grid)
}

func scenicScore(xIn: Int, yIn: Int, grid: GridType) -> Int {
    guard !(xIn == 0 || yIn == 0 || xIn == grid[yIn].count-1 || yIn == grid.count-1) else {
        return 0
    }
    var score = 0
    score = findDistance(xIn: xIn, yIn: yIn, addX: -1, addY: 0, grid: grid)
    score = score * findDistance(xIn: xIn, yIn: yIn, addX: 1, addY: 0, grid: grid)
    score = score * findDistance(xIn: xIn, yIn: yIn, addX: 0, addY: -1, grid: grid)
    score = score * findDistance(xIn: xIn, yIn: yIn, addX: 0, addY: 1, grid: grid)
    return score
}

func countVisibleTrees(grid: GridType) -> Int {
    var result = 0
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            if treeVisible(xIn: x, yIn: y, grid: grid) {
                result += 1
            }
        }
    }
    return result
}

func bestScenicScore(grid: GridType) -> Int {
    var result = Int.min
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            let score = scenicScore(xIn: x, yIn: y, grid: grid)
            if score > result {
               result = score
            }
        }
    }
    return result
}

let input = readLinesRemoveEmpty(str: inputString)
let grid = loadGrid(input: input)

print("Part 1: \(countVisibleTrees(grid: grid))")
print("Part 2: \(bestScenicScore(grid: grid))")
