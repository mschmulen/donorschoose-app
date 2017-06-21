
import UIKit

extension UIColor {

  // RGB Color Extension usage:
  //  let newSwiftColor = UIColor(red: 255, green: 165, blue: 0)

  public convenience init(red: Int, green: Int, blue: Int) {
    let newRed = CGFloat(red)/255
    let newGreen = CGFloat(green)/255
    let newBlue = CGFloat(blue)/255

    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
  }
}

extension UIColor {

  public convenience init(hex:Int) {
    self.init(hex: hex, alpha: 1.0)
  }

  public convenience init(hex: Int, alpha: CGFloat) {
    let red =   CGFloat((0xff0000 & hex) >> 16) / 255.0
    let green = CGFloat((0xff00   & hex) >> 8)  / 255.0
    let blue =  CGFloat( 0xff     & hex      )  / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  var alpha: CGFloat { return cgColor.alpha }
  var halfGlass: UIColor { return self.withAlphaComponent(0.5) }
  var glass: UIColor { return self.withAlphaComponent(0.6) }

  var hexString: String {
    var red: CGFloat = 0
    var green: CGFloat  = 0
    var blue: CGFloat = 0
    self.getRed(&red, green: &green, blue: &blue, alpha: nil)
    let r = Int(255.0 * red);
    let g = Int(255.0 * green);
    let b = Int(255.0 * blue);
    return String(format: "#%02x%02x%02x", r,g,b)
  }

}
