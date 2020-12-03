//
//  main.swift
//  aoc-03-2
//
//  Created by Robertas on 2020-12-03.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 3 Quest 2")
    
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
            print("Encountered trees multiplied: \(multipleOfTreesEncountered(in: input))")
        }
    } catch {
        print(error)
    }
}

private func multipleOfTreesEncountered(in input: String) -> Int {
    let movementVariantions = [
        (right: 1, down: 1),
        (right: 3, down: 1),
        (right: 5, down: 1),
        (right: 7, down: 1),
        (right: 1, down: 2)
    ]
    var treesEncountered: [Int] = []
    movementVariantions.forEach{ variation in
        let treesForVariation = trees(from: input, movingRight: variation.right, down: variation.down)
        print("Trees to encounter moving \(variation.right) right and \(variation.down) down: \(treesForVariation)")
        treesEncountered.append(treesForVariation)
    }
    var result = 0
    treesEncountered.forEach{ treeAmount in
            result = (result < 1 ? 1 : result) * treeAmount
    }
    return result
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
