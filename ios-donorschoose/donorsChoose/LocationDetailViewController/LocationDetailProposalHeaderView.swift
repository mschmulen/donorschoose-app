//
//  LocationDetailProposalHeaderView.swift
//

import UIKit

class LocationDetailProposalHeaderView: UICollectionReusableView {

    @IBOutlet weak var labelMajor: UILabel!

    public func configure( major:String ) {
        labelMajor.text = major
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var reuseIdentifier: String {
        return String(describing: LocationDetailProposalHeaderView.self)
    }
    
    static var nib: UINib? {
        return UINib(nibName: String(describing: LocationDetailProposalHeaderView.self), bundle: Bundle(for: LocationDetailProposalHeaderView.self))
    }
}
