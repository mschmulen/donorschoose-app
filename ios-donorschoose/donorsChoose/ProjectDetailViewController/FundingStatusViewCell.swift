//
//  FundingStatusViewCell.swift
//
import UIKit

class FundingStatusViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!

    @IBOutlet weak var constraintWidth: NSLayoutConstraint!

    @IBOutlet weak var amountNeededLabel: UILabel!
    @IBOutlet weak var donorCountLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!

    @IBOutlet weak var viewFundingStatusBar: ViewFundingStatus! {
        didSet { viewFundingStatusBar.cornerRadius = 2 }
    }

    func configure( model:ProposalModel ) {
        labelTitle.text = "Funding Status:"

        amountNeededLabel.text =  "$\(model.costToComplete)"
        donorCountLabel.text = "\(model.numDonors)"

        let calendar: Calendar = Calendar.current
        let daysFromExpires = (calendar as NSCalendar).components(.day, from: model.expirationDate as Date)

        if let daysLeft = daysFromExpires.day {
            if (daysLeft < 30 ) {
                timeLeftLabel.isHidden = false
                timeLeftLabel.text = "\(daysLeft) days left!"
            }
            else {
                timeLeftLabel.text = "\(daysLeft) days left!"
                timeLeftLabel.isHidden = true
            }
        }
        else {
            timeLeftLabel.text = "unknown days left!"
            timeLeftLabel.isHidden = true
        }

        //
//        let percentFloat = CGFloat( CGFloat(model.percentFunded) * 0.01 )
//        viewFundingStatusBar.percentComplete = percentFloat
//
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
