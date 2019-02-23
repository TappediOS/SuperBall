//
//  PlaySound.swift
//  SuperBall
//
//  Created by jun on 2019/02/23.
//  Copyright © 2019 jun. All rights reserved.
//

import Foundation
import AVFoundation


class GameSounds {
   
   var audioPlayer: AVAudioPlayer! = nil
   
   init() {

      let soundFilePath = Bundle.main.path(forResource: "Mokkin", ofType: "mp3")
      let SoundURL: URL = URL(fileURLWithPath: soundFilePath!)

      do {
         audioPlayer = try AVAudioPlayer(contentsOf: SoundURL, fileTypeHint: nil)
      } catch {
         print("インスタンス作成失敗")
      }

      audioPlayer.prepareToPlay()
      
   }
   
   public func PlaySounds() {
      
      self.audioPlayer.currentTime = 0
      self.audioPlayer.play()
   }
   
}
