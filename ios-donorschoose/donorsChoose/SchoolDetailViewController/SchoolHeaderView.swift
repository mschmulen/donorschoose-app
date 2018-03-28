//
//  SchoolHeaderCollectionReusableView.swift
//

import UIKit

class SchoolHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var labelName: UILabel! {
        didSet{ labelName.text = "" }
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
