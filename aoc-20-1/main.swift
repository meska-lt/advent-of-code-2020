//
//  main.swift
//  aoc-20-1
//
//  Created by Robertas on 2020-12-20.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Tile: Equatable, Hashable {
    let id: Int
    let content: [[Character]]
    
    func edges(flippedHorizontally: Bool = false, flippedVertically: Bool = false) -> [[Character]]{
        if flippedHorizontally {
            return [content.first!.reversed(), content.map({ $0.last! }), content.last!.reversed(), content.map({ $0.first! })]
        } else if flippedVertically {
            return [content.last!, content.map({ $0.first! }).reversed(), content.first!, content.map({ $0.last! }).reversed()]
        } else if flippedVertically && flippedVertically {
            return [content.last!.reversed(), content.map({ $0.last! }).reversed(), content.first!.reversed(), content.map({ $0.first! }).reversed()]
        } else {
            return [content.first!, content.map({ $0.first! }), content.last!, content.map({ $0.last! })]
        }
    }
    
    func isAdjacent(to otherTile: Tile) -> Bool {
        let commonEdges = Set(Tile.allEdges(of: self)).intersection(Set(Tile.allEdges(of: otherTile)))
        return !commonEdges.isEmpty
    }
    
    static func allEdges(of tile: Tile) -> [[Character]] {
        return
            tile.edges() +
            tile.edges(flippedHorizontally: true) +
            tile.edges(flippedVertically: true) +
            tile.edges(flippedHorizontally: true, flippedVertically: true)
    }
    
}

func main() {
    print("Advent Of Code 2020: Day 20 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8)?.components(separatedBy: "\n\n").filter({ $0.count > 0 }) {
            let startTimestamp = Date().timeIntervalSince1970
            let tiles = input.map { parseTile(from: $0) }
            var adjacentTiles: [Int : Set<Int>] = [:]
            for tile in tiles {
                for otherTile in tiles {
                    if otherTile == tile {
                        continue
                    }
                    
                    if tile.isAdjacent(to: otherTile) {
                        var stuff = adjacentTiles[tile.id] ?? []
                        stuff.insert(otherTile.id)
                        adjacentTiles[tile.id] = stuff
                    }
                }
            }
            
            let cornerTileIds = adjacentTiles.keys.filter { (adjacentTiles[$0] ?? []).count == 2 }
            let result = cornerTileIds.reduce(into: 0) { intermediateResult, tileId in
                intermediateResult = (intermediateResult == 0 ? 1 : intermediateResult) * tileId
            }
            
            let endTimestamp = Date().timeIntervalSince1970
            print("Multiple of corner tile IDs is: \(result)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func parseTile(from input: String) -> Tile {
    var components = input.split(separator: "\n")
    let tileId = Int(String(components[0].replacingOccurrences(of: "Tile ", with: "").replacingOccurrences(of: ":", with: "")))
    components.removeFirst()
    let content = components.map { $0.map { $0 } }
    return Tile(id: tileId!, content: content)
}

main()
