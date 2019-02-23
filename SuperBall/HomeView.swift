//
//  HomeView.swift
//  SuperBall
//
//  Created by jun on 2019/02/22.
//  Copyright © 2019 jun. All rights reserved.
//

import Foundation
import UIKit


class HomeViewController: UIViewController {
   
   
   @IBOutlet weak var HeightScore: UILabel!
   
   var userDefaults: UserDefaults = UserDefaults.standard
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
      //first time
      if userDefaults.object(forKey: "HeightScoreTime") == nil {
         HeightScore.text = "nil"
      }else{
         let NowUserHightScoreTime = userDefaults.float(forKey: "HeightScoreTime")
         
         HeightScore.text = String(NowUserHightScoreTime)
      }

      //print(UserDefaults.standard.string(forKey: "HeightScoreTime"))
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
}
