//
//  main.swift
//  aoc-05-1
//
//  Created by Robertas on 2020-12-05.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 5 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }
    
//    runTests()

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let boardingPasses = input.split(separator: "\n").map(String.init)
            print("Entries to check: \(boardingPasses.count)")
            print("Highest seat ID on a boarding pass: \(highestSeatId(in: boardingPasses))")
        }
    } catch {
        print(error)
    }
}

private func highestSeatId(in boardingPasses: [String]) -> Int {
    var result = 0
    boardingPasses.forEach{ boardingPass in
        let passRow = row(for: boardingPass)
        let passColumn = column(for: boardingPass)
        let passSeatId = seatId(for: passRow, passColumn)
        result = max(result, passSeatId)
    }
    return result
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

private func runTests() {
    [
        "FBFBBFFRLR",
        "BFFFBBFRRR",
        "FFFBBBFRRR",
        "BBFFBBFRLL"
    ].forEach{ testPass in
        let testPassRow = row(for: testPass)
        let testPassColumn = column(for: testPass)
        print("Row for boarding pass \(testPass): \(testPassRow)")
        print("Column for boarding pass \(testPass): \(testPassColumn)")
        print("Seat ID for boarding pass \(testPass): \(seatId(for: testPassRow, testPassColumn))")
    }
}

main()
