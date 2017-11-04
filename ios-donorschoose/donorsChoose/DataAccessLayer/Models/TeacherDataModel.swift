//
// TeacherDataModel.swift
//
import Foundation

public struct TeacherDataModel {
    
    let id: String
    let name: String
    let profileURL: String
    let photoURL: String
    let description: String
    let joinedOn:String
    
    let povertyLevel:String?
    let schoolName:String
    let city:String?
    let zip:String
    let state:String?
    let totalProposals:String?
    let donationsTotalCount:String?
    let teacherChallengeId:String?
    let totalFundedProposals:String?
    
    public fileprivate(set) var myRefcount: Int
    
    init( id:String,
          name:String,
          profileURL:String,
          photoURL:String,
          description:String,
          povertyLevel:String?,
          schoolName:String,
          city:String?,
          state:String?,
          zip:String,
          totalProposals:String?,
          donationsTotalCount:String?,
          joinedOn:String,
          teacherChallengeId:String?,
          totalFundedProposals:String?
        ) {
        
        self.id = id
        self.name = name
        self.profileURL = profileURL
        self.photoURL = photoURL
        self.description = description
        
        self.povertyLevel = povertyLevel
        self.schoolName = schoolName
        self.city = city
        self.state = state
        self.zip = zip
        
        self.totalProposals = totalProposals
        self.donationsTotalCount = donationsTotalCount
        self.joinedOn = joinedOn
        
        self.teacherChallengeId = teacherChallengeId
        self.totalFundedProposals = totalFundedProposals
        myRefcount = 0
    }
    
    mutating func increment() { myRefcount += 1 }
}

extension TeacherDataModel: JSONParser {
    
    static func obtainModel(from json: JSONObjectBase) -> TeacherDataModel? {
        
        guard let id = json["id"] as? String,
            let name = json["name"] as? String,
            let profileURL = json["profileURL"] as? String,
            let photoURL = json["photoURL"] as? String,
            let schoolName = json["schoolName"] as? String,
            let city = json["city"] as? String,
            let zip = json["zip"] as? String,
            let joinedOn = json["joinedOn"] as? String,
            let description = json["description"] as? String
            else {
                return nil
        }
        
        let povertyLevel = json["povertyLevel"] as? String
        let state = json["state"] as? String
        let totalProposals = json["totalProposals"] as? String
        let donationsTotalCount = json["donationsTotalCount"] as? String
        let teacherChallengeId = json["teacherChallengeId"] as? String
        let totalFundedProposals:String? = (json["totalFundedProposals"] as? String) ?? ""
        
        return TeacherDataModel(id: id, name: name, profileURL: profileURL , photoURL: photoURL, description: description, povertyLevel: povertyLevel, schoolName: schoolName, city: city, state: state,zip:zip, totalProposals:totalProposals, donationsTotalCount:donationsTotalCount, joinedOn:joinedOn, teacherChallengeId:teacherChallengeId, totalFundedProposals:totalFundedProposals
        )
        
    }
}

