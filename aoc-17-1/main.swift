//
//  main.swift
//  aoc-17-1
//
//  Created by Robertas on 2020-12-17.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 17 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            var pocketState = [input.split(separator: "\n").map { $0.map { $0 }.map(Character.init) }]
            let cycleAmount = 6
            print("Before any cycles:\n")
            printPocket(pocketState)

            let startTimestamp = Date().timeIntervalSince1970

            for cycleNumber in 0 ..< cycleAmount {
                pocketState = iterate(pocketState)
                print("After \(cycleNumber + 1) cycle:\n")
                printPocket(pocketState)
            }

            let activeCubeCount = flat(pocketState).filter { $0 == "#" }.count
            let endTimestamp = Date().timeIntervalSince1970
            print("\(activeCubeCount) cubes left in the active state after \(cycleAmount) cycle(s)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func flat(_ pocket: [[[Character]]]) -> String {
    return pocket.map { $0.map { String($0) }.joined() }.joined()
}

private func expand(_ pocket: [[[Character]]]) -> [[[Character]]] {
    var resultPocket: [[[Character]]] = []
    let distance = 1
    let edgeLenght = pocket.first?.count ?? 0

    for zIndex in -distance ..< pocket.count + distance {
        var layer: [[Character]] = []
        for xIndex in -distance ..< edgeLenght + distance {
            var row: [Character] = []
            for yIndex in -distance ..< edgeLenght + distance {
                row.append(cubeAt(zIndex, xIndex, yIndex, in: pocket))
            }
            layer.append(row)
        }
        resultPocket.append(layer)
    }
    
    return resultPocket
}

private func iterate(_ pocket: [[[Character]]]) -> [[[Character]]] {
    var resultPocket: [[[Character]]] = expand(pocket)
    var edgeLength: Int = 0

    for zIndex in 0 ..< resultPocket.count {
        edgeLength = resultPocket[zIndex].count
        for xIndex in 0 ..< edgeLength {
            for yIndex in 0 ..< edgeLength {
                let cube = cubeAt(zIndex - 1, xIndex - 1, yIndex - 1, in: pocket)
                let cubeNeighbours = neighboursTo(zIndex - 1, xIndex - 1, yIndex - 1, in: pocket)
                let flatNeighbours = flat(cubeNeighbours)
                let activeNeighbourAmount = flatNeighbours.filter { $0 == "#" }.count
                switch cube {
                case "#": // Active
                    if ![2, 3].contains(activeNeighbourAmount) {
                        resultPocket[zIndex][xIndex][yIndex] = "."
                    }
                case ".": // Inactive
                    if activeNeighbourAmount == 3 {
                        resultPocket[zIndex][xIndex][yIndex] = "#"
                    }
                default:
                    fatalError("Cube state was not recognized")
                }
            }
        }
    }
    
    return resultPocket
}

private func neighboursTo(_ z: Int, _ x: Int, _ y: Int, in pocket: [[[Character]]], distance: Int = 1) -> [[[Character]]] {
    var neighbours: [[[Character]]] = []

    for zIndex in (z - distance ... z + distance) {
        var layer: [[Character]] = []
        for xIndex in (x - distance ... x + distance) {
            var row: [Character] = []
            for yIndex in (y - distance ... y + distance) {
                if z == zIndex && x == xIndex && y == yIndex {
                    continue
                }
                row.append(cubeAt(zIndex, xIndex, yIndex, in: pocket))
            }
            layer.append(row)
        }
        neighbours.append(layer)
    }
    
    return neighbours
}

private func cubeAt(_ zIndex: Int, _ xIndex: Int, _ yIndex: Int, in pocket: [[[Character]]]) -> Character {
    guard (0 ..< pocket.count).contains(zIndex) &&
        (0 ..< pocket[zIndex].count).contains(xIndex) &&
            (0 ..< pocket[zIndex][xIndex].count).contains(yIndex) else {
        return "."
    }
    return pocket[zIndex][xIndex][yIndex]
}

private func printPocket(_ pocket: [[[Character]]]) {
    let layerAmount = pocket.count
    (0 ..< layerAmount).forEach { layerIndex in
        print("z=\(layerIndex - (layerAmount - (layerAmount % 2)) / 2)")
        print(pocket[layerIndex].map { String($0) }.joined(separator: "\n"), terminator: "\n\n")
    }
}

main()
