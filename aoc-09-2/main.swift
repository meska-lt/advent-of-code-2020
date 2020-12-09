//
//  main.swift
//  aoc-09-2
//
//  Created by Robertas on 2020-12-09.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 9 Quest 2")

    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            print("Solution of input: \(solution(of: input))")
        }
    } catch {
        print(error)
    }
}

private func solution(of input: String) -> Int {
    let numberList = numbers(from: input)
    let firstInvalidNumberInList = firstInvalidNumber(in: numberList)
    let numbersThatSumToInvalidNumber = subset(of: numberList, withSum: firstInvalidNumberInList).sorted()

    return numbersThatSumToInvalidNumber.first! + numbersThatSumToInvalidNumber.last!
}

private func subset(of input: [Int], withSum targetSum: Int) -> [Int] {
    for subsetStartIndex in input.startIndex ..< input.count {
        var sumOfSubset = input[subsetStartIndex]
        var subsetEndIndex = subsetStartIndex + 1
        while (sumOfSubset <= targetSum) && (subsetEndIndex < input.count) {
            sumOfSubset += input[subsetEndIndex]
            if sumOfSubset == targetSum {
                return Array(input[subsetStartIndex ... subsetEndIndex])
            }
            subsetEndIndex += 1
        }
    }

    fatalError("Could not find invalid contiguous set in given input that sums to \(targetSum).")
}

private func firstInvalidNumber(in input: [Int]) -> Int {
    let preambleSize = 25
    var indexToCheck = input.startIndex
    while indexToCheck < input.count {
        if !isNumberValid(in: input, at: indexToCheck, with: preambleSize) {
            return input[indexToCheck]
        }
        indexToCheck += 1
    }

    fatalError("Could not find invalid number in given input.")
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
