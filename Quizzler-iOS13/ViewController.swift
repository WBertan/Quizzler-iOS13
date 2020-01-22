//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let questionRange = 5...10
    private let waitingTimeInSeconds = 2.0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var progressCurrentCount: UILabel!
    @IBOutlet weak var progressMaxCount: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    private var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        startGame()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        trueButton.isEnabled = false
        falseButton.isEnabled = false
        
        let answer = sender.currentTitle == "True"
        let correctAnswer = game.currentQuestion?.answer
        
        if(answer == correctAnswer) {
            sender.setTitleColor(UIColor.green, for: .disabled)
        } else {
            sender.setTitleColor(UIColor.red, for: .disabled)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitingTimeInSeconds, execute: {
            sender.setTitleColor(UIColor.white, for: .disabled)
            
            self.trueButton.isEnabled = true
            self.falseButton.isEnabled = true
            
            self.randomQuestion()
        })
    }
    
    private func randomQuestion() {
        if let question = game.nextQuestion() {
            showQuestion(question)
        } else {
            endGame()
        }
        updateProgress()
    }
    
    private func showQuestion(_ question: Question) {
        questionLabel.text = question.description
    }
    
    private func updateProgress() {
        progressBar.setProgress(game.progressPerc(), animated: true)
        progressCurrentCount.text = "\(game.progress)"
        progressMaxCount.text = "\(game.maxProgress)"
    }
    
    private func startGame() {
        restartButton.isHidden = true
        trueButton.isHidden = false
        falseButton.isHidden = false
        
        game = Game(maxProgress: Int.random(in: questionRange))
        randomQuestion()
    }
    
    private func endGame() {
        restartButton.isHidden = false
        trueButton.isHidden = true
        falseButton.isHidden = true
        
        questionLabel.text = "No more questions!"
    }
    
}

