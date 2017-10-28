//  TeacherDataAPIDelegate.swift

import Foundation

// https://data.donorschoose.org/docs/teacher-pages/

public protocol TeacherDataAPIDelegate {
  func dataUpdateCallback( _ dataAPI: TeacherDataAPIProtocol, didChangeData data:TeacherDataModel?, error:APIError? )
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
        let endpoint = "http://api.donorschoose.org/common/json-teacher.html?teacher=\(teacherID)&APIKey=\(apiConfig.API_KEY)"
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
    
    fileprivate func deSerializeContent( _ jsonObj:Any? ) -> TeacherDataModel?
    {
        guard
            let dict = jsonObj as? [String:AnyObject],
            let m = TeacherDataModel.obtainModel(from: dict as JSONObjectBase)
            else { return nil }
        return m
    }
    
}

