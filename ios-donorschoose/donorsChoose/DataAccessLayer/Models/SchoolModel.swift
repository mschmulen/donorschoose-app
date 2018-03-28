//
// SchoolDataModel.swift
//

import Foundation

public struct SchoolModel : Codable {
    let id:String
    let name:String
    let schoolURL:String
    let povertyLevel:String
    let city:String
    let zip:String
    let state:String
    let totalProposals:String
    let proposals: Array<ProposalModel>
}
