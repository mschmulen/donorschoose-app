//  SchoolDataAPIDelegate.swift

import Foundation

// https://data.donorschoose.org/docs/school-pages/

public protocol SchoolDataAPIDelegate {
    func dataUpdateCallback( _ dataAPI: SchoolDataAPIProtocol, didChangeData data:SchoolDataModel?, error:APIError? )
}

public protocol SchoolDataAPIProtocol {
    
    init(config:APIConfig, user:String, delegate: SchoolDataAPIDelegate?)
    func getCallbackDelegate() ->  SchoolDataAPIDelegate?
    
    func getSchoolInfo(_ schoolID:String)
}

open class SchoolDataAPI : SchoolDataAPIProtocol
{
    fileprivate let apiConfig:APIConfig
    fileprivate var callbackDelegate: SchoolDataAPIDelegate?
    
    public required init(config:APIConfig, user:String, delegate: SchoolDataAPIDelegate?)
    {
        self.apiConfig = config
        self.callbackDelegate = delegate
    }
    
    open func getCallbackDelegate() -> SchoolDataAPIDelegate?
    {
        return callbackDelegate
    }
    
    open func getSchoolInfo(_ schoolID:String)
    {
        let endpoint = "http://api.donorschoose.org/common/json_school.html?school=\(schoolID)&APIKey=\(apiConfig.API_KEY)"
        guard let requestURL = URL(string: endpoint) else { return }
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: requestURL, completionHandler: {
            (data, response, error) -> Void in
            
            if let networkError = error {
                self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.generateFromNetworkError(networkError))
            }
            else {
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode,// != 200,
                    statusCode == 200,
                    let data = data
                    else {
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.notify_USER_GENERIC_NETWORK)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    let results = self.deSerializeContent(json)
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results, error: nil)
                } catch {
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.notify_USER_GENERIC_NETWORK)
                }
            }
        })
        task.resume()
    }
    
    fileprivate func deSerializeContent( _ jsonObj:Any? ) -> SchoolDataModel?
    {
        guard
            let dict = jsonObj as? [String:AnyObject],
            let m = SchoolDataModel.obtainModel(from: dict as JSONObjectBase)
            else { return nil }
        return m
    }
    
}

