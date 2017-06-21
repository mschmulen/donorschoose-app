//  TeacherDataAPIDelegate.swift

import Foundation

// https://data.donorschoose.org/docs/teacher-pages/

public protocol TeacherDataAPIDelegate {
  func dataUpdateCallback( _ dataAPI: TeacherDataAPIProtocol, didChangeData data:TeacherDataModel?, error:APIError? )
}

public protocol TeacherDataAPIProtocol {
  init(apiConfig:APIConfig, user:String, delegate: TeacherDataAPIDelegate?)
  func getCallbackDelegate() ->  TeacherDataAPIDelegate?
  
  // Services
  func getTeacherInfo(_ teacherID:String)
}

open class TeacherDataAPI : TeacherDataAPIProtocol
{
  fileprivate let apiConfig:APIConfig
  fileprivate var callbackDelegate: TeacherDataAPIDelegate?

  // Mark - DataAPIProtocol
  public required init(apiConfig:APIConfig, user:String, delegate: TeacherDataAPIDelegate?)
  {
    self.apiConfig = apiConfig
    self.callbackDelegate = delegate
  }
  
  open func getCallbackDelegate() -> TeacherDataAPIDelegate?
  {
    return callbackDelegate
  }

  // Mark - Network API
  open func getTeacherInfo(_ teacherID:String)
    {
      let requestURL = "http://api.donorschoose.org/common/json-teacher.html?teacher=\(teacherID)&APIKey=\(apiConfig.API_KEY)"

      if let requestURL: URL = URL(string: requestURL) {
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                
                if let networkError = error {
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil, error: APIError.generateFromNetworkError(networkError))
                }
                else {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200 && data != nil ) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            let results = self.deSerializeContent(json)
                            self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
                        } catch {
//                          log("error in JSONSerialization")
//                          self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.notify_USER_GENERIC_NETWORK)
                        }
                    }
                    else {
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.notify_USER_GENERIC_NETWORK)
                    }
                }
            })
            
            task.resume()
      }
  }

  fileprivate func deSerializeContent( _ jsonObj:Any? ) -> TeacherDataModel?
  {
    if ( jsonObj != nil )
    {
      if let teacherDict = jsonObj as? [String: AnyObject] {
        if let m = TeacherDataModel.obtainModel(from: teacherDict as JSONObjectBase) {
          return m
        }
      }
    }
    return nil
  }//end deSerializeContent

}

