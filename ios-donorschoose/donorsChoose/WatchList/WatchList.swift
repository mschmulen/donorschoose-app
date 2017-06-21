//  WatchList.swift

import UIKit

// MAS TODO , lock down public and prive accessors
public class WatchList {

  public static let RefreshEventName = "WatchRefreshEvent"

  // singleton
  class var sharedInstance : WatchList {
    struct Static {
      static let instance : WatchList = WatchList()
    }
    return Static.instance
  }

  fileprivate let ITEMS_KEY = "WatchItems"

  func allItems() -> [WatchItemProtocol] {

    let todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
    let items = Array(todoDictionary.values)

    return items.map({
      let dictItem = $0 as! [String:Any]
      if let itemTypeString = dictItem["type"] as? String {

        let itemType = WatchItemType(stringLiteral: itemTypeString )
        switch ( itemType ) {
        case .PROPOSAL:
          return WatchItemProposal(
            title: dictItem["title"] as! String,
            modelID: dictItem["modelID"] as! String,
            UUID: dictItem["UUID"] as! String!,
            deadline: dictItem["deadline"] as? Date)
        case .TEACHER:
          return WatchItemTeacher(
            title: dictItem["title"] as! String,
            modelID: dictItem["modelID"] as! String,
            UUID: dictItem["UUID"] as! String! )
        case .SCHOOL:
          return WatchItemSchool(
            title: dictItem["title"] as! String,
            modelID: dictItem["modelID"] as! String,
            UUID: dictItem["UUID"] as! String! )
        case .CUSTOM_SEARCH :
          return WatchItemCustomSearch(
            title: dictItem["title"] as! String,
            modelID: dictItem["modelID"] as! String,
            searchString: dictItem["searchString"] as! String! )
        case .UNKNOWN :
          return WatchItemUnknown(
            title: dictItem["title"] as! String,
            modelID: dictItem["modelID"] as! String,
            UUID: dictItem["UUID"] as! String!)
        }
      }
      else {
        return WatchItemUnknown(
          title: dictItem["title"] as! String,
          modelID: dictItem["modelID"] as! String,
          UUID: dictItem["UUID"] as! String!)
      }
    })

    // MAS TODO sort based on deadline
    /*
     }).sort({(left: WatchItemProtocol, right:WatchItemProtocol) -> Bool in
     (left.deadline!.compare(right.deadline!) == .OrderedAscending)
     })
    */
  }

  func addItem(_ item: WatchItemProtocol, intrestType: WatchItemEventSourceType) {

    // first check and see if the item already eists
    if doesExistInItemDictionary( item ) == true {
      return
    }

    // persist a representation of this todo item in NSUserDefaults
    var itemDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)

    // store NSData representation of todo item in dictionary with UUID as key
      // MAS TODO Handle deadline if item
      if let insertItem = item as? WatchItemProposal {
          if let insertItemDeadline = insertItem.deadline {
              itemDictionary[item.UUID] = [
                  "type":WatchItemType.PROPOSAL.rawValue,
                  "title": insertItem.title,
                  "modelID": insertItem.modelID,
                  "UUID": insertItem.UUID,
                  "deadline":insertItemDeadline
              ]
          }
      }
      else if let insertItem = item as? WatchItemTeacher{
          itemDictionary[item.UUID] = [
              "type":WatchItemType.TEACHER.rawValue,"title": insertItem.title, "modelID": insertItem.modelID, "UUID": insertItem.UUID
          ]
      }
      else if let insertItem = item as? WatchItemSchool {
          itemDictionary[item.UUID] = [
              "type": WatchItemType.SCHOOL.rawValue,"title": insertItem.title, "modelID": insertItem.modelID, "UUID": insertItem.UUID
          ]
      }
      else if let insertItem = item as? WatchItemCustomSearch {
          itemDictionary[item.UUID] = ["type": WatchItemType.CUSTOM_SEARCH.rawValue,"title": insertItem.title, "modelID": insertItem.modelID, "UUID": insertItem.UUID , "searchString": insertItem.searchString ]
      }
      else {
          // MAS TOOD Support custom search
//          log( "un supported type")
      }
    UserDefaults.standard.set(itemDictionary, forKey: ITEMS_KEY)
  }

  func removeItem( _ item: WatchItemProtocol ) {
    if var oppertunityItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
      oppertunityItems.removeValue(forKey: item.UUID)
      UserDefaults.standard.set(oppertunityItems, forKey: ITEMS_KEY) // save/overwrite todo item list
    }
    //removeItemFromNotification(item)
  }

  func removeItemFromNotification(_ item: WatchItemProtocol) {

    let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
    // Nothing to remove, so return
    guard scheduledNotifications != nil else {return}

      // loop through notifications
      for notification in scheduledNotifications! {
          if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
              UIApplication.shared.cancelLocalNotification(notification) // there should be a maximum of one match on UUID
              break
          }
      }
      
      if var oppertunityItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
          oppertunityItems.removeValue(forKey: item.UUID)
          UserDefaults.standard.set(oppertunityItems, forKey: ITEMS_KEY) // save/overwrite todo item list
      }
  }

  //comparison functions
  private func isEqual( _ model:SearchDataModel, watchItemDictionary:[String:Any]) -> Bool {

    guard let _ = watchItemDictionary["type"] as? String,
      let _ = watchItemDictionary["title"] as? String,
      let _ = watchItemDictionary["modelID"] as? String,
      let _ = watchItemDictionary["UUID"] as? String
      else
    {
      return false
    }

    // MAS TODO finish comparison for SearchDataModel and Watch Item Dictionary
    return false
  }

  // MAS TODO complete comparison of SearchDataModel withe the WatchItem dictionary
  func doesExistInItemDictionary( _ model:SearchDataModel ) -> Bool {
    if let itemDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY)  {
      for (_, value) in itemDictionary {
        if let watchItemValue = value as? [String:Any] {
          if self.isEqual(model, watchItemDictionary: watchItemValue ) {
            return true
          }
        }
      }
    }
    return false
  }

  func doesExistInItemDictionary( _ watchItem:WatchItemProtocol ) -> Bool {
//    if let itemDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY)  {
//      for (_, value) in itemDictionary {
//        // MAS TODO add isEqual operator
//      }
//    }
    return false
  }

  // MAS TODO pass the struct not the string ...
  func doesExistInItemDictionary( _ modelIDString:String ) -> Bool {
//    if let itemDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY)  {
//      for (_, value) in itemDictionary {
//        // MAS TODO compare first by type
////              if let mID = value["modelID"] as? String {
////               if mID == modelIDString {
////                return true
////               }
////              }
//      }
//    }
    return false
  }

  func removeWatchItemByModelID( _ modelIDString:String ) {
    // MAS TODO Remove WatchItem By Model ID
//        if let itemDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
//            for (_, value) in itemDictionary {
//
//                // MAS TODO Swift 3 broke
//                /*
//                if let mID = value["modelID"] as? String {
//                    if mID == modelIDString {
//                        if let mUUIDString = value["UUID"] as? String {
//                            if var oppertunityItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
//                                oppertunityItems.removeValue(forKey: mUUIDString)
//                                UserDefaults.standard.set(oppertunityItems, forKey: ITEMS_KEY)
//                            }
//                        }
//                    }
//                }
//                */
//            }
//        }
    }
    
    /*
     func addNotificationForWatchItem(item: WatchItemProtocol) {
     
     // create a corresponding local notification
     let notification = UILocalNotification()
     notification.alertBody = "DonorsChoose \"\(item.title)\" has Ended" // text that will be displayed in the notification
     notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
     
     let shortTime = NSDate().dateByAddingTimeInterval(10)
     
     //NSDate *correctDate = [NSDate dateWithTimeInterval:1.0 sinceDate:yourDate]
     
     //when notification will be fired
     // notification.fireDate = item.deadline
     notification.fireDate = shortTime
     
     //notification.soundName = UILocalNotificationDefaultSoundName // play default sound
     
     // assign a unique identifier to the notification so that we can retrieve it later
     notification.userInfo = ["title": item.title, "modelID": item.modelID, "UUID": item.UUID]
     
     UIApplication.sharedApplication().scheduleLocalNotification(notification)
     }
     */
    
    /*
    func doesNotificationExistByModelID( modelID:String ) -> Bool {
   
      let scheduledNotifications: [UILocalNotification]? = UIApplication.sharedApplication().scheduledLocalNotifications
        
        // loop through notifications ...
        for notification in scheduledNotifications! {
            if (notification.userInfo!["modelID"] as! String == modelID) {
                return true
            }
        }
        
        return false
    }//end doesExistByModelID
    */


  // MAS TODO, use a generic with a protocol for the GUID

  //Proposal
  class func addToWatchList( _ model:ProposalDataModel) {
    let itemModel = WatchItemProposal(title: model.title, modelID:  model.id,  UUID: UUID().uuidString, deadline:model.expirationDate)
    WatchList.sharedInstance.addItem(itemModel, intrestType: WatchItemEventSourceType.watchlist_ADD)
  }

  class func removeFromWatchList( _ model:ProposalDataModel) {
    WatchList.sharedInstance.removeWatchItemByModelID(model.id)
  }

  class func doesWatchListItemExist( _ model:ProposalDataModel ) -> Bool {
    return WatchList.sharedInstance.doesExistInItemDictionary(model.id)
  }

  // Teacher
  class func addToWatchList( _ model:TeacherDataModel) {
    let itemModel = WatchItemTeacher(title: model.name, modelID:  model.id,  UUID: UUID().uuidString)
    WatchList.sharedInstance.addItem(itemModel, intrestType: WatchItemEventSourceType.watchlist_ADD)
  }

  class func removeFromWatchList( _ model:TeacherDataModel) {
    WatchList.sharedInstance.removeWatchItemByModelID(model.id)
  }

  class func doesWatchListItemExist( _ model:TeacherDataModel ) -> Bool {
    return WatchList.sharedInstance.doesExistInItemDictionary(model.id)
  }

  // School
  class func addToWatchList( _ model:SchoolDataModel) {
    let itemModel = WatchItemSchool(title: model.name, modelID:  model.id,  UUID: UUID().uuidString)
    WatchList.sharedInstance.addItem(itemModel, intrestType: WatchItemEventSourceType.watchlist_ADD)
  }

  class func removeFromWatchList( _ model:SchoolDataModel) {
    WatchList.sharedInstance.removeWatchItemByModelID(model.id)
  }

  class func doesWatchListItemExist( _ model:SchoolDataModel ) -> Bool {
    return WatchList.sharedInstance.doesExistInItemDictionary(model.id)
  }

  // CustomSearch , MAS TODO
  class func addToWatchList( _ model:SearchDataModel) {
    //model.sortOption
    let itemModel = WatchItemCustomSearch(title: model.keywords, modelID:  model.keywords, searchString: model.keywords)
    //searchSortOption: model.sortOption)
    WatchList.sharedInstance.addItem(itemModel, intrestType: WatchItemEventSourceType.watchlist_ADD)
  }

  class func removeFromWatchList( _ model:SearchDataModel) {
    WatchList.sharedInstance.removeWatchItemByModelID(model.keywords)
  }

  class func doesWatchListItemExist( _ model:SearchDataModel) -> Bool {
    return WatchList.sharedInstance.doesExistInItemDictionary(model)
  }

  public class func registerNotificationSettings(_ application: UIApplication)
  {
    //config the local notifications
    let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge], categories: nil)

    //application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))

    application.registerUserNotificationSettings(notificationSettings)
  }

}


