//
//  main.swift
//  aoc-07-1
//
//  Created by Robertas on 2020-12-07.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Rule: Hashable {
    let color: String
    let containedColors: String
}

func main() {
    print("Advent Of Code 2020: Day 7 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let ruleList = rules(from: input)
            let colorToLook = "shiny gold"
            let results = rules(ruleList, thatContain: colorToLook)
            print("Amount of rules that contain \(colorToLook) color: \(results.count)")
        }
    } catch {
        print(error)
    }
}

private func rules(from input: String) -> [Rule] {
    let ruleStrings = input.split(separator: "\n").map(String.init)
    return ruleStrings.map{ ruleString in
        let ruleParts = ruleString.components(separatedBy: " bags contain ")
        return Rule(color: ruleParts[0], containedColors: ruleParts[1])
    }
}

private func rules(_ ruleList: [Rule], thatContain color: String) -> [Rule] {
    var result = ruleList.filter { rule in
        return rule.containedColors.contains(color)
    }

    for rule in result {
        let moreRules = rules(ruleList, thatContain: rule.color)
        result += moreRules.filter { !result.contains($0) }
    }
    
    return result
}

main()
