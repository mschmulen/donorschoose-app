
import UIKit

@IBDesignable
open class ViewFundingStatus : UIView {
    
    var chartLine: CAShapeLayer!
    
    @IBInspectable
    open var barColor: UIColor = UIColor.green
    
    @IBInspectable
    open var animationDuration:Double = 1.0
    
    open var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            chartLine.cornerRadius = cornerRadius
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
        chartLine              = CAShapeLayer()
        chartLine.lineCap      = CAShapeLayerLineCap.butt
        chartLine.fillColor    = UIColor.white.cgColor
        chartLine.lineWidth    = frame.size.width
        chartLine.strokeEnd    = 0.0
        clipsToBounds          = true
        layer.addSublayer(chartLine)
    }
    
    /// PercentComplete CGFloat value from 0.0 (0%) to 1.0 (100%)
    open var percentComplete: CGFloat = 0.0 {
        didSet {
            
            UIGraphicsBeginImageContext(frame.size)
            
            let progressline:UIBezierPath = UIBezierPath()
            
            progressline.move(to: CGPoint(x: 0, y: frame.size.height))
            progressline.addLine(to: CGPoint(x: frame.size.width * percentComplete, y: frame.size.height))
            progressline.lineWidth = 1.0
            progressline.lineCapStyle = .square
            
            chartLine.path = progressline.cgPath
            chartLine.strokeColor = barColor.cgColor
            
            let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = self.animationDuration
            pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            
            chartLine.add(pathAnimation, forKey:"strokeEndAnimation")
            chartLine.strokeEnd = 1.0
            
            UIGraphicsEndImageContext()
        }
    }
    
    open override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor((self.backgroundColor?.cgColor)!)
            context.fill(rect)
        }
    }
    
}
