//  ProjectDataAPIDelegate.swift

import Foundation
import CoreLocation

public protocol ProposalDataAPIDelegate {
  func dataUpdateCallback( _ dataAPI: ProposalDataAPIProtocol, didChangeData dataList:[ProposalDataModel]?, error:APIError? )
}

public protocol ProposalDataAPIProtocol {

  init(config:APIConfig, user:String, delegate: ProposalDataAPIDelegate?)
  func getCallbackDelegate() ->  ProposalDataAPIDelegate?

  // Services
  func getDataWithSearchModel(_ searchModel:SearchDataModel)
  func getDataWithSearchModelAndLocation(_ searchModel:SearchDataModel, location:CLLocationCoordinate2D)
  func getDataWithProposalID(_ proposalID:String)
}

open class ProposalDataAPI : ProposalDataAPIProtocol
{
  fileprivate let apiConfig:APIConfig
  fileprivate var callbackDelegate: ProposalDataAPIDelegate?

  // -------------------------------------
  // Mark - DataAPIProtocol
  // -------------------------------------
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

  open func getDataWithSearchModelAndLocation(_ searchModel:SearchDataModel, location:CLLocationCoordinate2D) {

    let locationCenter = location
    let longitude = locationCenter.longitude
    let latitude = locationCenter.latitude

    let requestURL = "http://api.donorschoose.org/common/json_feed.html?APIKey=\(apiConfig.API_KEY)" + "&centerLat=\(latitude)&centerLng=\(longitude)"

    switch ( apiConfig.type ) {
    case .production, .stage :
      networkRequest(requestURL)
    case .mock :
      networkRequest(requestURL)
    }
  }

  open func getDataWithSearchModel(_ searchModel:SearchDataModel )
  {
    let keyworkSearchString = searchModel.keywords.stringByAddingUrlEncoding()

    let max = 12
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
        // breadcrumb
        if let breadcrumb = headerDict["breadcrumb"] as? [AnyObject] {
          for param in breadcrumb {
            if let paramComp = param as? [AnyObject] {
              print( "name: \(paramComp[0]) ," + "val: \(paramComp[1]) ," + "val2: \(paramComp[2])" )
            }
          }
        }
        // MAS TODO Cleanup
//        if let indexString = headerDict["index"] as? String {
//        }
//        if let maxCountString = headerDict["max"] as? String {
//        }
        if let proposalList = headerDict["proposals"] as? [AnyObject] {
          for prop in proposalList {
            if let m = ProposalDataModel.obtainModel(from: prop) {
              deSerializedDataModels.append( m )
            }
            else {
//              log( "failed to deserialize model ")
            }
          }
        }
      }
    }

    return deSerializedDataModels
  }
}




