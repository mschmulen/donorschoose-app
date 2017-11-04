//
//  AppDelegate.swift
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var topNav: TopNavViewController? = nil

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    WatchList.registerNotificationSettings( application )

//    let firstRun = true
//    if firstRun == true {
//      let vc = IntroWelcomePageViewController()
//      //      vc.delegate = self
////      self.show(vc, sender: nil)
//      window?.rootViewController = vc
//    }
//    else {
      topNav = TopNavViewController(userIDString: "1111", activity: nil)
      window?.rootViewController = topNav
//    }
    return true
  }
  
  // MAS TODO clean up
//  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//    topNav = TopNavViewController(userIDString: "1111", activity: nil)
//    window?.rootViewController = topNav
//    return true
//  }
//
//  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//    // let info = notification.userInfo
//    // "UUID"
//    // "modelID"
//    // "title"
//
//    // MAS TODO , Verify Digoenes removal
//    //NotificationCenter.default.post(name: Notification.Name(rawValue: Diogenes.RefreshEventName), object: self)
//
//    NotificationCenter.default.post(name: Notification.Name(rawValue: WatchList.RefreshEventName), object: self)
//
//    if let proposalIDString = notification.userInfo?["modelID"] as? String {
//      // tell the app to open  a modal dialog to the notification
//      let modalVC = ProposalDetailViewController(proposalID: proposalIDString)
//      window!.rootViewController?.present(modalVC, animated: true, completion: nil)
//    }
//  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

//    NotificationCenter.default.post(name: Notification.Name(rawValue: WatchList.RefreshEventName), object: self)


  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  //  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
  //
  //    guard let _ = AppRoute.route(activity:userActivity ) else {
  //      return false
  //    }
  //    if let topNav = topNav {
  //      topNav.startWithActivity( userActivity )
  //    }
  //    else {
  //      topNav = TopNavViewController(userIDString: "1111", activity:userActivity )
  //      window?.rootViewController = topNav
  //    }
  //    return true
  //  }

}

