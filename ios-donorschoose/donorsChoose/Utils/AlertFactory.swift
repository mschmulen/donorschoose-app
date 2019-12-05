
import UIKit
import CoreLocation

open class AlertFactory {
    
    class func AlertFromAPIError(_ error:APIError) -> UIAlertController?
    {
        let messageString:String = "API Error \(error )"
        let alert = UIAlertController(title: "Error", message: messageString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    class func AlertFromLocationStatus(_ status: CLAuthorizationStatus) -> UIAlertController?
    {
        var messageString:String = "Location Access"
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .denied:
            messageString = "Location Access Denied"
        case .notDetermined:
            messageString = "Location Access could not be determined"
        case .restricted:
            messageString = "Location Access Restricted"
        }
        
        messageString = messageString + "\n Please check your app settings and make sure Location Services are enabled"
        
        let alert = UIAlertController(title: "Location Access", message: messageString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    class func AlertFromError(_ error:APIError) -> UIAlertController?
    {
        switch(error)
        {
            //    case .deviceInternetOffline:
            //      let messageString:String = "No Internet connection, please check your settings"
            //      let alert = UIAlertController(title: "No Internet", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
            //      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            //      return alert
            //    case .genericNetwork:
            //      let messageString:String = "Error connecting to the server, please try again"
            //      let alert = UIAlertController(title: "Connecting Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
            //      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            //      return alert
            //    case .notify_USER_TIMEOUT:
            //      let messageString:String = "Connection timed out, please try again"
            //      let alert = UIAlertController(title: "Connecting Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
            //      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            //      return alert
            //    case .notify_USER_DATA_NOT_ALLOWED:
            //      let messageString:String = "Data is not allowed for this application on this device, please check your settings"
            //      let alert = UIAlertController(title: "Data Error", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
            //      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            //      return alert
        //    case .notify_USER_CONNECTION_LOST :
        case .unknown:
            return nil
        case .silent , .networkSerialize:
            return nil
        default:
            let alert = UIAlertController(title: error.messageTitle, message: error.messageBody, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil))
            return alert
        }
    }
}

