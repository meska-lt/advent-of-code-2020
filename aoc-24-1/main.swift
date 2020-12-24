//
//  main.swift
//  aoc-24-1
//
//  Created by Robertas on 2020-12-24.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Position: Equatable, Hashable {
    var x, y: Double
}

func main() {
    print("Advent Of Code 2020: Day 24 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let startTimestamp = Date().timeIntervalSince1970
            let blackTiles: [Position] = blackTilesAfterMovingInDirections(input)
            let endTimestamp = Date().timeIntervalSince1970
            print("Tiles with the black side up left: \(blackTiles.count)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func blackTilesAfterMovingInDirections(_ input: String) -> [Position] {
    var blackTiles: [Position] = []
    let directionStrings = input.split(separator: "\n")

    for directionsString in directionStrings {
        let position = positionAfterMoving(directionsString)
        if let positonIndex = blackTiles.firstIndex(of: position) {
            blackTiles.remove(at: positonIndex)
        } else {
            blackTiles.append(position)
        }
    }
    
    return blackTiles
}

private func positionAfterMoving(_ directions: String.SubSequence) -> Position {
    var position = Position(x: 0, y: 0)
    var cursorIndex = directions.startIndex
    while cursorIndex < directions.endIndex {
        var nextIndex = directions.index(after: cursorIndex)
        switch directions[cursorIndex ..< nextIndex] {
        case "e": position.x += 1
        case "w": position.x -= 1
        case "n", "s":
            nextIndex = directions.index(after: nextIndex)
            switch directions[cursorIndex ..< nextIndex] {
            case "ne": position.x += 0.5; position.y += 0.5
            case "se": position.x += 0.5; position.y -= 0.5
            case "nw": position.x -= 0.5; position.y += 0.5
            case "sw": position.x -= 0.5; position.y -= 0.5
            default: break
            }
        default: break
        }
        cursorIndex = nextIndex
    }
    return position
}

main()
