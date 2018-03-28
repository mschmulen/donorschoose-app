//  ProposalFooterView.swift

import UIKit

open class ProposalFooterView: UICollectionReusableView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var reuseIdentifier: String {
        return String(describing: ProposalFooterView.self)
    }
    
    static var nib: UINib? {
        return UINib(nibName: String(describing: ProposalFooterView.self), bundle: Bundle(for: ProposalFooterView.self))
    }
    
}
