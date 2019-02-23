//
//  GameViewController.swift
//  SuperBall
//
//  Created by jun on 2018/11/20.
//  Copyright © 2018 jun. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
   
   
   var userDefaults: UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill

                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.accessibilityIgnoresInvertColors = true
         
         #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
         #else
            view.showsFPS = false
            view.showsNodeCount = false
         #endif
         
         
         
            view.backgroundColor = UIColor.white
        }
      
      
      //移動後に、揃ってるかの確認したいから通知を受け取る。。
      NotificationCenter.default.addObserver(self, selector: #selector(FinGameCatchNotification(notification:)), name: .FinGame, object: nil)
      
    }
   
   
   private func CheckHightScoreTime(UserTimeThatThisGame: Float){
      
      let NowUserHightScoreTime = userDefaults.float(forKey: "HeightScoreTime")
      
      //first time
      if userDefaults.object(forKey: "HeightScoreTime") == nil {
         userDefaults.set(UserTimeThatThisGame, forKey: "HeightScoreTime")
         userDefaults.synchronize()
      }
      
      if NowUserHightScoreTime > UserTimeThatThisGame {
         
         userDefaults.set(UserTimeThatThisGame, forKey: "HeightScoreTime")
         userDefaults.synchronize()
      }
      
   }
   
   //MARK:- 通知を受け取る関数郡
   @objc func FinGameCatchNotification(notification: Notification) -> Void {
      print("--- Game Fin notification ---")
      
      if let userInfo = notification.userInfo {
         let UserTime = userInfo["UserTime"]!
         
         CheckHightScoreTime(UserTimeThatThisGame: UserTime as! Float)
         print("time = \(UserTime)")
      }else{
         print("通知受け取ったけど、中身nilやった。")
      }
      
      self.dismiss(animated: true)
   }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
