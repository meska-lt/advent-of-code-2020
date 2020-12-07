//
//  main.swift
//  aoc-07-2
//
//  Created by Robertas on 2020-12-07.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Capacity: Hashable {
    let color: String
    let amount: Int
}

struct Rule: Hashable {
    let color: String
    let containedColors: [Capacity]
}

func main() {
    print("Advent Of Code 2020: Day 7 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let colorToLook = "shiny gold"
            let result = amountOfBagsThatColorContains(colorToLook, from: input)
            
            print("Amount of bags that \(colorToLook) color contains: \(result)")
        }
    } catch {
        print(error)
    }
}

private func amountOfBagsThatColorContains(_ colorToLook: String, from input: String) -> Int {
    let ruleList = rules(from: input)
    var results = rules(ruleList, thatContainedBy: colorToLook)
    let lookupRule = results.removeFirst()
    var resultDict: [String : [Capacity]] = [:]
    results.forEach { result in
        resultDict[result.color] = result.containedColors
    }
    var grandTotal = 0

    for containedColor in lookupRule.containedColors {
        let capacity = sizeOf(containedColor.color, using: resultDict)
        grandTotal += capacity * containedColor.amount
    }

    return grandTotal
}

private func rules(from input: String) -> [Rule] {
    let ruleStrings = input.split(separator: "\n").map(String.init)
    return ruleStrings.map(rule(from:))
}

private func capacity(from input: [String]) -> [Capacity] {
    return input.map { capacityEntry in
        var splitCapacityEntry = capacityEntry.split(separator: " ").map(String.init)
        guard let amount = Int(splitCapacityEntry.removeFirst()) else {
            fatalError("Failed to parse capacity entry: \(capacityEntry)")
        }
        splitCapacityEntry.removeLast()
        return Capacity(color: splitCapacityEntry.joined(separator: " "), amount: amount)
    }
}

private func rule(from string: String) -> Rule {
    let parts = string.components(separatedBy: " bags contain ")
    let containedColors = parts[1].replacingOccurrences(of: ".", with: "").components(separatedBy: ", ")
    let capacityList: [Capacity]

    if containedColors.first == "no other bags" {
        capacityList = []
    } else {
        capacityList = capacity(from: containedColors)
    }

    return Rule(color: parts[0], containedColors: capacityList)
}

private func rules(_ ruleList: [Rule], thatContainedBy color: String) -> [Rule] {
    var result = ruleList.filter { $0.color == color }

    for rule in result {
        for capacityEntry in rule.containedColors {
            let moreRules = rules(ruleList, thatContainedBy: capacityEntry.color)
            result += moreRules.filter { !result.contains($0) }
        }
    }

    return result
}

private func sizeOf(_ color: String, using dict: [String : [Capacity]]) -> Int {
    guard let sizeEntries = dict[color] else {
        fatalError()
    }
    if sizeEntries.count < 1 {
        return 1
    } else {
        var sum = 1
        for entry in sizeEntries {
            let sizeOfEntry = sizeOf(entry.color, using: dict)
            sum += sizeOfEntry * entry.amount
        }
        return sum
    }
}

main()
