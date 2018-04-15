//  ProposalHeaderView.swift

import UIKit

open class ProposalHeaderView: UICollectionReusableView {

    @IBOutlet weak var imageBackground: UIImageView! {
        didSet {
            imageBackground.alpha = 0
        }
    }

    @IBOutlet weak var viewTextContainer: UIView!

    @IBOutlet weak var buttonTeacher: UIButton!

    @IBOutlet weak var buttonSchool: UIButton!

    @IBOutlet weak var buttonLocation: UIButton!

    fileprivate struct config {
        static let fadeInTime:Double = Double(1.0)
    }

    open func loadImageBackground(_ imageURL:URL) {
        downloadBackgroundImage(imageURL)
    }


    override open func awakeFromNib() {
        super.awakeFromNib()

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
}

