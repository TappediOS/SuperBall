//
//  HomeView.swift
//  SuperBall
//
//  Created by jun on 2019/02/22.
//  Copyright © 2019 jun. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import Firebase
import GameKit
import EAIntroView

class HomeViewController: UIViewController, GADBannerViewDelegate, GKGameCenterControllerDelegate, EAIntroDelegate {
   
   //MARK: Adのやつ
   let AdMobTEST_ID = "ca-app-pub-3940256099942544/2934735716"
   let AdMob_ID = "ca-app-pub-1460017825820383/5426911640"
   var BannerView: GADBannerView = GADBannerView()
   
   //MARK: リーダボードID
   let LEADERBOARD_ID = "BestTimeLeaderBoard"
   //MARK: Viewのサイズ
   let ViewWidth = UIScreen.main.bounds.size.width
   let ViewHeight = UIScreen.main.bounds.size.height
   
   //MARK: 広告の大きさ
   let AdViewHeight: CGFloat = 50
   //広告の端数
   let AdViewHeight_Fraction: CGFloat = 5
   
   //MARK: ラベル群
   @IBOutlet weak var HeightScore: UILabel!
   @IBOutlet weak var StartButton: UIButton!
   
   var RankingButton = UIButton()
   var YourHightScoreLabel = UILabel()
   
   //MARK: user defaults
   var userDefaults: UserDefaults = UserDefaults.standard
   
   //MARK: チュートリアルで使う。
   let Tutoro1 = EAIntroPage()
   let Tutoro2 = EAIntroPage()
   let Tutoro3 = EAIntroPage()
   let Tutoro4 = EAIntroPage()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      InitLabel()
      InitButton()
      InitBannerView()
      InitView()
      InitUserInfomation()
      
      if FirstOpenThisApp() == true {
         InitTutorialView()
         ShowTutorialView()
      }
   }
   
   //MARK:- チュートリアルの表示
   func ShowTutorialView(){
      
      if UIDevice.current.userInterfaceIdiom != .phone {
         return
      }
      
      
      let IntroViewFrame = CGRect(x: 0, y: 0, width: ViewWidth, height: ViewHeight)
      
      let IntroView = EAIntroView(frame: IntroViewFrame, andPages: [Tutoro1, Tutoro2, Tutoro3])
      IntroView?.skipButton.setTitle("スキップ", for: UIControl.State.normal) //スキップボタン欲しいならここで実装！
      IntroView?.delegate = self
      IntroView?.show(in: self.view, animateDuration: 1.0)
   }
   
   //MARK:- チュートリアルの初期化
   func InitTutorialView() {
      Tutoro1.bgImage = UIImage(named: "Swipe.png")
      Tutoro2.bgImage = UIImage(named: "Erace.png")
//      Tutoro3.title = "test"
//      Tutoro3.desc = "note"
      Tutoro3.bgImage = UIImage(named: "Until.png")
//      Tutoro3.titleFont = UIFont(name: "Helvetica-Bold", size: 32)
//      Tutoro3.titleColor = UIColor.orange
//      Tutoro3.descPositionY = self.view.bounds.size.height / 2
   }
   
   
   
   //MARK:- 初めて起動した(チュートリアルを出すかどうか)
   func FirstOpenThisApp() -> Bool {

      //first time
      if userDefaults.object(forKey: "FirstOpen") == nil {
         userDefaults.set(false, forKey: "FirstOpen")
         userDefaults.synchronize()
         return true
      }else{
         userDefaults.set(false, forKey: "FirstOpen")
         userDefaults.synchronize()
      }
      
      return false
   }
   
   //MARK:- ユーザ情報の初期化を行う。特に，最高記録の取得を行う。
   func InitUserInfomation() {
      //first time
      if userDefaults.object(forKey: "HeightScoreTime") == nil {
         HeightScore.text = NSLocalizedString("NoRecord", comment: "")
      }else{
         let NowUserHightScoreTime = userDefaults.float(forKey: "HeightScoreTime")
         HeightScore.text = String(NowUserHightScoreTime)
      }
   }
   
   //MARK:- Viewの初期化を行う
   func InitView(){
      view.backgroundColor = UIColor.init(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
   }
   
   //MARK:- 広告の初期化を行う。
   func InitBannerView() {
      
      #if DEBUG
         print("\n\n--------INFO ADMOB--------------\n")
         print("Google Mobile ads SDK Versioin -> " + GADRequest.sdkVersion() + "\n")
         BannerView.adUnitID = AdMobTEST_ID
         print("バナー広告：テスト環境\n\n")
      #else
         print("\n\n--------INFO ADMOB--------------\n")
         print("Google Mobile ads SDK Versioin -> " + GADRequest.sdkVersion() + "\n")
         BannerView.adUnitID = AdMob_ID
         print("バナー広告：本番環境")
      #endif
      
      BannerView.frame = CGRect(x: 0, y: ViewHeight - AdViewHeight - AdViewHeight_Fraction, width: ViewWidth, height: AdViewHeight)
      view.addSubview(BannerView)
      view.bringSubviewToFront(BannerView)
      
      BannerView.delegate = self
      BannerView.rootViewController = self
      
      BannerView.load(GADRequest())
   }
   
   //MARK:- ラベルの初期化を行う。
   func InitLabel() {
      
      let Found =  ViewWidth / 8
      let LabelWidth = Found * 6
      
      YourHightScoreLabel.text = NSLocalizedString("YourBestTime", comment: "")
      YourHightScoreLabel.adjustsFontSizeToFitWidth = true
      YourHightScoreLabel.frame = CGRect(x: Found, y: ViewHeight / 8, width: LabelWidth, height: ViewHeight / 8)
      YourHightScoreLabel.font = UIFont(name: "Helvetica", size: 60)
      YourHightScoreLabel.textColor = UIColor.white
      YourHightScoreLabel.textAlignment = NSTextAlignment.center
      view.addSubview(YourHightScoreLabel)
      
      HeightScore.frame = CGRect(x: Found, y: (ViewHeight / 8) * 2, width: LabelWidth, height: ViewHeight / 8)
      HeightScore.font = UIFont(name: "Helvetica", size: 50)
      HeightScore.adjustsFontSizeToFitWidth = true
      HeightScore.textColor = UIColor.white
      
   }

   //MARK:- ボタンの初期化を行う。
   func InitButton() {
      
      let StartButton_PositionY = (ViewHeight / 2) + (ViewHeight / 8) / 2

      StartButton.setTitle("Tap To Start", for: UIControl.State.normal)
      StartButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
      StartButton.backgroundColor = UIColor.init(displayP3Red: 61 / 255, green: 61 / 255, blue: 61 / 255, alpha: 1)
      StartButton.titleLabel?.font = UIFont(name: "Helvetica", size: 50)
      StartButton.titleLabel?.adjustsFontSizeToFitWidth = true
      StartButton.frame = CGRect(x: ViewWidth / 10, y: StartButton_PositionY, width: ViewWidth / 10 * 8, height: ViewHeight / 8)
      
      StartButton.layer.cornerRadius = 8
      StartButton.layer.borderWidth = 1
      StartButton.layer.borderColor = UIColor.white.cgColor
      
      RankingButton.setTitle(NSLocalizedString("Ranking", comment: ""), for: UIControl.State.normal)
      RankingButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
      RankingButton.backgroundColor = UIColor.init(displayP3Red: 61 / 255, green: 61 / 255, blue: 61 / 255, alpha: 1)
      RankingButton.titleLabel?.font = UIFont(name: "Helvetica", size: 50)
      RankingButton.titleLabel?.adjustsFontSizeToFitWidth = true
      RankingButton.frame = CGRect(x: ViewWidth / 10, y: StartButton_PositionY + (ViewHeight / 8) * 5 / 4, width: ViewWidth / 10 * 8, height: ViewHeight / 8)
      
      RankingButton.layer.cornerRadius = 8
      RankingButton.layer.borderWidth = 1
      RankingButton.layer.borderColor = UIColor.white.cgColor
      
      RankingButton.addTarget(self, action: #selector(HomeViewController.ShowRankingView), for: .touchUpInside)
      
      view.addSubview(RankingButton)
   }
   
   //MARK:- スコアの取得を行う(beta)
   func GetScore(){
      let leaderBoardRequest = GKLeaderboard.init()
      leaderBoardRequest.identifier = LEADERBOARD_ID
      leaderBoardRequest.playerScope = GKLeaderboard.PlayerScope.global
      leaderBoardRequest.timeScope = GKLeaderboard.TimeScope.allTime
      leaderBoardRequest.range = NSRange(location: 1,length: 10)
      
      leaderBoardRequest.loadScores(completionHandler: {
         scores, error in
         if (error == nil) {
            print("Okだったよ")
         } else {
            print("だめっだった")
         }
      })
   }
   
   //MARK:- スコアボードビューの表示
   @objc func ShowRankingView() {
      let gcView = GKGameCenterViewController()
      gcView.gameCenterDelegate = self
      gcView.viewState = GKGameCenterViewControllerState.leaderboards
      self.present(gcView, animated: true, completion: nil)
      
      Analytics.logEvent("LoadRankingView", parameters: nil)
   }
   
   //MARK:- GKGameCenterControllerDelegate実装用
   func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
      gameCenterViewController.dismiss(animated: true, completion: nil)
   }
   
   
   @IBAction func PlayGameButton(_ sender: Any) {
      
   }
   
   
   //MARK:- ゲームから帰ってきたときに，スコアの更新をする
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //first time
      if userDefaults.object(forKey: "HeightScoreTime") == nil {
         HeightScore.text = NSLocalizedString("NoRecord", comment: "")
      }else{
         let NowUserHightScoreTime = userDefaults.float(forKey: "HeightScoreTime")
         
         HeightScore.text = String(NowUserHightScoreTime)
      }
   }
   
   
   //MARK:- ADMOB
   /// Tells the delegate an ad request loaded an ad.
   func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("広告(banner)のロードが完了しました。")
   }
   
   /// Tells the delegate an ad request failed.
   func adView(_ bannerView: GADBannerView,
               didFailToReceiveAdWithError error: GADRequestError) {
      print("広告(banner)のロードに失敗しました。: \(error.localizedDescription)")
   }
   
   /// Tells the delegate that a full-screen view will be presented in response
   /// to the user clicking on an ad.
   func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
   }
   
   /// Tells the delegate that the full-screen view will be dismissed.
   func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
   }
   
   /// Tells the delegate that the full-screen view has been dismissed.
   func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
   }
   
   /// Tells the delegate that a user click will open another app (such as
   /// the App Store), backgrounding the current app.
   func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
   }
}
