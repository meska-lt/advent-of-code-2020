//
//  main.swift
//  aoc-01-1
//
//  Created by Robertas on 2020-12-01.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 1 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)
    let sumToFind = 2020

    print("Input file: \(inputFilePath)")
    print("Input URL: \(inputURL)")

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let entryList = entries(from: input)
            print("Entries to check: \(entryList.count)")
            let result = multipleOfMembers(of: entryList, thatSum: sumToFind)
            print("Multiple of members that sum to \(sumToFind): \(result)")
        }
    } catch {
        print(error)
    }
}

private func multipleOfMembers(of entryList: [Int], thatSum targetSum: Int) -> Int {
    var firstEntryIndex = 0
    var secondEntryIndex = 1

    while firstEntryIndex < entryList.count {
        while secondEntryIndex < entryList.count {
            if firstEntryIndex != secondEntryIndex {
                let firstEntry = entryList[firstEntryIndex]
                let secondEntry = entryList[secondEntryIndex]
                let sum = firstEntry + secondEntry
                if sum == targetSum {
                    return firstEntry * secondEntry
                }
            }
            secondEntryIndex += 1
        }
        firstEntryIndex += 1
        secondEntryIndex = firstEntryIndex + 1
    }

    fatalError("Could not find different entries that would sum up to \(targetSum)")
}

private func entries(from input: String) -> [Int] {
    var result: [Int] = []
    let scanner = Scanner(string: input)
    var continueScan: Bool = true

    while continueScan {
        var scanResult: Int = 0
        continueScan = scanner.scanInt(&scanResult)
        if continueScan {
            result.append(scanResult)
        }
    }
    
    return result
}

main()
