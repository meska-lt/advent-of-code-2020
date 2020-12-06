//
//  main.swift
//  aoc-06-2
//
//  Created by Robertas on 2020-12-06.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 6 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let result = sumOfCommonGroupAnswers(in: input)
            print("Sum of per-group common positive answers: \(result)")
        }
    } catch {
        print(error)
    }
}

private func sumOfCommonGroupAnswers(in input: String) -> Int {
    let groups = input.components(separatedBy: "\n\n").map{ $0.split(separator: "\n") }
    return groups.reduce(into: 0) { tempResult, group in
        let distinctAnswers = Set(group.joined())
        let commonAnswers = distinctAnswers.filter{ isCharacter($0, commonIn: group) }
        tempResult += commonAnswers.count
    }
}

private func isCharacter(_ character: Character, commonIn list: [String.SubSequence]) -> Bool {
    return list.map { $0.contains(character) }.filter { $0 }.count == list.count
}

main()
