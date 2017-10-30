//
//  ProposalViewCell.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 10/30/17.
//  Copyright © 2017 jumptack. All rights reserved.
//

import UIKit

typealias ProposalViewCellType = (Name:String, Value:String)

class ProposalViewCell: UICollectionViewCell {

    @IBOutlet weak var labelProposalName: UILabel!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure( name:String, description:String) {
        labelProposalName.text = name
        textViewDescription.text = description
    }
    
    class func fromNib() -> ProposalViewCell?
    {
        var cell: ProposalViewCell?
        let nibViews =  Bundle(for: self).loadNibNamed("ProposalViewCell", owner: nil, options: nil )
        
        for nibView in nibViews! {
            if let cellView = nibView as? ProposalViewCell {
                cell = cellView
            }
        }
        return cell
    }
    
}
