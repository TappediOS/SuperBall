//
//  Particle.swift
//  SuperBall
//
//  Created by jun on 2018/12/31.
//  Copyright © 2018 jun. All rights reserved.
//

import Foundation
import SpriteKit

class Particles {
   
   var Particle: SKEmitterNode!
   private let ParticleTime = 0.4
   private let WaitTime = 0.4
   
   init(x: Int, y: Int, ViewX: Int, ViewY: Int, Color: Int) {
      
      let Wide = ViewX / 5
      let Intarnal = ViewX / 25
      let FirstZure = -ViewX * 2 / 5   //位置ズレ防止
      let x1 = FirstZure + Intarnal * x + Wide * (x - 1)
      let y1 = -ViewY * 3 / 8 + Intarnal * y + Wide * (y - 1)
      
      
      
      //ここで画像を選択。
      switch Color {
      case 1:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle1.sks")
         break
      case 2:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle2.sks")
         break
      case 3:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle3.sks")
         break
      case 4:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle4.sks")
         break
      case 5:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle5.sks")
         break
      case 6:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle6.sks")
         break
      case 7:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle7.sks")
         break
      case 8:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle8.sks")
         break
      case 9:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle9.sks")
         break
      case 10:
         Particle = SKEmitterNode.init(fileNamed: "RemoveParticle10.sks")
         break
      default:
         print("BallNumber is \(Color)")
         fatalError("BallNumber is NOT 1...4")
         break;
      }
      
      Particle.position = CGPoint(x: x1, y: y1)
      
      
   }
   
   func RetrutnParticle() -> SKEmitterNode {
      return self.Particle
   }
   
   func RemoveFromParent() {
      
      let WaitAction = SKAction.wait(forDuration: WaitTime)
      let RemoveAction = SKAction.removeFromParent()
      let HideAction = SKAction.fadeOut(withDuration: ParticleTime)
      let SeqAction = SKAction.sequence([WaitAction, HideAction, RemoveAction])
      
      self.Particle.run(SeqAction)
      
      
   }
   
   
}
