import UIKit

@objc(PsVideoViewManager)
class PsVideoViewManager: RCTViewManager {

    override func view() -> (PsVideoView) {
    return PsVideoView()
  }
}
