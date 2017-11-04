//
//  UserDataModel.swift
//
import Foundation

extension DefaultsKeys {
  static let launchCount = DefaultsKey<Int>("launchCount")
  static let didShowIntro = DefaultsKey<Bool>("didShowIntro")
  static let didShowCustomSearchIntro = DefaultsKey<Bool>("didShowCustomSearchIntro")
  static let didShowInNeedIntro = DefaultsKey<Bool>("didShowInNeedIntro")
}

open class UserDataModel {
    
  fileprivate var customSearchModelPList: Plist?
  
  fileprivate let customSearchModelPListName = "userCustomSearchModel"
  
  open var customSearchModel: SearchDataModel {
      didSet {
          customSearchModel.save(customSearchModelPListName)
      }
  }
  
  open var didShowIntro: Bool {
      get { return Defaults[.didShowIntro] }
      set { Defaults[.didShowIntro] = newValue }
  }
  
  open var didShowCustomSearchIntro: Bool {
      get { return Defaults[.didShowCustomSearchIntro] }
      set { Defaults[.didShowCustomSearchIntro] = newValue }
  }
  
  open var didShowInNeedIntro: Bool {
      get { return Defaults[.didShowInNeedIntro] }
      set { Defaults[.didShowInNeedIntro] = newValue }
  }

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
    customSearchModel = SearchDataModel(pListName: customSearchModelPListName)
  }
  
}
