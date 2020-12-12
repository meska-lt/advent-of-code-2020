//
//  main.swift
//  aoc-12-2
//
//  Created by Robertas on 2020-12-12.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Instruction {
    let action: Character
    let value: Int
}

struct Coordinates {
    var east: Int
    var north: Int
}

struct Ship {
    var direction: Character
    var position: Coordinates
    
    mutating func perform( instructions: [Instruction], relativeTo coordinates: Coordinates) {
        var waypointCoordinates = coordinates

        for instruction in instructions {
            switch instruction.action {
            case "N","S":
                waypointCoordinates.north += instruction.value * (instruction.action == "N" ? 1 : -1)
            case "E","W":
                waypointCoordinates.east += instruction.value * (instruction.action == "E" ? 1 : -1)
            case "F":
                position.east += waypointCoordinates.east * instruction.value
                position.north += waypointCoordinates.north * instruction.value
            default:
                let oldWaypointCoordinates = waypointCoordinates
                if instruction.action == "R" && instruction.value == 90 ||
                   instruction.action == "L" && instruction.value == 270
                {
                    waypointCoordinates.east = oldWaypointCoordinates.north
                    waypointCoordinates.north = -oldWaypointCoordinates.east
                } else if instruction.action == "R" && instruction.value == 270 ||
                       instruction.action == "L" && instruction.value == 90
                {
                    waypointCoordinates.east = -oldWaypointCoordinates.north
                    waypointCoordinates.north = oldWaypointCoordinates.east
                } else if (instruction.action == "R" || instruction.action == "L") &&
                          instruction.value == 180
                {
                    waypointCoordinates.east *= -1
                    waypointCoordinates.north *= -1
                }
            }
        }
    }
}

func main() {
    let startTimestamp = Date().timeIntervalSince1970
    print("Advent Of Code 2020: Day 12 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let instructionList = instructions(from: input)
            let waypointCoordinates = Coordinates(east: 10, north: 1)
            var ship = Ship(direction: "E", position: Coordinates(east: 0, north: 0))
            ship.perform(instructions: instructionList, relativeTo: waypointCoordinates)
            let horizontalShift = abs(ship.position.east)
            let verticalShift = abs(ship.position.north)
            let manhattanDistance = horizontalShift + verticalShift
            let logSuffix = "\(horizontalShift) + \(verticalShift) = \(manhattanDistance)"
            print("Manhattan distance from ship to waypoint is \(logSuffix)")
        }
    } catch {
        print(error)
    }
    let endTimestamp = Date().timeIntervalSince1970
    print("It took \(abs(endTimestamp - startTimestamp)) second(s) to complete.")
}

private func instructions(from input: String) -> [Instruction] {
    let rows = input.split(separator: "\n")
    return rows.map { row in
        let startOfValue = row.index(row.startIndex, offsetBy: 1)
        let direction = row[row.startIndex..<startOfValue].map{ $0 }.first!
        let value = Int(row[startOfValue...])!
        return Instruction(action: direction, value: value)
    }
}

main()
