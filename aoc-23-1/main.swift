//
//  main.swift
//  aoc-23-1
//
//  Created by Robertas on 2020-12-23.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 23 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\n", with: "") {
            let startTimestamp = Date().timeIntervalSince1970

            var cups = input.map({ Int("\($0)")! })
            var currentCupIndex: Int = 0
            let turnAmount = 100
            
            for turnNumber in 1...turnAmount
            {
                print("-- move \(turnNumber) --")
                print("cups: \(cups)".replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: ""))
                let currentCupLabel = cups[currentCupIndex]
                cups = cupCircleAfterMove(cups, current: currentCupIndex)
                currentCupIndex = (cups.firstIndex(of: currentCupLabel)! + 1) % cups.count
            }
            print("-- final --")
            print("cups: \(cups)".replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: ""))
            let resultStartCupLabel = 1
            let result = "\(cupOrderAfter(resultStartCupLabel, in: cups))"
                .replacingOccurrences(of: ", ", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
            let endTimestamp = Date().timeIntervalSince1970
            print("labels on the cups after cup \(resultStartCupLabel): \(result)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func cupCircleAfterMove(_ cups: [Int], current currentCupIndex: Int) -> [Int] {
    var pickedUpCupIndexes: [Int] = []
    var cupCircle = cups

    for offset in (1 ... 3).reversed() {
        let cupIndex = (currentCupIndex + offset) % cups.count
        pickedUpCupIndexes.append(cupIndex)
        cupCircle.removeAll(where: { $0 == cups[cupIndex] })
    }
    
    print("pick up: \(pickedUpCupIndexes.reversed().map { cups[$0] })")
    
    var destinationCupLabel = cups[currentCupIndex]
    var destinationCupIndex: Int?

    repeat {
        destinationCupLabel -= 1
        if destinationCupLabel < cupCircle.min()! {
            destinationCupLabel = cupCircle.max()!
        }
        destinationCupIndex = cupCircle.firstIndex(of: destinationCupLabel)
    } while destinationCupIndex == nil

    print("destination: \(destinationCupLabel)\n")

    let targetIndex = (destinationCupIndex! + 1)
    for cupIndex in pickedUpCupIndexes {
        cupCircle.insert(cups[cupIndex], at: targetIndex)
    }
    
    return cupCircle
}

private func cupOrderAfter(_ startLabel: Int, in cups: [Int]) -> [Int] {
    var result = cups

    while result[0] != startLabel {
        let firstMember = result.first!
        result.removeFirst()
        result.append(firstMember)
    }

    result.removeFirst()
    
    return result
}

main()
