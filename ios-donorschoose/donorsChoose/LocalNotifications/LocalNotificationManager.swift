//
//  LocalNotificationManager.swift
//  donorsChoose
//

import Foundation
import UserNotifications
import CoreLocation

// https://useyourloaf.com/blog/local-notifications-with-ios-10/

@objc class LocalNotificationManager : NSObject {
    
    private enum AppLocalNotification : String {
        case projectEndingSoon = "projectEndingSoon"
        case projectsNearMe = "projectsNearMe"
        case teacherCheckIn = "teacherCheckin"
        case schoolCheckIn = "schoolCheckIn"
    }
    
    private static var activeNotifications:[AppLocalNotification] = [ ] //.projectsNearYou, .teacherCheckIn, .schoolCheckIn]
    
    @objc public class func scheduleCalendarNotificationProjectEndingSoon( projectID:String ) {
        print( "scheduleCalendarNotification for \(AppLocalNotification.projectEndingSoon.rawValue)")
    }
    
    //    @objc public class func unscheduleAllNotifications() {
//        for notification in activeNotifications {
//            unscheduleNotification(key: notification)
//        }
//    }
    

    
    // Mark: Private
    
    private class func unscheduleNotification(key:AppLocalNotification) {
        // NSAssert([NSThread isMainThread], @"Must call UIKit methods from the main thread");
        assert( Thread.isMainThread , "Must call UIKit methods from the main thread" )
        
        //    for (UILocalNotification *lNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        //        if ([[lNotification.userInfo valueForKey:kNotifKey] isEqualToString:dripKey]) {
        //            [[UIApplication sharedApplication] cancelLocalNotification:lNotification];
        //        }
        //    }
        //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:dripKey];
    }
    
    private class func hasSeenLocalNotification(key:AppLocalNotification) -> Bool {
        return (UserDefaults.standard.object(forKey: key.rawValue) != nil)
    }
    
    private class func isLocalNotificationScheduled( key: AppLocalNotification ) -> Bool {
        // MAS TODO dead code
//        var notificationScheduled = false
        
//        guard let scheduledLocalNotifications = UIApplication.shared.scheduledLocalNotifications else { return dripScheduled }
//
//        for lNotification in scheduledLocalNotifications {
//            // if ([[lNotification.userInfo valueForKey:kNotifKey] isEqualToString:dripKey]) {
//            if let notificationInfo = lNotification.userInfo?[kNotifKey] as? String, notificationInfo == key.rawValue {
//                dripScheduled = true
//            }
//        }
//        return notificationScheduled
        return false
    }
    
    private class func scheduleNotification( key: AppLocalNotification, startIntervalForTesting:TimeInterval ) {
        unscheduleNotification( key: key)
    }
    

    // Util
    private class func checkAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
    }
    
    private class func requestAuthorization() {
        // badge, sound, alert, carPlay
        let options: UNAuthorizationOptions = [.alert, .sound];
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }
}

