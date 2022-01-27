//
//  ViewController.swift
//  CatchTheKenny
//
//  Created by Erkan Kızgın on 26.01.2022.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    @IBOutlet weak var imageView8: UIImageView!
    @IBOutlet weak var imageView9: UIImageView!
    
    var imageViews = [UIImageView]()
    var timer : Timer?
    var countDownTimer : Timer?
    var score = 0
    var remainingTime = 10
    var highScore = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView1.isUserInteractionEnabled = true
        imageView2.isUserInteractionEnabled = true
        imageView3.isUserInteractionEnabled = true
        imageView4.isUserInteractionEnabled = true
        imageView5.isUserInteractionEnabled = true
        imageView6.isUserInteractionEnabled = true
        imageView7.isUserInteractionEnabled = true
        imageView8.isUserInteractionEnabled = true
        imageView9.isUserInteractionEnabled = true
    
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
        
        scoreLabel.text = "Score : 0"
        highScoreLabel.text = "High Score : \(highScore)"

        imageViews = [imageView1,imageView2,imageView3,imageView4,imageView5,imageView6,imageView7,imageView8,imageView9]
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getImage), userInfo: nil, repeats: true)
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountDown), userInfo: nil, repeats: true)
        
        
    }
    
    
    @objc func getImage(){
        setHidden(arr: imageViews)
        let index = randomIndeks(max: UInt32(imageViews.count-1))
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(Increse))
        imageViews[index].addGestureRecognizer(recognizer)
        imageViews[index].isHidden = false
    }
    
    @objc func Increse(){
        score = score + 1
        self.scoreLabel.text = "Score : \(score)"
    }

}

extension ViewController {
    
    func randomIndeks(max : UInt32) -> Int{
        let random = arc4random_uniform(max)
        return Int(random)
    }
    
    func setHidden(arr : [UIImageView]){
        for item in arr {
            item.isHidden = true
        }
    }
    
    func setHighScore(){
        
        if score > highScore {
            highScore = score
            highScoreLabel.text = "High Score : \(highScore)"
        }
        UserDefaults.standard.set(highScore,forKey: "HighScore")
        
    }
    
    @objc func CountDown(){
        remainingTime = remainingTime - 1
        timeLabel.text = "Time : \(remainingTime)"
        
        if remainingTime == 0 {
            timer?.invalidate()
            countDownTimer?.invalidate()
            setHighScore()
            
            for image in self.imageViews{
                image.isHidden = true
            }
            
            let alert = UIAlertController(title: "Replay", message: "Do you want to play again", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default){
                UIAlertAction in
                self.score = 0
                self.scoreLabel.text = "Score : \(self.score)"
                self.remainingTime = 10
                self.timeLabel.text = "Time : \(self.remainingTime)"
                
                
                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.getImage), userInfo: nil, repeats: true)
                self.countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.CountDown), userInfo: nil, repeats: true)
                
            }
            
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

