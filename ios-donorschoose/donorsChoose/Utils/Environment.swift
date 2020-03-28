//
//  Environment.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import Foundation

import Foundation

#if DEBUG
var env: Environment = .production
#else
var env: Environment = .production
#endif

enum Environment {
    case dev
    case production
    
    var displayString: String {
        switch ( self ) {
        case .dev: return "dev"
        case .production: return "production"
        }
    }
    
    func log(_ message: String) {
        switch ( self ) {
        case .dev: print( message)
        default: break
        }
    }
}
