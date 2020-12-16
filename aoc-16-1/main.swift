//
//  main.swift
//  aoc-16-1
//
//  Created by Robertas on 2020-12-16.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 16 Quest 1")
    
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
            let nearbyTicketStrings = notes[2].replacingOccurrences(of: "nearby tickets:\n", with: "")
            let nearbyTickets = nearbyTicketStrings.split(separator: "\n").map(String.init).map { ticketNumbers(from: $0) }
            let errorRate = invalidTicketNumbers(from: nearbyTickets, accordingTo: rules).reduce(into: 0) { intermediateResult, invalidNumber in
                intermediateResult += invalidNumber
            }

            let endTimestamp = Date().timeIntervalSince1970
            print("Ticket scanning error rate: \(errorRate)")
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

private func invalidTicketNumbers(from tickets: [[Int]], accordingTo rules: [String : [Range<Int>]]) -> [Int] {
    return tickets.flatMap { ticket in
        ticket.filter { !isValidValue($0, accordingTo: rules) }
    }
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
