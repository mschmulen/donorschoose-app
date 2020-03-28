//
//  TestEnvironment.swift
//  donorsChooseUITests
//
//  Created by Matthew Schmulen on 3/28/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

enum AppTestEnvironment {
    case device
    case simulator
}

#if targetEnvironment(simulator)
    let appTestEnvironment = AppTestEnvironment.simulator    // Simulator
#else
    let appTestEnvironment = AppTestEnvironment.device
#endif

