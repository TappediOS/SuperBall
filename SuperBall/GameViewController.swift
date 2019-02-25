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
import GameKit
import Firebase
import Crashlytics

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADInterstitialDelegate {
   
   var userDefaults: UserDefaults = UserDefaults.standard
   
   let LEADERBOARD_ID = "BestTimeLeaderBoard"
   
   var Interstitial: GADInterstitial!
   let ADMOBTEST_ID = "ca-app-pub-3940256099942544/4411468910"
   let ADMOB_ID = "ca-app-pub-1460017825820383/3183891685"

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
      
      
      InitInstitial()
      
      //移動後に、揃ってるかの確認したいから通知を受け取る。。
      NotificationCenter.default.addObserver(self, selector: #selector(FinGameCatchNotification(notification:)), name: .FinGame, object: nil)
      
    }
   
   //MARK:- 広告初期化
   func InitInstitial() {
      
      #if DEBUG
         print("インターステイシャル:テスト環境")
         Interstitial = GADInterstitial(adUnitID: ADMOBTEST_ID)
         if let ADID = Interstitial.adUnitID {
            print("テスト広告ID読み込み完了")
            print("TestID = \(ADID)")
         }else{
            print("テスト広告ID読み込み失敗")
         }
      #else
         print("インターステイシャル:本番環境")
         Interstitial = GADInterstitial(adUnitID: ADMOB_ID)
      #endif
      
      self.Interstitial.delegate = self
      Interstitial.load(GADRequest())
   }
   
   
   //MARK:- ゲームセンターにデータを送信する関数
   private func PostTimeToGameCenter(PostTime: Float) {
      
      #if DEBUG
         return
      #else
     
      #endif
      
      let YourPostTime = Int(PostTime * 100)
      
      print("Float = \(PostTime)")
      print("Int = \(YourPostTime)")
      
      let SendScore: GKScore = GKScore()
      SendScore.value = Int64(YourPostTime)
      SendScore.leaderboardIdentifier = self.LEADERBOARD_ID
      
      let scoreArr: [GKScore] = [SendScore]
      GKScore.report(scoreArr, withCompletionHandler: {(error: NSError?) -> Void in
         if error != nil {
            print("スコア:\(PostTime) をゲームセンターに送信成功")
         } else {
            print("スコア:\(PostTime) をゲームセンターに送信できませんでした。")
         }
         } as? (Error?) -> Void)
      //send score finished
   }
   
   //MARK:- スコアの更新確認を行う。
   private func CheckHightScoreTime(UserTimeThatThisGame: Float){
      
      let NowUserHightScoreTime = userDefaults.float(forKey: "HeightScoreTime")
      
      //MARK: 強制的にデータ送信
      if userDefaults.object(forKey: "HeightScoreTime") == nil {
         userDefaults.set(UserTimeThatThisGame, forKey: "HeightScoreTime")
         userDefaults.synchronize()
         
         PostTimeToGameCenter(PostTime: UserTimeThatThisGame)
      }
      
      //MARK: 記録更新したらデータ送信する。
      if NowUserHightScoreTime > UserTimeThatThisGame {
         
         print("ハイスコア更新しました。\nデータをゲームセンターに送信します。")
         
         userDefaults.set(UserTimeThatThisGame, forKey: "HeightScoreTime")
         userDefaults.synchronize()
         
         PostTimeToGameCenter(PostTime: UserTimeThatThisGame)
      }
      
      print("ハイスコア更新はいしません。")
      
   }
   
   //MARK:- 広告表示する
   func ShowInterstitial(){
      
      if Interstitial.isReady {
         print("広告の準備できてるからpresentする!")
         Interstitial.present(fromRootViewController: self)
      }else{
         print("広告あかんかったからそのまま戻る")
         self.dismiss(animated: true, completion: nil)
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
      
      
      //MARK:- ここで閉じる
      ShowInterstitial()
     
   }
   
   
   //MARK:- 広告のデリゲート群
   //広告の読み込みが完了した時
   func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("\n-- Interstitial広告の読み込み完了 --\n")
      Analytics.logEvent("AdReadyOK", parameters: nil)
   }
   //広告の読み込みが失敗した時
   func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("\n-- Interstitial広告の読み込み失敗 --\n")
      Analytics.logEvent("AdNotReady", parameters: nil)
      
   }
   //広告画面が開いた時
   func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("広告開いた")
   }
   //広告をクリックして開いた画面を閉じる直前
   func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("閉じる直前")
   }
   //広告をクリックして開いた画面を閉じる直後
   func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      print("閉じる直後")
      AudioServicesPlaySystemSound(1519)
      self.dismiss(animated: true, completion: nil)
   }
   //広告をクリックした時
   func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("ボタンクリックした")
   }
   
   
   //MARK:- GKGameCenterControllerDelegate実装用
   func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
      gameCenterViewController.dismiss(animated: true, completion: nil)
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
