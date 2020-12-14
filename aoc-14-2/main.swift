//
//  main.swift
//  aoc-14-2
//
//  Created by Robertas on 2020-12-14.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

extension String {

    func pad(to destinationSize: Int) -> String {
        guard destinationSize > self.count else {
            return self
        }
        var padded = self
        for _ in 0 ..< (destinationSize - self.count) {
            padded = "0" + padded
        }
        return padded
    }

}

extension Int {
    
    func values(from mask: [Character]) -> [Int] {
        let binarySelfMasked: [Character] = self.apply(mask)
        var floatingIndexes: [Int] = []
        var result: [Int] = []
        
        for index in binarySelfMasked.startIndex ..< binarySelfMasked.endIndex {
            if binarySelfMasked[index] == "X" {
                floatingIndexes.append(index)
            }
        }
        
        let iterationAmount = floatingIndexes.reduce(into: 0) { intermediateResult, index in
            intermediateResult = (intermediateResult == 0 ? 1 : intermediateResult) * 2
        }
        
        for iteration in 0 ..< iterationAmount {
            let iterationBinary = String(iteration, radix: 2).pad(to: floatingIndexes.count).map { $0 }
            var binarySelf: [Character] = binarySelfMasked
            for iterator3 in 0 ..< floatingIndexes.count {
                binarySelf[floatingIndexes[iterator3]] = iterationBinary[iterator3]
            }
            let newValue = Int(String(binarySelf), radix: 2)!
            result.append(newValue)
        }
        
        return result
    }

    private func apply(_ bitmask: [Character]) -> [Character] {
        var binarySelfMasked: [Character] = String(self, radix: 2).pad(to: bitmask.count).map { $0 }

        for maskIndex in bitmask.startIndex ..< bitmask.endIndex {
            let maskCharacter = bitmask[maskIndex]
            switch maskCharacter {
            case "1", "X":
                binarySelfMasked[maskIndex] = maskCharacter
            default:
                break
            }
        }

        return binarySelfMasked
    }

}

func main() {
    print("Advent Of Code 2020: Day 14 Quest 2")
    
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
            let addresses = Int(row[0].replacingOccurrences(of: "mem[", with: "").replacingOccurrences(of: "]", with: ""))!.values(from: bitmask.map { $0 })
            let value = Int(row[1])!
            for address in addresses {
                memory[address] = value
            }
        }
    }

    return memory
}

main()
