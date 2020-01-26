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
    @IBOutlet weak var optionAButton: UIButton!
    @IBOutlet weak var optionBButton: UIButton!
    @IBOutlet weak var optionCButton: UIButton!
    @IBOutlet weak var progressCurrentCount: UILabel!
    @IBOutlet weak var progressMaxCount: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    private var optionButtons: [UIButton] = []
    
    private var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionButtons.append(optionAButton)
        optionButtons.append(optionBButton)
        optionButtons.append(optionCButton)
        
        startGame()
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        startGame()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        disableButtons()
        
        let isUserRight = game.checkAnswer(userAnswer: sender.currentTitle!)
        
        if(isUserRight) {
            sender.setTitleColor(UIColor.green, for: .normal)
        } else {
            sender.setTitleColor(UIColor.red, for: .normal)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitingTimeInSeconds, execute: {
            self.enableButtons()
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
        hideButtons()
        for (button, option) in zip(optionButtons, question.options) {
            show(button: button, withLabel: option)
        }
    }
    
    private func updateProgress() {
        progressBar.setProgress(game.progressPerc(), animated: true)
        progressCurrentCount.text = "\(game.progress)"
        progressMaxCount.text = "\(game.maxProgress)"
    }
    
    private func startGame() {
        restartButton.isHidden = true
        showButtons()
        
        game = Game(maxProgress: Int.random(in: questionRange))
        randomQuestion()
    }
    
    private func endGame() {
        restartButton.isHidden = false
        hideButtons()
        
        questionLabel.text = "No more questions!\nYour score: \(game.score)"
    }
    
    private func disableButtons() {
        optionButtons.forEach { (button) in
            button.isEnabled = false
        }
    }
    
    private func enableButtons() {
        optionButtons.forEach { (button) in
            button.setTitleColor(UIColor.white, for: .normal)
            button.isEnabled = true
        }
    }
    
    private func hideButtons() {
        optionButtons.forEach { (button) in
            button.isHidden = true
        }
    }
    
    private func showButtons() {
        optionButtons.forEach { (button) in
            button.isHidden = false
        }
    }
    
    private func show(button: UIButton, withLabel title: String) {
        button.setTitle(title, for: .normal)
        button.isHidden = false
    }
    
}

