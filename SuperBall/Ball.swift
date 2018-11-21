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
   public var PositionY: Int
   
   public var TouchBegan: CGPoint!
   
 
   init(BallPositionX: Int, BallPositionY: Int, BallColor: Int) {
      
      //let texture = SKTexture(imageNamed: "One.png")
      self.PositionX = BallPositionX
      self.PositionY = BallPositionY
      
      let texture: SKTexture
      
      switch BallColor {
      case 1:
         texture = SKTexture(imageNamed: "One.png")
         break
      case 2:
         texture = SKTexture(imageNamed: "Two.png")
         break
      case 3:
         texture = SKTexture(imageNamed: "Three.png")
         break
      case 4:
         texture = SKTexture(imageNamed: "Four.png")
         break
      default:
         print("BallNumber is \(BallColor)")
         fatalError("BallNumber is NOT 1...4")
         break;
      }
      
      super.init(texture: texture, color: UIColor.cyan, size: texture.size())
      
      self.isUserInteractionEnabled = true
      self.yScale /= 8
      self.xScale /= 8

      self.position = CGPoint(x: -400 + BallPositionX * 150 + BallPositionX / 2, y: -400 + BallPositionY * 150 + BallPositionY / 2)

      
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
   
   private func WhereSwip(X: CGFloat, Y: CGFloat) -> Int {
     
      var degree:Int
      
      if(X != 0){
         let radian = atan(Y/abs(X)) //arctan からラジアンを求める
         degree = Int(radian * CGFloat(180 * M_1_PI)) //ラジアンから角度に変換
      }else{
         // x方向の変化がなかった場合(=垂直方向にスワイプされた場合)
         degree = Y < 0 ? -90:90;
      }
      print("角度は \(degree)")
      return degree
   }
   
   private func SwipCheck(x: CGFloat, y: CGFloat) {
      
      switch WhereSwip(X: x, Y: y) {
      case -90 ..< -45:
         print("下にスワイプされたよ")
      case -45 ..< 45:
         if(x >= 0){
            print("右にスワイプされたよ")
         }else{
            print("左にスワイプされたよ")
         }
      case 45 ... 90:
         print("上にスワイプされたよ")
      default:
         print("上にスワイプされたよ(default)")
      }
      
      print()
      return
  
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      print("ballタッチしたよ")
      self.color = UIColor.blue

//      print("touch!")
//      print("---event---")
//      print(event)
//      print("touches")
//      print(touches)

   }
   
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      print("ballタッチ終わり")
      self.color = UIColor.cyan
      
      if let TouchPoint = touches.first?.location(in: self) {
         var TmpPoint = TouchPoint
         TmpPoint.x = TmpPoint.x - self.position.x
         TmpPoint.y = TmpPoint.y - self.position.y
         print("touch End Point = \(TmpPoint)")
         SwipCheck(x: TmpPoint.x, y: TmpPoint.y)
         return
      }else{
         print("タッチ離したあと、Nilでした。")
         return
      }
      
      
   }
   
   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     // print("ballタッチが動いてる")
      self.color = UIColor.white
   }
   
   public func ChangeColor() {
      self.color = UIColor.blue
   }
   
   

   
}
