
import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  func stopLoading() {
    self.activityIndicator.stopAnimating()
    self.activityIndicator.isHidden = true
  }

  func startLoading() {
    self.activityIndicator.isHidden = false
    self.activityIndicator.startAnimating()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.activityIndicator.startAnimating()

  }

}
