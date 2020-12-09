//
//  main.swift
//  aoc-09-1
//
//  Created by Robertas on 2020-12-09.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 9 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            print("First invalid number in input: \(firstInvalidNumber(in: input))")
        }
    } catch {
        print(error)
    }
}

private func firstInvalidNumber(in input: String) -> Int {
    let preambleSize = 25
    let numbersToCheck = numbers(from: input)
    var indexToCheck = numbersToCheck.startIndex
    while indexToCheck < numbersToCheck.count {
        if !isNumberValid(in: numbersToCheck, at: indexToCheck, with: preambleSize) {
            return numbersToCheck[indexToCheck]
        }
        indexToCheck += 1
    }
    fatalError("Could not find invalid number in input.")
}

private func isNumberValid(in input: [Int], at index: Int, with preambleSize: Int) -> Bool {
    guard index >= preambleSize else {
        return true
    }
    let numberToCheck = input[index]
    let preamble = Array(input[(index - preambleSize) ..< index])

    for previousNumber in preamble {
        for anotherNumber in preamble {
            if anotherNumber == previousNumber {
                continue
            }
            if numberToCheck - previousNumber == anotherNumber {
                return true
            }
        }
    }

    return false
}

private func numbers(from input: String) -> [Int] {
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
