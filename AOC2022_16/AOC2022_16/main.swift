//
//  main.swift
//  AOC2022_16
//
//  Created by Kaštovský Lubomír on 16.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

struct Valve {
    let rate: Int
    let destNodes: [String]
}

struct Path {
    var valveNames: [String]
    var valveNamesEl: [String]
    var openValves: Set<String>
    var openValvesCmp: String
    var pressureAddition: Int
    var pressure: Int
}

typealias Graph = [String: Valve]

// Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
func createGraph(input: [String]) -> Graph {
    var graph = Graph()
    input.forEach { line in
        let parts = line.components(separatedBy: [" ", ";", "=", ","]).filter { !$0.isEmpty }
        var nodes = [String]()
        for i in 10..<parts.count {
            nodes.append(parts[i])
        }
        let node = Valve(rate: Int(parts[5])!, destNodes: nodes)
        graph[parts[1]] = node
    }
    return graph
}

func maxPressure(paths: [Path]) -> Int {
    var maxPressure = 0
    for path in paths {
        if path.pressure >= maxPressure {
            maxPressure = path.pressure
        }
    }
    return maxPressure
}

func pressure(graph: inout Graph, steps: Int, start: String) -> Int {
    var paths = [Path(valveNames: [start], valveNamesEl: [start], openValves: [], openValvesCmp: "", pressureAddition: 0, pressure: 0)]
    let nonzeroValvesCount = graph.filter { $0.value.rate != 0 }.count
    var newPaths = [Path]()
    for _ in 1...steps {
        for p in paths {
            let path = p
            let valveName = path.valveNames.last!
            let newPressure = path.pressure + path.pressureAddition
            if path.openValves.count == nonzeroValvesCount {
                newPaths.append(
                    Path(valveNames: path.valveNames,
                         valveNamesEl: path.valveNamesEl,
                         openValves: path.openValves,
                         openValvesCmp: String(path.openValves.sorted().joined()),
                         pressureAddition: path.pressureAddition,
                         pressure: newPressure)
                )
            } else {
                if graph[valveName]!.rate != 0 && !path.openValves.contains(valveName) {
                    // then add new opened valve
                    var newOpen = path.openValves
                    newOpen.insert(valveName)
                    let newPressureAddition = path.pressureAddition + graph[valveName]!.rate
                    newPaths.append(
                        Path(valveNames: path.valveNames,
                             valveNamesEl: path.valveNamesEl,
                             openValves: newOpen,
                             openValvesCmp: String(newOpen.sorted().joined()),
                             pressureAddition: newPressureAddition,
                             pressure: newPressure)
                    )
                }
                for valve in graph[valveName]!.destNodes {
                    if !paths.contains(where: { $0.valveNames.last! == valve && $0.pressureAddition > path.pressureAddition && $0.pressure > path.pressure }) {
                        let newPath = Path(
                            valveNames: path.valveNames + [valve],
                            valveNamesEl: path.valveNamesEl,
                            openValves: path.openValves,
                            openValvesCmp: String(path.openValves.sorted().joined()),
                            pressureAddition: path.pressureAddition,
                            pressure: newPressure
                        )
                        newPaths.append(newPath)
                    }
                }
            }
        }
        paths = newPaths
        newPaths.removeAll()
    }
    
    let maxPressure = maxPressure(paths: paths)
    
    return maxPressure
}


func pressure2(graph: inout Graph, steps: Int, start: String) -> Int {
    var paths = [Path(valveNames: [start], valveNamesEl: [start], openValves: [], openValvesCmp: "", pressureAddition: 0, pressure: 0)]
    let nonzeroValvesCount = graph.filter { $0.value.rate != 0 }.count
    var newPaths = [Path]()
    var allOpenPressure = Int.min
    var valveName = ""
    var valveNameEl = ""
    var newOpen = Set<String>()
    var newPressureAddition = 0
    
    for i in 1...steps {
        for path in paths {
            valveName = path.valveNames.last!
            // new released gas number
            let newPressure = path.pressure + path.pressureAddition
            
            // simulate possible moves of human
            if path.openValves.count == nonzeroValvesCount {
                newPaths.append(
                    Path(valveNames: path.valveNames,
                         valveNamesEl: path.valveNamesEl,
                         openValves: path.openValves,
                         openValvesCmp: String(path.openValves.sorted().joined()),
                         pressureAddition: path.pressureAddition,
                         pressure: newPressure)
                )
                if newPressure > allOpenPressure {
                    // max pressure for state where everything is open
                    // all states with lower pressure and not everything open will be removed
                    allOpenPressure = newPressure
                }
            } else {
                // can open valve
                if graph[valveName]!.rate != 0 && !path.openValves.contains(valveName) {
                    // then add new opened valve
                    newOpen = path.openValves
                    newOpen.insert(valveName)
                    newPressureAddition = path.pressureAddition + graph[valveName]!.rate
                    newPaths.append(
                        Path(valveNames: path.valveNames,
                             valveNamesEl: path.valveNamesEl,
                             openValves: newOpen,
                             openValvesCmp: String(newOpen.sorted().joined()),
                             pressureAddition: newPressureAddition,
                             pressure: newPressure)
                    )
                }
                for valve in graph[valveName]!.destNodes {
                    // don't include path on same valve but with
                    if !paths.contains(where: { $0.valveNames.last! == valve && $0.pressureAddition > path.pressureAddition && $0.pressure >= newPressure })
                        && path.valveNamesEl.last! != valve
                    {
                        let newPath = Path(
                            valveNames: path.valveNames + [valve],
                            valveNamesEl: path.valveNamesEl,
                            openValves: path.openValves,
                            openValvesCmp: String(path.openValves.sorted().joined()),
                            pressureAddition: path.pressureAddition,
                            pressure: newPressure
                        )
                        newPaths.append(newPath)
                    }
                }
            }
        }
        
        paths = newPaths
        newPaths.removeAll()
        
        // reduce space
        if allOpenPressure > Int.min {
            paths = paths.filter { $0.pressure >= allOpenPressure }
        }
        paths = reduceSpace(inPaths: paths, step: i)
        
        // simulate elephant move
        for path in paths {
            valveNameEl = path.valveNamesEl.last!
            if path.openValves.count == nonzeroValvesCount {
                newPaths.append(
                    Path(valveNames: path.valveNames,
                         valveNamesEl: path.valveNamesEl,
                         openValves: path.openValves,
                         openValvesCmp: String(path.openValves.sorted().joined()),
                         pressureAddition: path.pressureAddition,
                         pressure: path.pressure)
                )
                if path.pressure > allOpenPressure {
                    // max pressure for state where everything is open
                    // all states with lower pressure and not everything open will be removed
                    allOpenPressure = path.pressure
                }
            } else {
                // can open valve
                if graph[valveNameEl]!.rate != 0 && !path.openValves.contains(valveNameEl) {
                    // then add new opened valve
                    newOpen = path.openValves
                    newOpen.insert(valveNameEl)
                    let newPressureAddition = path.pressureAddition + graph[valveNameEl]!.rate
                    newPaths.append(
                        Path(valveNames: path.valveNames,
                             valveNamesEl: path.valveNamesEl,
                             openValves: newOpen,
                             openValvesCmp: String(newOpen.sorted().joined()),
                             pressureAddition: newPressureAddition,
                             pressure: path.pressure)  // presure already added
                    )
                }
                
                for valve in graph[valveNameEl]!.destNodes {
                    if !paths.contains(where: { $0.valveNamesEl.last! == valve && $0.pressureAddition > path.pressureAddition && $0.pressure >= path.pressure })
                        && path.valveNames.last! != valve
                    {
                        let newPath = Path(
                            valveNames: path.valveNames,
                            valveNamesEl: path.valveNamesEl + [valve], // adding elephant path
                            openValves: path.openValves,
                            openValvesCmp: String(path.openValves.sorted().joined()),
                            pressureAddition: path.pressureAddition,
                            pressure: path.pressure // presure already added
                        )
                        newPaths.append(newPath)
                    }
                }
            }
        }
        
        paths = newPaths
        newPaths.removeAll()
        
        // reduce space
        if allOpenPressure > Int.min {
            paths = paths.filter { $0.pressure >= allOpenPressure }
        }
        paths = reduceSpace(inPaths: paths, step: i)
    }
    
    let maxPressure = maxPressure(paths: paths)
    return maxPressure
}

func reduceSpace(inPaths: [Path], step: Int) -> [Path] {
    var paths = inPaths
    let openValvesDiff = step > 15 ? 1 : 2 // with increasing steps we can be more strict
    let pressureAdditionDivider = step > 15 ? 5 : 2 // with increasing steps we can be more strict

    paths = paths.filter { path in
        // don't want paths on same position with less open valves
        !paths.contains(where: {
            ($0.valveNamesEl.last! == path.valveNamesEl.last!
            && $0.valveNames.last! == path.valveNames.last!
            && $0.openValves.count > path.openValves.count)
        })
        ||
        // don't want paths on same position with smaller pressure and releasing less gass
        !paths.contains(where: {
            ($0.valveNamesEl.last! == path.valveNamesEl.last!
            && $0.valveNames.last! == path.valveNames.last!
             && $0.pressure > path.pressure && $0.pressureAddition > path.pressureAddition)
        })
        ||
        // don't want paths with same open valves but lower pressure sum
        paths.contains(where: {
            ($0.openValvesCmp == path.openValvesCmp
            && $0.pressure > path.pressure && $0.pressureAddition == path.pressureAddition)
        })
    }
    
    // don't want paths with too low pressure in comparison to the best gas releasing paths available
    let highestPressure = paths.max(by: { $0.pressure < $1.pressure })!.pressure
    let highestAddition = paths.filter { $0.pressure == highestPressure }.max(by: { $0.pressureAddition < $1.pressureAddition })!.pressureAddition
    paths = paths.filter { path in
        path.pressure >= (highestPressure - highestAddition/pressureAdditionDivider)
    }
    
    // don't want paths where the number of open valves is lower in comparison to paths with most open valves
    let maxOpenCount = paths.max(by: { $0.openValves.count < $1.openValves.count })!.openValves.count
    paths = paths.filter { path in
        path.openValves.count >= (maxOpenCount - openValvesDiff)
    }
    
    return paths
}

func printPaths(_ input: [Path], pattern: [String]? = nil) {
    input.sorted(by: { $0.openValves.count < $1.openValves.count }).forEach {
        if let pat = pattern, $0.valveNamesEl.joined() == pat.joined() {
            print($0)
        } else {
            if pattern == nil {
                print($0)
            }
        }
    }
}


let input = readLinesRemoveEmpty(str: inputString)
var graph = createGraph(input: input)

print(pressure(graph: &graph, steps: 30, start: "AA"))
print(pressure2(graph: &graph, steps: 26, start: "AA"))


// TODO: Find better way how to solve this. Currently it's a mess.
