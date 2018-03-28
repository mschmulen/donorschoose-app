//
//  SchoolDetailProposalHeaderView.swift
//

import UIKit

class SchoolDetailProposalHeaderView: UICollectionReusableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var reuseIdentifier: String {
        return String(describing: SchoolDetailProposalHeaderView.self)
    }
    
    static var nib: UINib? {
        return UINib(nibName: String(describing: SchoolDetailProposalHeaderView.self), bundle: Bundle(for: SchoolDetailProposalHeaderView.self))
    }
    
    
}
