//  ProjectDataAPIDelegate.swift

import Foundation
import CoreLocation

public protocol ProposalDataAPIDelegate {
    func dataUpdateCallback( _ dataAPI: ProposalDataAPIProtocol, didChangeData dataList:[ProposalDataModel]?, error:APIError? )
}

public protocol ProposalDataAPIProtocol {
    
    init(config:APIConfig, user:String, delegate: ProposalDataAPIDelegate?)
    func getCallbackDelegate() ->  ProposalDataAPIDelegate?
    
    func getDataWithSearchModel(_ searchModel:SearchDataModel, pageIndex:Int)
    func getDataWithSearchModelAndLocation(_ searchModel:SearchDataModel, location:CLLocationCoordinate2D, pageIndex:Int)
    func getDataWithProposalID(_ proposalID:String)
}

open class ProposalDataAPI : ProposalDataAPIProtocol
{
    static let defaultMax = 20
    fileprivate let apiConfig:APIConfig
    fileprivate var callbackDelegate: ProposalDataAPIDelegate?
    fileprivate var pageIndex = 0
    fileprivate let pageSize = ProposalDataAPI.defaultMax
    
    public required init(config:APIConfig, user:String , delegate: ProposalDataAPIDelegate?)
    {
        self.apiConfig = config
        self.callbackDelegate = delegate
    }
    
    open func getCallbackDelegate() -> ProposalDataAPIDelegate?
    {
        return callbackDelegate
    }
    
    open func getDataWithProposalID(_ proposalID:String) {
        let partnerIDString = "&partnerId=\(apiConfig.PARTNER_ID)"
        
        //includes historic and show showSynopsis flag
        let requestURL = "http://api.donorschoose.org/common/json_feed.html?&historical=true&showSynopsis=true&APIKey=\(apiConfig.API_KEY)" + partnerIDString + "&id=\(proposalID)"
        
        networkRequest(requestURL)
    }
    
    open func getDataWithSearchModelAndLocation(_ searchModel:SearchDataModel, location:CLLocationCoordinate2D, pageIndex:Int) {
        
        // MAS TODO use the pageIndex for paging
        // "max" and "index" are optional but if provided they will support paged data
        
        let locationCenter = location
        let longitude = locationCenter.longitude
        let latitude = locationCenter.latitude
        
        var requestURL = "http://api.donorschoose.org/common/json_feed.html?APIKey=\(apiConfig.API_KEY)" + "&centerLat=\(latitude)&centerLng=\(longitude)"
        
        // append the page index
        //    requestURL += "&index=\(pageIndex)"
        
        //append the max
        //    requestURL += "&index=\(pageSize)"
        
        switch ( apiConfig.type ) {
        case .production, .stage :
            networkRequest(requestURL)
        case .mock :
            networkRequest(requestURL)
        }
    }
    
    open func getDataWithSearchModel(_ searchModel:SearchDataModel, pageIndex:Int )
    {
        let keyworkSearchString = searchModel.keywords.stringByAddingUrlEncoding()
        
        let max = pageSize
        let partnerIDString = "&partnerId=\(apiConfig.PARTNER_ID)"
        var requestURL = "http://api.donorschoose.org/common/json_feed.html?max=\(max)&keywords=%22\(keyworkSearchString)%22&sortBy=\(searchModel.sortOption.requestValue())&APIKey=\(apiConfig.API_KEY)" + partnerIDString
        
        switch searchModel.type {
        case .in_NEED, .keyword :
            requestURL = "http://api.donorschoose.org/common/json_feed.html?max=\(max)&keywords=%22\(keyworkSearchString)%22&sortBy=\(searchModel.sortOption.requestValue())&APIKey=\(apiConfig.API_KEY)" + partnerIDString
            
        case .location :
            // default austin 30.2672° N, 97.7431° W
            let locationCenter = CLLocationCoordinate2D.init(latitude: 30.2672, longitude: 97.7431)
            let longitude = locationCenter.longitude
            let latitude = locationCenter.latitude
            
            requestURL = "http://api.donorschoose.org/common/json_feed.html?APIKey=\(apiConfig.API_KEY)" + partnerIDString + "centerLat=\(latitude)&centerLng=\(longitude)"
        }
        
        // MAS TODO handle paging
        // append the page index
        //    requestURL += "&index=\(pageIndex)"
        
        //append the max
        //    requestURL += "&index=\(pageSize)"
        
        
        switch ( apiConfig.type ) {
            
        case .production, .stage :
            networkRequest(requestURL)
        case .mock :
            networkRequest(requestURL)
        }
        
    }
    
    // -------------------------------------
    // Mark - Network and Comms
    // -------------------------------------
    
    fileprivate let queue = DispatchQueue(label: "serial queue", attributes: [])
    
    /// Network provider
    fileprivate func networkRequest(_ requestURL:String)
    {
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
                        
                        // MAS TODO swift 3 broke
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            let results = self.deSerializeContent(json)
                            self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
                        } catch {
                            // log("error in JSONSerialization")
                            /*
                             self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.notify_USER_GENERIC_NETWORK)
                             */
                        }
                        
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
    
    fileprivate func deSerializeContent( _ jsonObj:Any? ) -> [ProposalDataModel]
    {
        var deSerializedDataModels:[ProposalDataModel] = [ProposalDataModel]()
        
        if ( jsonObj != nil )
        {
            // MAS TODO cleanup
            if let headerDict = jsonObj as? [String: AnyObject] {
                
                // MAS TODO get the "index" and the "totalProposals"
                //“index”:”0″,
                // “max”:”10″,
                if let maxValue = headerDict["max"] {
                    print( "maxValue \(maxValue)")
                    //pagSize = maxValue
                }
                if let totalProposalsValue = headerDict["totalProposals"] {
                    print ("totalProposals \(totalProposalsValue) ")
                }
                
                if let indexValue = headerDict["index"] {
                    print( "page index = \(indexValue)")
                }
                
                // breadcrumb
                if let breadcrumb = headerDict["breadcrumb"] as? [AnyObject] {
                    for param in breadcrumb {
                        if let paramComp = param as? [AnyObject] {
                            print( "name: \(paramComp[0]) ," + "val: \(paramComp[1]) ," + "val2: \(paramComp[2])" )
                        }
                    }
                }
                
                if let proposalList = headerDict["proposals"] as? [AnyObject] {
                    for prop in proposalList {
                        if let m = ProposalDataModel.obtainModel(from: prop) {
                            deSerializedDataModels.append( m )
                        }
                        else {
                            //print( "failed to deserialize model ")
                        }
                    }
                }
            }
        }
        
        return deSerializedDataModels
    }
}




