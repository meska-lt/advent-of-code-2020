//
//  main.swift
//  aoc-13-1
//
//  Created by Robertas on 2020-12-13.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    let startTimestamp = Date().timeIntervalSince1970
    print("Advent Of Code 2020: Day 13 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let notes = String(data: inputData, encoding: String.Encoding.utf8)?.components(separatedBy: "\n") {
            let earliestDepartureTime = Int(notes[0])!
            let busList = notes[1].split(separator: ",").map { Int($0) }
            let busInServiceList = busList.compactMap { $0 }
            var departureTime = earliestDepartureTime
            var shouldContinue = true
            var busId: Int?

            repeat {
                busId = busInServiceList.first(where: { departureTime % $0 == 0 })
                if let _ = busId {
                    shouldContinue = false
                } else {
                    departureTime += 1
                }
            } while shouldContinue

            let relativeWaitTime = departureTime - earliestDepartureTime
            print("Need to wait \(departureTime) - \(earliestDepartureTime) = \(relativeWaitTime)")
            let waitTime = busId! * relativeWaitTime
            print("Minutes to wait: \(waitTime)")
        }
    } catch {
        print(error)
    }
    let endTimestamp = Date().timeIntervalSince1970
    print("It took \(abs(endTimestamp - startTimestamp)) second(s) to complete.")
}

main()
