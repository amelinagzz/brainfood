//
//  GameVC.swift
//  BrainTeaser
//
//  Created by Adriana Gonzalez on 4/21/16.
//  Copyright © 2016 Adriana Gonzalez. All rights reserved.
//

import UIKit
import pop

class GameVC: UIViewController, ResultsDelegate {

    @IBOutlet weak var timerLbl: UILabel!
    
    
    @IBOutlet weak var yesBtn: CustomButton!
    @IBOutlet weak var noBtn: CustomButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    var resultView: Results!
    var currentCard: Card!
    var prevCard: Card!
    var startTime = NSTimeInterval()
    var gameTime = 3.0
    var timer: NSTimer!
    var correctAns = 0
    var wrongAns = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCard = createCardFromNib()
        currentCard.center = AnimationEngine.screenCenterPosition
        self.view.addSubview(currentCard)
    }

  
    @IBAction func yesPressed(sender: UIButton){

        if sender.titleLabel?.text == "Yes"{
            showNextCard(checkAnswer(true))
        }else{
            titleLbl.text = "Does this card match the previous?"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            showNextCard(0)

        }

    }
    
    @IBAction func noPressed(sender: AnyObject){
        showNextCard(checkAnswer(false))

    }
    
    func update(){
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - startTime
        let seconds = gameTime - elapsedTime
        if seconds > 0 {
            elapsedTime -= NSTimeInterval(seconds)
            timerLbl.text = "\(UInt8(seconds))"

        } else {
            timer.invalidate()
            timerLbl.text = "time's up"
            endGame()

        }
    }
    
    func checkAnswer(answer: Bool) -> Int{

        if(answer == true){
            if(prevCard.currentShape == currentCard.currentShape){
                correctAns += 1
                return 1
            }else{
                wrongAns += 1
                return 2
            }
        }else{
            if(prevCard.currentShape != currentCard.currentShape){
                correctAns += 1
                return 1
            }else{
                wrongAns += 1
                return 2
            }
        }
        
    }
    
    func showNextCard(result:Int){
        
        if let current = currentCard {
            let cardToRemove = current
            prevCard = current
            currentCard = nil
            AnimationEngine.animatetoPosition(cardToRemove, position: AnimationEngine.offScreenLeftPosition, completion: { (anim: POPAnimation!, Bool) -> Void in
                cardToRemove.removeFromSuperview()
            })
            
        }
        
        if let next = createCardFromNib() {
            next.center = AnimationEngine.offScreenRightPosition
            self.view.addSubview(next)
            currentCard = next
            
            if noBtn.hidden{
                noBtn.hidden = false
                yesBtn.setTitle("Yes", forState: .Normal)
            }
            
            if(result == 1){
                next.showCorrect()
            }
            if(result == 2){
                next.showWrong()
            }
            
            AnimationEngine.animatetoPosition(next, position: AnimationEngine.screenCenterPosition, completion: { (anim: POPAnimation!, finished: Bool) -> Void in
                next.checkImg.image = nil
            })
        }
    }
    
    func endGame(){
              
        resultView = NSBundle.mainBundle().loadNibNamed("Results", owner: self, options: nil)[0] as! Results
        resultView.correct = correctAns
        resultView.error = wrongAns
        resultView.setupView()
        resultView.center = AnimationEngine.screenCenterPosition
        resultView.delegate = self
        resultView.alpha = 0
        self.view.addSubview(resultView)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
           self.resultView.alpha = 1
            }, completion: { finished in
        })


    }
    
    func createCardFromNib() -> Card?{
        return NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)[0] as? Card
    }
    
    func restart() {
        
        self.correctAns = 0
        self.wrongAns = 0
        self.titleLbl.text = "Remember this image"
        self.yesBtn.setTitle("Start", forState: .Normal)
        self.noBtn.hidden = true
        timerLbl.text = "1:00"

    
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            self.resultView.alpha = 0
            
            }, completion: { finished in
        })
    }
}
