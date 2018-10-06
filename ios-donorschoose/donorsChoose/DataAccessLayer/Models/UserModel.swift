//
//  UserDataModel.swift
//

import Foundation
//import Firebase

// MAS TODO UserDefaults config

//open class DefaultsKeys {
//    fileprivate init() {}
//}
//
//extension DefaultsKeys {
//  static let launchCount = DefaultsKey<Int>("launchCount")
//  static let didShowIntro = DefaultsKey<Bool>("didShowIntro")
//  static let didShowCustomSearchIntro = DefaultsKey<Bool>("didShowCustomSearchIntro")
//  static let didShowInNeedIntro = DefaultsKey<Bool>("didShowInNeedIntro")
//}

struct LocalUserData: Codable, UserDefaultStorable {
    
    let launchCount:Int
    let didShowIntro:Bool
    let didShowCustomSearchIntro:Bool
    let didShowInNeedIntro:Bool
    
    //    let themeName: String
    //    let backgroundImageURL: URL?
}

open class UserDataModel {
    
    enum UserType {
        case dev
        case anonymous
        
        var label:String {
            switch self {
            case .dev:
                return "dev"
            case .anonymous:
                return "anonymous"
            }
        }
    }
    
    let name:String
    let userType:UserType
    
    //    var localCustomSearch:LocalCustomSearchModel? {
    //        get {
    ////            let localCustomSearchs = LocalCustomSearchModel.read()
    //            return LocalCustomSearchModel.read()
    //        }
    //
    //        set {
    //            localCustomSearch?.write()
    //        }
    //    }
    
    var localUserData:LocalUserData? {
        get {
            return LocalUserData.read()
        }
        
        set {
            localUserData?.write()
        }
    }
    
    // MAS TODO Convert legacy search models to the current one.
    
    //  fileprivate var customSearchModelPList: Plist?
    //  fileprivate let customSearchModelPListName = "userCustomSearchModel"
    
    //  open var customSearchModel: SearchDataModel {
    //      didSet {
    //          customSearchModel.save(customSearchModelPListName)
    //      }
    //  }
    
    
    
    //  open var didShowIntro: Bool = false //{
    //      get { return Defaults[.didShowIntro] }
    //      set { Defaults[.didShowIntro] = newValue }
    //  }
    
    //  open var didShowCustomSearchIntro: Bool = false//{
    //      get { return Defaults[.didShowCustomSearchIntro] }
    //      set { Defaults[.didShowCustomSearchIntro] = newValue }
    //  }
    
    //  open var didShowInNeedIntro: Bool = false//{
    //      get { return Defaults[.didShowInNeedIntro] }
    //      set { Defaults[.didShowInNeedIntro] = newValue }
    //  }
    
    // MAS TODO
    /*
     func loadSearchDataModel(completionBlock: (SearchDataModel?, NSError?) -> Void) {
     
     let syncClient: AWSCognito = AWSCognito.defaultCognito()
     let userSettings: AWSCognitoDataset = syncClient.openOrCreateDataset("user_settings")
     
     userSettings.synchronize().continueWithExceptionCheckingBlock({(result: AnyObject?, error: NSError?) -> Void in
     
     if let error = error {
     completionBlock(nil, error)
     return
     }
     /*
     let titleTextColorString: String? = userSettings.stringForKey(ColorThemeSettingsTitleTextColorKey)
     let titleBarColorString: String? = userSettings.stringForKey(ColorThemeSettingsTitleBarColorKey)
     let backgroundColorString: String? = userSettings.stringForKey(ColorThemeSettingsBackgroundColorKey)
     
     if let titleTextColorString = titleTextColorString,
     titleBarColorString = titleBarColorString,
     backgroundColorString = backgroundColorString {
     self.theme = Theme(titleTextColor: titleTextColorString.toInt32(),
     withTitleBarColor: titleBarColorString.toInt32(),
     withBackgroundColor: backgroundColorString.toInt32())
     } else {
     self.theme = Theme()
     }
     */
     completionBlock(self, error)
     })
     }
     
     */
    
    public init() {
        name = "~"
        userType = .anonymous
        // MAS TODO Removed all references to Google/Fabric Analytics.
//        Analytics.setUserProperty(userType.label, forName: "userType")
        // customSearchModel = SearchDataModel(pListName: customSearchModelPListName)
    }
    
}
