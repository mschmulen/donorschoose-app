//  NetworkRequestBase.swift

import Foundation

public typealias JSONObjectBase = AnyObject

public struct APIConfig {
    
    public let apiKey:String
    public let partnerID:String
    public let givingPageID:String
    public let partnerEmail:String
    
    public init() {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.path(forResource: "apiKeys", ofType: "plist") else {
            apiKey = "DONORSCHOOSE"
            partnerID = "20785042"
            givingPageID = "20785042"
            partnerEmail = "matt@jumptack.com"
            return
        }
        
        guard fileManager.fileExists(atPath: path) else {
            apiKey = "DONORSCHOOSE"
            partnerID = "20785042"
            givingPageID = "20785042"
            partnerEmail = "matt@jumptack.com"
            return
        }
        
        guard let dict = NSDictionary(contentsOfFile: path) else {
            apiKey = "DONORSCHOOSE"
            partnerID = "20785042"
            givingPageID = "20785042"
            partnerEmail = "matt@jumptack.com"
            return
        }
        
        guard let API_KEYString = dict["API_KEY"] as? String,
            let PARTNER_IDString = dict["PARTNER_ID"] as? String,
            let GIVING_PAGE_IDString = dict["GIVING_PAGE_ID"] as? String,
            let PARTNER_EMAILString = dict["PARTNER_EMAIL"] as? String else {
                apiKey = "DONORSCHOOSE"
                partnerID = "20785042"
                givingPageID = "20785042"
                partnerEmail = "matt@jumptack.com"
                return
        }
        
        apiKey = API_KEYString
        partnerID = PARTNER_IDString
        givingPageID = GIVING_PAGE_IDString
        partnerEmail = PARTNER_EMAILString
    }
}





