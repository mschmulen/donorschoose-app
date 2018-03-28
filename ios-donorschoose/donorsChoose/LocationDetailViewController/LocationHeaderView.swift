//
//  LocationHeaderView.swift
//

import UIKit

class LocationHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var labelName: UILabel! {
        didSet{ labelName.text = "" }
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
    }
    
    static var reuseIdentifier: String {
      return String(describing: LocationHeaderView.self)
    }
    
    static var nib: UINib? {
      return UINib(nibName: String(describing: LocationHeaderView.self), bundle: Bundle(for: LocationHeaderView.self))
    }
}
