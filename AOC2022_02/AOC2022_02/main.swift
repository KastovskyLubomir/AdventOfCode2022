//
//  main.swift
//  AOC2022_02
//
//  Created by Kaštovský Lubomír on 02.12.2022.
//  Copyright © 2022 Kaštovský Lubomír. All rights reserved.
//

import Foundation


let games = readLinesRemoveEmpty(str: inputString)

func gameResult(input: String) -> Int {
    let turns = input.components(separatedBy: " ")
    let elf = turns[0]
    let me = turns[1]
    var score = 0
    switch me {
    case "X": // rock
        score += 1
        switch elf {
        case "A": score += 3
        case "B": score += 0
        case "C": score += 6
        default:break
        }
    case "Y": // paper
        score += 2
        switch elf {
        case "A": score += 6
        case "B": score += 3
        case "C": score += 0
        default:break
        }
    case "Z": // scissors
        score += 3
        switch elf {
        case "A": score += 0
        case "B": score += 6
        case "C": score += 3
        default:break
        }
    default:break
    }
    return score
}

func fixedGameResult(input: String) -> Int {
    let turns = input.components(separatedBy: " ")
    let elf = turns[0]
    let me = turns[1]
    var score = 0
    switch me {
    case "X": // loose
        score += 0
        switch elf {
        case "A": score += 3
        case "B": score += 1
        case "C": score += 2
        default:break
        }
    case "Y": // draw
        score += 3
        switch elf {
        case "A": score += 1
        case "B": score += 2
        case "C": score += 3
        default:break
        }
    case "Z": // win
        score += 6
        switch elf {
        case "A": score += 2
        case "B": score += 3
        case "C": score += 1
        default:break
        }
    default:break
    }
    return score
}

func totalScore(input: [String]) -> Int {
    var score = 0
    input.forEach {
        score += gameResult(input: $0)
    }
    return score
}

func totalScoreFixed(input: [String]) -> Int {
    var score = 0
    input.forEach {
        score += fixedGameResult(input: $0)
    }
    return score
}

print("Part 1: \(totalScore(input: games))")
print("Part 2: \(totalScoreFixed(input: games))")
