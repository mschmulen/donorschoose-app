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
    
    private class func scheduleNotificationByTimeInterval( timeInterval:TimeInterval ) {
        // Time interval: Schedule a notification for a number of seconds later. For example to trigger in five minutes ( 300 ) :
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                        repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default
        
        // Scheduling
        let center = UNUserNotificationCenter.current()
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print("UNUserNotificationCenter error \(error)")
            }
        })

    }
    
    private class func scheduleNotificationOnCalendarDay( ) {
        // ---------------------------  > iOS10
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default
        
        //Calendar: Trigger at a specific date and time. The trigger is created using a date components object which makes it easier for certain repeating intervals. To convert a Date to its date components use the current calendar. For example:
        let date = Date(timeIntervalSinceNow: 3600)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        
        // To create the trigger from the date components:
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        
        // Scheduling
        let center = UNUserNotificationCenter.current()
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print( "error \(error)")
            }
        })
    }
    
    private class func scheduleNotificationByCalendarWeekly( ) {
        
        // ---------------------------  > iOS10
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default

        //Calendar: Trigger at a specific date and time. The trigger is created using a date components object which makes it easier for certain repeating intervals. To convert a Date to its date components use the current calendar. For example:
        let date = Date(timeIntervalSinceNow: 3600)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        
        // To create the trigger from the date components:
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        //To create a trigger that repeats at a certain interval use the correct set of date components. For example, to have the notification repeat daily at the same time we need just the hour, minutes and seconds:
//        let triggerDaily = Calendar.current.dateComponents([hour,.minute,.second,], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        
        // To have it repeat weekly at the same time we also need the weekday:
        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        // Scheduling
        let center = UNUserNotificationCenter.current()
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        
    }
}

