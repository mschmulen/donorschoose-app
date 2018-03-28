//  ProposalHeaderView.swift

import UIKit

open class ProposalHeaderView: UICollectionReusableView {

  @IBOutlet weak var imageBackground: UIImageView! {
    didSet {
      imageBackground.alpha = 0
    }
  }

  @IBOutlet weak var imageTeacherPic: UIImageView! {
    didSet {
      imageTeacherPic.alpha = 0
    }
  }

  @IBOutlet weak var viewTextContainer: UIView!

  @IBAction func actionButtonTeacher(_ sender: AnyObject) {
    // MAS TODO impliment actionButtonTeacher
  }

  @IBOutlet weak var buttonTeacher: UIButton!

  @IBOutlet weak var buttonSchool: UIButton!

  @IBOutlet weak var labelLocation: UILabel!

  fileprivate struct config {
    static let fadeInTime:Double = Double(1.0)
  }

  open func loadImageBackground(_ imageURL:URL) {
    downloadBackgroundImage(imageURL)
  }

  open func loadImageTeacher(_ imageURL:URL) {
    downloadTeacherImage(imageURL)
  }

  override open func awakeFromNib() {
    super.awakeFromNib()

    //config the techer pic
    self.imageTeacherPic.layer.cornerRadius = self.imageTeacherPic.frame.size.width / 2
    self.imageTeacherPic.clipsToBounds = true

    self.imageTeacherPic.layer.borderWidth = 3.0
    self.imageTeacherPic.layer.borderColor = UIColor.white.cgColor

  }

  static var reuseIdentifier: String {
    return String(describing: ProposalHeaderView.self)
  }

  static var nib: UINib? {
    return UINib(nibName: String(describing: ProposalHeaderView.self), bundle: Bundle(for: ProposalHeaderView.self))
  }
}

// Image loading
extension ProposalHeaderView {

  public func downloadBackgroundImage(_ url: URL ){

    getDataFromUrl(url) { (data, response, error)  in
      DispatchQueue.main.async { () -> Void in
        guard let data = data , error == nil else {
          self.imageBackground.isHidden = false
          self.imageBackground.image = UIImage(named: "classPicture")
          self.imageBackground.contentMode = .scaleAspectFill
          self.imageBackground.fadeIn(duration: 1)
          return
        }
        self.imageBackground.isHidden = false
        if let imageFromData = UIImage(data: data) {
          self.imageBackground.image = imageFromData
        }
        else {
          self.imageBackground.image = UIImage(named: "classPicture")
        }
        self.imageBackground.contentMode = .scaleAspectFill
        self.imageBackground.fadeIn(duration: config.fadeInTime)
      }
    }
  }

  public func downloadTeacherImage(_ url: URL ){

    getDataFromUrl(url) { (data, response, error)  in
      DispatchQueue.main.async { () -> Void in
        guard let data = data , error == nil else { return }
        self.imageTeacherPic.isHidden = false
        self.imageTeacherPic.image = UIImage(data: data)
        self.imageTeacherPic.contentMode = .scaleAspectFill
        self.imageTeacherPic.fadeIn(duration: config.fadeInTime)
      }
    }
  }

}

