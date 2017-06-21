//
//  StatViewCell.swift

import UIKit

open class StatViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelStatName: UILabel! {
        didSet { labelStatName.text = ""}
    }
    
    @IBOutlet weak var labelStatValue: UILabel! {
        didSet { labelStatValue.text = "" }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
}
