//
//  main.swift
//  aoc-11-1
//
//  Created by Robertas on 2020-12-11.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    let startTimestamp = Date().timeIntervalSince1970
    print("Advent Of Code 2020: Day 11 Quest 1")
    
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
                if occupiedSpots.utf16.count > 3 {
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
    let startRow = rowIndex - (rowIndex > 0 ? 1 : 0)
    let endRow = rowIndex + (rowIndex + 1 < floorMap.count ? 1 : 0)
    let startColumn = charIndex - (charIndex > 0 ? 1 : 0)
    let endColumn = charIndex + (charIndex + 1 < floorMap.first!.count ? 1 : 0)
    for adjacentRowIndex in startRow ... endRow {
        var adjacentRow: [Character] = []
        let row: [Character] = floorMap[adjacentRowIndex].map { $0 }
        for adjacentCharIndex in startColumn ... endColumn {
            if isAdjacent(adjacentRowIndex, adjacentCharIndex, to: rowIndex, charIndex) {
                adjacentRow.append(row[adjacentCharIndex])
            }
        }
        result.append(String(adjacentRow))
    }

    return result
}

private func isAdjacent(_ adjacentRowIndex: Int, _ adjacentCharIndex: Int, to rowIndex: Int, _ charIndex: Int) -> Bool {
    let isSameRow = rowIndex == adjacentRowIndex
    let isSameColumn = charIndex == adjacentCharIndex
    
    if isSameColumn && isSameRow {
        return false
    }
    
    let distanceTolerance = 1
    let rowDistance = abs(adjacentRowIndex - rowIndex)
    let columnDistance = abs(adjacentCharIndex - charIndex)
    let isAdjacentRow = isSameRow && !isSameColumn && columnDistance < distanceTolerance + 1
    let isAdjacentColumn = !isSameRow && isSameColumn && rowDistance < distanceTolerance + 1
    let isDiagonal = rowDistance == columnDistance && rowDistance < distanceTolerance + 1

    return isAdjacentRow || isAdjacentColumn || isDiagonal
}

main()
