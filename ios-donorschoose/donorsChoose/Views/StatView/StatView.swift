
import UIKit

@IBDesignable open class StatView: UIView {

  public enum STATVIEW_STAT {
    case supporters
    case students_REACHED
    case projects_FUNDED
    case dollars_RAISED
    case schools_PARTICIPATING

    func nameString() -> String {
      switch self {
      case .students_REACHED : return "STUDENTS REACHED"
      case .supporters: return "SUPPORTERS"
      case .projects_FUNDED : return "PROJECTS FUNDED"
      case .dollars_RAISED : return "DOLLARS RAISED"
      case .schools_PARTICIPATING : return "SCHOOLS PARTICIPATING"
      }
    }

    func valueString() -> String {
      switch self {
      case .students_REACHED : return "18,652,905"
      case .supporters: return "2,124,954"
      case .projects_FUNDED : return "741,462"
      case .dollars_RAISED : return "434,702,470"
      case .schools_PARTICIPATING : return "68,734"
      }
    }
  }

  @IBInspectable var currentStat:STATVIEW_STAT = STATVIEW_STAT.supporters {
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
