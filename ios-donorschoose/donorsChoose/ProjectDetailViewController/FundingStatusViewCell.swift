//
//  FundingStatusViewCell.swift
//
import UIKit

class FundingStatusViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    func configure( model:ProposalModel ) {
        labelTitle.text = "Funding Status:"
        
        let calendar: Calendar = Calendar.current
        let daysFromExpires = (calendar as NSCalendar).components(.day, from: model.expirationDate as Date)
        
        let daysLeftString = "days left!"
        if let daysLeftValue = daysFromExpires.day {
            if (daysLeftValue < 30 ) {
                timeLeftLabel.isHidden = false
                timeLeftLabel.text = "\(daysLeftValue) \(daysLeftString)"
            }
            else {
                timeLeftLabel.text = "\(daysLeftValue) \(daysLeftString)"
                timeLeftLabel.isHidden = true
            }
        }
        else {
            timeLeftLabel.text = "unknown \(daysLeftString)"
            timeLeftLabel.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    class func fromNib() -> FundingStatusViewCell?
    {
        var cell: FundingStatusViewCell?
        let nibViews =  Bundle(for: self).loadNibNamed("FundingStatusViewCell", owner: nil, options: nil )
        
        for nibView in nibViews! {
            if let cellView = nibView as? FundingStatusViewCell {
                cell = cellView
            }
        }
        return cell
    }
}
