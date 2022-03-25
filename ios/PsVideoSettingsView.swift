//
//  PsVideoSettingsView.swift
//  react-native-ps-video
//
//  Created by dev288 on 15/02/22.
//

import UIKit

class PsVideoSettingsView: UIView {
    let imageIconSpeed: UIImageView = UIImageView()
    let labelTitleSpeed: UILabel = UILabel()
    let labelSubTitleSpeed: UILabel = UILabel()
    let imageIconAudio: UIImageView = UIImageView()
    let labelTitleAudio: UILabel = UILabel()
    let labelSubTitleAudio: UILabel = UILabel()
    let speedButton: UIButton = UIButton()
    let audioButton: UIButton = UIButton()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup () {
        addSpeedIcon()
        addSpeedTitleLabel()
        addSpeedSubTitleLabel()
        addAudioIcon()
        addAudioTitleLabel()
        addAudioSubTitleLabel()
        addSpeedButton()
        addAudioButton()
    }
    
    func addSpeedIcon() {
        imageIconSpeed.backgroundColor = .white
        imageIconSpeed.layer.cornerRadius = 20
        imageIconSpeed.clipsToBounds = true
        self.addSubview(imageIconSpeed)
        
        imageIconSpeed.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: imageIconSpeed, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        let topConstraint = NSLayoutConstraint(item: imageIconSpeed, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10)
        let widthConstraint = NSLayoutConstraint(item: imageIconSpeed, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let heightConstraint = NSLayoutConstraint(item: imageIconSpeed, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        self.addConstraints([leadingConstraint, topConstraint, widthConstraint, heightConstraint])
    }
    
    func addSpeedTitleLabel() {
        labelTitleSpeed.textColor = .white
        labelTitleSpeed.textAlignment = .left
        labelTitleSpeed.text = "Speed"
        self.addSubview(labelTitleSpeed)
        
        labelTitleSpeed.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: labelTitleSpeed, attribute: .leading, relatedBy: .equal, toItem: imageIconSpeed, attribute: .trailing, multiplier: 1, constant: 10)
        let topConstraint = NSLayoutConstraint(item: labelTitleSpeed, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5)
        let widthConstraint = NSLayoutConstraint(item: labelTitleSpeed, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: labelTitleSpeed, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        self.addConstraints([leadingConstraint, topConstraint, widthConstraint, heightConstraint])
    }
    
    func addSpeedSubTitleLabel() {
        labelSubTitleSpeed.textColor = .white
        labelSubTitleSpeed.textAlignment = .left
        labelSubTitleSpeed.text = "Normal"
        self.addSubview(labelSubTitleSpeed)
        
        labelSubTitleSpeed.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: labelSubTitleSpeed, attribute: .leading, relatedBy: .equal, toItem: imageIconSpeed, attribute: .trailing, multiplier: 1, constant: 10)
        let topConstraint = NSLayoutConstraint(item: labelSubTitleSpeed, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 30)
        let widthConstraint = NSLayoutConstraint(item: labelSubTitleSpeed, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: labelSubTitleSpeed, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        self.addConstraints([leadingConstraint, topConstraint, widthConstraint, heightConstraint])
    }
    
    func addSpeedButton() {
        self.addSubview(speedButton)
        
        speedButton.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: speedButton, attribute: .leading, relatedBy: .equal, toItem: imageIconSpeed, attribute: .leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: speedButton, attribute: .top, relatedBy: .equal, toItem: labelTitleSpeed, attribute: .top, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: speedButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: speedButton, attribute: .bottom, relatedBy: .equal, toItem: labelSubTitleSpeed, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])
    }
    
    func addAudioIcon() {
        imageIconAudio.backgroundColor = .white
        imageIconAudio.layer.cornerRadius = 20
        imageIconAudio.clipsToBounds = true
        self.addSubview(imageIconAudio)
        
        imageIconAudio.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: imageIconAudio, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        let topConstraint = NSLayoutConstraint(item: imageIconAudio, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 70)
        let widthConstraint = NSLayoutConstraint(item: imageIconAudio, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let heightConstraint = NSLayoutConstraint(item: imageIconAudio, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        self.addConstraints([leadingConstraint, topConstraint, widthConstraint, heightConstraint])
    }
    
    func addAudioTitleLabel() {
        labelTitleAudio.textColor = .white
        labelTitleAudio.textAlignment = .left
        labelTitleAudio.text = "Audio"
        self.addSubview(labelTitleAudio)
        
        labelTitleAudio.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: labelTitleAudio, attribute: .leading, relatedBy: .equal, toItem: imageIconAudio, attribute: .trailing, multiplier: 1, constant: 10)
        let topConstraint = NSLayoutConstraint(item: labelTitleAudio, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 65)
        let widthConstraint = NSLayoutConstraint(item: labelTitleAudio, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: labelTitleAudio, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        self.addConstraints([leadingConstraint, topConstraint, widthConstraint, heightConstraint])
    }
    
    func addAudioSubTitleLabel() {
        labelSubTitleAudio.textColor = .white
        labelSubTitleAudio.textAlignment = .left
        labelSubTitleAudio.text = "Auto"
        self.addSubview(labelSubTitleAudio)
        
        labelSubTitleAudio.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: labelSubTitleAudio, attribute: .leading, relatedBy: .equal, toItem: imageIconAudio, attribute: .trailing, multiplier: 1, constant: 10)
        let topConstraint = NSLayoutConstraint(item: labelSubTitleAudio, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 90)
        let widthConstraint = NSLayoutConstraint(item: labelSubTitleAudio, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: labelSubTitleAudio, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        self.addConstraints([leadingConstraint, topConstraint, widthConstraint, heightConstraint])
    }
    
    func addAudioButton() {
        self.addSubview(audioButton)
        
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: audioButton, attribute: .leading, relatedBy: .equal, toItem: imageIconAudio, attribute: .leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: audioButton, attribute: .top, relatedBy: .equal, toItem: labelTitleAudio, attribute: .top, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: audioButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: audioButton, attribute: .bottom, relatedBy: .equal, toItem: labelSubTitleAudio, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])
    }
}
