//
//  main.swift
//  aoc-10-1
//
//  Created by Robertas on 2020-12-10.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 10 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let joltRatings = ratings(from: input).sorted()
            let result = multipleOfEdgeDifferences(in: joltRatings)
            print("Number of 1-jolt differences multiplied by the number of 3-jolt differences: \(result)")
        }
    } catch {
        print(error)
    }
}

private func multipleOfEdgeDifferences(in input: [Int]) -> Int {
    let tolerance = 3
    let builtInJoltRating = input.last! + tolerance
    let ratingChain = input
    var result = (oneJoltDiffs: 0, threeJoltDiffs: 0)
    
    for ratingIndex in ratingChain.startIndex ... ratingChain.endIndex {
        let difference: Int

        if ratingIndex == ratingChain.startIndex {
            difference = ratingChain[ratingIndex]
        } else if ratingIndex == ratingChain.endIndex {
            difference = builtInJoltRating - ratingChain[ratingIndex - 1]
        } else {
            difference = ratingChain[ratingIndex] - ratingChain[ratingIndex - 1]
        }

        switch difference {
        case 1: result.oneJoltDiffs += 1
        case 3: result.threeJoltDiffs += 1
        default: break
        }
    }

    return result.oneJoltDiffs * result.threeJoltDiffs
}

private func ratings(from input: String) -> [Int] {
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
