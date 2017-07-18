
import UIKit

//public protocol IntroWelcomeViewControllerDelegate: class {
//  func introWelcomeViewControllerDonePressed(_ controller: IntroWelcomeViewController)
//}

public class IntroWelcomeViewController: UIViewController {

  @IBOutlet internal var imageView: UIImageView!

  @IBAction func doneButtonPressed(_ sender: Any) {
    // MAS TODO configure the callback
//    delegate?.introWelcomeViewControllerDonePressed(self)
  }

//  public var delegate: IntroWelcomeViewControllerDelegate?
  internal let imageNames: [String] = ["mock1", "mock1"]
  internal var index = 0
  internal var timer: Timer?

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    timer = Timer.scheduledTimer(timeInterval: 5.0, target: self,
                                 selector: #selector(updateImageView(_:)),
                                 userInfo: nil, repeats: true)
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
  }
  
  internal func updateImageView(_ timer: Timer) {
    print( "update image view")
//    index = (index + 1) < imageNames.count ? (index + 1) : 0
//    imageView.image = UIImage(named: imageNames[index],
//                              in: Bundle(for: type(of: self)),
//                              compatibleWith: nil)
  }

}
