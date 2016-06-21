//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Kasey Schlaudt on 6/19/16.
//  Copyright © 2016 coprograming.com. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var MinerImg: MonsterImg!
    @IBOutlet weak var fruitImg: DragImg!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    @IBOutlet weak var restartBtn: UIButton!
    
    @IBOutlet weak var rockSelectCharacter: UIButton!
    @IBOutlet weak var minerSelectCharacter: UIButton!
    
    @IBOutlet weak var ground1: UIImageView!
    @IBOutlet weak var ground2: UIImageView!
    @IBOutlet weak var ground3: UIImageView!
    @IBOutlet weak var ground4: UIImageView!
    
    @IBOutlet weak var rockSenery: UIImageView!
    @IBOutlet weak var rockSenery2: UIImageView!
    @IBOutlet weak var rockSenery4: UIImageView!
    
    @IBOutlet weak var baseGrass1: UIImageView!
    @IBOutlet weak var baseGrass2: UIImageView!
    @IBOutlet weak var baseGrass3: UIImageView!
    @IBOutlet weak var baseGrass4: UIImageView!
    
    @IBOutlet weak var ground: UIImageView!
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = true
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameSelectingPlayer()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        fruitImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        monsterImg.playIdleAnimation()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        monsterHappy = false
        
        restartBtn.hidden = true
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        fruitImg.alpha = DIM_ALPHA
        fruitImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        
        if !monsterHappy {
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
 
        }
        
        let rand = arc4random_uniform(3)
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            
            fruitImg.alpha = DIM_ALPHA
            fruitImg.userInteractionEnabled = false
        } else if rand == 1 {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            fruitImg.alpha = DIM_ALPHA
            fruitImg.userInteractionEnabled = false
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            fruitImg.alpha = OPAQUE
            fruitImg.userInteractionEnabled = true

        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    @IBAction func restartPressed(sender: AnyObject) {
        gigaDied()
        
    }
    
    func gigaDied() {
        
        penalties = 0
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        heartImg.hidden = false
        foodImg.hidden = false
        restartBtn.hidden = true
        
        startTimer()
        monsterImg.playIdleAnimation()
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        restartBtn.hidden = false
        
        heartImg.hidden = true
        foodImg.hidden = true
    }
    
    func gameSelectingPlayer() {
        
        rockSelectCharacter.hidden = false
        minerSelectCharacter.hidden = false
        
        fruitImg.hidden = true
        heartImg.hidden = true
        foodImg.hidden = true
        penalty3Img.hidden = true
        penalty2Img.hidden = true
        penalty1Img.hidden = true
        
        
    }
    
    @IBAction func minerSelected(sender: AnyObject) {
        startTimer()
        rockSelectCharacter.hidden = true
        minerSelectCharacter.hidden = true
        ground1.hidden = true
        ground2.hidden = true
        ground3.hidden = true
        ground4.hidden = true
        
        baseGrass1.hidden = false
        baseGrass2.hidden = false
        baseGrass3.hidden = false
        baseGrass4.hidden = false
        
        ground.hidden = true
        
        MinerImg.hidden = false
        heartImg.hidden = false
        foodImg.hidden = false
        fruitImg.hidden = false
        penalty1Img.hidden = false
        penalty2Img.hidden = false
        penalty3Img.hidden = false
        
    }
    
    @IBAction func rockSelected(sender: AnyObject) {
        startTimer()
        rockSelectCharacter.hidden = true
        minerSelectCharacter.hidden = true
        ground1.hidden = true
        ground2.hidden = true
        ground3.hidden = true
        ground4.hidden = true
        
        rockSenery.hidden = false
        rockSenery2.hidden = false
        rockSenery4.hidden = false
        
        baseGrass1.hidden = true
        baseGrass2.hidden = true
        baseGrass3.hidden = true
        baseGrass4.hidden = true
        
        ground.hidden = false

        monsterImg.hidden = false
        heartImg.hidden = false
        foodImg.hidden = false
        fruitImg.hidden = false
        penalty1Img.hidden = false
        penalty2Img.hidden = false
        penalty3Img.hidden = false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}