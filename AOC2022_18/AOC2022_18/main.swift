//
//  main.swift
//  AOC2022_18
//
//  Created by Kaštovský Lubomír on 18.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

struct Cube: Hashable {
    var x: Int
    var y: Int
    var z: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

typealias Droplet = [[[Int]]]
typealias Dimensions = (minx: Int, maxx: Int, miny: Int, maxy: Int, minz: Int, maxz: Int)

let additions = [[-1, 0, 0], [1, 0, 0], [0, -1, 0], [0, 1, 0], [0, 0, -1], [0, 0, 1]]

func loadCubes(input: [String]) -> Set<Cube> {
    var result = Set<Cube>()
    input.forEach { line in
        let ints = stringNumArrayToArrayOfInt(input: line, separators: [","])
        result.insert(Cube(x: ints[0], y: ints[1], z: ints[2]))
    }
    return result
}

func countNeighbors(cube: Cube, cubes: Set<Cube>) -> Int {
    var result = 0
    additions.forEach { addition in
        let cube = Cube(x: cube.x + addition[0], y: cube.y + addition[1], z: cube.z + addition[2])
        if cubes.contains(cube) {
            result += 1
        }
    }
    return result
}

func surfaceSum(cubes: Set<Cube>) -> Int {
    var result = 0
    cubes.forEach { cube in
        result += 6 - countNeighbors(cube: cube, cubes: cubes)
    }
    
    return result
}

func getDimensions(cubes: Set<Cube>) -> Dimensions {
    let minx = cubes.min(by: { $0.x < $1.x })!.x
    let maxx = cubes.max(by: { $0.x < $1.x })!.x
    let miny = cubes.min(by: { $0.y < $1.y })!.y
    let maxy = cubes.max(by: { $0.y < $1.y })!.y
    let minz = cubes.min(by: { $0.z < $1.z })!.z
    let maxz = cubes.max(by: { $0.z < $1.z })!.z
    return (minx, maxx, miny, maxy, minz, maxz)
}

func createDropplet(cubes: Set<Cube>) -> Droplet {
    var droplet = Droplet()
    let dim = getDimensions(cubes: cubes)
    for x in dim.minx...dim.maxx {
        var yrow = [[Int]]()
        for y in dim.miny...dim.maxy {
            var zrow = [Int]()
            for z in dim.minz...dim.maxz {
                if cubes.contains(Cube(x: x, y: y, z: z)) {
                    // append cube
                    zrow.append(1)
                } else {
                    // append air
                    zrow.append(0)
                }
            }
            yrow.append(zrow)
        }
        droplet.append(yrow)
    }
    return droplet
}

func expandablePositions(cube: Cube, droplet: Droplet, dim: Dimensions) -> [Cube] {
    var result = [Cube]()
    additions.forEach { addition in
        if cube.x+addition[0] >= dim.minx && cube.x+addition[0] <= dim.maxx
            && cube.y+addition[1] >= dim.miny && cube.y+addition[1] <= dim.maxy
            && cube.z+addition[2] >= dim.minz && cube.z+addition[2] <= dim.maxz {
            if droplet[cube.x+addition[0]][cube.y+addition[1]][cube.z+addition[2]] == 0 {
                result.append(Cube(x: cube.x+addition[0], y: cube.y+addition[1], z: cube.z+addition[2]))
            }
        }
    }
    return result
}

enum Planes: CaseIterable {
    case xmin
    case xmax
    case ymin
    case ymax
    case zmin
    case zmax
}

func generateExpandablePlane(plane: Planes, cubes: Set<Cube>, droplet: inout Droplet) -> Set<Cube> {
        
    let dim = getDimensions(cubes: cubes)
    
    var x1 = dim.minx
    var x2 = dim.maxx
    var y1 = dim.miny
    var y2 = dim.maxy
    var z1 = dim.minz
    var z2 = dim.maxz
    
    switch plane {
    case .xmin: x2 = dim.minx
    case .xmax: x1 = dim.maxx
    case .ymin: y2 = dim.miny
    case .ymax: y1 = dim.maxy
    case .zmin: z2 = dim.minz
    case .zmax: z1 = dim.maxz
    }
    
    var waterExpandPositions = Set<Cube>()
    for x in x1...x2 {
        for y in y1...y2 {
            for z in z1...z2 {
                let cube = Cube(x: x, y: y, z: z)
                if !cubes.contains(cube) {
                    droplet[x][y][z] = 2
                    let expandable = expandablePositions(cube: cube, droplet: droplet, dim: dim)
                    expandable.forEach { waterExpandPositions.insert($0) }
                }
            }
        }
    }
    
    return waterExpandPositions
}

// 0 - air, 1 - cube, 2 - water
func fillWithWater(cubes: Set<Cube>) -> Int {
    let dim = getDimensions(cubes: cubes)
    var droplet = createDropplet(cubes: cubes)
    var waterExpandPositions = Set<Cube>()
    
    Planes.allCases.forEach { plane in
        var planeCubes = generateExpandablePlane(plane: plane, cubes: cubes, droplet: &droplet)
        waterExpandPositions.formUnion(planeCubes)
    }
    
    while !waterExpandPositions.isEmpty {
        let cube = waterExpandPositions.removeFirst()
        droplet[cube.x][cube.y][cube.z] = 2
        let expandable = expandablePositions(cube: cube, droplet: droplet, dim: dim)
        expandable.forEach { waterExpandPositions.insert($0) }
    }
    
    //printDroplet(droplet: droplet)
    
    // get air cubes
    var airCubes = Set<Cube>()
    for x in dim.minx...dim.maxx {
        for y in dim.miny...dim.maxy {
            for z in dim.minz...dim.maxz {
                if droplet[x][y][z] == 0 {
                    airCubes.insert(Cube(x: x, y: y, z: z))
                }
            }
        }
    }
    
    let airPocketsSurface = surfaceSum(cubes: airCubes)
    let cubesSurface = surfaceSum(cubes: cubes)
    
    return cubesSurface - airPocketsSurface
}

func printDroplet(droplet: Droplet) {
    let dim = getDimensions(cubes: cubes)
    for x in dim.minx...dim.maxx {
        var plane = ""
        for y in dim.miny...dim.maxy {
            var str = ""
            for z in dim.minz...dim.maxz {
                if droplet[x][y][z] == 0 {
                    str += "."
                }
                if droplet[x][y][z] == 1 {
                    str += "#"
                }
                if droplet[x][y][z] == 2 {
                    str += "-"
                }
            }
            plane += str + "\n"
        }
        print(plane)
        print("+++++")
    }
    print("**********")
}

let input = readLinesRemoveEmpty(str: inputString)
let cubes = loadCubes(input: input)

print("Part 1: \(surfaceSum(cubes: cubes))")

let dimensions = getDimensions(cubes: cubes)
print("Part 2: \(fillWithWater(cubes: cubes))")
