//
//  main.swift
//  AOC2022_11
//
//  Created by Kaštovský Lubomír on 10.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation

struct Monkey {
    var items: [Int]
    let operation: String
    let value: String
    let testValue: Int
    let trueMonkey: Int
    let falseMonkey: Int
    var inspected: Int
    
    func worryLevel(oldValue: Int) -> Int {
        let val = value == "old" ? oldValue : Int(value)!
        if operation == "+" {
            return oldValue + val
        } else if operation == "*" {
            return oldValue * val
        }
        return 0
    }
}

func primeFactors(n: Int) -> [Int] {
    guard n >= 4 else {
        return [n]
    }
    let lim = Int(sqrt(Double(n)))
    for x in 2...lim {
        if n % x == 0 {
            var result = [x]
            result.append(contentsOf: primeFactors(n: n / x))
            return result
        }
    }
    return [n]
}

func loadMonkeys(input: [String]) -> [Int: Monkey] {
    var dir = [Int:Monkey]()
    var i = 0
    while i<input.count {
        if input[i].contains("Monkey") {
            let parts = input[i+1].components(separatedBy: ":").filter { !$0.isEmpty }
            let items = parts[1].components(separatedBy: [" ", ","]).filter { !$0.isEmpty }.map { Int($0)! }
            let partsO = input[i+2].components(separatedBy: " ").filter { !$0.isEmpty }
            let testValue = Int(input[i+3].components(separatedBy: " ").filter{ !$0.isEmpty }[3])!
            let trueMonkey = Int(input[i+4].components(separatedBy: " ").filter{ !$0.isEmpty }[5])!
            let falseMonkey = Int(input[i+5].components(separatedBy: " ").filter{ !$0.isEmpty }[5])!
            dir[i/6] = Monkey(
                items: items,
                operation: partsO[4],
                value: partsO[5],
                testValue: testValue,
                trueMonkey: trueMonkey,
                falseMonkey: falseMonkey,
                inspected: 0
            )
        }
        i += 6
    }
    return dir
}

func simulate(rounds: Int, monkeys: inout [Int: Monkey], division: Bool) {
    var lcm = 1
    
    if !division {
        let primes = monkeys.map { primeFactors(n: $0.value.testValue) }.joined()
        let primesFiltered = Set(primes).compactMap { $0 }
        primesFiltered.forEach { lcm *= $0 }
    }
    
    for _ in 0..<rounds {
        for j in 0..<monkeys.count {
            let monkey = monkeys[j]!
            let items = monkey.items
            items.forEach { item in
                var level = division ? monkey.worryLevel(oldValue: item) / 3 : monkey.worryLevel(oldValue: item)
                if !division {
                    level = level % lcm
                }
                if level % monkey.testValue == 0 {
                    monkeys[monkey.trueMonkey]!.items.append(level)
                } else {
                    monkeys[monkey.falseMonkey]!.items.append(level)
                }
            }
            monkeys[j]!.inspected += monkey.items.count
            monkeys[j]!.items = []
        }
    }
}

func printItems(monkeys: [Int: Monkey]) {
    for i in 0..<monkeys.count {
        print(monkeys[i]!.items)
    }
}

let input = readLinesRemoveEmpty(str: inputString)
var monkeys = loadMonkeys(input: input)
var monkeys2 = monkeys

simulate(rounds: 20, monkeys: &monkeys, division: true)
let inspections = monkeys.compactMap { $0.value.inspected }.sorted()
print("Part 1: ", inspections[inspections.count-1] * inspections[inspections.count-2])

simulate(rounds: 10000, monkeys: &monkeys2, division: false)
let inspections2 = monkeys2.compactMap { $0.value.inspected }.sorted()
print("Part 2: ", inspections2[inspections2.count-1] * inspections2[inspections2.count-2])
