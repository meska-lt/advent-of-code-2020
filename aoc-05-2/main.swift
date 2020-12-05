//
//  main.swift
//  aoc-05-2
//
//  Created by Robertas on 2020-12-05.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 5 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let boardingPasses = input.split(separator: "\n").map(String.init)
            print("Entries to check: \(boardingPasses.count)")
            print("My seat ID: \(mySeatId(in: boardingPasses))")
        }
    } catch {
        print(error)
    }
}

private func mySeatId(in boardingPasses: [String]) -> Int {
    let seatIds = boardingPasses.map{ seatId(for: row(for: $0), column(for: $0)) }.sorted()
    for seatId in seatIds.first! ..< seatIds.last! {
        if !seatIds.contains(seatId + 1) {
            return seatId + 1
        }
    }
    fatalError("Could not find my seat ID")
}

private func row(for input: String) -> Int {
    var currentRowRange = (lower: 0, upper: 127)
    var lastSeenDirection: Character = input.first!
    input.forEach{ character in
        switch character {
            // lower half
            case "F":
                currentRowRange.upper -= (currentRowRange.upper - currentRowRange.lower) / 2 + 1
                lastSeenDirection = character
            // upper half
            case "B":
                currentRowRange.lower += (currentRowRange.upper - currentRowRange.lower) / 2 + 1
                lastSeenDirection = character
            default: break
        }
    }
    switch lastSeenDirection {
    case "F": return currentRowRange.lower
    case "B": return currentRowRange.upper
    default: fatalError("Failed to calculate the row")
    }
}

private func column(for input: String) -> Int {
    var currentColumnRange = (lower: 0, upper: 7)
    var lastSeenDirection: Character = input.first!
    input.forEach{ character in
        switch character {
            // lower half
            case "L":
                currentColumnRange.upper -= (currentColumnRange.upper - currentColumnRange.lower) / 2 + 1
                lastSeenDirection = character
            // upper half
            case "R":
                currentColumnRange.lower += (currentColumnRange.upper - currentColumnRange.lower) / 2 + 1
                lastSeenDirection = character
            default: break
        }
    }
    switch lastSeenDirection {
    case "L": return currentColumnRange.lower
    case "R": return currentColumnRange.upper
    default: fatalError("Failed to calculate the column")
    }
}

private func seatId(for row: Int, _ column: Int) -> Int {
    return row * 8 + column
}

main()
