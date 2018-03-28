
import UIKit
import CoreLocation

class ProposalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var amountNeededLabel: UILabel!
    @IBOutlet weak var donorCountLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    @IBOutlet weak var viewFundingStatusBar: ViewFundingStatus! {
        didSet { viewFundingStatusBar.cornerRadius = 2 }
    }
    
    func loadItem(_ model: ProposalModel ) {
        
        titleLabel.text = model.title
        descriptionLabel.text = model.shortDescription
        
        teacherLabel.text = model.teacherName
        schoolLabel.text = model.schoolName
        locationLabel.text = "\(model.city),\(model.state)"
        
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
        
        if let imageURLString = model.thumbImageURL  {
            if let url = URL(string: imageURLString) {
                downloadImage(url)
            }
        }
        
        let percentFloat = CGFloat( CGFloat(model.percentFunded) * 0.01 )
        viewFundingStatusBar.percentComplete = percentFloat
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.backgroundColor = UIColor.white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageThumbnail.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
        teacherLabel.text = ""
        schoolLabel.text = ""
        locationLabel.text = ""
        amountNeededLabel.text =  ""
        donorCountLabel.text = ""
        timeLeftLabel.text = ""
        timeLeftLabel.isHidden = true
        viewFundingStatusBar.percentComplete = 0
    }
    
}

extension ProposalTableViewCell : AnimatedTableViewCellProtocol {
    
    func startAnimation() {
        self.layer.transform = CATransform3DMakeScale(0.75,0.75,1)
        UIView.animate(withDuration: 0.20, animations: {
            self.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
}

extension ProposalTableViewCell {
    
    func downloadImage(_ url: URL){
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data , error == nil else {
                    return
                }
                self.imageThumbnail.image = UIImage(data: data)
            }
        }
    }
    
}



