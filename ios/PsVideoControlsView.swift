//
//  PsVideoControlsView.swift
//  react-native-ps-video
//
//  Created by dev288 on 08/02/22.
//

import UIKit

protocol PsVideoControlsViewDelegate {
    func setVideoSpeed(rate: String)
    func setVideoQuality(quality: String)
}

class PsVideoControlsView: UIView {
    let viewToTap: UIView = UIView()
    let playButton: UIButton = UIButton()
    let stopButton: UIButton = UIButton()
    let forwardButton: UIButton = UIButton()
    let backwardButton: UIButton = UIButton()
    let watermarkLabel: UILabel = UILabel()
    let fullScreenButton: UIButton = UIButton()
    let sliderControl: UISlider = UISlider()
    let videoQualityButton: UIButton = UIButton()
    let settingsButton: UIButton = UIButton()
    let timeLabel: UILabel = UILabel()
    
    private let videoSpeedArray = [".5x", ".75x", "1.0x", "1.25x", "1.5x", "1.75x", "2x"]
    private let videoQualityArray = ["Auto", "360p", "480p", "720p", "1080p"]
    var selectedSpeed = "1.0x"
    var selectedQuality = "360p"
    
    var tableVideoQuality: UITableView = UITableView()
    var delegate: PsVideoControlsViewDelegate?
    var isSettingsSelected: Bool = false
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup () {
        addViewToTap()
        addPlayButton()
        addForwardButton()
        addBackwardButton()
        addSliderControl()
        addFullScreenButton()
        addWatermarkLabel()
        addSettingsButton()
        addVideoQualityButton()
        setupTableView()
        addTimeLabel()
    }
    
    func addViewToTap() {
        viewToTap.backgroundColor = .clear
        self.addSubview(viewToTap)
        
        viewToTap.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: viewToTap, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: viewToTap, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -100)
        let bottomConstraint = NSLayoutConstraint(item: viewToTap, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: viewToTap, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 40)
        self.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, topConstraint])
    }
    
    func addPlayButton() {
        playButton.backgroundColor = .clear
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.setImage(UIImage(named: "pause"), for: .selected)
        playButton.imageView?.contentMode = .scaleAspectFit
        self.addSubview(playButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: playButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
        let heightConstraint = NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
        self.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
    }
    
    func addForwardButton() {
        forwardButton.backgroundColor = .clear
        forwardButton.setBackgroundImage(UIImage(named: "forward"), for: .normal)
        forwardButton.setTitle("15", for: .normal)
        forwardButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forwardButton.titleLabel?.textColor = .white
        forwardButton.imageView?.contentMode = .scaleAspectFit
        self.addSubview(forwardButton)
        
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: forwardButton, attribute: .leading, relatedBy: .equal, toItem: playButton, attribute: .trailing, multiplier: 1, constant: 10)
        let centerYConstraint = NSLayoutConstraint(item: forwardButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: forwardButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: forwardButton, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint, centerYConstraint, widthConstraint, heightConstraint])
    }
    
    func addBackwardButton() {
        backwardButton.backgroundColor = .clear
        backwardButton.setBackgroundImage(UIImage(named: "backward"), for: .normal)
        backwardButton.setTitle("5", for: .normal)
        backwardButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backwardButton.titleLabel?.textColor = .white
        backwardButton.imageView?.contentMode = .scaleAspectFit
        self.addSubview(backwardButton)
        
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: backwardButton, attribute: .trailing, relatedBy: .equal, toItem: playButton, attribute: .leading, multiplier: 1, constant: -10)
        let centerYConstraint = NSLayoutConstraint(item: backwardButton, attribute: .centerY, relatedBy: .equal, toItem: playButton, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: backwardButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: backwardButton, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraints([trailingConstraint, centerYConstraint, widthConstraint, heightConstraint])
    }
    
    func addWatermarkLabel() {
        watermarkLabel.textAlignment = .right
        watermarkLabel.numberOfLines = 0
        self.addSubview(watermarkLabel)
        
        watermarkLabel.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: watermarkLabel, attribute: .trailing, relatedBy: .equal, toItem: fullScreenButton, attribute: .leading, multiplier: 1, constant: -10)
        let topConstraint = NSLayoutConstraint(item: watermarkLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10)
        let widthConstraint = NSLayoutConstraint(item: watermarkLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        self.addConstraints([trailingConstraint, topConstraint, widthConstraint])
    }
    
    func addSliderControl() {
        sliderControl.minimumTrackTintColor = .white
        sliderControl.maximumTrackTintColor = .gray
        let circleImage = makeCircleWith(size: CGSize(width: 15, height: 15), backgroundColor: UIColor.white)
        sliderControl.setThumbImage(circleImage, for: .normal)
        sliderControl.setThumbImage(circleImage, for: .highlighted)
        self.addSubview(sliderControl)
        
        sliderControl.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: sliderControl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20)
        let trailingConstraint = NSLayoutConstraint(item: sliderControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -55)
        let bottomConstraint = NSLayoutConstraint(item: sliderControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -50)
        let heightConstraint = NSLayoutConstraint(item: sliderControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        self.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightConstraint])
    }
    
    fileprivate func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func addFullScreenButton() {
        fullScreenButton.backgroundColor = .clear
        fullScreenButton.setImage(UIImage(named: "fullscreen"), for: .normal)
        fullScreenButton.setImage(UIImage(named: "exitfullscreen"), for: .selected)
        fullScreenButton.imageView?.contentMode = .scaleAspectFit
        fullScreenButton.imageEdgeInsets = UIEdgeInsets(top: 10, left:10, bottom: 10, right: 10)
        self.addSubview(fullScreenButton)
        
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: fullScreenButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15)
        let centerYConstraint = NSLayoutConstraint(item: fullScreenButton, attribute: .centerY, relatedBy: .equal, toItem: sliderControl, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: fullScreenButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: fullScreenButton, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraints([trailingConstraint, centerYConstraint, widthConstraint, heightConstraint])
    }
    
    func addSettingsButton() {
        settingsButton.backgroundColor = .clear
        settingsButton.setTitle("1.0x", for: .normal)
        settingsButton.setTitle("1.0x", for: .selected)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        settingsButton.setTitleColor(.white, for: .normal)
        self.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: settingsButton, attribute: .trailing, relatedBy: .equal, toItem: sliderControl, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: settingsButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        let widthConstraint = NSLayoutConstraint(item: settingsButton, attribute: .width, relatedBy: .equal, toItem: playButton, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: settingsButton, attribute: .height, relatedBy: .equal, toItem: playButton, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraints([trailingConstraint, bottomConstraint, widthConstraint, heightConstraint])
    }
    
    func addVideoQualityButton() {
        videoQualityButton.backgroundColor = .clear
        videoQualityButton.contentHorizontalAlignment = .right
        videoQualityButton.titleLabel?.textColor = .white
        videoQualityButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        videoQualityButton.setTitle("360p", for: .normal)
        self.addSubview(videoQualityButton)
        
        videoQualityButton.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: videoQualityButton, attribute: .trailing, relatedBy: .equal, toItem: settingsButton, attribute: .leading, multiplier: 1, constant: -10)
        let centerYConstraint = NSLayoutConstraint(item: videoQualityButton, attribute: .centerY, relatedBy: .equal, toItem: settingsButton, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: videoQualityButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70)
        let heightConstraint = NSLayoutConstraint(item: videoQualityButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
        self.addConstraints([trailingConstraint, centerYConstraint, widthConstraint, heightConstraint])
    }
    
    func addTimeLabel() {
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textAlignment = .left
        timeLabel.text = "00:00-00:00"
        self.addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: timeLabel, attribute: .leading, relatedBy: .equal, toItem: sliderControl, attribute: .leading, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: settingsButton, attribute: .centerY, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: timeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        self.addConstraints([leadingConstraint, centerYConstraint, heightConstraint])
    }
}

//Tableview
extension PsVideoControlsView: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        self.addSubview(tableVideoQuality)
        tableVideoQuality.backgroundColor = .black.withAlphaComponent(0.8)
        tableVideoQuality.isHidden = true
        
        tableVideoQuality.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: tableVideoQuality, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20)
        let trailingConstraint = NSLayoutConstraint(item: tableVideoQuality, attribute: .trailing, relatedBy: .equal, toItem: settingsButton, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: tableVideoQuality, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        let widthConstraint = NSLayoutConstraint(item: tableVideoQuality, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        self.addConstraints([topConstraint, trailingConstraint, widthConstraint, bottomConstraint])
        
        tableVideoQuality.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableVideoQuality.dataSource = self
        tableVideoQuality.delegate = self
    }
    
    func setTableViewFrame(isSettings: Bool) {
        self.isSettingsSelected = isSettings
        tableVideoQuality.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSettingsSelected {
            return videoSpeedArray.count
        }
        else {
            return videoQualityArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isSettingsSelected {
            cell.textLabel?.text = videoSpeedArray[indexPath.row]
            if selectedSpeed == videoSpeedArray[indexPath.row] {
                cell.textLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            }
            else {
                cell.textLabel?.backgroundColor = .clear
            }
        }
        else {
            cell.textLabel?.text = videoQualityArray[indexPath.row]
            if selectedQuality == videoQualityArray[indexPath.row] {
                cell.textLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            }
            else {
                cell.textLabel?.backgroundColor = .clear
            }
        }
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSettingsSelected {
            selectedSpeed = videoSpeedArray[indexPath.row]
            delegate?.setVideoSpeed(rate: videoSpeedArray[indexPath.row])
            tableVideoQuality.isHidden = true
        }
        else {
            selectedQuality = videoQualityArray[indexPath.row]
            delegate?.setVideoQuality(quality: videoQualityArray[indexPath.row])
            tableVideoQuality.isHidden = true
        }
    }
}

extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}
