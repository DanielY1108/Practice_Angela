//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
            
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var player: AVAudioPlayer?

    var totlaTime = 0
    var barPercentage = 0
    
    let eggTimes = ["Soft" : 10, "Medium" : 20, "Hard" : 30,]
    
    var timer = Timer()
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        progressBar.progress = 0
        
        if let hardness = sender.currentTitle {
            if let result = eggTimes[hardness] {
                totlaTime = result
            }
        }
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

    }
    
    @objc func fireTimer() {
        if totlaTime >= barPercentage {
            let loading = (Float(barPercentage) / Float(totlaTime) * 100)
            print(loading)
            titleLabel.text = String(format: "%.1f", loading) + "% 요리중"
            progressBar.progress = Float(barPercentage) / Float(totlaTime)
            print(Float(barPercentage) , Float(totlaTime))
            barPercentage += 1

        } else {
            timer.invalidate()
            titleLabel.text = "요리가 완성 됬어요"
            playSound()
            
        }
    }
    
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "alarm_sound", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 1
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
