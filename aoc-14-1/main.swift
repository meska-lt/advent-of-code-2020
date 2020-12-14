//
//  main.swift
//  aoc-14-1
//
//  Created by Robertas on 2020-12-14.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Command {
    let address: Int
    let value: Int
}

extension String {

    func pad(to destinationSize: Int) -> String {
        var padded = self
        for _ in 0 ..< (destinationSize - self.count) {
            padded = "0" + padded
        }
        return padded
    }

}

extension Int {

    func apply(_ bitmask: [Character]) -> Int {
        var binarySelf: [Character] = String(self, radix: 2).pad(to: bitmask.count).map { $0 }

        for maskIndex in bitmask.startIndex ..< bitmask.endIndex {
            let maskCharacter = bitmask[maskIndex]
            switch maskCharacter {
            case "0", "1":
                binarySelf[maskIndex] = maskCharacter
            default:
                break
            }
        }

        return Int(String(binarySelf), radix: 2)!
    }

}

func main() {
    print("Advent Of Code 2020: Day 14 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?.split(separator: "\n").map(String.init) {
            let startTimestamp = Date().timeIntervalSince1970
            let memory = memoryAfterPerforming(input)
            let sumOfMemoryValues = memory.values.reduce(into: 0) { intermediateResult, value in
                intermediateResult += value
            }
            let endTimestamp = Date().timeIntervalSince1970
            print("Sum of all values left in memory: \(sumOfMemoryValues)")
            print("It took \(abs(endTimestamp - startTimestamp)) second(s) to complete.")
        }
    } catch {
        print(error)
    }
}

private func memoryAfterPerforming(_ input: [String]) -> [Int : Int] {
    var bitmask: String = String(repeating: "X", count: 36)
    var memory: [Int : Int] = [:]

    for rowIndex in input.startIndex ..< input.endIndex {
        let row = input[rowIndex].components(separatedBy: " = ")
        switch row[0] {
        case "mask":
            bitmask = row[1]
        default:
            let address = Int(row[0].replacingOccurrences(of: "mem[", with: "").replacingOccurrences(of: "]", with: ""))!
            let value = Int(row[1])!
            
            memory[address] = value.apply(bitmask.map { $0 })
        }
    }

    return memory
}

main()
