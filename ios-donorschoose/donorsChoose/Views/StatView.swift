
import UIKit

//@IBDesignable
class StatView: UIView {
    
    public enum Stat {
        case supporters
        case studentsReached
        case projectsFunded
        case dollarsRaised
        case schoolsParticipating
        
        func nameString() -> String {
            switch self {
            case .studentsReached : return "STUDENTS REACHED"
            case .supporters: return "SUPPORTERS"
            case .projectsFunded : return "PROJECTS FUNDED"
            case .dollarsRaised : return "DOLLARS RAISED"
            case .schoolsParticipating : return "SCHOOLS PARTICIPATING"
            }
        }
        
        func valueString() -> String {
            switch self {
            case .studentsReached : return "18,652,905"
            case .supporters: return "2,124,954"
            case .projectsFunded : return "741,462"
            case .dollarsRaised : return "434,702,470"
            case .schoolsParticipating : return "68,734"
            }
        }
    }
    
    //    @IBInspectable var currentStat:Stat = Stat {
    var currentStat:Stat = Stat.supporters {
        didSet {
            statNameLabel.text = currentStat.nameString()
            statValueLabel.text = currentStat.valueString()
        }
    }
    
    @IBOutlet fileprivate var contentView:UIView!
    
    @IBOutlet weak var statNameLabel: UILabel! {
        didSet {
            statNameLabel.text = "STAT NAME"
        }
    }
    
    @IBOutlet weak var statValueLabel: UILabel! {
        didSet {
            statValueLabel.text = "333,333"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        let nib = UINib(nibName: "StatView", bundle: Bundle(for: type(of: self)))
        guard let content = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return }
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.white
    }
    
}
