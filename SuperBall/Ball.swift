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
   
   private let SelfNumber: Int
   public var PositionX: Int
   public var PositionY: Int
   
   public var TouchBegan: CGPoint!
   
 
   init(BallPositionX: Int, BallPositionY: Int, BallColor: Int, ViewX: Int, ViewY: Int) {
      
      //let texture = SKTexture(imageNamed: "One.png")
      self.PositionX = BallPositionX
      self.PositionY = BallPositionY
      
      let texture: SKTexture
      
      switch BallColor {
      case 1:
         texture = SKTexture(imageNamed: "One.png")
         self.SelfNumber = BallColor
         break
      case 2:
         texture = SKTexture(imageNamed: "Two.png")
         self.SelfNumber = BallColor
         break
      case 3:
         texture = SKTexture(imageNamed: "Three.png")
         self.SelfNumber = BallColor
         break
      case 4:
         texture = SKTexture(imageNamed: "Four.png")
         self.SelfNumber = BallColor
         break
      case 5:
         texture = SKTexture(imageNamed: "Five.png")
         self.SelfNumber = BallColor
         break
      default:
         print("BallNumber is \(BallColor)")
         fatalError("BallNumber is NOT 1...4")
         break;
      }
      
      super.init(texture: texture, color: UIColor.cyan, size: CGSize(width: CGFloat(ViewX / 5), height: CGFloat(ViewX / 5)))
      
      self.isUserInteractionEnabled = true

      let Wide = ViewX / 5
      let Intarnal = ViewX / 25
      let FirstZure = -ViewX * 2 / 5
      let x1 = FirstZure + Intarnal * BallPositionX + Wide * (BallPositionX - 1)
      let y1 = -ViewY * 3 / 8 + Intarnal * BallPositionY + Wide * (BallPositionY - 1)
      self.position = CGPoint(x: x1, y: y1)

      
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
      print("--- ball info ---")
      print("ball num is \(self.SelfNumber)")
      print("ball posi is [\(self.PositionX)][\(self.PositionY)]")

//      print("touch!")
//      print("---event---")
//      print(event)
//      print("touches")
//      print(touches)

   }
   
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
