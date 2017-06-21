//  UIImage+FadeInOut.swift

import UIKit

public extension UIView {

  // Fade in a view with a duration
  // - parameter duration: custom animation duration
  func fadeIn(duration: TimeInterval = 1.0) {
    UIView.animate(withDuration: duration, animations: {
      self.alpha = 1.0
    })
  }
  
  // Fade out a view with a duration
  //   - parameter duration: custom animation duration
  func fadeOut(duration: TimeInterval = 1.0) {
    UIView.animate(withDuration: duration, animations: {
      self.alpha = 0.0
    })
  }
    
}
