//  ProjectDataAPIDelegate.swift

import Foundation
import CoreLocation

public protocol ProjectAPIDelegate {
    func dataUpdateCallback( _ dataAPI: ProjectAPIProtocol, didChangeData dataList:[ProposalModel]?, error:APIError? )
}

public protocol ProjectAPIProtocol {
    init(config:APIConfig, user:String, delegate: ProjectAPIDelegate?)
    func getCallbackDelegate() ->  ProjectAPIDelegate?
    
//    func getDataWithProposalID(_ proposalID:String)
//    func getDataWithSearchModel(_ searchModel:SearchDataModel, pageSize:Int, pageIndex:Int)
//    func getDataWithSearchModelAndLocation(_ searchModel:SearchDataModel, location:CLLocationCoordinate2D, pageSize:Int, pageIndex:Int)
    
    func getData(_ searchModel:SearchDataModel, pageIndex:Int, callback: @escaping ([ProposalModel], APIError?) -> Void)
    func getData(_ proposalID:String, callback: @escaping (ProposalModel?, APIError?) -> Void)
}

class ProjectAPI : ProjectAPIProtocol
{
    fileprivate let apiConfig:APIConfig
    fileprivate var callbackDelegate: ProjectAPIDelegate?
    fileprivate var pageIndex = 0
    
    fileprivate let queue = DispatchQueue(label: "serial queue", attributes: [])
    
    public required init(config:APIConfig, user:String , delegate: ProjectAPIDelegate?)
    {
        self.apiConfig = config
        self.callbackDelegate = delegate
    }
    
    func getCallbackDelegate() -> ProjectAPIDelegate?
    {
        return callbackDelegate
    }
    
//    func getDataWithProposalID(_ proposalID:String) {
//        var components = URLComponents()
//        components.scheme = "http"
//        components.host = "api.donorschoose.org"
//        components.path = "/common/json_feed.html"
//        let apiKeyQueryItem = URLQueryItem(name: "APIKey", value: apiConfig.apiKey)
//        let historicalQueryItem = URLQueryItem(name: "historical", value: "\(true)")
//        let showSynopsisQueryItem = URLQueryItem(name: "showSynopsis", value: "\(true)")
//        let partnerIdQueryItem = URLQueryItem(name: "partnerId", value: apiConfig.partnerID)
//        let proposalIdQueryItem = URLQueryItem(name: "id", value: proposalID)
//
//        components.queryItems = [
//            historicalQueryItem,
//            showSynopsisQueryItem,
//            apiKeyQueryItem,
//            partnerIdQueryItem,
//            proposalIdQueryItem
//        ]
//        guard let requestURL = components.url else {
//            print( "error generating request" )
//            return
//        }
//        networkRequest(requestURL)
//    }
    
//    func getDataWithSearchModelAndLocation(_ searchModel:SearchDataModel, location:CLLocationCoordinate2D, pageSize:Int, pageIndex:Int) {
//
//        let locationCenter = location
//        let longitude = locationCenter.longitude
//        let latitude = locationCenter.latitude
//
//        // let requestURL = "http://api.donorschoose.org/common/json_feed.html?APIKey=\(apiConfig.apiKey)" + "&centerLat=\(latitude)&centerLng=\(longitude)"
//
//        var components = URLComponents()
//        components.scheme = "http"
//        components.host = "api.donorschoose.org"
//        components.path = "/common/json_feed.html"
//
//        let apiKeyQueryItem = URLQueryItem(name: "APIKey", value: apiConfig.apiKey)
//        let centerLatQueryItem = URLQueryItem(name: "centerLat", value: "\(latitude)")
//        let centerLngQueryItem = URLQueryItem(name: "centerLng", value: "\(longitude)")
//        // let maxQueryItem = URLQueryItem(name: "max", value: "\(pageSize)")
//        components.queryItems = [apiKeyQueryItem, centerLatQueryItem,centerLngQueryItem]
//        guard let requestURL = components.url else {
//            print( "error generating request" )
//            return
//        }
//        networkRequest(requestURL)
//    }
    
//    func getDataWithSearchModel(_ searchModel:SearchDataModel, pageSize:Int, pageIndex:Int )
//    {
//        var components = URLComponents()
//        components.scheme = "http"
//        components.host = "api.donorschoose.org"
//        components.path = "/common/json_feed.html"
//        let maxQueryItem = URLQueryItem(name: "max", value: "\(pageSize)")
//        let sortByQueryItem:URLQueryItem
//        let apiKeyQueryItem = URLQueryItem(name: "APIKey", value: apiConfig.apiKey)
//        let partnerIdQueryItem = URLQueryItem(name: "partnerId", value: apiConfig.partnerID)
//
//        var keywordsQueryItem:URLQueryItem?
//        if let keywords = searchModel.keywords {
//            switch searchModel.type {
//            case .keyword, .inspiresUser:
//                keywordsQueryItem = URLQueryItem(name: "keywords", value: "\(keywords.stringByAddingUrlEncoding())")
//            default:
//                break
//            }
//        }
//        sortByQueryItem =  URLQueryItem(name: "sortBy", value: "\(searchModel.sortOption.requestValue())")
//        if let keywordsQueryItem = keywordsQueryItem {
//            components.queryItems = [maxQueryItem, keywordsQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
//        } else {
//            components.queryItems = [maxQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
//        }
//        guard let requestURL = components.url else {
//            return
//        }
//        networkRequest(requestURL)
//    }
    
//    fileprivate func networkRequest(_ requestURL:URL)
//    {
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let task = session.dataTask(with: requestURL, completionHandler: { (data, response, error) -> Void in
//            if let networkError = error {
//                self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.generateFromNetworkError(networkError))
//            }
//            else {
//                guard let httpResponse = response as? HTTPURLResponse,
//                    let data = data, (httpResponse.statusCode == 200)
//                    else {
//                        self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.genericNetwork)
//                        return
//                }
//                do {
//                    let projectModel = try JSONDecoder().decode(ProjectNetworkModel.self, from: data)
//                    let results = projectModel.proposals
//                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: results , error: nil)
//                } catch let error {
//                    print("error in JSONSerialization \(error)")
//                    self.callbackDelegate?.dataUpdateCallback(self, didChangeData: nil , error: APIError.networkSerialize)
//                }
//            }
//        })
//        task.resume()
//    }
    
    func makeRequestURL(_ searchModel:SearchDataModel) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.donorschoose.org"
        components.path = "/common/json_feed.html"
        let maxQueryItem = URLQueryItem(name: "max", value: "\(searchModel.pageSize)")
        let sortByQueryItem:URLQueryItem
        let apiKeyQueryItem = URLQueryItem(name: "APIKey", value: apiConfig.apiKey)
        let partnerIdQueryItem = URLQueryItem(name: "partnerId", value: apiConfig.partnerID)

        var keywordsQueryItem:URLQueryItem?
        if let keywords = searchModel.keywords {
            switch searchModel.type {
            case .keyword, .inspiresUser:
                keywordsQueryItem = URLQueryItem(name: "keywords", value: "\(keywords.stringByAddingUrlEncoding())")
            default:
                break
            }
        }
        sortByQueryItem =  URLQueryItem(name: "sortBy", value: "\(searchModel.sortOption.requestValue())")
        if let keywordsQueryItem = keywordsQueryItem {
            components.queryItems = [maxQueryItem, keywordsQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
        } else {
            components.queryItems = [maxQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
        }
        return components.url
    }
    
    func getData(_ proposalID:String, callback: @escaping (ProposalModel?, APIError?) -> Void) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.donorschoose.org"
        components.path = "/common/json_feed.html"
        let apiKeyQueryItem = URLQueryItem(name: "APIKey", value: apiConfig.apiKey)
        let historicalQueryItem = URLQueryItem(name: "historical", value: "\(true)")
        let showSynopsisQueryItem = URLQueryItem(name: "showSynopsis", value: "\(true)")
        let partnerIdQueryItem = URLQueryItem(name: "partnerId", value: apiConfig.partnerID)
        let proposalIdQueryItem = URLQueryItem(name: "id", value: proposalID)
        
        components.queryItems = [
            historicalQueryItem,
            showSynopsisQueryItem,
            apiKeyQueryItem,
            partnerIdQueryItem,
            proposalIdQueryItem
        ]
        guard let requestURL = components.url else {
            callback(nil, APIError.genericNetwork)
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: requestURL, completionHandler: { (data, response, error) -> Void in
            if let networkError = error {
                callback(nil, APIError.generateFromNetworkError(networkError))
            }
            else {
                guard let httpResponse = response as? HTTPURLResponse,
                    let data = data, (httpResponse.statusCode == 200)
                    else {
                        callback(nil, APIError.genericNetwork)
                        return
                }
                do {
                    let projectModel = try JSONDecoder().decode(ProjectNetworkModel.self, from: data)
                    callback(projectModel.proposals.first, nil)
                } catch let error {
                    print("error in JSONSerialization \(error)")
                    callback(nil, APIError.networkSerialize)
                }
            }
        })
        task.resume()
    }
    
    func getData(_ searchModel:SearchDataModel, pageIndex:Int, callback: @escaping ([ProposalModel], APIError?) -> Void) {
        
        guard let requestURL = makeRequestURL(searchModel) else {
            callback([ProposalModel](), APIError.genericNetwork)
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: requestURL, completionHandler: { (data, response, error) -> Void in
            if let networkError = error {
                callback([ProposalModel](), APIError.generateFromNetworkError(networkError))
            }
            else {
                guard let httpResponse = response as? HTTPURLResponse,
                    let data = data, (httpResponse.statusCode == 200)
                    else {
                        callback([ProposalModel](), APIError.genericNetwork)
                        return
                }
                do {
                    let projectModel = try JSONDecoder().decode(ProjectNetworkModel.self, from: data)
                    callback(projectModel.proposals, nil)
                } catch let error {
                    print("error in JSONSerialization \(error)")
                    callback([ProposalModel](), APIError.networkSerialize)
                }
            }
        })
        task.resume()
    }
}




