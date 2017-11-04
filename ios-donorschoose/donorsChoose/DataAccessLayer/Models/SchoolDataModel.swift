//
// SchoolDataModel.swift
//

import Foundation

public struct SchoolDataModel {
    let id: String
    let name: String
    let schoolURL: String
    let povertyLevel:String
    let city:String
    let zip:String
    let state:String
    let totalProposals:String
    
    let proposals:[ProposalDataModel]
    
    init( id:String,
          name:String,
          schoolURL:String,
          povertyLevel:String,
          city:String,
          state:String,
          zip:String,
          totalProposals:String,
          proposals:[ProposalDataModel]
        ) {
        
        self.id = id
        self.name = name
        self.schoolURL = schoolURL
        self.povertyLevel = povertyLevel
        self.city = city
        self.zip = zip
        self.state = state
        self.totalProposals = totalProposals
        
        self.proposals = proposals
        
    }
    
}

extension SchoolDataModel: JSONParser {
    
    static func obtainModel(from json: JSONObjectBase) -> SchoolDataModel? {
        
        guard let id = json["id"] as? String,
            let name = json["name"] as? String,
            let schoolURL = json["schoolURL"] as? String,
            let povertyLevel = json["povertyLevel"] as? String,
            let city = json["city"] as? String,
            let state = json["state"] as? String,
            let zip = json["zip"] as? String,
            let totalProposals = json["totalProposals"] as? String
            else {
                return nil
        }
        
        var proposals = [ProposalDataModel]()
        if let proposalList = json["proposals"] as? [AnyObject] {
            for proposal in proposalList {
                if let m = ProposalDataModel.obtainModel(from: proposal) {
                    proposals.append( m )
                }
            }
        }
        
        return SchoolDataModel(id: id, name: name, schoolURL: schoolURL, povertyLevel: povertyLevel, city: city, state: state,zip:zip, totalProposals:totalProposals, proposals:proposals
        )
        
    }
}

