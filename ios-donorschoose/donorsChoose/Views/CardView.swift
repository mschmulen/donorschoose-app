
import UIKit

class CardView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
        clipsToBounds = false
        layer.masksToBounds = false;
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0);
        layer.shadowRadius = 4.0;
        layer.shadowOpacity = 1.0
    }
    
}
