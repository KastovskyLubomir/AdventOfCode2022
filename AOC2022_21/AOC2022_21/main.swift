//
//  main.swift
//  AOC2022_21
//
//  Created by Lubomir Kastovsky on 20.12.2022.
//  Copyright © 2022 Lubomir Kastovsky. All rights reserved.
//

import Foundation

enum MonkeyOperation {
    case add
    case sub
    case div
    case mul
}

struct Monkey {
    let operation: MonkeyOperation?
    let value: Int?
    let leftOperand: String?
    let rightOperand: String?
}

typealias Monkeys = [String: Monkey]

func loadMonkeys(input: [String]) -> Monkeys {
    var monkeys = Monkeys()
    input.forEach { line in
        let parts = line.components(separatedBy: [" ", ":"]).filter { !$0.isEmpty }
        if let value = Int(parts[1]) {
            monkeys[parts[0]] = Monkey(operation: nil, value: value, leftOperand: nil, rightOperand: nil)
        } else {
            var op: MonkeyOperation = .add
            if parts[2] == "-" {
                op = .sub
            }
            if parts[2] == "/" {
                op = .div
            }
            if parts[2] == "*" {
                op = .mul
            }
            monkeys[parts[0]] = Monkey(operation: op, value: nil, leftOperand: parts[1], rightOperand: parts[3])
        }
    }
    return monkeys
}

func computeRoot(rootName: String, monkeys: inout Monkeys) -> Int {
    if let monkey = monkeys[rootName] {
        if let value = monkey.value {
            return value
        } else if let op = monkey.operation, let leftName = monkey.leftOperand, let rightName = monkey.rightOperand {
            let left = computeRoot(rootName: leftName, monkeys: &monkeys)
            let right = computeRoot(rootName: rightName, monkeys: &monkeys)
            switch op {
            case .add: return left + right
            case .sub: return left - right
            case .div: return left / right
            case .mul: return left * right
            }
        }
    }
    return 0
}

func constructExpressions(rootName: String, monkeys: inout Monkeys) -> (Int?, String?) {
    if let monkey = monkeys[rootName] {
        if rootName == "root" {
            let left = constructExpressions(rootName: monkey.leftOperand!, monkeys: &monkeys)
            let right = constructExpressions(rootName: monkey.rightOperand!, monkeys: &monkeys)
            var leftStr = left.1
            var rightStr = right.1
            if let leftNum = left.0 {
                leftStr = String(leftNum)
            }
            if let rightNum = right.0 {
                rightStr = String(rightNum)
            }
            print("Left has humn: ", leftStr!.contains("humn"))
            print("Right has humn: ", rightStr!.contains("humn"))
            
            if leftStr!.contains("humn") {
                let result = consumeExpression(expr: leftStr!, equalValue: right.0!)
                return (result, "humn")
            } else if rightStr!.contains("humn") {
                let result = consumeExpression(expr: rightStr!, equalValue: left.0!)
                return (result, "humn")
            }
            
            return (nil, leftStr! + "  ==  " + rightStr!)
        } else if rootName == "humn" {
            return (nil, "humn")
        } else if let value = monkey.value {
            return (value, nil)
        } else if let op = monkey.operation, let leftName = monkey.leftOperand, let rightName = monkey.rightOperand {
            let left = constructExpressions(rootName: leftName, monkeys: &monkeys)
            let right = constructExpressions(rootName: rightName, monkeys: &monkeys)
            if let leftNumber = left.0, let rightNumber = right.0 {
                switch op {
                case .add: return (leftNumber + rightNumber, nil)
                case .sub: return (leftNumber - rightNumber, nil)
                case .div: return (leftNumber / rightNumber, nil)
                case .mul: return (leftNumber * rightNumber, nil)
                }
            } else if let leftStr = left.1, let rightStr = right.1 {
                switch op {
                case .add: return (nil, "(" + leftStr + "+" + rightStr + ")")
                case .sub: return (nil, "(" + leftStr + "-" + rightStr + ")")
                case .div: return (nil, "(" + leftStr + "/" + rightStr + ")")
                case .mul: return (nil, "(" + leftStr + "*" + rightStr + ")")
                }
            } else {
                var leftStr = left.1
                var rightStr = right.1
                if let leftNum = left.0 {
                    leftStr = String(leftNum)
                }
                if let rightNum = right.0 {
                    rightStr = String(rightNum)
                }
                switch op {
                case .add: return (nil, "(" + leftStr! + "+" + rightStr! + ")")
                case .sub: return (nil, "(" + leftStr! + "-" + rightStr! + ")")
                case .div: return (nil, "(" + leftStr! + "/" + rightStr! + ")")
                case .mul: return (nil, "(" + leftStr! + "*" + rightStr! + ")")
                }
            }
        }
    }
    return (nil, nil)
}

func consumeExpression(expr: String, equalValue: Int) -> Int {
    var tmpExpr = Array(expr)
    var result = equalValue
    
    print("\(String(tmpExpr)) == \(equalValue)")
    
    while tmpExpr.count > 1 {
        print(String(tmpExpr))
        if tmpExpr.first! == "h" {
            return result
        }
        tmpExpr.removeFirst()
        tmpExpr.removeLast()
        if tmpExpr.first!.isNumber {
            var value = 0
            while tmpExpr.first!.isNumber {
                value = Int(String(tmpExpr.removeFirst()))! + (value * 10)
            }
            switch tmpExpr.first! {
            case "+": result -= value
            case "-": result = (result - value) * (-1)
            case "/": break
            case "*": result /= value
            default:break
            }
            tmpExpr.removeFirst()
        } else if tmpExpr.last!.isNumber {
            var value = ""
            while tmpExpr.last!.isNumber {
                value = String(tmpExpr.removeLast()) + value
            }
            let numValue = Int(value)!
            switch tmpExpr.last! {
            case "+": result -= numValue
            case "-": result += numValue
            case "/": result *= numValue
            case "*": result /= numValue
            default:break
            }
            tmpExpr.removeLast()
        }
        print(String(tmpExpr))
        print(result)
    }
    return Int.max
}

let input = readLinesRemoveEmpty(str: inputString)
var monkyes = loadMonkeys(input: input)

print(computeRoot(rootName: "root", monkeys: &monkyes))
print(constructExpressions(rootName: "root", monkeys: &monkyes))
