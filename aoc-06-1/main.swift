//
//  main.swift
//  aoc-06-1
//
//  Created by Robertas on 2020-12-06.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 6 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let result = sumOfDistinctGroupAnswers(in: input)
            print("Sum of per-group distinct positive answers: \(result)")
        }
    } catch {
        print(error)
    }
}

private func sumOfDistinctGroupAnswers(in input: String) -> Int {
    var result: Int = 0
    let groupAnswerList = input.components(separatedBy: "\n\n")
    groupAnswerList.forEach{ groupAnswers in
        result += distinctGroupAnswers(from: groupAnswers)
    }
    return result
}

private func distinctGroupAnswers(from peopleAnswers: String) -> Int {
    var distinctGroupAnswers: Set<Character> = []
    peopleAnswers
        .components(separatedBy: "\n")
        .forEach{ personAnswers in
            personAnswers.forEach{ distinctGroupAnswers.insert($0) }
        }
    return distinctGroupAnswers.count
}

main()
