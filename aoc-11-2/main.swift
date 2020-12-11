//
//  main.swift
//  aoc-11-2
//
//  Created by Robertas on 2020-12-11.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    let startTimestamp = Date().timeIntervalSince1970
    print("Advent Of Code 2020: Day 11 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            var shouldContinueUpdates: Bool
            var floorMap = input.components(separatedBy: "\n")
            floorMap.removeLast()

            var updateAmount = 0
            repeat {
                let previousMap = floorMap
                floorMap = updatedFloor(floorMap)
                shouldContinueUpdates = previousMap.joined() != floorMap.joined()
                updateAmount += 1
                print("Updates performed: \(updateAmount)", terminator: "\r")
                fflush(stdout)
            } while shouldContinueUpdates
            print("Updates performed: \(updateAmount)\n")

            let result = floorMap.joined().filter { $0 == "#" }.count
            print("Number of seats that end up occupied: \(result)")
        }
    } catch {
        print(error)
    }
    let endTimestamp = Date().timeIntervalSince1970
    print("It took \(abs(endTimestamp - startTimestamp)) second(s) to complete.")
}

private func updatedFloor(_ floorMap: [String]) -> [String] {
    var result: [String] = []
    for rowIndex in floorMap.startIndex ..< floorMap.endIndex {
        var row: [Character] = floorMap[rowIndex].map { $0 }
        for charIndex in row.startIndex ..< row.endIndex {
            switch row[charIndex] {
            case "L":
                let adjacentSpots = charactersAdjacent(to: rowIndex, charIndex, in: floorMap)
                let occupiedSpots = adjacentSpots.joined().filter { $0 == "#" }
                if occupiedSpots.isEmpty {
                    row[charIndex] = "#"
                }
            case "#":
                let adjacentSpots = charactersAdjacent(to: rowIndex, charIndex, in: floorMap)
                let occupiedSpots = adjacentSpots.joined().filter { $0 == "#" }
                if occupiedSpots.count > 4 {
                    row[charIndex] = "L"
                }
            default:
                break
            }
        }
        result.append(String(row))
    }
    return result
}

private func charactersAdjacent(to rowIndex: Int, _ charIndex: Int, in floorMap: [String]) -> [String] {
    var result: [String] = []
    
    let directions = [
        [-1, -1], [0, -1], [1, -1],
        [-1, 0],/* [0, 0],*/ [1, 0],
        [-1, 1], [0, 1], [1, 1],
    ]

    for direction in directions {
        let subset = characters(startingFrom: rowIndex, charIndex, in: direction, from: floorMap)
        result.append(subset)
    }
    
    return result
}

private func characters(startingFrom rowIndex: Int, _ charIndex: Int, in direction: [Int], from floorMap: [String]) -> String {
    var shouldStop = false
    var targetRow = rowIndex
    var targetColumn = charIndex
    var result: [Character] = []

    repeat {
        targetRow = targetRow + direction[0]
        targetColumn = targetColumn + direction[1]
        let isEdgeReached = targetRow < 0 || targetColumn < 0 || targetRow == floorMap.count || targetColumn == floorMap.first!.count
        if !isEdgeReached {
            let row: [Character] = floorMap[targetRow].map { $0 }
            let character = row[targetColumn]
            result.append(character)
            shouldStop = ["L", "#"].contains(character)
        } else {
            shouldStop = true
        }
    } while !shouldStop

    return String(result)
}


main()
