//
//  main.swift
//  aoc-19-1
//
//  Created by Robertas on 2020-12-19.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Rule {
    let subRuleLists: [[Int]]
    let match: Character?
}

func main() {
    print("Advent Of Code 2020: Day 19 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?.components(separatedBy: "\n\n") {
            let messages = input[1].components(separatedBy: "\n")
            let startTimestamp = Date().timeIntervalSince1970
            let ruleDict = ruleDictionary(from: input[0].split(separator: "\n").map(String.init))
            let targetRule = 0
            let validOptions = options(forRule: targetRule, in: ruleDict)
            let validMessages = messages.filter { validOptions.contains($0) }
            let endTimestamp = Date().timeIntervalSince1970
            print("Number of messages that completely match rule \(targetRule): \(validMessages.count)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func ruleDictionary(from input: [String]) -> [Int : Rule] {
    var result: [Int : Rule] = [:]

    input.forEach { ruleString in
        let splitRuleString = ruleString.components(separatedBy: ": ")
        let ruleIndex = Int(splitRuleString[0])!
        let charToMatch: Character?
        let subRules: [[Int]]

        if splitRuleString[1].contains("\"") {
            charToMatch = splitRuleString[1].replacingOccurrences(of: "\"", with: "").map { $0 }.first
            subRules = []
        } else {
            let subRuleStrings = splitRuleString[1].components(separatedBy: " | ")
            charToMatch = nil
            subRules = subRuleStrings.filter { $0.count > 0 }.map { subRuleString in
                return subRuleString.split(separator: " ").map { Int(String($0))! }
            }
        }
        result[ruleIndex] = Rule(subRuleLists: subRules, match: charToMatch)
    }
    
    return result
}

private func options(forRule ruleIndex: Int, in ruleDict: [Int : Rule]) -> [String] {
    guard let rule = ruleDict[ruleIndex] else {
        fatalError()
    }
    if let char = rule.match {
        return ["\(char)"]
    } else {
        var result: [String] = []
        
        for subRuleList in rule.subRuleLists {
            var subResults: [[String]] = []
            for subRule in subRuleList {
                subResults.append(options(forRule: subRule, in: ruleDict))
            }
            result.append(contentsOf: extractSubResults(subResults))
        }
        
        return result
    }
}

private func extractSubResults(_ subResult: [[String]]) -> [String] {
    var result: [String] = []

    for subResultListIndex in 0 ..< subResult.count {
        if subResultListIndex == 0 && result.isEmpty {
            result = subResult[subResultListIndex]
        } else {
            var newResult: [String] = []
            for subResultIndex in 0 ..< subResult[subResultListIndex].count {
                for resultIndex in 0 ..< result.count {
                    newResult.append(result[resultIndex] + subResult[subResultListIndex][subResultIndex])
                }
            }
            result = newResult
        }
    }

    return result
}

main()
