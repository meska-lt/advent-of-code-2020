//
//  main.swift
//  aoc-04-2
//
//  Created by Robertas on 2020-12-04.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

func main() {
    print("Advent Of Code 2020: Day 4 Quest 2")
    
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
    let passComponents = passport.replacingOccurrences(of: "\n", with: " ").split(separator: " ").map { String($0) }
    var pass: [String : String] = [:]

    passComponents.forEach{ component in
        let componentParts = component.split(separator: ":").map { String($0) }
        guard componentParts.count == 2 else { return }
        pass[componentParts[0]] = componentParts[1]
    }
    
    return
        isBirthYearValid(in: pass) &&
        isIssueYearValid(in: pass) &&
        isExpirationYearValid(in: pass) &&
        isHeightValid(in: pass) &&
        isHairColorValid(in: pass) &&
        isEyeColorValid(in: pass) &&
        isPassportIdValid(in: pass)
}

private func isBirthYearValid(in pass: [String : String]) -> Bool {
    let key = "byr"
    guard
        let value = pass[key],
        let year = Int(value),
        (year > 1919) && (year < 2003) else {
        return false
    }
    return true
}

private func isIssueYearValid(in pass: [String : String]) -> Bool {
    let key = "iyr"
    guard
        let value = pass[key],
        let year = Int(value),
        (year > 2009) && (year < 2021) else {
        return false
    }
    return true
}

private func isExpirationYearValid(in pass: [String : String]) -> Bool {
    let key = "eyr"
    guard
        let value = pass[key],
        let year = Int(value),
        (year > 2019) && (year < 2031) else {
        return false
    }
    return true
}

private func isHeightValid(in pass: [String : String]) -> Bool {
    let key = "hgt"
    guard var value = pass[key] else {
        return false
    }
    let isMetric = value.hasSuffix("cm")
    if isMetric {
        value = value.replacingOccurrences(of: "cm", with: "")
    } else if value.hasSuffix("in") {
        value = value.replacingOccurrences(of: "in", with: "")
    } else {
        return false
    }
    guard let integerValue = Int(value) else {
        return false
    }
    return
        integerValue > (isMetric ? 149 : 58) &&
        integerValue < (isMetric ? 194 : 77)
}

private func isHairColorValid(in pass: [String : String]) -> Bool {
    let key = "hcl"
    guard let value = pass[key], value.hasPrefix("#") else {
        return false
    }
    let color = value.replacingOccurrences(of: "#", with: "")
    guard let _ = Int(color, radix: 16) else {
        return false
    }
    return color.count == 6
}

private func isEyeColorValid(in pass: [String : String]) -> Bool {
    let key = "ecl"
    guard let value = pass[key] else {
        return false
    }
    switch value {
    case "amb", "blu", "brn", "gry", "grn", "hzl", "oth":
        return true
    default:
        return false
    }
}

private func isPassportIdValid(in pass: [String : String]) -> Bool {
    let key = "pid"
    guard let value = pass[key], let _ = Int(value), value.count == 9 else {
        return false
    }
    return true
}

main()
