//
//  Referee.swift
//  SuperBall
//
//  Created by jun on 2018/11/20.
//  Copyright © 2018 jun. All rights reserved.
//

import Foundation

class referee {
   
   public var CheckedNum: Int
   public var CountOfBall : Int
   public var GameCount: Int
   
   init(Num: Int, Count: Int){
      self.CheckedNum = Num
      self.CountOfBall = Count
      self.GameCount = 0
   }
   
   public func InitCheckCount() {
      self.CheckedNum = 0
      self.CountOfBall = 0
   }
   
   
}
