//
//  main.swift
//  aoc-08-1
//
//  Created by Robertas on 2020-12-08.
//  Copyright © 2020 Robertas Kvietkauskas. All rights reserved.
//

import Foundation

enum Operation: String {
    case acc
    case jmp
    case nop
}

final class Instruction {
    let operation: Operation
    let argument: Int
    var isDone: Bool = false
    
    init(with operation: Operation, _ argument: Int) {
        self.operation = operation
        self.argument = argument
    }
}

func main() {
    print("Advent Of Code 2020: Day 8 Quest 1")
    
    guard CommandLine.arguments.count > 1 else {
        print("Input path was not given. Exiting.")
        return
    }

    let inputFilePath = CommandLine.arguments[1]
    let inputURL = URL(fileURLWithPath: inputFilePath)

    do {
        let inputData = try Data(contentsOf: inputURL)
        if let input = String(data: inputData, encoding: String.Encoding.utf8) {
            var instructions = bootCode(from: input)
            let result = accumulatorValue(afterRunning: &instructions)
            print("Value in the accumulator before any instruction is executed a second time is: \(result)")
        }
    } catch {
        print(error)
    }
}

private func bootCode(from input: String) -> [Instruction] {
    return input.split(separator: "\n").map { row in
        let instructionParts = row.split(separator: " ").map(String.init)
        guard instructionParts.count == 2 else {
            fatalError("Failed to parse instruction \(row)")
        }
        guard
            let operation = Operation(rawValue: instructionParts[0]),
            let argument = Int(instructionParts[1]) else {
            fatalError("Failed to parse instruction \(row)")
        }
        return Instruction(with: operation, argument)
    }
}

private func accumulatorValue(afterRunning instructions: inout [Instruction]) -> Int {
    var acc = 0
    var instructionIndex = 0
    
    guard instructions.count > 0 else {
        return acc
    }

    repeat {
        let instruction = instructions[instructionIndex]

        switch instruction.operation {
        case .acc:
            acc += instruction.argument
            instructionIndex += 1
        case .jmp:
            instructionIndex += instruction.argument
        case .nop:
            instructionIndex += 1
        }

        instruction.isDone = true
    } while !instructions[instructionIndex].isDone
    
    return acc
}

main()
