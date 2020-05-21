//
//  ViewController.swift
//  LandscapeModeVideoPlayer
//
//  Created by Aamier T Mgr on 5/21/20.
//  Copyright © 2020 aamiertmgr. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
  
  //Mark:IBOutlets
  @IBOutlet weak var videoView: UIView!
  
  var player:AVPlayer?
  var playerLayer:AVPlayerLayer?
  
  //Mark: ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.videoView.contentMode = .scaleToFill
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.playVideo()
  }
  
  
  //Mark:Observe screen mode change
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    DispatchQueue.main.async {
      self.playerLayer?.frame = self.videoView.bounds
    }
  }
  
  //Mark: User defined methods
  
  private func playVideo() {
    
    //Initialize video path
    guard let path = Bundle.main.path(forResource: "myvideo", ofType:"mp4") else {
      debugPrint("myvideo.mp4 not found")
      return
    }
    
    //Initialize url for video
    let url = URL(fileURLWithPath: path)
    
    //Initialize video player with url of video
    player = AVPlayer(url: url)
    
    //Initialize video player layer
    playerLayer = AVPlayerLayer(player: player)
    
    guard let player = player else {
      print("player not initialized.")
      return
    }
    
    //Repeat video infinitely
    self.loopVideo(videoPlayer: player)
    
    //Set playerLayer frame to view iboutlet.
    playerLayer?.frame = self.videoView.bounds
    
    guard let playerLayer = playerLayer else {
      print("Player layer not initialized.")
      return
    }
    
    //Add player layer to uiview
    videoView.layer.addSublayer(playerLayer)
    
    //Play video
    player.play()
  }
  
  //Method to loop video
  func loopVideo(videoPlayer: AVPlayer) {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
      videoPlayer.seek(to: CMTime.zero)
      videoPlayer.play()
    }
  }
}

