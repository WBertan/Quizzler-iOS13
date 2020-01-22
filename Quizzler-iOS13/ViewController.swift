//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
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
    
    private func generateQuestion() -> (String, Bool) {
        let a = Int.random(in: 0...9)
        let b = Int.random(in: 0...9)
        let operation = operations.randomElement()!
        let comparison = comparisons.randomElement()!
        let realResult = operation.value(a, b)
        let randomResult = operations.randomElement()!.value(a, b)
        let questionResult = comparison.value(realResult, randomResult)
        return ("\(numbers[a]) \(operation.key) \(numbers[b]) is \(comparison.key) \(randomResult)", questionResult)
    }
    
    private var questions: [(String, Bool)] = []
    
    private var progress: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions = (1...Int.random(in: 5...10)).map({ _ -> (String, Bool) in generateQuestion() })
        
        randomQuestion()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        trueButton.isEnabled = false
        falseButton.isEnabled = false
        
        let answer = sender.currentTitle == "True"
        
        if(answer == questions[progress].1) {
            sender.setTitleColor(UIColor.green, for: .disabled)
        } else {
            sender.setTitleColor(UIColor.red, for: .disabled)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            sender.setTitleColor(UIColor.white, for: .disabled)
            
            self.trueButton.isEnabled = true
            self.falseButton.isEnabled = true
            
            self.randomQuestion()
        })
    }
    
    private func randomQuestion() {
        progress += 1
        updateProgress()
        if progress < questions.count {
            questionLabel.text = questions[progress].0
        } else {
            endGame()
        }
    }
    
    private func updateProgress() {
        let progressBarValue = Float(progress)/Float(questions.count)
        progressBar.setProgress(progressBarValue, animated: true)
    }
    
    private func endGame() {
        updateProgress()
        
        trueButton.isHidden = true
        falseButton.isHidden = true
        
        questionLabel.text = "No more questions!"
    }
    
}

