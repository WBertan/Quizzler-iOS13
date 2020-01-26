//
//  Game.swift
//  Quizzler-iOS13
//
//  Created by William Da Silva on 22/01/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct Game {
    let maxProgress: Int
    var progress: Int = -1
    var currentQuestion: Question?
    var endGame: Bool = false
    var score: Int = 0
    
    mutating func nextQuestion() -> Question? {
        if progress >= maxProgress {
            endGame = true
            return nil
        } else {
            progress += 1
            currentQuestion = generateQuestion()
            return currentQuestion
        }
    }
    
    mutating func checkAnswer(userAnswer: String) -> Bool {
        let correctAnswer = currentQuestion?.answer
        let isUserRight = userAnswer.caseInsensitiveCompare(correctAnswer!) == .orderedSame
        if isUserRight {
            score += 1
        }
        return isUserRight
    }
    
    func progressPerc() -> Float {
        return endGame ? 1.0 : Float(progress)/Float(maxProgress + 1)
    }
    
    private let numbers = [
        "Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine"
    ]
    
    private let operations = [
        "+": { (a: Int, b: Int) -> Int in a + b },
        "-": { (a: Int, b: Int) -> Int in a - b },
        "*": { (a: Int, b: Int) -> Int in a * b }
    ]
    
    private let comparisons = [
        "equal to": { (a: Int, b: Int) -> Bool in a == b },
        "greater than": { (a: Int, b: Int) -> Bool in a > b },
        "greater or equal than": { (a: Int, b: Int) -> Bool in a >= b },
        "less than": { (a: Int, b: Int) -> Bool in a < b },
        "less or equal than": { (a: Int, b: Int) -> Bool in a <= b }
    ]
    
    private func generateQuestion() -> Question {
        return Bool.random() ? generateBoolOptions() : generateMultiOptions(quantity: 3)
    }
    
    func generateBoolOptions() -> Question {
        let a = Int.random(in: 0...9)
        let b = Int.random(in: 0...9)
        let operation = operations.randomElement()!
        let comparison = comparisons.randomElement()!
        let realResult = operation.value(a, b)
        let randomResult = operations.randomElement()!.value(a, b)
        let questionResult = comparison.value(realResult, randomResult)
        let questionOptions = ["True", "False"]
        
        return Question(
            description: "\(numbers[a]) \(operation.key) \(numbers[b]) is \(comparison.key) \(randomResult)",
            answer: "\(questionResult)",
            options: questionOptions
        )
    }
    func generateMultiOptions(quantity: Int) -> Question {
        let a = Int.random(in: 0...9)
        let b = Int.random(in: 0...9)
        let shuffledOperations = operations.shuffled()
        let operation = shuffledOperations.first!
        let realResult = "\(operation.value(a, b))"
        var questionOptions = shuffledOperations.dropFirst().prefix(quantity - 1).map { (function) -> String in
            "\(function.value(a, b))"
        }
        questionOptions.append(realResult)
        
        return Question(
            description: "\(numbers[a]) \(operation.key) \(numbers[b]) is:",
            answer: realResult,
            options: questionOptions.shuffled()
        )
    }
    
}
