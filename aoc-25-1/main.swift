//
//  main.swift
//  aoc-25-1
//
//  Created by Robertas on 2020-12-25.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 25 Quest 1")
    
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
            let cardsPublicKey = Int(input[0])!
            let doorPublicKey = Int(input[1])!
            let subjectNumber = 7
            print("Calculating loop size of the card...", terminator: "\r")
            let cardsLoopSize = loopSizeOf(transformedValue: cardsPublicKey, createdUsing: subjectNumber)
            print("Loop size of the card calculated. Calculating loop size of the card...", terminator: "\r")
            let doorLoopSize = loopSizeOf(transformedValue: doorPublicKey, createdUsing: subjectNumber)
            let encryptionKey = transform(cardsPublicKey, inLoopOf: doorLoopSize)
            guard encryptionKey == transform(doorPublicKey, inLoopOf: cardsLoopSize) else {
                fatalError("Failed to determine proper loop sizes")
            }
            let endTimestamp = Date().timeIntervalSince1970
            print("Encryption key is: \(encryptionKey)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func transform(_ value: Int, using subjectNumber: Int) -> Int {
    return value * subjectNumber % 20201227
}

private func transform(_ subjectNumber: Int, inLoopOf loopSize: Int) -> Int {
    var value = 1
    for _ in 0 ..< loopSize {
        value = transform(value, using: subjectNumber)
    }
    return value
}

private func loopSizeOf(transformedValue: Int, createdUsing subjectNumber: Int) -> Int {
    var value = 1
    var loopSize = 0

    while value != transformedValue {
        value = transform(value, using: subjectNumber)
        loopSize += 1
    }
    
    return loopSize
}

main()
