//
//  GameScene.swift
//  SuperBall
//
//  Created by jun on 2018/11/20.
//  Copyright © 2018 jun. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
import SCLAlertView

class GameScene: SKScene {
    
    //private var label : SKLabelNode?
   private var spinnyNode : SKShapeNode?
   private var AllBall: [[ball]] = [[]]
   
   private let OpenStage = HoldStage(Flame: 1)
   private let Score = ScoreSet()
   
   private var ExistCombo = 0 //2になったら消える。
   private var CountForExistConbo = 0
   
   private let Time = GameTimer()
   
   private var GameSound = GameSounds()
   
    override func didMove(to view: SKView) {

      //ビューの長さを取得
      let ViewSizeX = self.scene?.frame.width
      let ViewSizeY = self.scene?.frame.height
      
      self.backgroundColor = UIColor.init(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 0)
     
      
      InitStageSize(SizeX: ViewSizeX, SizeY: ViewSizeY)
      InitScore()
      SetStageBall()
      InitGameTimer()
      
      
      //移動するために通知を受け取る
      NotificationCenter.default.addObserver(self, selector: #selector(MoveCatchNotification(notification:)), name: .MoveBall, object: nil)
      //移動後に、揃ってるかの確認したいから通知を受け取る。。
      NotificationCenter.default.addObserver(self, selector: #selector(FinishMoveCatchNotification(notification:)), name: .FinishMove, object: nil)
      
      NotificationCenter.default.addObserver(self, selector: #selector(PlaySoundNotification(notification:)), name: .PlaySoundNotifi, object: nil)
      
      
      
    }
   
   
   //MARK:- スコア、ステージ、Ballの初期化をする。
   private func InitGameTimer() {
      Time.InitTimer(ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
      Time.StartTimer()
      addChild(Time.TimerLabel)
   }
   
   private func InitScore() {
      Score.InitScoreLabel(ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
      Score.InitLabel(ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
      Score.InitLevel(Level: OpenStage.StageNumMAX)
      addChild(Score.ScoreLabel)
      addChild(Score.ComboLabel)
      //addChild(Score.ComboUpLabel)
      addChild(Score.LebelUpLabel)
      addChild(Score.score)
      addChild(Score.combo)
      addChild(Score.time)
   }
   
   private func InitStageSize(SizeX: CGFloat?, SizeY: CGFloat?){
      if let X = SizeX {
         OpenStage.SetStageSizeX(SizeX: X)
      }else{
         fatalError("ビューの横を初期化できませんでした。")
      }
      
      if let Y = SizeY {
         OpenStage.SetStageSizeY(SizeY: Y)
      }else{
         fatalError("ビューの縦を初期化できませんでした。")
      }
   }


   private func SetStageBall() {
      var Ball1: ball = ball(BallPositionX: -1, BallPositionY: -1, BallColor: 1, ViewX: -1, ViewY: -1)
      var Ball2: ball = ball(BallPositionX: -1, BallPositionY: -1, BallColor: 1, ViewX: -1, ViewY: -1)
      var Ball3: ball = ball(BallPositionX: -1, BallPositionY: -1, BallColor: 1, ViewX: -1, ViewY: -1)
      var Ball4: ball = ball(BallPositionX: -1, BallPositionY: -1, BallColor: 1, ViewX: -1, ViewY: -1)
      
      for x in 1 ... 4 {
         for y in 1 ... 4 {
            let StageNum: Int = OpenStage.Stage[x][y]
            switch y {
            case 1:
               Ball1 = ball(BallPositionX: x, BallPositionY: y, BallColor: StageNum, ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
               Ball1.name = "\(x)+\(y)"
               addChild(Ball1)
               break
            case 2:
               Ball2 = ball(BallPositionX: x, BallPositionY: y, BallColor: StageNum, ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
               Ball2.name = "\(x)+\(y)"
               addChild(Ball2)
               break
            case 3:
               Ball3 = ball(BallPositionX: x, BallPositionY: y, BallColor: StageNum, ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
               Ball3.name = "\(x)+\(y)"
               addChild(Ball3)
               break
            case 4:
               Ball4 = ball(BallPositionX: x, BallPositionY: y, BallColor: StageNum, ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
               Ball4.name = "\(x)+\(y)"
               addChild(Ball4)
               break
            default:
               fatalError("Cant Create Ball")
               break
            }
         }
         AllBall.append([Ball1, Ball2, Ball3, Ball4])
      }
      print("AllBallの初期化完了")
      for x in 1 ... 4 {
         for y in 0 ... 3 {
            print("AllBall[\(x)][\(y)].selfnum = \(AllBall[x][y].SelfNumber)")
         }
         print("")
      }
      print("")
      
      ShowAllBall()
   }
   
   //MARK:- 端っこのやつが画面外に出ないよう判断する関数
   private func AbleToMoveBall(FirstX: Int, FirstY: Int, Vect: String) -> Bool{
      
      switch Vect {
      case "Up":
         if FirstY == 4{
            print("\n上には移動できません")
            return false
         }
         break
      case "Down":
         if FirstY == 1{
            print("\n下には移動できません")
            return false
         }
         break
      case "Right":
         if FirstX == 4{
            print("\n右には移動できません")
            return false
         }
         break
      case "Left":
         if FirstX == 1{
            print("\n左には移動できません")
            return false
         }
         break
      default:
         fatalError("\n変な方向送られてきた。")
         break;
      }
      
      return true
   }
   
   //MARK:- 2つ目のBallの座標を取得する。
   private func GetSecondX(FirstX: Int, FirstY: Int, Vect: String) -> Int{
      switch Vect {
      case "Up":
         return FirstX
      case "Down":
         return FirstX
      case "Right":
         return FirstX + 1
      case "Left":
         return FirstX - 1
      default:
         fatalError("変な方向送られてきた。")
         break;
      }
   }
   
   private func GetSecondY(FirstX: Int, FirstY: Int, Vect: String) -> Int{
      switch Vect {
      case "Up":
         return FirstY + 1
      case "Down":
         return FirstY - 1
      case "Right":
         return FirstY
      case "Left":
         return FirstY
      default:
         fatalError("変な方向送られてきた。")
         break;
      }
   }
   
   
   //MARK:- 座標変換
   private func SwapAllBall(FirstX: Int, FirstY: Int, SecondX: Int, SecondY: Int){
    
      let Tmp = AllBall[FirstX][FirstY - 1]
      AllBall[FirstX][FirstY - 1] = AllBall[SecondX][SecondY - 1]
      AllBall[SecondX][SecondY - 1] = Tmp
      return
   }
   
   private func SwapStageNum(FirstX: Int, FirstY: Int, SecondX: Int, SecondY: Int){
      
      let Tmp = self.OpenStage.Stage[FirstX][FirstY]
      OpenStage.Stage[FirstX][FirstY] = OpenStage.Stage[SecondX][SecondY]
      OpenStage.Stage[SecondX][SecondY] = Tmp
      return
   }
   
   //MARK:- ballを動かす
   private func MoveDoubleBall(FirstX: Int, FirstY: Int, SecondX: Int, SecondY: Int, Vect: String){
      
      switch Vect {
      case "Up":
         AllBall[FirstX][FirstY - 1].MoveUp(MoveX: FirstX, MoveY: FirstY, First: true)
         AllBall[SecondX][SecondY - 1].MoveDown(MoveX: SecondX, MoveY: SecondY, First: false)
         break
      case "Down":
         AllBall[FirstX][FirstY - 1].MoveDown(MoveX: FirstX, MoveY: FirstY, First: true)
         AllBall[SecondX][SecondY - 1].MoveUp(MoveX: SecondX, MoveY: SecondY, First: false)
         break
      case "Right":
         AllBall[FirstX][FirstY - 1].MoveRight(MoveX: FirstX, MoveY: FirstY, First: true)
         AllBall[SecondX][SecondY - 1].MoveLeft(MoveX: SecondX, MoveY: SecondY, First: false)
         break
      case "Left":
         AllBall[FirstX][FirstY - 1].MoveLeft(MoveX: FirstX, MoveY: FirstY, First: true)
         AllBall[SecondX][SecondY - 1].MoveRight(MoveX: SecondX, MoveY: SecondY, First: false)
         break
      default:
         fatalError("変な方向送られてきた。")
         break;
      }
      
      SwapAllBall(FirstX: FirstX, FirstY: FirstY, SecondX: SecondX, SecondY: SecondY)
      SwapStageNum(FirstX: FirstX, FirstY: FirstY, SecondX: SecondX, SecondY: SecondY)
      
      return
   }
   
   private func CheckMoveDoubleBall(FirstX: Int, FirstY: Int, Vect: String){
      
      if AbleToMoveBall(FirstX: FirstX, FirstY: FirstY, Vect: Vect) == false {
         AllBall[FirstX][FirstY - 1].AbleToMove(OnlyOnePoint: false)
         return
      }
      
      let SecondX: Int = GetSecondX(FirstX: FirstX, FirstY: FirstY, Vect: Vect)
      let SecondY: Int = GetSecondY(FirstX: FirstX, FirstY: FirstY, Vect: Vect)
      
      PrintMoveInfo(FirstX: FirstX, FirstY: FirstY, SecondX: SecondX, SecondY: SecondY)
      MoveDoubleBall(FirstX: FirstX, FirstY: FirstY, SecondX: SecondX, SecondY: SecondY, Vect: Vect)
      ShowAllBall()
      ShowAllStageNum()
      return
   }
   
   
   //MARK:- 情報出力
   private func ShowAllStageNum() {
      print("\n--- All Stage Into ---")
      
      for x in 1...4{
         print("[", terminator: "")
         for y in 1 ... 4 {
            print(" \(self.OpenStage.Stage[x][y])", terminator: "")
         }
         print(" ]")
      }
      print("--------------------")
      return
   }
   
   private func ShowAllBall(){
      
      print("\n--- All Ball Into ---")
      
      for y in (0...3).reversed(){
         print("[", terminator: "")
         for x in 1 ... 4 {
            print(" \(AllBall[x][y].SelfNumber)", terminator: "")
         }
         print(" ]")
      }
      print("--------------------")
      return
   }
   
   private func PrintMoveInfo(FirstX: Int, FirstY: Int, SecondX: Int, SecondY: Int){
      
      print("\n移動する2つの座標が決定しました。")
      print("1つめは座標[\(FirstX)][\(FirstY)]")
      print("2つめは座標[\(SecondX)][\(SecondY)]")
      return
   }
   
   
   //MARK:- 通知を受け取る関数郡
   @objc func MoveCatchNotification(notification: Notification) -> Void {
      print("--- Move notification ---")

      if let userInfo = notification.userInfo {
         let SentedX = userInfo["SentX"] as! Int
         let SentedY = userInfo["SentY"] as! Int
         let Vect = userInfo["Vect"] as! String
         print("\nSentedX = \(SentedX)")
         print("SentedY = \(SentedY)")
         print("Vect = \(Vect)")
         //GameSound.PlaySounds(BallNumber: AllBall[SentedX][SentedY - 1].SelfNumber)
         CheckMoveDoubleBall(FirstX: SentedX, FirstY: SentedY, Vect: Vect)
      }else{
         print("通知受け取ったけど、中身nilやった。")
      }
      
      return
   }
   
   @objc func FinishMoveCatchNotification(notification: Notification) -> Void {
      print("--- Finish Move notification ---")
  
      if let userInfo = notification.userInfo {
         let x = userInfo["x"] as! Int
         let y = userInfo["y"] as! Int
         CheckStage(x: x, y: y)
      }else{
         print("通知受け取ったけど、中身nilやった。")
      }
      return
   }
   
   @objc func PlaySoundNotification(notification: Notification) -> Void {
      print("--- Play Sounds notification ---")
      
      if let userInfo = notification.userInfo {
         let BallNumber = userInfo["BallNum"] as! Int
         GameSound.PlaySounds(BallNumber: BallNumber)
      }else{
         print("通知受け取ったけど、中身nilやった。")
      }
      return
   }
   
   private func ShowCheck(x: Int , y: Int) {
      print("\nstage[\(x)][\(y)]が一致しています。\n")
   }
   
   
   //MARK:- ゲーム終了！
   private func GameSet() {
      print("gameSet")
      let FinTime = Time.StopTimer()
      print("time = \(FinTime)")
      ShowGameSetView(FinTime: FinTime)
      
   }
   
   private func ShowGameSetView(FinTime: Float){
      
      let GameSetView = SCLAlertView()
      GameSetView.addButton("Button1"){
         print("tap")
         let SentObject: [String : Any] = ["UserTime": FinTime]
         NotificationCenter.default.post(name: .FinGame, object: nil, userInfo: SentObject)
      }
      GameSetView.showSuccess("Compleate", subTitle: "Time:\(FinTime)")
   }
   
   //MARK:- スコアを上げる関数
   private func ScoreUP(Count: Int) {
      if Score.ScoreUp(CountOfDis: Count) == false {
         return
      }
      
      GameSet()
   }
   
   //MARK:- レベルを上げる関数
   private func CheckLevelUP() {
      if Score.Level == 4 && Score.YourScore > Score.ScoreForLevelUP * (Score.Level - 3) {
         Score.LevelUP()
         OpenStage.StageNumMAX += 1
      }
      
      if Score.Level == 5 && Score.YourScore > Score.ScoreForLevelUP * (Score.Level - 3) {
         Score.LevelUP()
         OpenStage.StageNumMAX += 1
      }
      
      if Score.Level == 6 && Score.YourScore > Score.ScoreForLevelUP * (Score.Level - 3) {
         Score.LevelUP()
         OpenStage.StageNumMAX += 1
      }
      
      if Score.Level == 7 && Score.YourScore > Score.ScoreForLevelUP * (Score.Level - 3) {
         Score.LevelUP()
         OpenStage.StageNumMAX += 1
      }
      
      if Score.Level == 8 && Score.YourScore > Score.ScoreForLevelUP * (Score.Level - 3) {
         Score.LevelUP()
         OpenStage.StageNumMAX += 1
      }
      
      if Score.Level == 9 && Score.YourScore > Score.ScoreForLevelUP * (Score.Level - 3) {
         Score.LevelUP()
         OpenStage.StageNumMAX += 1
      }
   }
   
    
   //MARK:- ここで、ボールが何個消えるかが決定する。
   private func CheckStage(x: Int, y: Int) {
    
      let CheckTapple = self.OpenStage.CheckStage(x: x, y: y)
      
      CountForExistConbo += 1
      if CountForExistConbo == 3 {
         CountForExistConbo = 1
         ExistCombo = 0
      }
      
      guard CheckTapple.1 == true else {
         print("一致しているものは存在していませんでした。")
         
         ExistCombo += 1
         
         if ExistCombo == 2 {
            Score.ResetCombo()
         }
         
         return
      }
      
      
      
      //移動できなくする。
      self.AllBall[x][y - 1].YouAreJustDead = true
      
      let Count = CheckTapple.0.count
      
      //MARK: スコアを上げる関数に飛ばす。
      ScoreUP(Count: Count)
      //MARK: レベルアップするかどうかを判断
      CheckLevelUP()
      
      //2個消す。
      if Count == 2 {
         Remove2Balls(x1: x, y1: y, x2: CheckTapple.0[0], y2: CheckTapple.0[1])
         Create2Balls(x1: x, y1: y, x2: CheckTapple.0[0], y2: CheckTapple.0[1])
         
         return
      }
      
      //3個消す。
      if Count == 4 {
         Remove3Balls(x1: x, y1: y, x2: CheckTapple.0[0], y2: CheckTapple.0[1], x3: CheckTapple.0[2], y3: CheckTapple.0[3])
         Create3Balls(x1: x, y1: y, x2: CheckTapple.0[0], y2: CheckTapple.0[1], x3: CheckTapple.0[2], y3: CheckTapple.0[3])
         return
      }
      
      //4個消す。
      if Count == 6 {
         Remove4Balls(x1: x, y1: y, x2: CheckTapple.0[0], y2: CheckTapple.0[1], x3: CheckTapple.0[2], y3: CheckTapple.0[3], x4: CheckTapple.0[4], y4: CheckTapple.0[5])
         Create4Balls(x1: x, y1: y, x2: CheckTapple.0[0], y2: CheckTapple.0[1], x3: CheckTapple.0[2], y3: CheckTapple.0[3], x4: CheckTapple.0[4], y4: CheckTapple.0[5])
         
         return
      }
      
      print("ここに入るのはおかしい。")
      fatalError("ここに入るのはおかしい。")
      
   }
   
   func RemoveParticle(x1: Int, y1: Int, Color: Int){
      
      let Part = Particles(x: x1, y: y1, ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY), Color: Color)
      addChild(Part.RetrutnParticle())
      Part.RemoveFromParent()
      
   }
   //MARK:- ボールを生成する処理
   private func CreateBall(x: Int, y: Int) {
      OpenStage.ChangeStageNum(x: x, y: y)
      let StageNum = OpenStage.Stage[x][y]
      let balls = ball(BallPositionX: x, BallPositionY: y , BallColor: StageNum, ViewX: Int(OpenStage.ViewSizeX), ViewY: Int(OpenStage.ViewSizeY))
      AllBall[x][y - 1] = balls
      addChild(balls)
      AllBall[x][y - 1].ReCreatedAnimation()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
         self.RemoveParticle(x1: x, y1: y, Color: self.AllBall[x][y - 1].SelfNumber)
      }
      return
   }
   
   private func Create2Balls(x1: Int, y1: Int, x2: Int, y2: Int){
      self.CreateBall(x: x1, y: y1)
      self.CreateBall(x: x2, y: y2)
   }
   
   private func Create3Balls(x1: Int, y1: Int, x2: Int, y2: Int, x3: Int, y3: Int){
      self.CreateBall(x: x1, y: y1)
      self.CreateBall(x: x2, y: y2)
      self.CreateBall(x: x3, y: y3)
   }
   
   private func Create4Balls(x1: Int, y1: Int, x2: Int, y2: Int, x3: Int, y3: Int, x4: Int, y4: Int){
      self.CreateBall(x: x1, y: y1)
      self.CreateBall(x: x2, y: y2)
      self.CreateBall(x: x3, y: y3)
      self.CreateBall(x: x4, y: y4)
   }
   
   
   //MARK:- ボールを削除する処理
   private func Remove2Balls(x1: Int, y1: Int, x2: Int, y2: Int){
      AllBall[x1][y1 - 1].RemoveBall()
      
      AllBall[x2][y2 - 1].RemoveBall()
   }
   
   private func Remove3Balls(x1: Int, y1: Int, x2: Int, y2: Int, x3: Int, y3: Int){
      AllBall[x1][y1 - 1].RemoveBall()
      
      AllBall[x2][y2 - 1].RemoveBall()
      AllBall[x3][y3 - 1].RemoveBall()
   }
   
   private func Remove4Balls(x1: Int, y1: Int, x2: Int, y2: Int, x3: Int, y3: Int, x4: Int, y4: Int){
      AllBall[x1][y1 - 1].RemoveBall()
      
      AllBall[x2][y2 - 1].RemoveBall()
      AllBall[x3][y3 - 1].RemoveBall()
      AllBall[x4][y4 - 1].RemoveBall()
   }
   
   
   
   //MARK:- タッチイベント
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
      print("Tap Point is \(pos)")
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
      
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
      
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
