//
//  main.swift
//  aoc-02-2
//
//  Created by Robertas on 2020-12-02.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

struct Policy {
    let character: Character
    let firstIndex: Int
    let lastIndex: Int
}

struct Entry {
    let policy: Policy
    let password: String
    
    var isValid: Bool {
        let charAtFirstIndex = password[password.index(password.startIndex, offsetBy: policy.firstIndex - 1)]
        let charAtLastIndex = password[password.index(password.startIndex, offsetBy: policy.lastIndex - 1)]
        let charsMatch = charAtFirstIndex == charAtLastIndex
        let foundMatch =
            charAtFirstIndex == policy.character ||
            charAtLastIndex == policy.character
        return foundMatch && !charsMatch
        
    }
}

func main() {
    print("Advent Of Code 2020: Day 2 Quest 2")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    print("Input file: \(inputFilePath)")
    print("Input URL: \(inputURL)")

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let entryList = entries(from: input)
            print("Entries to check: \(entryList.count)")
            let validEntries = entryList.filter{ $0.isValid }
            print("Valid entries in input: \(validEntries.count)")
        }
    } catch {
        print(error)
    }
}


private func entries(from input: String) -> [Entry] {
    var result: [Entry] = []

    let rows = input.split(separator: "\n")
    rows.forEach{ row in
        let rowParts = row.split(separator: ":")
        guard rowParts.count == 2 else {
            fatalError("Found unusual structure in database")
        }
        let entry = Entry(policy: policy(from: rowParts[0]), password: password(from: rowParts[1]))
        result.append(entry)
    }
    
    return result
}

private func password(from substring: Substring.SubSequence) -> String {
    if substring.hasPrefix(" ") {
        let passwordRange = substring.index(substring.startIndex, offsetBy: 1)...
        return String(substring[passwordRange])
    } else {
        return String(substring)
    }
}

private func policy(from substring: Substring.SubSequence) -> Policy {
    let policyParts = substring.split(separator: " ")
    guard policyParts.count == 2 else {
        fatalError("Policy \(substring) has unusual structure")
    }
    let character = Character(String(policyParts[1]))
    let rangeParts = policyParts[0].split(separator: "-")
    guard rangeParts.count == 2 else {
        fatalError("Policy character range \"\(policyParts[0])\" has unusual structure")
    }
    guard let firstIndex = Int(rangeParts[0]), let lastIndex = Int(rangeParts[1]), firstIndex < lastIndex else {
        fatalError("Password policy \(substring) can't be initialized")
    }
    return Policy(character: character, firstIndex: firstIndex, lastIndex: lastIndex)
}

main()
