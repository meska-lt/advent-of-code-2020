//
//  main.swift
//  aoc-12-1
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
    let east: Int
    let north: Int
}

struct Position {
    let direction: Character
    let coordinates: Coordinates

    func afterPerforming(_ instruction: Instruction) -> Position {
        switch instruction.action {
        case "N", "S":
            let distanceToMove = instruction.value * (instruction.action == "N" ? 1 : -1)
            let resultCoordinates = Coordinates(east: coordinates.east, north: coordinates.north + distanceToMove)
            return Position(direction: direction, coordinates: resultCoordinates)
        case "E", "W":
            let distanceToMove = instruction.value * (instruction.action == "E" ? 1 : -1)
            let resultCoordinates = Coordinates(east: coordinates.east + distanceToMove, north: coordinates.north)
            return Position(direction: direction, coordinates: resultCoordinates)
        case "L", "R":
            let degreesToRotate = (instruction.action == "R") ? instruction.value : 360 - instruction.value
            let newDirection = directionAfterTurning(degrees: degreesToRotate)
            return Position(direction: newDirection, coordinates: coordinates)
        case "F":
            let newCoordinates = coordinatesAfterMovingForward(instruction.value)
            return Position(direction: direction, coordinates: newCoordinates)
        default:
            return self
        }
    }
    
    private func directionAfterTurning(degrees: Int) -> Character {
        switch direction {
        case "E":
            switch degrees {
            case 90: return "S"
            case 180: return "W"
            case 270: return "N"
            default: return direction
            }
        case "S":
            switch degrees {
            case 90: return "W"
            case 180: return "N"
            case 270: return "E"
            default: return direction
            }
        case "W":
            switch degrees {
            case 90: return "N"
            case 180: return "E"
            case 270: return "S"
            default: return direction
            }
        case "N":
            switch degrees {
            case 90: return "E"
            case 180: return "S"
            case 270: return "W"
            default: return direction
            }
        default:
            return direction
        }
    }
    
    private func coordinatesAfterMovingForward(_ distance: Int) -> Coordinates {
        switch direction {
        case "E":
            return Coordinates(east: coordinates.east + distance, north: coordinates.north)
        case "S":
            return Coordinates(east: coordinates.east, north: coordinates.north - distance)
        case "W":
            return Coordinates(east: coordinates.east - distance, north: coordinates.north)
        case "N":
            return Coordinates(east: coordinates.east, north: coordinates.north + distance)
        default:
            break
        }
        return self.coordinates
    }
}

func main() {
    let startTimestamp = Date().timeIntervalSince1970
    print("Advent Of Code 2020: Day 12 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let resultPosition = positionAfterPerforming(instructions: instructions(from: input))
            let horizontalShift = abs(resultPosition.coordinates.east)
            let verticalShift = abs(resultPosition.coordinates.north)
            let manhattanDistance = horizontalShift + verticalShift
            let logSuffix = "\(horizontalShift) + \(verticalShift) = \(manhattanDistance)"
            print("Manhattan distance from its starting position is \(logSuffix)")
        }
    } catch {
        print(error)
    }
    let endTimestamp = Date().timeIntervalSince1970
    print("It took \(abs(endTimestamp - startTimestamp)) second(s) to complete.")
}

private func positionAfterPerforming(instructions: [Instruction]) -> Position {
    let startCoordinates = Coordinates(east: 0, north: 0)
    let startPosition = Position(direction: "E", coordinates: startCoordinates)
    var resultPosition = startPosition
    for instruction in instructions {
        resultPosition = resultPosition.afterPerforming(instruction)
    }
    return resultPosition
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
