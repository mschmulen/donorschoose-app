//
//  StatViewCell.swift

import UIKit

typealias StatType = (Name:String, Value:String)

open class StatViewCell: UICollectionViewCell {
    
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var labelStatName: UILabel! {
        didSet {
            labelStatName.text = ""
        }
    }
    
    @IBOutlet weak var labelStatValue: UILabel! {
        didSet {
            labelStatValue.text = ""
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure( name:String, value:String) {
        labelStatName.text = name
        labelStatValue.text = value
    }
    
    
    class func fromNib() -> StatViewCell?
    {
        var cell: StatViewCell?
        let nibViews =  Bundle(for: self).loadNibNamed("StatViewCell", owner: nil, options: nil )
        
        for nibView in nibViews! {
            if let cellView = nibView as? StatViewCell {
                cell = cellView
            }
        }
        return cell
    }

}
