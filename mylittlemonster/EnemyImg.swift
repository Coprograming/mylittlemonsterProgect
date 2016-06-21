//
//  EnemyImg.swift
//  mylittlemonster
//
//  Created by Kasey Schlaudt on 6/21/16.
//  Copyright © 2016 coprograming.com. All rights reserved.
//

import Foundation
import UIKit

class EnemyImg: MonsterImg {
    
    override func playIdleAnimation(){
    
        self.image = UIImage(named: "idle1Enemy.png")
    
        self.animationImages = nil
    
        var imgArray = [UIImage]()
        for x in 1...4{
            let img = UIImage(named: "idle\(x)Enemy.png")
            imgArray.append(img!)
        }
    
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    override func playDeathAnimation() {
        
        self.image = UIImage(named: "hide6.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for x in 1...6{
            let img = UIImage(named: "hide\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }

}

