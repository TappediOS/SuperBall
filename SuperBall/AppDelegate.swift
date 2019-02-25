//
//  AppDelegate.swift
//  SuperBall
//
//  Created by jun on 2018/11/20.
//  Copyright © 2018 jun. All rights reserved.
//

import UIKit
import StoreKit
import GameKit

import Firebase
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      
      
      //--------------------FIREBASE-----------------------//
      #if DEBUG
      let fileName = "GoogleService-Info"
      print("テスト環境")
      #else
      let fileName = "GoogleService-Info"
      print("本番のfirebaseにアクセス")
      #endif
      
      let filePath = Bundle.main.path(forResource: fileName, ofType: "plist")
      let fileopts = FirebaseOptions(contentsOfFile: filePath!)
      
      FirebaseApp.configure(options: fileopts!)
      
      //--------------------FIREBASE-----------------------//
      
      
      
      
      
      //MARK:- GameCenter
      if let rootView = self.window?.rootViewController {
         let player = GKLocalPlayer.local
         
         player.authenticateHandler = {(viewController, error) -> Void in
            if player.isAuthenticated {
               //geme center login
               print("ゲームセンターの認証完了")
               
            } else if viewController != nil {
               //game center not login. login page open
               print("ゲームセンターにログインしていません。ログインページを表示します。")
               rootView.present(viewController!, animated: true, completion: nil)
               
            } else {
               if error != nil {
                  //game center login error
                  print("ゲームセンターのログインでエラーが発生しました")
               }
            }
         }
      }
      ///MARK: GameCenter
      
      
      //Ads BannerView
      GADMobileAds.configure(withApplicationID: "ca-app-pub-1460017825820383~3403383539")
      //Ads BannerView
      GADMobileAds.configure(withApplicationID: "ca-app-pub-1460017825820383~3403383539")
      
      
      return true
   }

   func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   }

   func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }

   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }

   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }


}

