//  DonorDataAPIDelegate.swift

import Foundation

// https://data.donorschoose.org/docs/donor-pages/
// https://www.donorschoose.org/common/rss_challenge_feed.html?id=00000
// https://www.donorschoose.org/giving/mobile-giving-page/20785042/?id=20785042&active=true
// https://api.donorschoose.org/common/json_challenge.html?APIKey=DONORSCHOOSE&id=20785042
// https://api.donorschoose.org/common/json_challenge.html?APIKey=DONORSCHOOSE&id=20785042
// h ttps://api.donorschoose.org/common/json-challenge.html?APIKey=DONORSCHOOSE&id=20785042

public protocol DonorPageDataAPIDelegate {
  func dataUpdateCallback( _ dataAPI: DonorPageDataAPIProtocol, didChangeData data:DonorPageDataModel?, error:APIError? )
}

public protocol DonorPageDataAPIProtocol {

  init(config:APIConfig, user:String, delegate: DonorPageDataAPIDelegate?)
  func getCallbackDelegate() ->  DonorPageDataAPIDelegate?
  
  // Services
  func getStats()
}

// MAS TODO open ? why
open class DonorPageDataAPI : DonorPageDataAPIProtocol
{
  
  fileprivate let apiConfig:APIConfig
  fileprivate var callbackDelegate: DonorPageDataAPIDelegate?

  // Mark - DataAPIProtocol
  public required init(config:APIConfig, user:String, delegate: DonorPageDataAPIDelegate?)
  {
    self.apiConfig = config
    self.callbackDelegate = delegate
  }

  open func getCallbackDelegate() -> DonorPageDataAPIDelegate?
  {
    return callbackDelegate
  }

  // -------------------------------------
  // Mark - Network API
  //let requestURL = "http://api.donorschoose.org/common/json-challenge.html?id=\(givingPageID)&APIKey=\(apiConfig.API_KEY)"
  // -------------------------------------
  open func getStats()
  {

    // MAS TODO , verify
    //    let requestURL = "https://api.donorschoose.org/common/json_challenge.html?APIKey=\(APIKey)&id=\(givingPageID)"

    let requestURL = "https://api.donorschoose.org/common/json_challenge.html?APIKey=\(apiConfig.API_KEY)&id=\(apiConfig.GIVING_PAGE_ID)"

    if let requestURL: URL = URL(string: requestURL) {

      let config = URLSessionConfiguration.default
            let session = URLSession( configuration: config )
            let task = session.dataTask(with: requestURL, completionHandler: {
                (data, response, error) -> Void in

                if let networkError = error {
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.generateFromNetworkError(networkError))
                }
                else {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200 && data != nil ) {
                        
                        let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                        let results = self.deSerializeContent(json)
                        
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
                    }
                    else {
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.notify_USER_GENERIC_NETWORK)
                    }
                }
                
            }) 
            task.resume()
        }
    }
    
    fileprivate func deSerializeContent( _ jsonObj:Any? ) -> DonorPageDataModel?
    {
        if ( jsonObj != nil )
        {
            if let dictionary = jsonObj as? [String: Any] {
                
                let m = try? DonorPageDataModel(json: dictionary)
                return m
            }
        }
        return nil
    }
    
}


