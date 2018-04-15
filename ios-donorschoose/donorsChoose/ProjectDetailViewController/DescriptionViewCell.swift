//  DescriptionViewCell.swift

import UIKit

class DescriptionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    func configure( title:String , description:String ) {
        labelTitle.text = title
        labelDescription.text = description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    class func fromNib() -> DescriptionViewCell?
    {
        var cell: DescriptionViewCell?
        let nibViews =  Bundle(for: self).loadNibNamed("DescriptionViewCell", owner: nil, options: nil )
        
        for nibView in nibViews! {
            if let cellView = nibView as? DescriptionViewCell {
                cell = cellView
            }
        }
        return cell
    }
}
