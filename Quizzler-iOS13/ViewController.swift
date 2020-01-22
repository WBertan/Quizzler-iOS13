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
    
    private var questions = [
        "Four + Two is equal to Six": true,
        "2": true,
        "3": true,
        "4": true,
        "5": true,
        "6": true
    ]
    private var question: (String, Bool)!
    
    private var maxProgress: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxProgress = questions.count
        
        updateProgress()
        randomQuestion()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        trueButton.isEnabled = false
        falseButton.isEnabled = false
        
        let answer = sender.currentTitle == "True"
        
        if(answer == question!.1) {
            sender.setTitleColor(UIColor.green, for: .disabled)
        } else {
            sender.setTitleColor(UIColor.red, for: .disabled)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            sender.setTitleColor(UIColor.white, for: .disabled)
            
            self.trueButton.isEnabled = true
            self.falseButton.isEnabled = true
            
            self.updateProgress()
            self.randomQuestion()
        })
    }
    
    private func randomQuestion() {
        question = questions.popFirst()
        if let question = question {
            questionLabel.text = question.0
        } else {
            endGame()
        }
    }
    
    private func updateProgress() {
        let progress = Float(maxProgress - questions.count)/Float(maxProgress)
        progressBar.setProgress(progress, animated: true)
    }
    
    private func endGame() {
        updateProgress()
        
        trueButton.isHidden = true
        falseButton.isHidden = true
        
        questionLabel.text = "No more questions!"
    }
    
}

