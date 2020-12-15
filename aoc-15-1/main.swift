//
//  main.swift
//  aoc-15-1
//
//  Created by Robertas on 2020-12-15.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 15 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\n", with: "").split(separator: ",").compactMap({ Int($0) }) {
            let targetTurn = 2020
            let startTimestamp = Date().timeIntervalSince1970
            let targetNumber = lastNumberSpoken(at: targetTurn, startingWith: input)
            let endTimestamp = Date().timeIntervalSince1970
            print("Last number spoken is: \(targetNumber)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func lastNumberSpoken(at targetTurn: Int, startingWith input: [Int]) -> Int {
    var lastNumberSpoken: Int = 0
    var numbersSpoken: [Int] = []

    for turn in 0 ..< targetTurn {
        if turn < input.count {
            lastNumberSpoken = input[turn]
        } else if numbersSpoken.filter({ $0 == lastNumberSpoken }).count > 1 {
            lastNumberSpoken = age(of: lastNumberSpoken, in: numbersSpoken)
        } else {
            lastNumberSpoken = 0
        }
        numbersSpoken.append(lastNumberSpoken)
    }
    
    return lastNumberSpoken
}

private func age(of lastNumberSpoken: Int, in numbersSpoken: [Int]) -> Int {
    let lastIndexOfNumberSpoken = numbersSpoken.lastIndex(of: lastNumberSpoken)!
    let secondToLastIndexOfNumberSpoken = numbersSpoken[numbersSpoken.startIndex ..< lastIndexOfNumberSpoken].lastIndex(of: lastNumberSpoken)!
    return lastIndexOfNumberSpoken - secondToLastIndexOfNumberSpoken
}

main()
