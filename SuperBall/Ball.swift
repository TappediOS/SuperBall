//
//  Ball.swift
//  SuperBall
//
//  Created by jun on 2018/11/20.
//  Copyright © 2018 jun. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class ball :SKSpriteNode {
   
   private let SelfNumber: Int = Int(arc4random_uniform(5) + 1)
   public var PositionX: Int
   //public var PositionY: Int
   
 
   init(Num: Int, Num2: Int) {
      let texture = SKTexture(imageNamed: "man")
      self.PositionX = Num
      super.init(texture: nil, color: UIColor.cyan, size: texture.size())
      
      self.position = CGPoint(x: Num, y: Num2)

      
      //PositionY = y
      //position = CGPoint(node.position.x, node.position.y + 10)
      //self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(10, 10))
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func ShowData() {
      print("Ball.position = \(self.position)")
      print("Ball.size = \(self.size)")
      print("Ball.selfNUM = \(self.SelfNumber)")
      print("Ball.PositionX = \(self.PositionX)")
      print("Ball.position = \(self.position)")

   }
   
}
