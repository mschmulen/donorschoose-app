//
//  TeacherHeaderCollectionReusableView.swift

import UIKit

class TeacherHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var backgroundImage: UIImageView! {
        didSet { backgroundImage.alpha = 0 }
    }
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.isHidden = true
            profileImage.alpha = 0
        }
    }
    
    @IBOutlet weak var labelName: UILabel! {
        didSet { labelName.text = "" }
    }
    
    fileprivate struct config {
        static let fadeInTime:Double = Double(1.0)
    }
    
    func loadBackgroundImagePicture(_ imageURL:URL ) {
        downloadBackgroundImage(imageURL)
    }
    
    func loadImagePicture(_ imageURL:URL) {
        downloadProfileImage(imageURL)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var reuseIdentifier: String {
        return String(describing: TeacherHeaderView.self)
    }
    
    static var nib: UINib? {
        return UINib(nibName: String(describing: TeacherHeaderView.self), bundle: Bundle(for: TeacherHeaderView.self))
    }
    
}

// Image loading extension
extension TeacherHeaderView {
    
    func downloadBackgroundImage(_ url: URL){
        
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data , error == nil else {
                    self.backgroundImage.isHidden = false
                    self.backgroundImage.image = UIImage(named: "classPicture")
                    self.backgroundImage.contentMode = .scaleAspectFill
                    self.backgroundImage.fadeIn(duration: 1)
                    return
                }
                self.backgroundImage.isHidden = false
                if let imageFromData = UIImage(data: data) {
                    self.backgroundImage.image = imageFromData
                }
                else {
                    self.backgroundImage.image = UIImage(named: "classPicture")
                }
                self.backgroundImage.contentMode = .scaleAspectFill
                self.backgroundImage.fadeIn(duration: config.fadeInTime)
            }
        }
 
    }
    
    func downloadProfileImage(_ url: URL){
        
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data , error == nil else { return }
                self.profileImage.isHidden = false
                self.profileImage.image = UIImage(data: data)
                self.profileImage.fadeIn(duration: config.fadeInTime)
                self.profileImage.contentMode = .scaleAspectFill
            }
        }
        
    }

}

