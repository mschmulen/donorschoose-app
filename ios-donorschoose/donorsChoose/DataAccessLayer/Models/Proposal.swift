
import Foundation
import UIKit

public struct ProposalModel :Codable {
    
    public let id:String
    public let title: String
    public let teacherId: String
    public let teacherName: String
    public let schoolName: String
    public let state: String
    public let city: String
    public let costToComplete:String
    public let numDonors:Int
    public let percentFunded:Int
    public let proposalURL:String
    public let fulfillmentTrailer:String
    public let fundingStatus:String
    public let gradeLevel:GradeLevelModel
    public let imageURL:String?
    public let latitude:String
    public let longitude:String
    public let thumbImageURL:String?
    public let povertyLevel:String
    public let schoolUrl:String
    public let extractedSchoolID:String?
    public let totalPrice:String
    public let zip:String
    public let expirationDate:Date
    public let freeShipping:Bool
    public let fundURL:String?
    public let shortDescription:String
    
    public let synopsis:String?
    
    // codable
    enum CodingError: Error {
        case decoding(String)
    }
    
    public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        
        title = try values.decode(String.self, forKey: .title)
        teacherId = try values.decode(String.self, forKey: .teacherId)
        teacherName = try values.decode(String.self, forKey: .teacherName)
        schoolName = try values.decode(String.self, forKey: .schoolName)
        state = try values.decode(String.self, forKey: .state)
        city = try values.decode(String.self, forKey: .city)
        costToComplete = try values.decode(String.self, forKey: .costToComplete)
        
        numDonors = Int( try values.decode(String.self, forKey: .numDonors) ) ?? 0
        percentFunded = Int( try values.decode(String.self, forKey: .percentFunded) )!
        proposalURL = try values.decode(String.self, forKey: .proposalURL)
        fulfillmentTrailer = try values.decode(String.self, forKey: .fulfillmentTrailer)
        fundingStatus = try values.decode(String.self, forKey: .fundingStatus)
        gradeLevel = try values.decode(GradeLevelModel.self, forKey: .gradeLevel)
        imageURL = try? values.decode(String.self, forKey: .imageURL) // String?
        latitude = try values.decode(String.self, forKey: .latitude)
        longitude = try values.decode(String.self, forKey: .longitude)
        thumbImageURL = try? values.decode(String.self, forKey: .thumbImageURL) // String?
        povertyLevel = try values.decode(String.self, forKey: .povertyLevel)
        schoolUrl = try values.decode(String.self, forKey: .schoolUrl)
        
        totalPrice = try values.decode(String.self, forKey: .totalPrice)
        zip = try values.decode(String.self, forKey: .zip)
        
        fundURL = try? values.decode(String.self, forKey: .fundURL) // String?
        shortDescription = try values.decode(String.self, forKey: .shortDescription)
        
        // MAS TODO codable
        freeShipping = false // try values.decode(Bool.self, forKey: .freeShipping)
        
        if let synopsisString = ((try? values.decode(String?.self, forKey: .synopsis)) as String??) {
            synopsis = synopsisString
        } else {
            synopsis = shortDescription
        }

        // expirationDate = dateFormatter.date(from: try values.decode(String.self, forKey: .expirationDate))!
        let expirationDateString = try values.decode(String.self, forKey: .expirationDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: expirationDateString ) {
            expirationDate = date
        } else {
            throw CodingError.decoding("Decoding Error: \(dump(values))")
        }
        
        if let _ = URL(string: schoolUrl) {
            let schoolURLpaths = schoolUrl.components(separatedBy: "/")
            // MAS TODO , Fix This
            let secondLastPath = schoolURLpaths[schoolURLpaths.count - 2]
            let schoolID = secondLastPath
            extractedSchoolID = schoolID
        } else {
            throw CodingError.decoding("Decoding Error: \(dump(values))")
        }
    }
}

//        let gLevelModel = GradeLevelModel(id:"123" , name: "mock")
//
//        guard let latitudeString = json["latitude"] as? String,
//            let longitudeString = json["longitude"] as? String
//            else {
//                return nil
//        }
//
//        guard let totalPriceString = json["totalPrice"] as? String else {
//            return nil
//        }
//

//
//        // optionals
//        let imageURL = json["imageURL"] as? String
//        let thumbImageURL = json["thumbImageURL"] as? String
//        let fundURL = json["fundURL"] as? String
//
//        let synopsisString = json["synopsis"] as? String
//
//        // process facets
//        return ProposalDataModel(
//            id:id,
//            title: title,
//            teacherID: teacherID,
//            teacherName:teacherName,
//            schoolName: schoolName,
//            state:state,
//            city:city,
//            costToComplete:costToComplete,
//            numDonors:numDonors,
//            percentFunded:percentFunded,
//            proposalURL:proposalURL,
//            fulfillmentTrailer:fulfillmentTrailer,
//            fundingStatus:fundingStatus,
//            gradeLevel: gLevelModel,
//            imageURL : imageURL,
//            latitude:latitudeString,
//            longitude:longitudeString,
//            thumbImageURL: thumbImageURL,
//            povertyLevel:povertyLevel,
//            schoolUrl:schoolUrl,
//            extractedSchoolID:extractedSchoolID,
//            totalPrice: totalPriceString,
//            zip:"zip",
//            expirationDate: expDate,
//            freeShipping: false,
//            fundURL: fundURL,
//            shortDescription:shortDescription,
//            synopsis: synopsisString
//        )
//    }
//}


//        let name = try? values.decode(String.self, forKey: CodingKeys.name)
//        let preferedColumns = try? values.decode(Int.self, forKey: .preferedColumns)
//        let preferedRows = try? values.decode(Int.self, forKey: .preferedColumns)
//        let score = try? values.decode(GameScore.self, forKey: .score)
//        let board = try? values.decode(Array<T>.self, forKey: .board)
//
//        if let name = name,
//            let preferedColumns = preferedColumns ,
//            let preferedRows = preferedRows,
//            let score = score,
//            let board = board
//        {
//            self.name = name
//            self.numberOfPreferedColumnsForBoard = preferedColumns
//            self.numberOfPreferedRowsForBoard = preferedRows
//            self.score = score
//            self.board = board
//        } else {
//            throw CodingError.decoding("Decoding Error: \(dump(values))")
//        }
