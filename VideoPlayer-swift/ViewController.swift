//
//  ViewController.swift
//  VideoPlayer-swift
//
//  Created by Han Chen on 6/6/2016.
//  Copyright © 2016年 Han Chen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

enum AppError: ErrorType {
  case InvalidResource(String, String)
}

enum PlayStatusType: Int {
  case Play
  case Pause
  case Stop
}

class ViewController: UIViewController {
  @IBOutlet weak var toolbar: UIToolbar!
  
  var avPlayer: AVPlayer!
  var avPlayerViewController: AVPlayerViewController!
  var avPlayerLayer: AVPlayerLayer!
  var playStatus: PlayStatusType = .Play

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.setupPause_BarButtonItem()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupPause_BarButtonItem() {
    switch self.playStatus {
    case .Play:
      let pause_BarButtonItem = UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: #selector(playAndPauseButtonPressed))
      self.toolbar.items![0] = pause_BarButtonItem
    case .Pause:
      let play_BarButtonItem = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: #selector(playAndPauseButtonPressed))
      self.toolbar.items![0] = play_BarButtonItem
      break
    case .Stop:
      break
    }
  }

  func playLocalVideo(videoName: String, videoType: String) throws {
    guard let path = NSBundle.mainBundle().pathForResource(videoName, ofType: videoType) else {
      throw AppError.InvalidResource(videoName, videoType)
    }
    
    self.avPlayer = AVPlayer(URL: NSURL(fileURLWithPath: path))
    self.avPlayerViewController = AVPlayerViewController()
    self.avPlayerViewController.player = self.avPlayer
    self.presentViewController(self.avPlayerViewController, animated: true) {
      self.avPlayer.play()
      self.playStatus = .Play
    }
  }
  
  func playRemoteVideo(url: NSURL) throws {
    self.avPlayer = AVPlayer(URL: url)
    self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
    
    self.avPlayerLayer.frame = CGRectMake(20, 200, UIScreen.mainScreen().bounds.width - 20 * 2, 200)
    self.avPlayerLayer.backgroundColor = UIColor.lightGrayColor().CGColor
    self.view.layer.addSublayer(self.avPlayerLayer)
    self.avPlayer.play()
    self.playStatus = .Play
  }
  
  // MARK: - IBAction
  @IBAction func playLocalVideoButtonPressed(sender: UIBarButtonItem) {
    let videoName = "xcodevideo"
    let videoType = "mp4"
    do {
      try playLocalVideo(videoName, videoType: videoType)
    } catch AppError.InvalidResource(videoName, videoType) {
      print("Colud not find resource \(videoName).\(videoType)")
    } catch {
      print("Play locat video error")
    }
  }
  
  @IBAction func playRemoteVideoButtonPressed(sender: UIBarButtonItem) {
    let url: NSURL! = NSURL(string: "http://devstreaming.apple.com/videos/swift/assets/xcode-hd.mp4")
    do {
      try playRemoteVideo(url)
    } catch {
      print("Play remote video error")
    }
  }
  
  func playAndPauseButtonPressed(sender: UIBarButtonItem) {
    if avPlayer != nil {
      switch self.playStatus {
      case .Play:
        self.avPlayer.pause()
        self.playStatus = .Pause
        break
      case .Pause:
        self.avPlayer.play()
        self.playStatus = .Play
        break
      case .Stop:
        break
      }
      self.setupPause_BarButtonItem()
    }
  }
}

