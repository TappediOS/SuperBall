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

class ScoreSet {
   
   public var Level:Int = 0
   private let LevelMax = 10
   public let ScoreForLevelUP = 250
   private let Base: Int = 10
   var YourScore: Int = 0
   var Combo: Int = 0
   
   var ScoreLabel: SKLabelNode = SKLabelNode(text: String(0))
   var ComboLabel: SKLabelNode = SKLabelNode(text: String(0))
   
   init() {
      ScoreLabel.fontSize = 100
      ComboLabel.fontSize = 100
   }
   
   public func InitScoreLabel(ViewX: Int, ViewY: Int) {
      let Wide = ViewX / 8
      let Hight = ViewY / 3
      
      let Intarnal = ViewX / 25
      let FirstZure = -ViewX * 2 / 5   //位置ズレ防止
      
      let ScoreLabelPositionX = FirstZure + Intarnal  + Wide
      let ScoreLabelPositionY = Hight
      
      let ComboLabelPositionX = FirstZure + Intarnal  + Wide * 3
      let ComboLabelPositionY = Hight
      
      ScoreLabel.position = CGPoint(x: ScoreLabelPositionX, y: ScoreLabelPositionY)
      
      ComboLabel.position = CGPoint(x: ComboLabelPositionX, y: ComboLabelPositionY)
   }
   
   public func InitLevel(Level: Int) {
      self.Level = Level
   }
   
   private func getScore(CountOfDis: Int) ->Int {
      
      switch CountOfDis {
      case 2:  //2個消えた
         return self.Base + Combo / 10
      case 4:  //3個消えた
         return self.Base * 2 + Combo / 5
      case 6:  //4個消えた
         return self.Base * 3 + Combo / 2
      default:
         print("なんでやねん")
         return self.Base + Combo / 10
      }
      
   }
   
   public func ResetCombo() {
      self.Combo = 0
      self.ComboLabel.text = String(self.Combo)
      return
   }
   
   public func ScoreUp(CountOfDis: Int){
      self.YourScore += getScore(CountOfDis: CountOfDis)
      self.Combo += 1
      self.ScoreLabel.text = String(self.YourScore)
      self.ComboLabel.text = String(self.Combo)
   }
   
   public func LevelUP() {
      
      guard self.LevelMax > self.Level else {
         return
      }
      
      self.Level += 1
      print("レベルアップしました。")
      print("Level = \(self.Level)")
   }
   
}
