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
    
    func getStats(_ givingPageId:String)
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
    
    open func getStats(_ givingPageId:String)
    {
        let requestURL = "https://api.donorschoose.org/common/json_challenge.html?APIKey=\(apiConfig.apiKey)&id=\(givingPageId)"
        if let requestURL: URL = URL(string: requestURL) {
            let config = URLSessionConfiguration.default
            let session = URLSession( configuration: config )
            let task = session.dataTask(with: requestURL, completionHandler: {
                (data, response, error) -> Void in
                
                if let networkError = error {
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.generateFromNetworkError(networkError))
                }
                else {
                    guard let httpResponse = response as? HTTPURLResponse,
                        let data = data, (httpResponse.statusCode == 200)
                        else {
                            self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.genericNetwork)
                            return
                    }
                    
                    do {
                        let results = try JSONDecoder().decode(DonorPageDataModel.self, from: data)
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
                    } catch let error {
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.networkSerialize)
                    }
                }
            })
            task.resume()
        }
    }
}


