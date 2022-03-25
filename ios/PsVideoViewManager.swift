import UIKit

@objc(PsVideoViewManager)
class PsVideoViewManager: RCTViewManager {
  @objc override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override func view() -> (PsVideoView) {
    return PsVideoView()
  }
  
  @objc func playAnotherVideo(_ url: String) {
    DispatchQueue.main.async {
      PsVideoView.playNextVideo(url: url)
    }
  }
}
