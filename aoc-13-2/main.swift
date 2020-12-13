//
//  main.swift
//  aoc-13-2
//
//  Created by Robertas on 2020-12-13.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 13 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let notes = String(data: inputData, encoding: String.Encoding.utf8)?.split(separator: "\n") {
                for noteIndex in notes.index(notes.startIndex, offsetBy: 1) ..< notes.endIndex {
                    printWaitTime(from: String(notes[noteIndex]), increaseOffset: noteIndex == (notes.endIndex - 1))
            }
        }
    } catch {
        print(error)
    }
}

private func printWaitTime(from note: String, increaseOffset: Bool) {
    let startTimestamp = Date().timeIntervalSince1970
    let busList = note.split(separator: ",").map { Int($0) }
    let busInServiceList = busList.compactMap{ $0 }.sorted()
    var departureTime = increaseOffset ? 100000000000000 : 0
    var shouldContinue = true
    
    // fine tune
    while departureTime % busInServiceList.last! != 0 {
        departureTime -= 1
    }
    
    let departingBusIndex: Int = busList.firstIndex(of: busInServiceList.last!)!

    print("Bus list: \(note)")

    repeat {
        if increaseOffset && (departureTime % 1000000000 == 0) {
            print("Checking departure time past \(departureTime)", terminator: "\r")
            fflush(stdout)
        }
        departureTime += busInServiceList.last!
        if departureTime == busInServiceList.last! {
            departureTime -= departingBusIndex
        }

        shouldContinue = false
        for busIdIndex in busList.startIndex ..< busList.endIndex {
            if let busId = busList[busIdIndex], !shouldContinue {
                shouldContinue = (departureTime + busIdIndex) % busId != 0
            }
        }
    } while shouldContinue

    print("Need to wait: \(departureTime)")
    let endTimestamp = Date().timeIntervalSince1970
    print("It took \(abs(endTimestamp - startTimestamp)) second(s) to complete.")
}

main()
