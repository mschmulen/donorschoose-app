//  SchoolDataAPIDelegate.swift

import Foundation

// https://data.donorschoose.org/docs/school-pages/

public protocol SchoolDataAPIDelegate {
    func dataUpdateCallback( _ dataAPI: SchoolDataAPIProtocol, didChangeData data:SchoolDataModel?, error:APIError? )
}

public protocol SchoolDataAPIProtocol {
    
    init(config:APIConfig, user:String, delegate: SchoolDataAPIDelegate?)
    func getCallbackDelegate() ->  SchoolDataAPIDelegate?
    
    // General Info
    func getSchoolInfo(_ schoolID:String)
    
    // Proposals
    // Information about the currently-fundable projects associated with this school.
    // http://data.donorschoose.org/docs/project-listing/json-responses/
    // func getProposalsForSchool(schoolID:String)
    
    // Supporters
    // Information about donors who have given to projects at this school.
    // func getSupporters()
    
    // School Angels
    // func getSchoolAngels()
    
    // Teachers
    // Information about teachers at this school with active projects
    //func getSchoolInfoTeachers(schoolID:String , teachersmax:Int? , teachersindex:Int? )
    
}

open class SchoolDataAPI : SchoolDataAPIProtocol
{
    fileprivate let apiConfig:APIConfig
    fileprivate var callbackDelegate: SchoolDataAPIDelegate?
    
    // Mark - DataAPIProtocol
    public required init(config:APIConfig, user:String, delegate: SchoolDataAPIDelegate?)
    {
        self.apiConfig = config
        self.callbackDelegate = delegate
    }
    
    open func getCallbackDelegate() -> SchoolDataAPIDelegate?
    {
        return callbackDelegate
    }
    
    // Mark - Network API

    open func getSchoolInfo(_ schoolID:String)
    {
        let requestURL = "http://api.donorschoose.org/common/json_school.html?school=\(schoolID)&APIKey=\(apiConfig.API_KEY)"
        
        if let requestURL: URL = URL(string: requestURL) {
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: requestURL, completionHandler: {
                (data, response, error) -> Void in
                
                if let networkError = error {
                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.generateFromNetworkError(networkError))
                }
                else {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200 && data != nil ) {
                        
                        // MAS TODO Swift 3 broke
                        /*
                        let json: AnyObject? = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) // options:.AllowFragments
                        let results = self.deSerializeContent(json)
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
                        */
                    }
                    else {
                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.notify_USER_GENERIC_NETWORK)
                    }
                }
            }) 
            task.resume()
        }
    }
    
    fileprivate func deSerializeContent( _ jsonObj:AnyObject? ) -> SchoolDataModel?
    {
        if ( jsonObj != nil )
        {
            if let schoolDict = jsonObj as? [String: AnyObject] {
                
                if let m = SchoolDataModel.obtainModel(from: schoolDict as JSONObjectBase) {
                    return m
                }
            }
        }
        return nil
    }//end deSerializeContent
    
}

