//
//  FullScreenVideoPlayerVC.swift
//  CustomVideoPlayer
//
//  Created by dev288 on 07/02/22.
//

import UIKit
import AVKit

protocol PsVideoFullViewVCDelegate {
    func viewDismissed(player: AVPlayer, layer: AVPlayerLayer, quality: String, speed: String)
}

class PsVideoFullViewVC: UIViewController {
    let viewToTap: UIView = UIView()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var delegate: PsVideoFullViewVCDelegate?
    let controlsView: PsVideoControlsView = PsVideoControlsView()
    var isTimerRunning: Bool = false
    var timer = Timer()
    var playerSpeed: String = ""
    var playerQuality: String = ""
    var timeObserver: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addControlsView()
        addViewToTap()
        
        let gestureControlsView = UITapGestureRecognizer(target: self, action:  #selector (self.handleControlsViewTouchAction(_:)))
        controlsView.viewToTap.addGestureRecognizer(gestureControlsView)
        let gesturePlayerView = UITapGestureRecognizer(target: self, action:  #selector (self.handlePlayerViewTouchAction(_:)))
        viewToTap.addGestureRecognizer(gesturePlayerView)
        controlsView.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if player?.isPlaying == true {
            player?.play()
            controlsView.playButton.isSelected = true
            addTimeObserver()
            startTimer()
            setVideoSpeed(rate: playerSpeed)
            setVideoQuality(quality: playerQuality)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer!.frame = view.bounds
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    @objc func backAction() {
        removeObservers()
        self.dismiss(animated: true) {
            self.delegate?.viewDismissed(player: self.player!, layer: self.playerLayer!, quality: (self.controlsView.videoQualityButton.titleLabel?.text)!, speed: (self.controlsView.settingsButton.titleLabel?.text)!)
        }
    }
    
    func addViewToTap() {
        viewToTap.backgroundColor = .clear
        viewToTap.isHidden = true
        self.view.addSubview(viewToTap)
        
        viewToTap.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: viewToTap, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: viewToTap, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: viewToTap, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: viewToTap, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, topConstraint])
    }
    
    func addControlsView() {
        view.addSubview(controlsView)

        controlsView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: controlsView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: controlsView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: controlsView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: controlsView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        
        controlsView.playButton.addTarget(self, action:#selector(self.playAction), for: .touchUpInside)
        controlsView.stopButton.addTarget(self, action:#selector(self.stopAction), for: .touchUpInside)
        controlsView.forwardButton.addTarget(self, action:#selector(self.forwardAction), for: .touchUpInside)
        controlsView.backwardButton.addTarget(self, action:#selector(self.backwardAction), for: .touchUpInside)
        controlsView.fullScreenButton.addTarget(self, action:#selector(self.backAction), for: .touchUpInside)
        controlsView.fullScreenButton.isSelected = true
        controlsView.sliderControl.addTarget(self, action: #selector(self.sliderAction), for: .valueChanged)
        controlsView.settingsButton.addTarget(self, action: #selector(self.settingsAction), for: .touchUpInside)
        controlsView.videoQualityButton.addTarget(self, action: #selector(self.videoQualityAction), for: .touchUpInside)
    }
    
    @objc func playAction() {
        if player?.isPlaying == true {
            player?.pause()
            controlsView.playButton.isSelected = false
        }
        else {
            if timeObserver == nil {
                addTimeObserver()
            }
            player?.play()
            controlsView.playButton.isSelected = true
            setVideoSpeed(rate: playerSpeed)
            setVideoQuality(quality: playerQuality)
        }
    }
    
    @objc func pauseAction() {
        player?.pause()
        controlsView.playButton.isSelected = false
    }
    
    @objc func stopAction() {
        let newtime = 0
        let time: CMTime = CMTimeMake(value: Int64(newtime*1000), timescale: 1000)
        player?.seek(to: time)
        player?.pause()
        controlsView.playButton.isSelected = false
    }
    
    @objc func forwardAction() {
        var time: CMTime = CMTime()
        guard let duration = player?.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds((player?.currentTime())!)
        var newTime = currentTime + 15
        if newTime > (CMTimeGetSeconds(duration)) {
            
            newTime = CMTimeGetSeconds(duration)
            controlsView.playButton.isSelected = false
            
        }
        time = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player?.seek(to: time)
    }
    
    @objc func backwardAction() {
        var time: CMTime = CMTime()
        let currentTime = CMTimeGetSeconds((player?.currentTime())!)
        var newTime = currentTime - 5
        if newTime < 0 {
            newTime = 0
        }
        
        time = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player?.seek(to: time)
    }
    
    @objc func sliderAction() {
        player?.seek(to: CMTimeMake(value: Int64(controlsView.sliderControl.value * 1000), timescale: 1000))
    }
    
    @objc func handleControlsViewTouchAction(_ sender:UITapGestureRecognizer) {
        controlsView.isHidden = true
        viewToTap.isHidden = false
        resetControls()
    }
    
    @objc func handlePlayerViewTouchAction(_ sender:UITapGestureRecognizer) {
        controlsView.isHidden = false
        viewToTap.isHidden = true
        startTimer()
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {
            [weak self] time in
            guard let currentItem = self?.player?.currentItem else{return}
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.controlsView.sliderControl.minimumValue = 0
            self?.controlsView.sliderControl.maximumValue = Float(currentItem.duration.seconds)
            self?.controlsView.sliderControl.value = Float(currentItem.currentTime().seconds)
            
            let playhead = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            self?.controlsView.timeLabel.text = "\(self?.formatTimeFor(seconds: playhead) ?? "")-\(self?.formatTimeFor(seconds: duration) ?? "")"
        })
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(appMovedToBackground, name: UIApplication.willResignActiveNotification, object: nil)
        
        if timeObserver != nil {
            player?.removeTimeObserver(timeObserver!)
        }
    }
    
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(PsVideoView.timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        if !controlsView.videoQualityButton.isSelected && !controlsView.settingsButton.isSelected {
            controlsView.isHidden = true
            viewToTap.isHidden = false
            resetControls()
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
        
        player?.currentItem?.preferredPeakBitRate = maxBitRate
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
    
    func resetControls() {
        controlsView.settingsButton.isSelected = false
        controlsView.tableVideoQuality.isHidden = true
        controlsView.videoQualityButton.isSelected = false
    }
    
    @objc func appMovedToBackground() {
        pauseAction()
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension PsVideoFullViewVC: PsVideoControlsViewDelegate {
    func setVideoSpeed(rate: String) {
        resetControls()
        controlsView.selectedSpeed = rate
        playerSpeed = rate
        switch rate {
        case ".5x":
            player?.rate = 0.5
            controlsView.settingsButton.setTitle("0.5x", for: .normal)
            controlsView.settingsButton.setTitle("0.5x", for: .selected)
            
        case ".75x":
            player?.rate = 0.75
            controlsView.settingsButton.setTitle(".75x", for: .normal)
            controlsView.settingsButton.setTitle(".75x", for: .selected)
            
        case "1.0x":
            player?.rate = 1
            controlsView.settingsButton.setTitle("1.0x", for: .normal)
            controlsView.settingsButton.setTitle("1.0x", for: .selected)
            
        case "1.25x":
            player?.rate = 1.25
            controlsView.settingsButton.setTitle("1.25x", for: .normal)
            controlsView.settingsButton.setTitle("1.25x", for: .selected)
            
        case "1.5x":
            player?.rate = 1.5
            controlsView.settingsButton.setTitle("1.5x", for: .normal)
            controlsView.settingsButton.setTitle("1.5x", for: .selected)
            
        case "1.75x":
            player?.rate = 1.75
            controlsView.settingsButton.setTitle("1.75x", for: .normal)
            controlsView.settingsButton.setTitle("1.75x", for: .selected)
            
        case "2x":
            player?.rate = 2
            controlsView.settingsButton.setTitle("2x", for: .normal)
            controlsView.settingsButton.setTitle("2x", for: .selected)
            
        case "3x":
            player?.rate = 3
            controlsView.settingsButton.setTitle("3x", for: .normal)
            controlsView.settingsButton.setTitle("3x", for: .selected)
            
        default:
            break
        }
        
        controlsView.playButton.isSelected = true
    }
    
    func setVideoQuality(quality: String) {
        resetControls()
        controlsView.selectedQuality = quality
        playerQuality = quality
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
}
