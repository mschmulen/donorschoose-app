//
//  DonorDataAPIDelegate.swift
//

import Foundation

public protocol DonorPageDataAPIDelegate {
    func dataUpdateCallback( _ dataAPI: DonorPageDataAPIProtocol, didChangeData data:DonorPageDataModel?, error:APIError? )
}

public protocol DonorPageDataAPIProtocol {
    
    init(config:APIConfig, user:String, delegate: DonorPageDataAPIDelegate?)
    func getCallbackDelegate() ->  DonorPageDataAPIDelegate?
    
    func getStats()
}

open class DonorPageDataAPI : DonorPageDataAPIProtocol
{
    
    fileprivate let apiConfig:APIConfig
    fileprivate var callbackDelegate: DonorPageDataAPIDelegate?
    
    public required init(config:APIConfig, user:String, delegate: DonorPageDataAPIDelegate?)
    {
        self.apiConfig = config
        self.callbackDelegate = delegate
    }
    
    open func getCallbackDelegate() -> DonorPageDataAPIDelegate?
    {
        return callbackDelegate
    }
    
    open func getStats()
    {
        
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


