
import UIKit

public protocol AnimatedTableViewCellProtocol {
  func startAnimation()
}

protocol UIReusable: class {
  static var reuseIdentifier: String { get }
  static var nib: UINib? { get }
}

extension UIReusable {

  static var reuseIdentifier: String {
    let stringFromClass = NSStringFromClass( self )
    let nameComponents = stringFromClass.split{$0 == "."}.map(String.init)
    let prefix = nameComponents[1]
    return prefix
  }

  static var nibFileNameFromReuseIdentifier: String {
    let stringFromClass = NSStringFromClass( self )
    let compArr =  stringFromClass.split{$0 == "."}.map(String.init)
    let fileName = compArr[1]
    return fileName
  }

  static var nib: UINib? {
    let n = UINib(nibName: String(describing: nibFileNameFromReuseIdentifier), bundle: Bundle(for: self))
    return n
  }

}

// conform TableView and Collection Cell to Reusable
extension UITableViewCell : UIReusable {}
extension UICollectionViewCell : UIReusable {}

extension UITableView {

  func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: UIReusable {
    if let nib = T.nib {
      self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    } else {
      self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
  }
  
  func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: UIReusable {
      return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: UIReusable {
    if let nib = T.nib {
      self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    } else {
      self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
  }
  
  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: UIReusable {
    return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
  }
}

// MAS TODO support UICollectionView
extension UICollectionView {

 /*
  func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: UIReusable {
    if let nib = T.nib {

      self.register(nil, forCellWithReuseIdentifier:T.reuseIdentifier)

      self.register(nil, forCellWithReuseIdentifier: "yack")

      self.register(T, forCellWithReuseIdentifier: "yack")

      //self.register(nil,
                   // forCellWithReuseIdentifier: T.reuseIdentifier)
      //self.register(nil, forCellWithReuseIdentifier: T.reuseIdentifier)


    } else {

      //self.register(T.self,
                   // forCellReuseIdentifier: T.reuseIdentifier)
    }
  }


  func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: UIReusable {
    return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }

  func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: UIReusable {
    if let nib = T.nib {
      self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    } else {
      self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
  }

  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: UIReusable {
    return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
  }
 */
}



