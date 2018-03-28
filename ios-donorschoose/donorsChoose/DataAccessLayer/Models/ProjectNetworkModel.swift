//
//  ProjectNetworkModel.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import Foundation

public struct ProjectNetworkModel : Codable {
    
    let index:Int
    let max:Int
    let proposals:[ProposalModel]
    let searchTerms:String
    let searchURL:URL
    
    let totalProposals:Int

    enum CodingError: Error {
        case decoding(String)
    }
    
    public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        proposals = try values.decode([ProposalModel].self, forKey: .proposals)
        searchTerms = try values.decode(String.self, forKey: .searchTerms)
        searchURL = try values.decode(URL.self, forKey: .searchURL)
        
        // guard let tpInt = Int( try values.decode(String.self, forKey: .totalProposals) ) else { }
        index = Int( try values.decode(String.self, forKey: .index) ) ?? 0
        max = Int( try values.decode(String.self, forKey: .max) ) ?? 100
        totalProposals = Int( try values.decode(String.self, forKey: .totalProposals) ) ?? 100
    }
}

