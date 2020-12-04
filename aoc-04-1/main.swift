//
//  main.swift
//  aoc-04-1
//
//  Created by Robertas on 2020-12-04.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 4 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    print("Input file: \(inputFilePath)")

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            let entryList = input.components(separatedBy: "\n\n")
            print("Entries to check: \(entryList.count)")
            let result = entryList.filter{ isValid(passport: $0) }.count
            print("Amount of valid passwords: \(result)")
        }
    } catch {
        print(error)
    }
}

private func isValid(passport: String) -> Bool {
    return
        passport.contains("byr:") &&
        passport.contains("iyr:") &&
        passport.contains("eyr:") &&
        passport.contains("hgt:") &&
        passport.contains("hcl:") &&
        passport.contains("ecl:") &&
        passport.contains("pid:")
}


main()
