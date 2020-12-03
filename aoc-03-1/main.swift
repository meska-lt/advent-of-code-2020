//
//  main.swift
//  aoc-03-1
//
//  Created by Robertas on 2020-12-03.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 3 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    print("Input file: \(inputFilePath)")
    print("Input URL: \(inputURL)")

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let stepsRight = 3
            let stepsDown = 1
            print("Trees to encounter: \(trees(from: input, movingRight: stepsRight, down: stepsDown))")
        }
    } catch {
        print(error)
    }
}

private func trees(from input: String, movingRight right: Int, down: Int) -> Int {
    let rows = input.split(separator: "\n")
    let lastRowIndex = rows.count - 1
    var currentRowIndex = 0
    var currentColumnIndex = 0
    var result = 0

    while currentRowIndex < lastRowIndex {
        currentColumnIndex += right
        if currentColumnIndex >= rows[currentRowIndex].count {
            currentColumnIndex -= rows[currentRowIndex].count
        }
        currentRowIndex += down
        result += amount(of: "#", in: rows[currentRowIndex], at: currentColumnIndex)
    }
    
    return result
}

private func amount(of charToFind: Character, in row: String.SubSequence, at columnIndex: Int) -> Int {
    let charIndex = row.index(row.startIndex, offsetBy: columnIndex)
    switch row[charIndex] {
    case charToFind:
        return 1
    default:
        return 0
    }
}

main()
