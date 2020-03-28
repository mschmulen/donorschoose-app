
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
    // public let freeShipping:Bool
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
        imageURL = try? values.decode(String.self, forKey: .imageURL)
        latitude = try values.decode(String.self, forKey: .latitude)
        longitude = try values.decode(String.self, forKey: .longitude)
        thumbImageURL = try? values.decode(String.self, forKey: .thumbImageURL)
        povertyLevel = try values.decode(String.self, forKey: .povertyLevel)
        schoolUrl = try values.decode(String.self, forKey: .schoolUrl)
        
        totalPrice = try values.decode(String.self, forKey: .totalPrice)
        zip = try values.decode(String.self, forKey: .zip)
        
        fundURL = try? values.decode(String.self, forKey: .fundURL)
        shortDescription = try values.decode(String.self, forKey: .shortDescription)
                
        if let synopsisString = ((try? values.decode(String?.self, forKey: .synopsis)) as String??) {
            synopsis = synopsisString
        } else {
            synopsis = shortDescription
        }
        
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
