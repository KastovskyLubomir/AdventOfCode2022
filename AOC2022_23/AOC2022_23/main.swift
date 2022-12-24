//
//  main.swift
//  AOC2022_23
//
//  Created by Lubomir Kastovsky on 23.12.2022.
//  Copyright © 2022 Lubomir Kastovsky. All rights reserved.
//

import Foundation


typealias Grid = Set<Int>

// center is x:5000, y:5000

func getId(x: Int, y: Int) -> Int {
    return x * 100000 + y
}

func getPos(id: Int) -> (x: Int, y: Int) {
    return (id/100000, id%100000)
}

func loadGrid(input: [String]) -> Grid {
    var set = Grid()
    let xsize = input[0].count
    let ysize = input.count
    print(xsize, ysize)
    var y = 5000 - ysize/2
    input.forEach { line in
        var x = 5000 - xsize/2
        line.forEach { char in
            if char == "#" {
                let id = getId(x: x, y: y)
                set.insert(id)
            }
            x += 1
        }
        y += 1
    }
    return set
}

func hasNeigbour(id: Int, grid: inout Grid, additions: [[(Int, Int)]]) -> Bool {
    let pos = getPos(id: id)
    for sideAdditions in additions {
        let id0 = getId(x: pos.x + sideAdditions[0].0, y: pos.y + sideAdditions[0].1)
        let id1 = getId(x: pos.x + sideAdditions[1].0, y: pos.y + sideAdditions[1].1)
        let id2 = getId(x: pos.x + sideAdditions[2].0, y: pos.y + sideAdditions[2].1)
        if grid.contains(id0) || grid.contains(id1) || grid.contains(id2) {
            return true
        }
    }
    return false
}

func newPositionId(id: Int, grid: inout Grid, additions: [[(Int, Int)]]) -> Int? {
    let pos = getPos(id: id)
    for sideAdditions in additions {
        let id0 = getId(x: pos.x + sideAdditions[0].0, y: pos.y + sideAdditions[0].1)
        let id1 = getId(x: pos.x + sideAdditions[1].0, y: pos.y + sideAdditions[1].1)
        let id2 = getId(x: pos.x + sideAdditions[2].0, y: pos.y + sideAdditions[2].1)
        if !grid.contains(id0) && !grid.contains(id1) && !grid.contains(id2) {
            return id1
        }
    }
    return nil
}

func move(grid: inout Grid, additions: [[(Int, Int)]]) {
    var duplicatePositions = Grid()
    var newGrid = Grid()
    print(grid.count)
    grid.forEach { id in
        if hasNeigbour(id: id, grid: &grid, additions: additions),
            let position = newPositionId(id: id, grid: &grid, additions: additions) {
            if !duplicatePositions.contains(position) {
                if !newGrid.contains(position) {
                    newGrid.insert(position)
                } else {
                    duplicatePositions.insert(position)
                }
            }
        } else {
            newGrid.insert(id)
        }
    }
    print(duplicatePositions.count)
    print(newGrid.count)
    // we have duplicates
    // go again and don't put on duplicates
    newGrid.removeAll()
    grid.forEach { id in
        if hasNeigbour(id: id, grid: &grid, additions: additions),
            let position = newPositionId(id: id, grid: &grid, additions: additions) {
            if !duplicatePositions.contains(position) {
                newGrid.insert(position)
            } else {
                // is in duplicates, use old position
                newGrid.insert(id)
            }
        } else {
            newGrid.insert(id)
        }
    }
    print(newGrid.count)
    
    grid = newGrid
}

func repeatMoves(times: Int, grid: inout Grid) -> Int {
    //                  north                       south                       west                        east
    var additions = [[(-1,-1), (0, -1), (1, -1)], [(-1,1), (0, 1), (1, 1)], [(-1,-1), (-1, 0), (-1, 1)], [(1,-1), (1, 0), (1, 1)]]
    printGrid(grid: grid)
    for i in 0..<times {
        print("round: \(i+1)")
        move(grid: &grid, additions: additions)
        let first = additions.removeFirst()
        additions.append(first)
        printGrid(grid: grid)
    }
    
    let minx = getPos(id: grid.min(by: { getPos(id: $0).x < getPos(id: $1).x })!).x
    let maxx = getPos(id: grid.max(by: { getPos(id: $0).x < getPos(id: $1).x })!).x
    let miny = getPos(id: grid.min(by: { getPos(id: $0).y < getPos(id: $1).y })!).y
    let maxy = getPos(id: grid.max(by: { getPos(id: $0).y < getPos(id: $1).y })!).y
    
    let size = (abs(maxx - minx) + 1) * (abs(maxy - miny) + 1)
    print(size)
    print(grid.count)
    return size - grid.count
}

func finalPositionRound(grid: inout Grid) -> Int {
    //                  north                       south                       west                        east
    var additions = [[(-1,-1), (0, -1), (1, -1)], [(-1,1), (0, 1), (1, 1)], [(-1,-1), (-1, 0), (-1, 1)], [(1,-1), (1, 0), (1, 1)]]
    //printGrid(grid: grid)
    var i = 0
    var tmpGrid = grid
    while true {
        print("round: \(i+1)")
        move(grid: &grid, additions: additions)
        let first = additions.removeFirst()
        additions.append(first)
        //printGrid(grid: grid)
        i += 1
        if tmpGrid == grid {
            return i
        }
        tmpGrid = grid
    }
    
    let minx = getPos(id: grid.min(by: { getPos(id: $0).x < getPos(id: $1).x })!).x
    let maxx = getPos(id: grid.max(by: { getPos(id: $0).x < getPos(id: $1).x })!).x
    let miny = getPos(id: grid.min(by: { getPos(id: $0).y < getPos(id: $1).y })!).y
    let maxy = getPos(id: grid.max(by: { getPos(id: $0).y < getPos(id: $1).y })!).y
    
    let size = (abs(maxx - minx) + 1) * (abs(maxy - miny) + 1)
    print(size)
    print(grid.count)
    return size - grid.count
}

func printGrid(grid: Grid) {
    let minx = getPos(id: grid.min(by: { getPos(id: $0).x < getPos(id: $1).x })!).x
    let maxx = getPos(id: grid.max(by: { getPos(id: $0).x < getPos(id: $1).x })!).x
    let miny = getPos(id: grid.min(by: { getPos(id: $0).y < getPos(id: $1).y })!).y
    let maxy = getPos(id: grid.max(by: { getPos(id: $0).y < getPos(id: $1).y })!).y
    
    print("\(minx),\(miny) -> \(maxx), \(maxy)")
    
    for y in miny...maxy {
        var str = ""
        for x in minx...maxx {
            if grid.contains(getId(x: x, y: y)) {
                str += "#"
            } else {
                str += "."
            }
        }
        print(str)
    }
    print("----")
    
}

let input = readLinesRemoveEmpty(str: inputString)
var grid = loadGrid(input: input)
var grid2 = grid

print(repeatMoves(times: 10, grid: &grid))
print(finalPositionRound(grid: &grid2))
