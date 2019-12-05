//  TeacherDataAPIDelegate.swift

import Foundation

public protocol TeacherDataAPIDelegate {
    func dataUpdateCallback( _ dataAPI: TeacherDataAPIProtocol, didChangeData data:TeacherModel?, error:APIError? )
}

public protocol TeacherDataAPIProtocol {
    init(apiConfig:APIConfig, user:String, delegate: TeacherDataAPIDelegate?)
    func getCallbackDelegate() ->  TeacherDataAPIDelegate?
    
    func getTeacherInfo(_ teacherID:String)
}

open class TeacherDataAPI : TeacherDataAPIProtocol
{
    fileprivate let apiConfig:APIConfig
    fileprivate var callbackDelegate: TeacherDataAPIDelegate?
    
    public required init(apiConfig:APIConfig, user:String, delegate: TeacherDataAPIDelegate?)
    {
        self.apiConfig = apiConfig
        self.callbackDelegate = delegate
    }
    
    open func getCallbackDelegate() -> TeacherDataAPIDelegate?
    {
        return callbackDelegate
    }
    
    open func getTeacherInfo(_ teacherID:String)
    {
        let endpoint = "http://api.donorschoose.org/common/json-teacher.html?teacher=\(teacherID)&APIKey=\(apiConfig.apiKey)"
        guard let requestURL = URL(string: endpoint) else { return }
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: requestURL, completionHandler: {
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
                    let results = try JSONDecoder().decode(TeacherModel.self, from: data)
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
                } catch {
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.networkSerialize)
                }
            }
        })
        task.resume()
    }
}

