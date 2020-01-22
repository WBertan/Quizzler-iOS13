//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by William Da Silva on 22/01/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

struct Question {
    let description: String
    let answer: Bool
    
    init(description: String, answer: Bool) {
        self.description = description
        self.answer = answer
    }
}
