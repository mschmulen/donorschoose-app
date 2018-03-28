//
//  LocationViewCell.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 10/30/17.
//  Copyright © 2017 jumptack. All rights reserved.
//

import UIKit

typealias LocationViewCellType = (Name:String, Value:String)

class LocationViewCell: UICollectionViewCell {

    @IBOutlet weak var labelLocationName: UILabel!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure( name:String, description:String) {
        labelLocationName.text = name
        textViewDescription.text = description
    }
    
    class func fromNib() -> LocationViewCell?
    {
        var cell: LocationViewCell?
        let nibViews =  Bundle(for: self).loadNibNamed("LocationViewCell", owner: nil, options: nil )
        
        for nibView in nibViews! {
            if let cellView = nibView as? LocationViewCell {
                cell = cellView
            }
        }
        return cell
    }
    
}
