//
//  main.swift
//  AOC2022_19
//
//  Created by Kaštovský Lubomír on 19.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

struct Blueprint {
    let oreRobotCostOre: Int
    let clayRobotCostOre: Int
    let obsidianRobotCostOre: Int
    let obsidianRobotCostClay: Int
    let geodeRobotCostOre: Int
    let geodeRobotCostObsidian: Int
}

typealias Blueprints = [Int: Blueprint]

struct StateOfWork: Hashable {
    var oreRobotsCount: Int
    var clayRobotsCount: Int
    var obsidianRobotsCount: Int
    var geodeRobotCount: Int
    var ore: Int
    var clay: Int
    var obsidian: Int
    var geode: Int
    
    init() {
        self.oreRobotsCount = 1
        self.clayRobotsCount = 0
        self.obsidianRobotsCount = 0
        self.geodeRobotCount = 0
        self.ore = 0
        self.clay = 0
        self.obsidian = 0
        self.geode = 0
    }
    
    init(oreRobotsCount: Int,
         clayRobotsCount: Int,
         obsidianRobotsCount: Int,
         geodeRobotCount: Int,
         ore: Int, clay: Int, obsidian: Int, geode: Int
    ) {
        self.oreRobotsCount = oreRobotsCount
        self.clayRobotsCount = clayRobotsCount
        self.obsidianRobotsCount = obsidianRobotsCount
        self.geodeRobotCount = geodeRobotCount
        self.ore = ore
        self.clay = clay
        self.obsidian = obsidian
        self.geode = geode
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(oreRobotsCount)
        hasher.combine(clayRobotsCount)
        hasher.combine(obsidianRobotsCount)
        hasher.combine(geodeRobotCount)
        hasher.combine(ore)
        hasher.combine(clay)
        hasher.combine(obsidian)
        hasher.combine(geode)
    }
}

// Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 5 clay. Each geode robot costs 3 ore and 15 obsidian.
func loadBlueprints(input: [String]) -> Blueprints {
    var result = Blueprints()
    input.forEach { line in
        let parts = line.components(separatedBy: [" ", ":"]).filter{ !$0.isEmpty }
        result[Int(parts[1])!] = Blueprint(
            oreRobotCostOre: Int(parts[6])!,
            clayRobotCostOre: Int(parts[12])!,
            obsidianRobotCostOre: Int(parts[18])!,
            obsidianRobotCostClay: Int(parts[21])!,
            geodeRobotCostOre: Int(parts[27])!,
            geodeRobotCostObsidian: Int(parts[30])!
        )
    }
    return result
}

func generateNewStates(state: StateOfWork, blueprint: Blueprint) -> Set<StateOfWork> {
    var result = Set<StateOfWork>()
    // make 0 or N possible robots from available ore
    var consumedOre = 0
    var consumedClay = 0
    var consumedObsidian = 0
    
    var addOR = 0
    var addCR = 0
    var addOBR = 0
    var addGR = 0
    
    for or in 0...1 {
        for cl in 0...1 {
            for ob in 0...1 {
                for ge in 0...1 {
                    consumedOre = 0
                    consumedClay = 0
                    consumedObsidian = 0
                    addOR = 0
                    addCR = 0
                    addOBR = 0
                    addGR = 0
                    
                    if or == 1 {
                        if state.ore >= blueprint.oreRobotCostOre {
                            consumedOre = blueprint.oreRobotCostOre
                            addOR = 1
                        }
                    } else if cl == 1 {
                        if state.ore >= blueprint.clayRobotCostOre {
                            consumedOre = blueprint.clayRobotCostOre
                            addCR = 1
                        }
                    } else if ob == 1 {
                        if state.ore >= blueprint.obsidianRobotCostOre && state.clay >= blueprint.obsidianRobotCostClay {
                            consumedOre = blueprint.obsidianRobotCostOre
                            consumedClay = blueprint.obsidianRobotCostClay
                            addOBR = 1
                        }
                    } else if ge == 1 {
                        if state.ore >= blueprint.geodeRobotCostOre && state.obsidian >= blueprint.geodeRobotCostObsidian {
                            consumedOre = blueprint.geodeRobotCostOre
                            consumedObsidian = blueprint.geodeRobotCostObsidian
                            addGR = 1
                        }
                    }
                    
                    let newState = StateOfWork(
                        oreRobotsCount: state.oreRobotsCount + addOR,
                        clayRobotsCount: state.clayRobotsCount + addCR,
                        obsidianRobotsCount: state.obsidianRobotsCount + addOBR,
                        geodeRobotCount: state.geodeRobotCount + addGR,
                        ore: state.ore - consumedOre + state.oreRobotsCount ,
                        clay: state.clay - consumedClay + state.clayRobotsCount,
                        obsidian: state.obsidian - consumedObsidian + state.obsidianRobotsCount,
                        geode: state.geode + state.geodeRobotCount
                    )
                    result.insert(newState)
                }
            }
        }
    }
    return result
}

func simulateWorking(blueprint: Blueprint, cycles: Int) -> Int {
    var workStates = Set<StateOfWork>()
    workStates.insert(StateOfWork())
    var newWorkStates = Set<StateOfWork>()
    for i in 0..<cycles {
        //print("cycle: \(i), count: \(workStates.count)")
        //print("g: ", workStates.max(by: { $0.geode < $1.geode })!.geode)
        //print("o: ", workStates.max(by: { $0.obsidian < $1.obsidian })!.obsidian)
        //print("----")
        workStates.forEach { state in
            let newStates = generateNewStates(state: state, blueprint: blueprint)
            newWorkStates.formUnion(newStates)
        }

        newWorkStates = newWorkStates.filter { state in
            if (state.ore > (blueprint.clayRobotCostOre + blueprint.oreRobotCostOre) && state.clayRobotsCount == 0 && state.oreRobotsCount == 0)
                || (state.clay > blueprint.obsidianRobotCostClay && state.ore > blueprint.obsidianRobotCostOre && state.obsidianRobotsCount == 0)
            {
                return false
            }
            return true
        }
        
        if i > 20 {
            if let maxGeodeRobots = newWorkStates.max(by: { $0.geodeRobotCount < $1.geodeRobotCount })?.geodeRobotCount {
                if maxGeodeRobots > 2 {
                    newWorkStates = newWorkStates.filter { $0.geodeRobotCount >= maxGeodeRobots - 1 }
                }
            }
        }
        
        workStates = newWorkStates
        newWorkStates.removeAll()
        //printStates(states: workStates, blueprint: blueprint)
    }
    return workStates.max(by: { $0.geode < $1.geode })?.geode ?? 0
}

func printStates(states: Set<StateOfWork>, blueprint: Blueprint) {
    print(blueprint)
    states.forEach {
        print("OR: \($0.oreRobotsCount), CR: \($0.clayRobotsCount), OBR: \($0.obsidianRobotsCount), GR: \($0.geodeRobotCount), O: \($0.ore), C: \($0.clay), OB: \($0.obsidian), G: \($0.geode)")
    }
}

func checkAllBlueprints(blueprints: Blueprints, cycles: Int) -> Int {
    var sum = 0
    blueprints.keys.sorted().forEach { key in
        let result = simulateWorking(blueprint: blueprints[key]!, cycles: cycles)
        sum += result * key
    }
    return sum
}

func checkAllBlueprints2(blueprints: Blueprints, cycles: Int) -> Int {
    var sum = 1
    blueprints.keys.sorted().forEach { key in
        let result = simulateWorking(blueprint: blueprints[key]!, cycles: cycles)
        sum = sum * result
    }
    return sum
}

let input = readLinesRemoveEmpty(str: inputString)
let blueprints = loadBlueprints(input: input)
//print(checkAllBlueprints(blueprints: blueprints, cycles: 24))

let blueprints2 = blueprints.filter { $0.key == 1 || $0.key == 2 || $0.key == 3 }
//print(checkAllBlueprints2(blueprints: blueprints2, cycles: 32))

print("Part 1 ...")
let start = DispatchTime.now()
let part1 = checkAllBlueprints(blueprints: blueprints, cycles: 24)
let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000

print("part 1: \(part1), time: \(timeInterval)")

print("\nPart 2 ...")
let start2 = DispatchTime.now()
let part2 = checkAllBlueprints2(blueprints: blueprints2, cycles: 32)
let end2 = DispatchTime.now()
let nanoTime2 = end2.uptimeNanoseconds - start2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000

print("part 2: \(part2), time: \(timeInterval2)")


/*
 Part 1 ...
 part 1: 1616, time: 217.355344958

 Part 2 ...
 part 2: 8990, time: 276.142920333
*/
