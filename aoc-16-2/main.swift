//
//  main.swift
//  aoc-16-2
//
//  Created by Robertas on 2020-12-16.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 16 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let notes = String(data: inputData, encoding: String.Encoding.utf8)?.components(separatedBy: "\n\n") {
            let startTimestamp = Date().timeIntervalSince1970

            let rules = ruleDictionary(from: notes[0].split(separator: "\n").map(String.init))
            let myTicketNumbers = ticketNumbers(from: notes[1].replacingOccurrences(of: "your ticket:\n", with: ""))
            let nearbyTicketStrings = notes[2].replacingOccurrences(of: "nearby tickets:\n", with: "")
            let nearbyTickets = nearbyTicketStrings.split(separator: "\n").map(String.init).map { ticketNumbers(from: $0) }
            let validNearbyTickets = nearbyTickets.filter { isValidTicket($0, accordingTo: rules) }
            var ruleIndex: [String : [Int]] = [:]

            let ticketValueAmount = validNearbyTickets.first?.count ?? 0

            for ticketValueIndex in 0 ..< ticketValueAmount {
                for key in rules.keys {
                    let ranges = rules[key]!
                    let everyTicketValueAtIndex  = validNearbyTickets.map { $0[ticketValueIndex] }
                    var isTicketValueInRuleRange = true
                    everyTicketValueAtIndex.forEach { ticketValue in
                        isTicketValueInRuleRange = isTicketValueInRuleRange && ranges.contains(where: { $0.contains(ticketValue) })
                    }
                    if isTicketValueInRuleRange {
                        var possibleIndexes = ruleIndex[key] ?? []
                        if !possibleIndexes.contains(ticketValueIndex) {
                            possibleIndexes.append(ticketValueIndex)
                        }
                        ruleIndex[key] = possibleIndexes
                    }
                }
            }
            
            repeat {
                for key in ruleIndex.keys {
                    let possibleIndexesOfRule = ruleIndex[key]!
                    if possibleIndexesOfRule.count == 1 {
                        let indexToRemove = possibleIndexesOfRule.first!
                        
                        ruleIndex.keys.forEach { ruleKey in
                            var possibleIndexes = ruleIndex[ruleKey]!
                            if possibleIndexes.count > 1 {
                                possibleIndexes.removeAll(where: { $0 == indexToRemove })
                            }
                            ruleIndex[ruleKey] = possibleIndexes
                        }
                    }
                }
            } while ruleIndex.values.contains(where: { $0.count > 1 })
            
            let resultRuleIndex = ruleIndex.filter { key, value in
                return key.hasPrefix("departure")
            }
            
            let result = resultRuleIndex.values.reduce(into: 0) { intermediateResult, valueIndexArray in
                let value = myTicketNumbers[valueIndexArray.first!]
                if (intermediateResult == 0) {
                    intermediateResult = value
                } else {
                    intermediateResult *= value
                }
            }
            
            print(result)

            let endTimestamp = Date().timeIntervalSince1970
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func ruleDictionary(from ruleStrings: [String]) -> [String : [Range<Int>]] {
    var result: [String : [Range<Int>]] = [:]
    ruleStrings.forEach { ruleString in
        let parts = ruleString.components(separatedBy: ": ")
        result[parts[0]] = ruleRanges(from: parts[1])
    }
    return result
}

private func ruleRanges(from string: String) -> [Range<Int>] {
    let valueStrings = string.components(separatedBy: " or ")
    var ranges: [Range<Int>] = []

    valueStrings.forEach { value in
        let rangeEnds = value.split(separator: "-")
        ranges.append(Int(rangeEnds[0])! ..< (Int(rangeEnds[1])! + 1))
    }

    return ranges
}

private func ticketNumbers(from ticket: String) -> [Int] {
    return ticket.split(separator: ",").map(String.init).map { Int($0) }.compactMap { $0 }
}

private func isValidTicket(_ ticket: [Int], accordingTo rules: [String : [Range<Int>]]) -> Bool {
    for ticketValue in ticket {
        if !isValidValue(ticketValue, accordingTo: rules) {
            return false
        }
    }
    return true
}

private func isValidValue(_ value: Int, accordingTo rules: [String : [Range<Int>]]) -> Bool {
    for ruleValueRanges in rules.values {
        for valueRange in ruleValueRanges {
            if valueRange.contains(value) {
                return true
            }
        }
    }
    return false
}

main()
