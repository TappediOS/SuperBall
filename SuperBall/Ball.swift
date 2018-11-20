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
   
   public var TouchBegan: CGPoint!
   
 
   init(Num: Int, Num2: Int) {
      let texture = SKTexture(imageNamed: "man")
      self.PositionX = Num
      super.init(texture: nil, color: UIColor.cyan, size: texture.size())
      
      self.isUserInteractionEnabled = true

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
         print("touch End Point = \(TouchPoint)")
         SwipCheck(x: TouchPoint.x, y: TouchPoint.y)
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
