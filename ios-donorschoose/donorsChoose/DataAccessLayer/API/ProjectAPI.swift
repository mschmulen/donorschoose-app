//  ProjectDataAPIDelegate.swift

import Foundation
import CoreLocation


public protocol ProjectAPIProtocol {
    init(config:APIConfig, user:String)
    
    func getData(_ searchModel:ProjectSearchDataModel, pageIndex:Int, callback: @escaping ([ProposalModel], APIError?) -> Void)
    func getData(_ proposalID:String, callback: @escaping (ProposalModel?, APIError?) -> Void)
}

class ProjectAPI : ProjectAPIProtocol
{
    fileprivate let apiConfig:APIConfig

    fileprivate var pageIndex = 0
    
    fileprivate let queue = DispatchQueue(label: "serial queue", attributes: [])
    
    public required init(config:APIConfig, user:String )
    {
        self.apiConfig = config
    }
    
    func makeRequestURL(_ searchModel:ProjectSearchDataModel) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.donorschoose.org"
        components.path = "/common/json_feed.html"
        let maxQueryItem = URLQueryItem(name: "max", value: "\(searchModel.pageSize)")
        let apiKeyQueryItem = URLQueryItem(name: "APIKey", value: apiConfig.apiKey)
        let partnerIdQueryItem = URLQueryItem(name: "partnerId", value: apiConfig.partnerID)
        let sortByQueryItem:URLQueryItem =  URLQueryItem(name: "sortBy", value: "\(searchModel.sortOption.requestValue())")
        
        switch searchModel.type {
        case .keyword:
            if let keywords = searchModel.keywords {
                let keywordsQueryItem:URLQueryItem = URLQueryItem(name: "keywords", value: "\(keywords.stringByAddingUrlEncoding())")
                components.queryItems = [maxQueryItem, keywordsQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            } else {
                components.queryItems = [maxQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            }
        case .inspiresUser:
            if let keywords = searchModel.keywords {
                let keywordsQueryItem:URLQueryItem = URLQueryItem(name: "keywords", value: "\(keywords.stringByAddingUrlEncoding())")
                components.queryItems = [maxQueryItem, keywordsQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            } else {
                components.queryItems = [maxQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            }
        case .locationLatLong:
            if let latitude = searchModel.latitude, let longitude = searchModel.longitude {
                let centerLatQueryItem = URLQueryItem(name: "centerLat", value: "\(latitude)")
                let centerLngQueryItem = URLQueryItem(name: "centerLng", value: "\(longitude)")
                // MAS TODO support other pramters
                components.queryItems = [apiKeyQueryItem, centerLatQueryItem,centerLngQueryItem, partnerIdQueryItem ] // sortByQueryItem, maxQueryItem ,]
            } else {
                components.queryItems = [maxQueryItem, sortByQueryItem, apiKeyQueryItem, partnerIdQueryItem]
            }
        case .locationInfo:
            if let locationInfo = searchModel.locationInfo {
                let stateQueryItem = URLQueryItem(name: "state", value: locationInfo.state)
//                let communityQueryItem = URLQueryItem(name: "community", value: "10007")
                // MAS TODO
                // https://api.donorschoose.org/common/json_feed.html?state=NC&community=10007:3&APIKey=DONORSCHOOSE
                components.queryItems = [apiKeyQueryItem, stateQueryItem, partnerIdQueryItem ]
            }
        case .urgent:
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
    
    func getData(_ searchModel:ProjectSearchDataModel, pageIndex:Int, callback: @escaping ([ProposalModel], APIError?) -> Void) {
        
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




