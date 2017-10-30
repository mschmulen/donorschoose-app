//
//  SchoolHeaderCollectionReusableView.swift
//

import UIKit

class SchoolHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet { profileImage.isHidden = true }
    }
    
    @IBOutlet weak var labelName: UILabel! {
        didSet{ labelName.text = "" }
    }
    
    @IBOutlet weak var labelCity: UILabel! {
        didSet { labelCity.text = "" }
    }
    
    func loadBackgroundImagePicture(_ imageURL:URL ) {
      downloadImage(imageURL, imageView: backgroundImage)
    }
    
    func loadImagePicture(_ imageURL:URL) {
      downloadImage(imageURL, imageView: profileImage)
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
    }
    
    static var reuseIdentifier: String {
      return String(describing: SchoolHeaderView.self)
    }
    
    static var nib: UINib? {
      return UINib(nibName: String(describing: SchoolHeaderView.self), bundle: Bundle(for: SchoolHeaderView.self))
    }
}

extension SchoolHeaderView {
  func downloadImage(_ url: URL, imageView:UIImageView ){
    getDataFromUrl(url) { (data, response, error)  in
      DispatchQueue.main.async { () -> Void in
          guard let data = data , error == nil else { return }
          imageView.isHidden = false
          imageView.image = UIImage(data: data)
          imageView.contentMode = .scaleAspectFill
      }
    }
  }
}

