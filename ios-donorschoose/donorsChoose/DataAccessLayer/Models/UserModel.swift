//
//  UserDataModel.swift
//

import Foundation

open class UserDataModel {
    
    enum UserType {
        case dev
        case anonymous
        
        var label: String {
            switch self {
            case .dev:
                return "dev"
            case .anonymous:
                return "anonymous"
            }
        }
    }
    
    let name: String
    let userType: UserType
    
    public init() {
        name = "~"
        userType = .anonymous
    }
    
}
