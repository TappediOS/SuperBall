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
import Animo
import AudioToolbox
import SpriteKitEasingSwift
import TapticEngine
import AVFoundation

class ball :SKSpriteNode {
   
   public let SelfNumber: Int
   private var Movement:Int      //動く距離を表す
   public var PositionX: Int
   public var PositionY: Int
   private let AnimateioSpeed: Double = 0.188   //動く際のアニメーションスピード
   private let FadeOutAnimationSpeed: Double = 0.17
   private let FadeInAnimationSpeed: Double = 0.196
   
   public var TouchBegan: CGPoint
   private var AreYouMoved: Bool = true
   private var AreYouLarge: Bool = false     //大きい状態かどうか
   
   private var AfterMovedPointX: CGFloat     //移動した後の座標X
   private var AfterMovedPointY: CGFloat     //これがないと移動後に位置がずれる
   
   public var YouAreJustDead = false
   
   
 
   
   
   /// クラスの初期化
   ///
   /// - Parameters:
   ///   - BallPositionX: X座標
   ///   - BallPositionY: Y座標
   ///   - BallColor: ボールの番号(画像)
   ///   - ViewX: 使用しているデバイスのWideを表す。
   ///   - ViewY: 使用しているデバイスのheightを表す
   init(BallPositionX: Int, BallPositionY: Int, BallColor: Int, ViewX: Int, ViewY: Int) {
      
      
      let Wide = ViewX / 5
      let Intarnal = ViewX / 25
      let FirstZure = -ViewX * 2 / 5   //位置ズレ防止
      let x1 = FirstZure + Intarnal * BallPositionX + Wide * (BallPositionX - 1)
      var y1 = -ViewY * 3 / 8 + Intarnal * BallPositionY
      y1 +=  Wide * (BallPositionY - 1)
      
      let texture: SKTexture
      
      self.PositionX = BallPositionX
      self.PositionY = BallPositionY
      self.Movement = Wide + Intarnal
      self.TouchBegan = CGPoint(x: 0, y: 0)
      
      self.AfterMovedPointX = CGFloat(x1)
      self.AfterMovedPointY = CGFloat(y1)
      
      //ここで画像を選択。
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
      case 6:
         texture = SKTexture(imageNamed: "Six.png")
         self.SelfNumber = BallColor
         break
      case 7:
         texture = SKTexture(imageNamed: "Seven.png")
         self.SelfNumber = BallColor
         break
      case 8:
         texture = SKTexture(imageNamed: "Eight.png")
         self.SelfNumber = BallColor
         break
      case 9:
         texture = SKTexture(imageNamed: "Nine.png")
         self.SelfNumber = BallColor
         break
      case 10:
         texture = SKTexture(imageNamed: "Ten.png")
         self.SelfNumber = BallColor
         break
      default:
         print("BallNumber is \(BallColor)")
         fatalError("BallNumber is NOT 1...4")
         break;
      }
      
      super.init(texture: texture, color: UIColor.cyan, size: CGSize(width: CGFloat(ViewX / 5), height: CGFloat(ViewX / 5)))
      
      //ノードがタッチできる状態にする。
      self.isUserInteractionEnabled = true

      //ポジションの設定。
      self.position = CGPoint(x: x1, y: y1)
      

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
   
   
   
   /// スワイプされた角度を求める
   ///
   /// - Parameters:
   ///   - X: 横にどれだけ移動しているか。
   ///   - Y: 縦にどれだけ移動したのか。
   /// - Returns: スワイプされた角度を変えす
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
   
   
   /// スワイプされた情報をGameSceneに送信する関数
   ///
   /// - Parameter Vect: スワイプ方向
   private func PostNotification(Vect: String){
      
      let SentObject: [String : Any] = ["SentX": self.PositionX as Int,
                                        "SentY": self.PositionY as Int,
                                        "Vect": Vect as String]
      
      print("")
      NotificationCenter.default.post(name: .MoveBall, object: nil, userInfo: SentObject)
   }
   
   private func FinishMovePostMotification() {
      
      let SentObject: [String : Any] = ["x": self.PositionX as Int,
                                        "y": self.PositionY as Int]
      print("")
      NotificationCenter.default.post(name: .FinishMove, object: nil, userInfo: SentObject)
   }
   
   private func PostNotifivationForPlaySound(BallNum: Int) {
      
      let SentObject: [String : Any] = ["BallNum": BallNum as Int]
      
      print("")
      NotificationCenter.default.post(name: .PlaySoundNotifi, object: nil, userInfo: SentObject)
   }
   
   
   /// スワイプされた方向をNotificationに送信する
   ///
   /// - Parameters:
   ///   - X: 横にどれだけ移動しているか。
   ///   - Y: 縦にどれだけ移動したのか。
   private func SwipCheck(x: CGFloat, y: CGFloat) {
      
      switch WhereSwip(X: x, Y: y) {
      case -90 ..< -45:
         print("下にスワイプされたよ")
         PostNotification(Vect: "Down")
      case -45 ..< 45:
         if(x >= 0){
            print("右にスワイプされたよ")
            PostNotification(Vect: "Right")
         }else{
            print("左にスワイプされたよ")
            PostNotification(Vect: "Left")
         }
      case 45 ... 90:
         print("上にスワイプされたよ")
         PostNotification(Vect: "Up")
      default:
         print("上にスワイプされたよ(default)")
         PostNotification(Vect: "Up")
      }
      
      print()
      return
  
   }
   
   
   /// ノードを大きくする関数
   private func LargeAnimation() {
      
      //Large状態でなければ大きくする。
      if self.AreYouLarge == false {
         let Large: SKAction = SKAction.scale(by: 1.2, duration: 0.2)
         self.run(Large)
         self.AreYouLarge = true
         return
      }
   }
 
   /// ノードを小さくする関数
   private func SmallAnimateion() {
      
      //Large状態であれば小さくする
      if self.AreYouLarge == true {
         let Small: SKAction = SKAction.scale(by: 1 / 1.2, duration: 0.2)
         self.run(Small)
         self.AreYouLarge = false
         return
      }
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

      print("AreYouMoved = \(self.AreYouMoved)")
      
      guard self.YouAreJustDead == false else {
         print("動けません。消えます")
         return
      }
      
      PostNotifivationForPlaySound(BallNum: self.SelfNumber)
      
      guard self.AreYouMoved == true else {
         print("移動中です。(StartPoint)")
         return
      }
      
      Play3Dtouch()
      
      
      
      print("--- ball info ---")
      print("ball num is \(self.SelfNumber)")
      print("ball posi is [\(self.PositionX)][\(self.PositionY)]")
      
    
      if let TouchStartPoint = touches.first?.location(in: self) {
         self.TouchBegan = TouchStartPoint
         print("touch Start Point = \(self.TouchBegan)")
         LargeAnimation()
      }else{
         print("タッチ離したとき、Nilでした。")
      }
      
      return
   }
   
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
      guard self.AreYouMoved == true else {
         print("移動中です。(EndPoint)")
         return
      }
      
      guard self.YouAreJustDead == false else {
         print("動けません。消えます")
         return
      }
      
      self.AreYouMoved = false
      
      if let TouchEndPoint = touches.first?.location(in: self) {
         var TmpPoint = TouchEndPoint
         TmpPoint.x = TmpPoint.x - self.TouchBegan.x
         TmpPoint.y = TmpPoint.y - self.TouchBegan.y
         print("touch End Point = \(TouchEndPoint)")
         SmallAnimateion()
         if LengthOfTwoPoint(Start: TouchBegan, End: TouchEndPoint) == false {
            print("移動はしません")
            self.AbleToMove(OnlyOnePoint: true)
            return
         }
         SwipCheck(x: TmpPoint.x, y: TmpPoint.y)
         return
      }else{
         print("タッチ離したあと、Nilでした。")
         return
      }
      
      
   }
   
   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     // print("ballタッチが動いてる")
   }
   
   public func ChangeColor() {
      self.color = UIColor.blue
   }
   
   private func AfterMoveInfo(First: Bool) {
      
      if First == true {
         print("Firstの位置情報")
         print("First[\(self.PositionX)][\(self.PositionY)]")
      }else{
         print("Secondの位置情報")
         print("Second[\(self.PositionX)][\(self.PositionY)]")
      }
      print("")
      return
      
   }
   
   public func MoveUp(MoveX: Int, MoveY: Int, First: Bool) {
      
      self.AreYouMoved = false
      self.PositionY += 1
      
      let MovePoint = CGPoint(x: self.AfterMovedPointX, y: self.AfterMovedPointY + CGFloat(Movement))
      
      self.AfterMovedPointY = MovePoint.y
      
     Play3Dtouch()

      //let Aktion: SKAction = SKAction.move(to: MovePoint, duration: AnimateioSpeed)
      
      let Aktion = SKEase.move(easeFunction: .curveTypeQuadratic, easeType: .easeTypeOut, time: self.AnimateioSpeed, from: self.position, to: MovePoint)
      
      
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove(OnlyOnePoint: false)
      }) ])
      self.run(action)
      
      AfterMoveInfo(First: First)
   }
   
   public func MoveDown(MoveX: Int, MoveY: Int, First: Bool){
      
      self.AreYouMoved = false
      self.PositionY -= 1
      
      let MovePoint = CGPoint(x: self.AfterMovedPointX, y: self.AfterMovedPointY - CGFloat(Movement))
      
      self.AfterMovedPointY = MovePoint.y
      
      Play3Dtouch()

      let Aktion = SKEase.move(easeFunction: .curveTypeQuadratic, easeType: .easeTypeOut, time: self.AnimateioSpeed, from: self.position, to: MovePoint)
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove(OnlyOnePoint: false)
      }) ])
      self.run(action)
      
      AfterMoveInfo(First: First)

   }
   
   public func MoveRight(MoveX: Int, MoveY: Int, First: Bool) {
      
      self.AreYouMoved = false
      self.PositionX += 1
      
      let MovePoint = CGPoint(x: self.AfterMovedPointX + CGFloat(Movement), y: AfterMovedPointY)
      
      self.AfterMovedPointX = MovePoint.x
      
      Play3Dtouch()

      let Aktion = SKEase.move(easeFunction: .curveTypeQuadratic, easeType: .easeTypeOut, time: self.AnimateioSpeed, from: self.position, to: MovePoint)
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove(OnlyOnePoint: false)
      }) ])
      self.run(action)
      AfterMoveInfo(First: First)
   }
   
   public func MoveLeft(MoveX: Int, MoveY: Int, First: Bool) {
      
      self.AreYouMoved = false
      self.PositionX -= 1
      let MovePoint = CGPoint(x: self.AfterMovedPointX - CGFloat(Movement), y: AfterMovedPointY)
      
      self.AfterMovedPointX = MovePoint.x
      
      Play3Dtouch()

      
      let Aktion = SKEase.move(easeFunction: .curveTypeQuadratic, easeType: .easeTypeOut, time: self.AnimateioSpeed, from: self.position, to: MovePoint)
      let action = SKAction.sequence([Aktion, SKAction.run({ [weak self] in
         self?.AbleToMove(OnlyOnePoint: false)
      }) ])
      self.run(action)
      AfterMoveInfo(First: First)
   }
   
   public func AbleToMove(OnlyOnePoint: Bool){
      print("動けるようになりました。")
      self.AreYouMoved = true
      if OnlyOnePoint == false {
         self.FinishMovePostMotification()
      }
      return
   }
   
   private func SoundPlay(){
      
//      switch self.SelfNumber {
//      case 1:
//         <#code#>
//      case 2:
//
//      case 3:
//
//      case 4:
//
//      case 5:
//
//      case 6:
//
//      case 7:
//
//      case 8:
//
//      case 9:
//
//      case 10:
//
//
//      default:
//         <#code#>
//      }
   }
   
   public func RemoveBall() {
      
      SoundPlay()
      
      let LargeAction = SKEase.scale(easeFunction: .curveTypeCubic, easeType: .easeTypeIn, time: FadeOutAnimationSpeed, from: 1, to: 1.3)
      
      let FadeOut = SKEase.fade(easeFunction: .curveTypeExpo, easeType: .easeTypeOut, time: FadeInAnimationSpeed, fromValue: 1, toValue: 0.04)
      let SmallAction = SKEase.scale(easeFunction: .curveTypeQuartic, easeType: .easeTypeOut, time: FadeInAnimationSpeed, from: 1.3, to: 0.2)
      
      let groupAktion = SKAction.group([FadeOut, SmallAction])
      
      let Remove = SKAction.removeFromParent()
      let FadeAction = SKAction.sequence([LargeAction, groupAktion, Remove])
      
      self.run(FadeAction)
   }
   
   
   
   
   public func ReCreatedAnimation() {
      
      self.isHidden = true
      
      let WaitActon = SKAction.wait(forDuration: FadeOutAnimationSpeed + FadeInAnimationSpeed + FadeOutAnimationSpeed * 0.1)
      
      let SmallAction = SKEase.scale(easeFunction: .curveTypeQuartic, easeType: .easeTypeOut, time: 0.02, from: 0.2, to: 0.15)
      let FadeOutAction = SKEase.fade(easeFunction: .curveTypeExpo, easeType: .easeTypeOut, time: 0.02, fromValue: 0.05, toValue: 0.01)
      
      let LargeAction = SKEase.scale(easeFunction: .curveTypeBack, easeType: .easeTypeOut, time: FadeInAnimationSpeed, from: 0.15, to: 1)
      let FadeInAction = SKEase.fade(easeFunction: .curveTypeBack, easeType: .easeTypeOut, time: FadeInAnimationSpeed, fromValue: 0.01, toValue: 1)
      
      let WaitGroup = SKAction.sequence([WaitActon, SKAction.run({ [weak self] in
         self?.isHidden = false
      }) ])
      let SmallAcitonGroup = SKAction.group([SmallAction, FadeOutAction])
      let LargeActionGroup = SKAction.group([LargeAction, FadeInAction])
      
      let RecreatedAktion = SKAction.sequence([WaitGroup, SmallAcitonGroup, LargeActionGroup])
      

      self.run(RecreatedAktion)
      AudioServicesPlaySystemSound(1521)
   }
   
   
   /// 2点間の距離を求め、距離が十分であるかどうか調べる
   ///
   /// - Parameters:
   ///   - Start: 始点
   ///   - End: 終点
   /// - Returns: 一定以上ならばtrueを返す。
   private func LengthOfTwoPoint(Start: CGPoint, End: CGPoint) -> Bool {
   
      let xDistance = Start.x - End.x
      let yDistance = Start.y - End.y
      let distance = sqrtf(Float(xDistance*xDistance + yDistance*yDistance))
      
      print("2点間の距離は\(distance)")
      
      if distance < 55 {
         return false
      }
      
      return true
   }
   
   func is3dTouchAvailable(traitCollection: UITraitCollection) -> Bool {
      return traitCollection.forceTouchCapability == UIForceTouchCapability.available
   }
   
   //MARK:- 3dタッチならす
   private func Play3Dtouch() {
      TapticEngine.impact.feedback(.medium)
      //TapticEngine.notification.feedback(.warning)
      return
   }
   
}
