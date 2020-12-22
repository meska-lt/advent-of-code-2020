//
//  main.swift
//  aoc-22-1
//
//  Created by Robertas on 2020-12-22.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Deck {
    let playerId: Int
    var cards: [Int]
}

func main() {
    print("Advent Of Code 2020: Day 22 Quest 1")
    
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
            let decks = input.components(separatedBy: "\n\n").map { deck(from: $0) }
            let winningDeckCards: [Int] = combatWinningDeck(in: decks).cards.reversed()
            let result = score(of: winningDeckCards)
            let endTimestamp = Date().timeIntervalSince1970
            print("Winning player's score is \(result)")
            print("It took \(endTimestamp - startTimestamp) second(s) to complete.")
        } else {
            fatalError("Could not parse input.")
        }
    } catch {
        print(error)
    }
}

private func deck(from input: String) -> Deck {
    var components = input.components(separatedBy: "\n").filter { !$0.isEmpty }
    let playerId = Int(components.first!.replacingOccurrences(of: "Player ", with: "").replacingOccurrences(of: ":", with: ""))!
    components.removeFirst()
    return Deck(playerId: playerId, cards: components.map { Int($0)! })
}

private func combatWinningDeck(in startingDecks: [Deck]) -> Deck {
    let totalCardAmount = startingDecks.reduce(into: 0) { $0 += $1.cards.count }
    var decks = startingDecks
    var roundIndex = 0

    while !decks.contains(where: { $0.cards.count == totalCardAmount }) {
        roundIndex += 1
        print("-- Round \(roundIndex) --")
        var cardsOnTable: [Int : Int] = [:]

        for deckIndex in 0 ..< decks.count {
            print("Player \(decks[deckIndex].playerId)'s deck: \(decks[deckIndex].cards)")
        }

        for deckIndex in 0 ..< decks.count {
            let topCard = decks[deckIndex].cards.first!
            print("Player \(decks[deckIndex].playerId) plays: \(topCard)")
            cardsOnTable[topCard] = deckIndex
            decks[deckIndex].cards.removeFirst()
        }

        let topCard = cardsOnTable.keys.max()!
        let winnerDeckIndex = cardsOnTable[topCard]!
        print("Player \(decks[winnerDeckIndex].playerId) wins the rond!")
        decks[winnerDeckIndex].cards.append(topCard)
        cardsOnTable.removeValue(forKey: topCard)
        decks[winnerDeckIndex].cards.append(contentsOf: cardsOnTable.keys)
    }

    return decks.first(where: { $0.cards.count == totalCardAmount })!
}

private func score(of deckCards: [Int]) -> Int {
    var result = 0
    for index in 0 ..< deckCards.count {
        result += deckCards[index] * (index + 1)
    }
    return result
}

main()
