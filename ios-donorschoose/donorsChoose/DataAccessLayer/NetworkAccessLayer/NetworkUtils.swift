//  NetworkRequestBase.swift

import Foundation

public typealias JSONObjectBase = AnyObject

public enum API_TYPE {
  case production
  case stage
  case mock
}

// custom keys and configs can be used by creating a custom "donorsChooseKeys.plist" file in the root folder
  // Root:Dictionary
  //    API_KEY:String
  //    GIVING_PAGE_ID:String
  //    PARTNER_ID:String
  //    PARTNER_EMAIL:String

public struct APIConfig {

  public let API_KEY:String
  public let PARTNER_ID:String
  public let GIVING_PAGE_ID:String
  public let PARTNER_EMAIL:String
  public let type = API_TYPE.production


  public init() {
    let fileManager = FileManager.default

    // MAS TODO Load from the config file if its present otherwise use the defaults
    guard let path = Bundle.main.path(forResource: "apiKeys", ofType: "plist") else {
      API_KEY = "DONORSCHOOSE"
      PARTNER_ID = "20785042"
      GIVING_PAGE_ID = "20785042"
      PARTNER_EMAIL = "matt@jumptack.com"
      return
    }

    guard fileManager.fileExists(atPath: path) else {
      API_KEY = "DONORSCHOOSE"
      PARTNER_ID = "20785042"
      GIVING_PAGE_ID = "20785042"
      PARTNER_EMAIL = "matt@jumptack.com"
      return
    }

    guard let dict = NSDictionary(contentsOfFile: path) else {
      API_KEY = "DONORSCHOOSE"
      PARTNER_ID = "20785042"
      GIVING_PAGE_ID = "20785042"
      PARTNER_EMAIL = "matt@jumptack.com"
      return
    }

    // load the API values
    guard let API_KEYString = dict["API_KEY"] as? String,
      let PARTNER_IDString = dict["PARTNER_ID"] as? String,
      let GIVING_PAGE_IDString = dict["GIVING_PAGE_ID"] as? String,
      let PARTNER_EMAILString = dict["PARTNER_EMAIL"] as? String else {
//        log( "apiKeys.plist is malformed")
        API_KEY = "DONORSCHOOSE"
        PARTNER_ID = "20785042"
        GIVING_PAGE_ID = "20785042"
        PARTNER_EMAIL = "matt@jumptack.com"
        return
    }

    API_KEY = API_KEYString
    PARTNER_ID = PARTNER_IDString
    GIVING_PAGE_ID = GIVING_PAGE_IDString
    PARTNER_EMAIL = PARTNER_EMAILString

    }
}

public enum APIError: Error {
    
    case notify_USER_INTERNET_OFFLINE
    case notify_USER_TIMEOUT
    case notify_USER_DATA_NOT_ALLOWED
    case notify_USER_CONNECTION_LOST
    
    case notify_USER_GENERIC_NETWORK
    case unknown(String)
    case silent(String)
    
    public static func generateFromNetworkError( _ networkError:NSError) -> APIError
    {
        if (networkError.domain == NSURLErrorDomain) {
            
            if (networkError.code == NSURLErrorNotConnectedToInternet) {
                return APIError.notify_USER_INTERNET_OFFLINE
            }
            else if (networkError.code == NSURLErrorTimedOut) {
                return APIError.notify_USER_TIMEOUT
            }
            else if (networkError.code == NSURLErrorDataNotAllowed) {
                return APIError.notify_USER_DATA_NOT_ALLOWED
            }
            else if (networkError.code == NSURLErrorNetworkConnectionLost) {
                return APIError.notify_USER_CONNECTION_LOST
            }
            else {
                //NSURLErrorCannotConnectToHost
                //NSURLErrorCannotFindHost
                //NSURLErrorCallIsActive
                return APIError.notify_USER_GENERIC_NETWORK
            }
        }
        else {
            return APIError.unknown(networkError.description)
        }
    }
    
    public static func generateFromNetworkError( _ networkError:Error) -> APIError
    {
      // MAS TODO Swift 3 , broke
//      show ( networkError.localizedDescription)
        /*
        if (networkError.domain == NSURLErrorDomain) {
            
            if (networkError.code == NSURLErrorNotConnectedToInternet) {
                return APIError.notify_USER_INTERNET_OFFLINE
            }
            else if (networkError.code == NSURLErrorTimedOut) {
                return APIError.notify_USER_TIMEOUT
            }
            else if (networkError.code == NSURLErrorDataNotAllowed) {
                return APIError.notify_USER_DATA_NOT_ALLOWED
            }
            else if (networkError.code == NSURLErrorNetworkConnectionLost) {
                return APIError.notify_USER_CONNECTION_LOST
            }
            else {
                //NSURLErrorCannotConnectToHost
                //NSURLErrorCannotFindHost
                //NSURLErrorCallIsActive
                return APIError.notify_USER_GENERIC_NETWORK
            }
        }
        else {
            return APIError.unknown(networkError.description)
        }
        */
        
        return APIError.notify_USER_GENERIC_NETWORK
    }

}

public extension String {
    func stringByAddingUrlEncoding() -> String {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._* ")
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)?.replacingOccurrences(of: " ", with: "+") ?? self
    }
}

