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

class HomeViewController: UIViewController, GADBannerViewDelegate {
   
   let AdMobTEST_ID = "ca-app-pub-3940256099942544/2934735716"
   let AdMob_ID = "ca-app-pub-1460017825820383/5426911640"
   
   var BannerView: GADBannerView = GADBannerView()
   
   let ViewWidth = UIScreen.main.bounds.size.width
   let ViewHeight = UIScreen.main.bounds.size.height
   
   let AdViewHeight: CGFloat = 50
   
   @IBOutlet weak var HeightScore: UILabel!
   
   var userDefaults: UserDefaults = UserDefaults.standard
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
      InitLabel()
      InitBannerView()
      
      //first time
      if userDefaults.object(forKey: "HeightScoreTime") == nil {
         HeightScore.text = "nil"
      }else{
         let NowUserHightScoreTime = userDefaults.float(forKey: "HeightScoreTime")
         
         HeightScore.text = String(NowUserHightScoreTime)
      }

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
         BannerView.adUnitID = AdMob_ID
         print("バナー広告：本番環境")
      #endif
      
      BannerView.frame = CGRect(x: 0, y: ViewHeight - AdViewHeight - 5, width: ViewWidth, height: AdViewHeight)
      view.addSubview(BannerView)
      view.bringSubviewToFront(BannerView)
      
      BannerView.delegate = self
      BannerView.rootViewController = self
      
      BannerView.load(GADRequest())
   }
   
   func InitLabel() {
      HeightScore.font = UIFont(name: "Helvetica", size: 50)
      HeightScore.adjustsFontSizeToFitWidth = true
      HeightScore.textColor = UIColor.white
      
   }
   
   
   
   
   @IBAction func PlayGameButton(_ sender: Any) {
      
     

      
   }
   
   
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //first time
      if userDefaults.object(forKey: "HeightScoreTime") == nil {
         HeightScore.text = "nil"
      }else{
         let NowUserHightScoreTime = userDefaults.float(forKey: "HeightScoreTime")
         
         HeightScore.text = String(NowUserHightScoreTime)
      }
   }
   
   
   
   //MARK:- ADMOB
   /// Tells the delegate an ad request loaded an ad.
   func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("広告のロードが完了しました。")
   }
   
   /// Tells the delegate an ad request failed.
   func adView(_ bannerView: GADBannerView,
               didFailToReceiveAdWithError error: GADRequestError) {
      print("広告のロードに失敗しました。: \(error.localizedDescription)")
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
