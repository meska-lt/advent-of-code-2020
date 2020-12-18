//
//  main.swift
//  aoc-18-2
//
//  Created by Robertas on 2020-12-18.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 18 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let expressions = String(data: inputData, encoding: String.Encoding.utf8)?.split(separator: "\n").map(String.init) {
            let startTimestamp = Date().timeIntervalSince1970
            let result = expressions.reduce(into: 0) { intermediateResult, expression in
                let expressionResult = evaluate(expression)
                print("Expression \(expression) result is: \(expressionResult).")
                intermediateResult += expressionResult
            }
            let endTimestamp = Date().timeIntervalSince1970
            print("Sum of expression results is: \(result).")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func evaluate(_ input: String) -> Int {
    var expression = input
    
    repeat {
        expression = eliminateParentheses(in: expression)
    } while expression.contains("(") || expression.contains(")")
    
    repeat {
        expression = eliminateSum(in: expression)
    } while expression.contains("+")

    let simpleExpression = expression.split(separator: " ").map(String.init)
    var cursor = simpleExpression.startIndex
    var result = 0

    while cursor < simpleExpression.endIndex {
        if cursor == simpleExpression.startIndex {
            result = Int(simpleExpression[cursor])!
        } else {
            switch simpleExpression[cursor - 1] {
            case "+": result += Int(simpleExpression[cursor])!
            case "*": result *= Int(simpleExpression[cursor])!
            default: break
            }
        }
        cursor += 1
    }
    
    return result
}

private func eliminateParentheses(in expression: String) -> String {
    if let lastOpeningIndex = expression.lastIndex(of: "(") {
        let openingIndex = expression.index(after: lastOpeningIndex)
        guard let firstClosingIndex = expression[openingIndex...].firstIndex(of: ")") else {
            fatalError()
        }
        let subexpression = String(expression[openingIndex ..< firstClosingIndex])
        var result = expression
        result.replaceSubrange(lastOpeningIndex ... firstClosingIndex, with: "\(evaluate(subexpression))")
        return result
    } else {
        return expression
    }
}

private func eliminateSum(in expression: String) -> String {
    guard let firstSumIndex = expression.firstIndex(of: "+") else {
        return expression
    }
    let firstOperandStartIndex: Substring.Index
    if let startIndex = expression[expression.startIndex ..< expression.index(before:firstSumIndex)].lastIndex(of: " ") {
        firstOperandStartIndex = expression.index(after: startIndex)
    } else {
        firstOperandStartIndex = expression.startIndex
    }
    let firstOperand = Int(expression[firstOperandStartIndex ..< expression.index(before:firstSumIndex)])!
    let secondOperandStartIndex = expression.index(firstSumIndex, offsetBy: 2)
    let secondOperandEndIndex = expression[secondOperandStartIndex...].firstIndex(of: " ") ?? expression.endIndex
    let secondOperandString = expression[secondOperandStartIndex ..< secondOperandEndIndex]
    var result = expression
    result.replaceSubrange(firstOperandStartIndex ..< expression.index(firstSumIndex, offsetBy: 2 + secondOperandString.count), with: "\(firstOperand + Int(secondOperandString)!)")
    return result
}

main()
