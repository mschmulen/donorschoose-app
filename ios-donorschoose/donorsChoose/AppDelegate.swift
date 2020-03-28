//
//  AppDelegate.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 2/13/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

// MAS TODO Analytics
//import AppAnalyticsLegacy

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var topNav: TopNavViewController? = nil
    
    var userInfo:UserDataModel? = UserDataModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MAS TODO Analytics
//        switch appNetworkEnvironment {
//        case .local:
//            AnalyticsService.start(config: AnalyticsServiceConfiguration.defaultLocalConfiguration)
//        case .stage:
//            AnalyticsService.start(config: AnalyticsServiceConfiguration.defaultStageConfiguration)
//        case .prod:
//            AnalyticsService.start(config: AnalyticsServiceConfiguration.defaultProductionConfiguration)
//        }
//
//        _ = AnalyticsService.shared().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let user = userInfo {
            topNav = TopNavViewController(user: user, activity: nil)
        } else  {
            topNav = TopNavViewController(user: UserDataModel(), activity: nil)
        }
        window?.rootViewController = topNav
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
//        AnalyticsService.shared().applicationWillResignActive( application )
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//       AnalyticsService.shared().applicationDidEnterBackground( application )
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//         AnalyticsService.shared().applicationWillEnterForeground( application )
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//         AnalyticsService.shared().applicationDidBecomeActive( application )
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        AnalyticsService.shared().applicationWillTerminate( application )
    }

}

