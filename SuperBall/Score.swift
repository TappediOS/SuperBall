//
//  Score.swift
//  SuperBall
//
//  Created by jun on 2018/12/04.
//  Copyright © 2018 jun. All rights reserved.
//

import Foundation
import SpriteKit
import SpriteKitEasingSwift
import AudioToolbox

class ScoreSet {
   
   private let FinalScore = 1750  //1750
   
   public var Level:Int = 0
   private let LevelMax = 10
   public let ScoreForLevelUP = 250
   private let Base: Int = 13
   var YourScore: Int = 0
   var Combo: Int = 0
   
   var MaxCombo: Int = 0
   
   private let ScoreUpAnimationTime = 0.8
   
   var ScoreLabel: SKLabelNode = SKLabelNode(text: String(0))
   var ComboLabel: SKLabelNode = SKLabelNode(text: String(0))
   //var ComboUpLabel: SKLabelNode = SKLabelNode(text: "0")
   
   var LebelUpLabel: SKLabelNode = SKLabelNode(text: "Level Up!")
   
   var score: SKLabelNode
   var combo: SKLabelNode
   var time: SKLabelNode
   
   private let FadeOutAnimationSpeed: Double = 0.17
   private let FadeInAnimationSpeed: Double = 0.196
   private let ReSetComboAnimationSpeed: Double = 0.09
   private var LevelUpAnimationSpeed: Double = 2.2
   private let LevelUpAnimationSpeed_SpeedUp = 0.05
   
   private var ComboLabelPositionX: CGFloat = 0
   private var ComboLabelPositionY: CGFloat = 0
   
   private var LebelUpLabelPositionX: CGFloat = 0
   private var LebelUpLabelPositionY: CGFloat = 0
   
   private var LebelUpLabelPositionXAfterMove: CGFloat = 0
   
   
   
   init() {
      ScoreLabel.fontSize = 100
      ComboLabel.fontSize = 100
      LebelUpLabel.fontSize = 180

      score = SKLabelNode(text: NSLocalizedString("Score", comment: ""))
      combo = SKLabelNode(text: NSLocalizedString("Combo", comment: ""))
      time = SKLabelNode(text: NSLocalizedString("Time", comment: ""))
      
      score.fontSize = 50
      combo.fontSize = 50
      time.fontSize = 50
   }
   
   public func InitLabel(ViewX: Int, ViewY: Int){
      
      let Wide = ViewX / 10
      let Internal = Wide / 4
      let Hight = ViewY / 3 + Int(ScoreLabel.fontSize / 2) + Int(score.fontSize / 2)
      
      let HalfViewX = ViewX / 2
      
      let ScoreLabelPositionX = Internal + (Wide * 4) / 2 - HalfViewX
      let ScoreLabelPositionY = Hight
      
      score.position = CGPoint(x: ScoreLabelPositionX, y: ScoreLabelPositionY)
      combo.position = CGPoint(x: Internal + Wide * 4 + Internal + (Wide * 2) / 2 - HalfViewX, y: Hight)
      time.position = CGPoint(x: Internal + Wide * 4 + Internal + Wide * 2 + Internal + (Wide * 3) / 2 - HalfViewX, y: Hight)
      
   }
   
   public func InitScoreLabel(ViewX: Int, ViewY: Int) {
      
//      let Wide = ViewX / 8
//      let Hight = ViewY / 3
//
//      let Intarnal = ViewX / 25
//      let FirstZure = -ViewX * 2 / 5   //位置ズレ防止
//
//      let ScoreLabelPositionX = FirstZure + Intarnal  + Wide
//      let ScoreLabelPositionY = Hight
      
      let Wide = ViewX / 10
      let Internal = Wide / 4
      let Hight = ViewY / 3 - Int(ScoreLabel.fontSize / 2)
      
      let HalfViewX = ViewX / 2
      
      let ScoreLabelPositionX = Internal + (Wide * 4) / 2 - HalfViewX
      let ScoreLabelPositionY = Hight
      
      ScoreLabel.position = CGPoint(x: ScoreLabelPositionX, y: ScoreLabelPositionY)
      
      self.ComboLabelPositionX = CGFloat(Internal + Wide * 4 + Internal + (Wide * 2) / 2 - HalfViewX)
      self.ComboLabelPositionY = CGFloat(Hight)
   
      ComboLabel.position = CGPoint(x: ComboLabelPositionX, y: ComboLabelPositionY)
      
      
      LebelUpLabelPositionX = CGFloat(-ViewX)
      LebelUpLabelPositionY = CGFloat(Hight) - CGFloat(self.LebelUpLabel.fontSize / 2 + self.ScoreLabel.fontSize)
      LebelUpLabelPositionXAfterMove = CGFloat(ViewX)
      
      LebelUpLabel.position = CGPoint(x: LebelUpLabelPositionX, y: LebelUpLabelPositionY)
      
      //ComboUpLabel.position = CGPoint(x: ComboLabelPositionX , y: ComboLabelPositionY - 20)
      //ComboUpLabel.isHidden = true
   }
   
   public func InitLevel(Level: Int) {
      self.Level = Level
   }
   
   private func getScore(CountOfDis: Int) ->Int {
      
      switch CountOfDis {
      case 2:  //2個消えた
         return self.Base + Combo / 2
      case 4:  //3個消えた
         return self.Base * 2 + Combo
      case 6:  //4個消えた
         return self.Base * 3 + Int(Double(Combo) * 1.25)
      default:
         print("なんでやねん")
         return self.Base + Combo / 10
      }
      
   }
   
   private func ResetComboAnimation(){
      
      let LeftAnimation = SKEase.move(easeFunction: .curveTypeBack, easeType: .easeTypeIn, time: ReSetComboAnimationSpeed,
                                      from: CGPoint(x: self.ComboLabel.position.x, y: self.ComboLabel.position.y),
                                      to: CGPoint(x: self.ComboLabel.position.x - (self.ComboLabel.fontSize / 2), y: self.ComboLabel.position.y))
      
      let RightAnimation = SKEase.move(easeFunction: .curveTypeBack, easeType: .easeTypeIn, time: ReSetComboAnimationSpeed,
                                      from: CGPoint(x: self.ComboLabel.position.x, y: self.ComboLabel.position.y),
                                      to: CGPoint(x: self.ComboLabel.position.x + (self.ComboLabel.fontSize / 2), y: self.ComboLabel.position.y))
   
      let YourPositionAnimation = SKEase.move(easeFunction: .curveTypeBack, easeType: .easeTypeIn, time: ReSetComboAnimationSpeed,
                                      from: CGPoint(x: self.ComboLabel.position.x, y: self.ComboLabel.position.y),
                                      to: CGPoint(x: self.ComboLabelPositionX, y: self.ComboLabelPositionY))
      
      let Group = SKAction.sequence([LeftAnimation, RightAnimation, YourPositionAnimation])
      
      self.ComboLabel.run(Group)
      AudioServicesPlaySystemSound( 1102 )
   }
   
   public func GetMaxCombo() -> Int {
      return self.MaxCombo
   }
   
   public func ResetCombo() {
      if self.Combo >= self.MaxCombo {
         self.MaxCombo = self.Combo
      }
      self.Combo = 0
      ResetComboAnimation()
      self.ComboLabel.text = String(self.Combo)
      return
   }
   
   public func ScoreUpAnimation(CountOfDis: Int){

      self.YourScore += getScore(CountOfDis: CountOfDis)
      self.Combo += 1
      
      let LargeAction = SKEase.scale(easeFunction: .curveTypeCubic, easeType: .easeTypeIn, time: FadeOutAnimationSpeed, from: 1, to: 1.3)
      let FadeOut = SKEase.fade(easeFunction: .curveTypeExpo, easeType: .easeTypeOut, time: FadeInAnimationSpeed, fromValue: 1, toValue: 0.04)
      let SmallAction = SKEase.scale(easeFunction: .curveTypeQuartic, easeType: .easeTypeOut, time: FadeInAnimationSpeed, from: 1.3, to: 0.2)
      let groupAktion = SKAction.group([FadeOut, SmallAction])
      let FadeAction = SKAction.sequence([LargeAction, groupAktion])
      let SmallAndScoreUpGroup = SKAction.sequence([FadeAction, SKAction.run({ [weak self] in
         self?.ScoreLabel.text = String(self!.YourScore)
         self?.ComboLabel.text = String(self!.Combo)
      }) ])
      let LargeActionAfter = SKEase.scale(easeFunction: .curveTypeBack, easeType: .easeTypeOut, time: FadeInAnimationSpeed, from: 0.15, to: 1)
      let FadeInAction = SKEase.fade(easeFunction: .curveTypeBack, easeType: .easeTypeOut, time: FadeInAnimationSpeed, fromValue: 0.01, toValue: 1)
      let LargeActionGroup = SKAction.group([LargeActionAfter, FadeInAction])
      let RecreatedAktion = SKAction.sequence([SmallAndScoreUpGroup, LargeActionGroup])
      
      self.ScoreLabel.run(RecreatedAktion)
      self.ComboLabel.run(RecreatedAktion)
   }
   
   private func ComboUpLabelAnimation(){
      //self.ComboUpLabel.isHidden = false
      
      //let FadeOut = SKEase.fade(easeFunction: .curveTypeExpo, easeType: .easeTypeOut, time: 0.01, fromValue: 1, toValue: 0.04)
   }
   
   public func ScoreUp(CountOfDis: Int) -> Bool{
      ScoreUpAnimation(CountOfDis: CountOfDis)
      ComboUpLabelAnimation()
      
      if self.YourScore >= FinalScore {
         return true
      }
      
      return false
   }
   
   private func LevelUpAnimation() {
      
      let RightAnimation = SKEase.move(easeFunction: .curveTypeQuartic,
                                       easeType: .easeTypeOut,
                                       time: LevelUpAnimationSpeed,
                                       from: CGPoint(x: LebelUpLabelPositionX, y: LebelUpLabelPositionY),
                                       to: CGPoint(x: LebelUpLabelPositionXAfterMove, y: LebelUpLabelPositionY))
      
      self.LebelUpLabel.run(RightAnimation)
      self.LevelUpAnimationSpeed -= self.LevelUpAnimationSpeed_SpeedUp
      
   }
   
   public func LevelUP() {
      
      guard self.LevelMax > self.Level else {
         return
      }
      
      self.Level += 1
      LevelUpAnimation()
      print("レベルアップしました。")
      print("Level = \(self.Level)")
   }
   
}
