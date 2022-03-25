//
//  PsVideoView.swift
//  react-native-ps-video
//
//  Created by Mzalih on 03/02/22.
//

import UIKit
import AVKit

class PsVideoView: UIView {
  @objc var color: String = "" {
    didSet {
      backgroundColor = .init(hexColor: color)
    }
  }
  
  @objc var url: String = "" {
    didSet {
      print("url is\(url)")
      PsVideoView.player = AVPlayer(url: URL(string: url)!)
    }
  }
  
  @objc var paused: Bool = false {
    didSet {
      if paused {
        PsVideoView.player?.pause()
        controlsView.playButton.isSelected = false
      }
      else {
        PsVideoView.player?.play()
        controlsView.playButton.isSelected = true
      }
    }
  }
  
  @objc var play: Bool = false {
    didSet {
      if play {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.initVideoPlayer()
          self.playAction()
        }
      }
      else {
        self.pauseAction()
      }
    }
  }
  
  @objc var stop: Bool = false {
    didSet {
      self.stopAction()
    }
  }
  
  @objc var controls: Bool = false {
    didSet {
      if controls {
        self.controlsView.isHidden = false
      }
      else {
        self.controlsView.isHidden = true
      }
    }
  }
  
  @objc var onBuffering: RCTBubblingEventBlock?
  
  @objc var maxBitRate: String = "" {
    didSet {
      self.controlsView.videoQualityButton.setTitle(maxBitRate, for: .normal)
      self.setBitRate(maxBitRate)
    }
  }
  
  @objc var watermarkText: String = "" {
    didSet {
      self.controlsView.watermarkLabel.text = watermarkText
    }
  }
  
  //Player
  var playerView: UIView = UIView()
  static var player: AVPlayer?
  var playerLayer: AVPlayerLayer?
  var controlsView: PsVideoControlsView = PsVideoControlsView()
  var timeObserver: Any?
  var isTimerRunning: Bool = false
  var timer = Timer()
  var playerSpeed: String = "1.0x"
  var playerQuality: String = "360p"
  
  override init (frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    setup()
  }
  
  func setup () {
    addPlayerView()
    addControlsView()
  }
  
  func initVideoPlayer() {
    playerLayer = AVPlayerLayer(player: PsVideoView.player)
    playerLayer?.frame = playerView.bounds
    playerLayer?.videoGravity = .resizeAspect
    playerLayer?.needsDisplayOnBoundsChange = true
    playerView.layer.addSublayer(playerLayer!)
  }
  
  static func playNextVideo(url: String) {
    let playerItem = AVPlayerItem(url: URL(string: "https://secure.northernskystar.com/v1/videos/watch?v=443&session_id=Ek4EbK7rzziHQ66")!)
    self.player?.replaceCurrentItem(with: playerItem)
    self.player?.seek(to: .zero)
    player?.play()
  }
  
  func addPlayerView() {
    addSubview(playerView)
    playerView.translatesAutoresizingMaskIntoConstraints = false
    let leadingConstraint = NSLayoutConstraint(item: playerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    let trailingConstraint = NSLayoutConstraint(item: playerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    let topConstraint = NSLayoutConstraint(item: playerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: playerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
    self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    
    let gestureControlsView = UITapGestureRecognizer(target: self, action:  #selector (self.handleControlsViewTouchAction(_:)))
    controlsView.viewToTap.addGestureRecognizer(gestureControlsView)
    let gesturePlayerView = UITapGestureRecognizer(target: self, action:  #selector (self.handlePlayerViewTouchAction(_:)))
    playerView.addGestureRecognizer(gesturePlayerView)
  }
  
  func addControlsView() {
    addSubview(controlsView)
    
    controlsView.translatesAutoresizingMaskIntoConstraints = false
    let leadingConstraint = NSLayoutConstraint(item: controlsView, attribute: .leading, relatedBy: .equal, toItem: playerView, attribute: .leading, multiplier: 1, constant: 0)
    let trailingConstraint = NSLayoutConstraint(item: controlsView, attribute: .trailing, relatedBy: .equal, toItem: playerView, attribute: .trailing, multiplier: 1, constant: 0)
    let topConstraint = NSLayoutConstraint(item: controlsView, attribute: .top, relatedBy: .equal, toItem: playerView, attribute: .top, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: controlsView, attribute: .bottom, relatedBy: .equal, toItem: playerView, attribute: .bottom, multiplier: 1, constant: 0)
    self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    
    controlsView.playButton.addTarget(self, action:#selector(self.playAction), for: .touchUpInside)
    controlsView.stopButton.addTarget(self, action:#selector(self.stopAction), for: .touchUpInside)
    controlsView.forwardButton.addTarget(self, action:#selector(self.forwardAction), for: .touchUpInside)
    controlsView.backwardButton.addTarget(self, action:#selector(self.backwardAction), for: .touchUpInside)
    controlsView.fullScreenButton.addTarget(self, action:#selector(self.fullScreenAction), for: .touchUpInside)
    controlsView.sliderControl.addTarget(self, action: #selector(self.sliderAction), for: .valueChanged)
    controlsView.settingsButton.addTarget(self, action: #selector(self.settingsAction), for: .touchUpInside)
    controlsView.videoQualityButton.addTarget(self, action: #selector(self.videoQualityAction), for: .touchUpInside)
    controlsView.delegate = self
  }
  
  @objc func playAction() {
    if controlsView.playButton.isSelected {
      PsVideoView.player?.pause()
      controlsView.playButton.isSelected = false
    }
    else {
      addObservers()
      PsVideoView.player?.play()
      controlsView.playButton.isSelected = true
      setBitRate(playerQuality)
      setVideoSpeed(rate: playerSpeed)
    }
  }
  
  @objc func pauseAction() {
    PsVideoView.player?.pause()
    controlsView.playButton.isSelected = false
  }
  
  func addObservers() {
    if timeObserver == nil {
      addTimeObserver()
    }
  }
  
  func removeObservers() {
    if timeObserver != nil {
      PsVideoView.player?.removeTimeObserver(timeObserver!)
    }
  }
  
  @objc func stopAction() {
    let newtime = 0
    let time: CMTime = CMTimeMake(value: Int64(newtime*1000), timescale: 1000)
    PsVideoView.player?.seek(to: time)
    PsVideoView.player?.pause()
    controlsView.playButton.isSelected = false
  }
  
  @objc func forwardAction() {
    var time: CMTime = CMTime()
    guard let duration = PsVideoView.player?.currentItem?.duration else {return}
    let currentTime = CMTimeGetSeconds((PsVideoView.player?.currentTime())!)
    var newTime = currentTime + 15
    if newTime > (CMTimeGetSeconds(duration)) {
      newTime = CMTimeGetSeconds(duration)
      controlsView.playButton.isSelected = false
    }
    time = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
    PsVideoView.player?.seek(to: time)
  }
  
  @objc func backwardAction() {
    var time: CMTime = CMTime()
    let currentTime = CMTimeGetSeconds((PsVideoView.player?.currentTime())!)
    var newTime = currentTime - 5
    if newTime < 0 {
      newTime = 0
    }
    
    time = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
    PsVideoView.player?.seek(to: time)
  }
  
  @objc func fullScreenAction() {
    var topVC = UIApplication.shared.keyWindow?.rootViewController
    while((topVC!.presentedViewController) != nil) {
      topVC = topVC!.presentedViewController
    }
    
    let psVideoFullViewVC = PsVideoFullViewVC()
    psVideoFullViewVC.modalPresentationStyle = .fullScreen
    psVideoFullViewVC.delegate = self
    psVideoFullViewVC.player = PsVideoView.player
    psVideoFullViewVC.playerLayer = playerLayer
    psVideoFullViewVC.playerSpeed = playerSpeed
    psVideoFullViewVC.playerQuality = playerQuality
    removeObservers()
    timeObserver = nil
    psVideoFullViewVC.view.layer.insertSublayer(playerLayer!, at: 0)
    topVC?.present(psVideoFullViewVC, animated: true, completion: nil)
  }
  
  @objc func sliderAction() {
    PsVideoView.player?.seek(to: CMTimeMake(value: Int64(controlsView.sliderControl.value * 1000), timescale: 1000))
  }
  
  @objc func handleControlsViewTouchAction(_ sender:UITapGestureRecognizer) {
    controlsView.isHidden = true
    resetControls()
  }
  
  @objc func handlePlayerViewTouchAction(_ sender:UITapGestureRecognizer) {
    controlsView.isHidden = false
    startTimer()
  }
  
  func resetControls() {
    controlsView.settingsButton.isSelected = false
    controlsView.tableVideoQuality.isHidden = true
    controlsView.videoQualityButton.isSelected = false
  }
  
  func  addTimeObserver() {
    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    let mainQueue = DispatchQueue.main
    self.timeObserver = PsVideoView.player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {
      [weak self] time in
      self?.bufferState()
      guard let currentItem = PsVideoView.player?.currentItem else {return}
      guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
      if !self!.isTimerRunning {
        self?.startTimer()
      }
      self?.controlsView.sliderControl.maximumValue = Float(currentItem.duration.seconds)
      self?.controlsView.sliderControl.minimumValue = 0
      self?.controlsView.sliderControl.value = Float(currentItem.currentTime().seconds)
      
      let playhead = currentItem.currentTime().seconds
      let duration = currentItem.duration.seconds
      self?.controlsView.timeLabel.text = "\(self?.formatTimeFor(seconds: playhead) ?? "")-\(self?.formatTimeFor(seconds: duration) ?? "")"
    })
  }
  
  func startTimer() {
    isTimerRunning = true
    timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(PsVideoView.timerAction), userInfo: nil, repeats: true)
  }
  
  @objc func timerAction() {
    if !controlsView.videoQualityButton.isSelected && !controlsView.settingsButton.isSelected {
      controlsView.isHidden = true
      resetTimer()
    }
  }
  
  func resetTimer() {
    timer.invalidate()
  }
  
  func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
    let secs = Int(seconds)
    let hours = secs / 3600
    let minutes = (secs % 3600) / 60
    let seconds = (secs % 3600) % 60
    return (hours, minutes, seconds)
  }
  
  func formatTimeFor(seconds: Double) -> String {
    let result = getHoursMinutesSecondsFrom(seconds: seconds)
    let hoursString = "\(result.hours)"
    var minutesString = "\(result.minutes)"
    if minutesString.count == 1 {
      minutesString = "0\(result.minutes)"
    }
    var secondsString = "\(result.seconds)"
    if secondsString.count == 1 {
      secondsString = "0\(result.seconds)"
    }
    var time = "\(hoursString):"
    if result.hours >= 1 {
      time.append("\(minutesString):\(secondsString)")
    }
    else {
      time = "\(minutesString):\(secondsString)"
    }
    return time
  }
  
  @objc func setBitRate(_ definition: String) {
    var maxBitRate: Double = 0
    switch definition {
    case "240p":
      maxBitRate = 1000
      break
      
    case "360p":
      maxBitRate = 500000
      break
      
    case "480p":
      maxBitRate = 100000
      break
      
    case "720p":
      maxBitRate = 2500000
      break
      
    case "1080p":
      maxBitRate = 4000000
      break
      
    case "2k":
      maxBitRate = 8000000
      break
      
    case "4k":
      maxBitRate = 20000000
      break
      
    default:
      maxBitRate = 100000
    }
    
    PsVideoView.player?.currentItem?.preferredPeakBitRate = maxBitRate
  }
  
  func onStartBuffering(_ status: Int) {
    guard let onBuffering = self.onBuffering else { return }
    
    let params: [String : Any] = ["status": status]
    onBuffering(params)
  }
  
  func bufferState() {
    if let currentItem = PsVideoView.player?.currentItem {
      if currentItem.status == AVPlayerItem.Status.readyToPlay {
        if currentItem.isPlaybackLikelyToKeepUp {
          onStartBuffering(1)
        } else if currentItem.isPlaybackBufferEmpty {
          onStartBuffering(2)
        }  else if currentItem.isPlaybackBufferFull {
          onStartBuffering(3)
        } else {
          onStartBuffering(1)
        }
      } else if currentItem.status == AVPlayerItem.Status.failed {
        print("Buffer log:Failed ")
      } else if currentItem.status == AVPlayerItem.Status.unknown {
        print("Buffer log:Unknown ")
      }
    } else {
      print("Buffer log: avPlayer.currentItem is nil")
    }
  }
  
  func getThumbnailImage() -> UIImage {
    let asset = AVAsset(url: URL(string: url)!)
    let imageGenerator:AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    let thumbTime = CMTimeMake(value: 3,timescale: 1)
    let thumbImage = try? imageGenerator.copyCGImage(at: thumbTime, actualTime: nil)
    return UIImage(cgImage: thumbImage!)
  }
  
  @objc func settingsAction() {
    if controlsView.settingsButton.isSelected {
      controlsView.settingsButton.isSelected = false
      controlsView.tableVideoQuality.isHidden = true
    }
    else {
      controlsView.settingsButton.isSelected = true
      controlsView.videoQualityButton.isSelected = false
      controlsView.tableVideoQuality.isHidden = false
      controlsView.setTableViewFrame(isSettings: true)
    }
  }
  
  @objc func videoQualityAction() {
    if controlsView.videoQualityButton.isSelected {
      controlsView.videoQualityButton.isSelected = false
      controlsView.tableVideoQuality.isHidden = true
    }
    else {
      controlsView.videoQualityButton.isSelected = true
      controlsView.setTableViewFrame(isSettings: false)
      controlsView.tableVideoQuality.isHidden = false
      controlsView.setTableViewFrame(isSettings: false)
    }
  }
}

extension PsVideoView: PsVideoFullViewVCDelegate {
  func viewDismissed(player: AVPlayer, layer: AVPlayerLayer, quality: String, speed: String) {
    self.playerQuality = quality
    self.playerSpeed = speed
    PsVideoView.player = player
    self.playerLayer = layer
    playerLayer?.frame = playerView.bounds
    playerLayer?.videoGravity = .resizeAspect
    playerLayer?.needsDisplayOnBoundsChange = true
    playerView.layer.addSublayer(playerLayer!)
    if player.isPlaying {
      player.play()
      controlsView.playButton.isSelected = true
      addTimeObserver()
      startTimer()
      setVideoSpeed(rate: playerSpeed)
      setVideoQuality(quality: playerQuality)
    }
    else {
      pauseAction()
    }
  }
}

extension CMTime {
  func getTimeString() -> String {
    let TSeconds = CMTimeGetSeconds(self)
    let hours = Int(TSeconds/3600)
    let minutes = Int(TSeconds/60) % 60
    let seconds = Int(TSeconds.truncatingRemainder(dividingBy: 60))
    if hours > 0 {
      return String(format: "%i:%02i:%02i",arguments: [hours,minutes,seconds])
    }
    else {
      return String(format: "%02i:%02i",arguments: [minutes,seconds])
    }
  }
}

extension PsVideoView: PsVideoControlsViewDelegate {
  func setVideoSpeed(rate: String) {
    resetControls()
    playerSpeed = rate
    controlsView.selectedSpeed = rate
    switch rate {
    case ".5x":
      PsVideoView.player?.rate = 0.5
      controlsView.settingsButton.setTitle("0.5x", for: .normal)
      controlsView.settingsButton.setTitle("0.5x", for: .selected)
      
    case ".75x":
      PsVideoView.player?.rate = 0.75
      controlsView.settingsButton.setTitle(".75x", for: .normal)
      controlsView.settingsButton.setTitle(".75x", for: .selected)
      
    case "1.0x":
      PsVideoView.player?.rate = 1
      controlsView.settingsButton.setTitle("1.0x", for: .normal)
      controlsView.settingsButton.setTitle("1.0x", for: .selected)
      
    case "1.25x":
      PsVideoView.player?.rate = 1.25
      controlsView.settingsButton.setTitle("1.25x", for: .normal)
      controlsView.settingsButton.setTitle("1.25x", for: .selected)
      
    case "1.5x":
      PsVideoView.player?.rate = 1.5
      controlsView.settingsButton.setTitle("1.5x", for: .normal)
      controlsView.settingsButton.setTitle("1.5x", for: .selected)
      
    case "1.75x":
      PsVideoView.player?.rate = 1.75
      controlsView.settingsButton.setTitle("1.75x", for: .normal)
      controlsView.settingsButton.setTitle("1.75x", for: .selected)
      
    case "2x":
      PsVideoView.player?.rate = 2
      controlsView.settingsButton.setTitle("2x", for: .normal)
      controlsView.settingsButton.setTitle("2x", for: .selected)
      
    case "3x":
      PsVideoView.player?.rate = 3
      controlsView.settingsButton.setTitle("3x", for: .normal)
      controlsView.settingsButton.setTitle("3x", for: .selected)
      
    default:
      break
    }
    
    controlsView.playButton.isSelected = true
  }
  
  func setVideoQuality(quality: String) {
    resetControls()
    playerQuality = quality
    controlsView.selectedQuality = quality
    switch quality {
    case "240p":
      setBitRate("240p")
      controlsView.videoQualityButton.setTitle("240p", for: .normal)
      
    case "360p":
      setBitRate("360p")
      controlsView.videoQualityButton.setTitle("360p", for: .normal)
      
    case "480p":
      setBitRate("480p")
      controlsView.videoQualityButton.setTitle("480p", for: .normal)
      
    case "720p":
      setBitRate("720p")
      controlsView.videoQualityButton.setTitle("720p", for: .normal)
      
    case "1080p":
      setBitRate("1080p")
      controlsView.videoQualityButton.setTitle("1080p", for: .normal)
      
    case "2k":
      setBitRate("2k")
      controlsView.videoQualityButton.setTitle("2k", for: .normal)
      
    case "4k":
      setBitRate("4k")
      controlsView.videoQualityButton.setTitle("4k", for: .normal)
      
    default:
      setBitRate("360p")
      controlsView.videoQualityButton.setTitle("Auto", for: .normal)
    }
  }
  
  override func layoutSubviews() {
    if playerLayer != nil {
      playerLayer?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
  }
}
