//
//  UserDefaultStorage.swift
//  donorsChoose
//
//  Created by Matthew Schmulen on 12/9/19.
//  Copyright © 2019 jumptack. All rights reserved.
//

import Foundation

/**
Usage:
    var storage = Storage()
    storage.isFirstLaunch = true
    print(storage.isFirstLaunch) // true
*/

/**
Usage with observing:
 
 var storage = Storage()
 var observation = storage.$isFirstLaunch.observe { old, new in
     print(old, new)
 }
 storage.isFirstLaunch = false
 
*/

struct AppUserDefaultStorage {
    
    @UserDefault(key: .isFirstLaunch)
    var isFirstLaunch: Bool
    
}


