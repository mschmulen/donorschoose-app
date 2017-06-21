
import UIKit

open class AlertFactory {

  open class func AlertFromAPIError(_ error:APIError) -> UIAlertController?
  {
    let messageString:String = "API Error \(error )"
    let alert = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    return alert
  }

  open class func AlertFromError(_ error:APIError) -> UIAlertController?
  {
    switch(error)
    {
    case .notify_USER_INTERNET_OFFLINE:

      let messageString:String = "No Internet connection, please check your settings"
      let alert = UIAlertController(title: "No Internet", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
      return alert
    case .notify_USER_GENERIC_NETWORK:
      let messageString:String = "Error connecting to the server, please try again"
      let alert = UIAlertController(title: "Connecting Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
      return alert
    case .notify_USER_TIMEOUT:
      let messageString:String = "Connection timed out, please try again"
      let alert = UIAlertController(title: "Connecting Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
      return alert
    case .notify_USER_DATA_NOT_ALLOWED:
      let messageString:String = "Data is not allowed for this application on this device, please check your settings"
      let alert = UIAlertController(title: "Data Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
      return alert
    case .notify_USER_CONNECTION_LOST :
      let messageString:String = "Connection lost, please try again"
      let alert = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
      return alert
    case .unknown:
      return nil
    case .silent:
      return nil
    }
  }
}

