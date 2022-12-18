//
//  main.swift
//  AOC2022_15
//
//  Created by Kaštovský Lubomír on 15.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

struct Sensor {
    let x: Int
    let y: Int
    let distance: Int
}

typealias Sensors = [Sensor]

func loadSensors(input: [String]) -> Sensors {
    var sensors = Sensors()
    input.forEach { line in
        let parts = line.components(separatedBy: [" ", ",", ":", "="]).filter { !$0.isEmpty }
        let sx = Int(parts[3])!
        let sy = Int(parts[5])!
        let bx = Int(parts[11])!
        let by = Int(parts[13])!
        let distance = abs(sx-bx) + abs(sy-by)
        sensors.append(Sensor(x: sx, y: sy, distance: distance))
    }
    sensors = sensors.sorted(by: { $0.x < $1.x })
    return sensors
}

func noBeaconsOnRow(row: Int, sensors: inout Sensors) -> [(Int, Int)] {
    var intervalsSorted = [(Int, Int)]()
    var intervals = [(Int, Int)]()
    var x1 = Int.max
    var x2 = Int.min
    sensors.forEach { sensor in
        if abs(row - sensor.y) <= sensor.distance {
            // it is in range
            let xDistance = sensor.distance - abs(row - sensor.y)
            let newX1 = sensor.x - xDistance
            let newX2 = sensor.x + xDistance
            intervalsSorted.append((newX1, newX2))
        }
    }
    intervalsSorted = intervalsSorted.sorted(by: { $0.0 < $1.0 })
    intervalsSorted.forEach { interval in
        if x1 == Int.max {
            x1 = interval.0
            x2 = interval.1
        } else {
            if x2 + 1 >= interval.0 {
                if interval.1 > x2 {
                    x2 = interval.1
                }
            } else {
                intervals.append((x1, x2))
                x1 = interval.0
                x2 = interval.1
            }
        }
        //print("x1: \(x1), x2: \(x2), newX1: \(interval.0), newX2: \(interval.1)")
    }
    intervals.append((x1, x2))
    return intervals
}

func noBeaconsCount(row: Int, sensors: inout Sensors) -> Int {
    let intervals = noBeaconsOnRow(row: row, sensors: &sensors)
    return intervals.reduce(0, { x, interval in
        x + (interval.1 - interval.0)
    })
}

func findBlindSpot(sensors: inout Sensors, miny: Int, maxy: Int) -> Int {
    for y in miny...maxy {
        let intervals = noBeaconsOnRow(row: y, sensors: &sensors)
        if intervals.count > 1 {
            return (intervals[0].1 + 1) * 4000000 + y
        }
    }
    return 0
}

let input = readLinesRemoveEmpty(str: inputString)
var sensors = loadSensors(input: input)

//print(noBeaconsOnRow(row: 10, sensors: sensors))
//print("Part 1: \(noBeaconsCount(row: 2000000, sensors: sensors))")

//print(findBlindSpot(sensors: sensors, miny: 0, maxy: 20))
//print("Part 2: \(findBlindSpot(sensors: sensors, miny: 0, maxy: 4000000))")


let startTime = DispatchTime.now()
let part1 = noBeaconsCount(row: 2000000, sensors: &sensors)
let endTime = DispatchTime.now()
let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000

print("Part 1: \(part1), time: \(timeInterval)")

let startTime2 = DispatchTime.now()
let part2 = findBlindSpot(sensors: &sensors, miny: 0, maxy: 4000000)
let endTime2 = DispatchTime.now()
let nanoTime2 = endTime2.uptimeNanoseconds - startTime2.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval2 = Double(nanoTime2) / 1_000_000_000

print("Part 2: \(part2), time: \(timeInterval2)")


