//  SchoolDataAPIDelegate.swift

import Foundation

public protocol SchoolDataAPIDelegate {
    func dataUpdateCallback( _ dataAPI: SchoolDataAPIProtocol, didChangeData data:SchoolModel?, error:APIError? )
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
        let endpoint = "http://api.donorschoose.org/common/json_school.html?school=\(schoolID)&APIKey=\(apiConfig.apiKey)"
        guard let requestURL = URL(string: endpoint) else { return }
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: requestURL, completionHandler: {
            (data, response, error) -> Void in
            
            if let networkError = error {
                // print( networkError.localizedDescription)
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
//                    print( try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) )
                    let results = try JSONDecoder().decode(SchoolModel.self, from: data)
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
                } catch let error {
                    print("error in JSONSerialization \(error)")
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.networkSerialize)
                }
            }
        })
        task.resume()
    }
    
}

