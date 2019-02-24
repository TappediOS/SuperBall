//
//  GKLocalPlayerUtil.swift
//  SuperBall
//
//  Created by jun on 2019/02/23.
//  Copyright © 2019 jun. All rights reserved.
//

import Foundation
import UIKit
import GameKit

struct GKLocalPlayerUtil {
   
   static var localPlayer:GKLocalPlayer = GKLocalPlayer();
   
   static func login(target: UIViewController){
      self.localPlayer = GKLocalPlayer.localPlayer
      self.localPlayer.authenticateHandler = {(viewController, error) -> Void in
         if ((viewController) != nil) {
            print("LoginCheck: Failed - LoginPageOpen")
            target.presentViewController(viewController, animated: true, completion: nil);
         }else{
            print("LoginCheck: Success")
            if (error == nil){
               print("LoginAuthentication: Success")
            }else{
               print("LoginAuthentication: Failed")
            }
         }
      }
   }
}

