//
//  AppNetworkEnv.swift
//  donorsChoose
//
//  Created by Matthew Schmulen on 12/20/19.
//  Copyright © 2019 jumptack. All rights reserved.
//

import Foundation

var appNetworkEnvironment = AppNetworkEnv.stage
//var appEnv = AppEnv.local

enum AppNetworkEnv {
    case local
    case stage
    case prod
    
    var description:String {
        switch self {
        case .local: return "local"
        case .stage: return "stage"
        case .prod: return "prod"
        }
    }
}

enum AppBuildEnv {
    case release
    case debug
    
    var description:String {
        switch self {
        case .release: return "release"
        case .debug: return "debug"
            
        }
    }
}

#if DEBUG
var appBuildEnvironment = AppBuildEnv.debug
#else
var appBuildEnvironment = AppBuildEnv.release
#endif
