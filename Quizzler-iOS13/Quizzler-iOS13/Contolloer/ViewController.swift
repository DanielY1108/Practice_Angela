//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var qusetionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var choiceOne: UIButton!
    @IBOutlet weak var choiceTwo: UIButton!
    @IBOutlet weak var choiceThree: UIButton!
    

    var quizBrain = QuizBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0
        configureStart()
    }

    @objc func configureStart() {
        qusetionLabel.text = quizBrain.quizQuestionText()
        choiceOne.backgroundColor = .clear
        choiceTwo.backgroundColor = .clear
        choiceThree.backgroundColor = .clear
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = "Get Score: \(quizBrain.getScore())"
        let answerChoice = quizBrain.answerButtonNum()
        choiceOne.setTitle(answerChoice[0], for: .normal)
        choiceTwo.setTitle(answerChoice[1], for: .normal)
        choiceThree.setTitle(answerChoice[2], for: .normal)
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        let userAnswer = sender.currentTitle!
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight {
            sender.backgroundColor = .green
            print(sender.currentTitle)

        } else {
            sender.backgroundColor = .red
        }

        quizBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(configureStart), userInfo: nil, repeats: false)
    }
    
}

