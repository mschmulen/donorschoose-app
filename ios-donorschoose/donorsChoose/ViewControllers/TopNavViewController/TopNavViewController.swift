//
//  TopNavViewController.swift
//

import UIKit

open class TopNavViewController: UITabBarController {
    
    var activity:NSUserActivity?
    let apiConfig = APIConfig()
    let devMode = false
    let userIDString:String
    var tabViewControllers = [UIViewController]()
    
    // MAS TODO this will leverage the app routing to correctly display the appropriate tab and viewController
    func startWithActivity( _ activity:NSUserActivity ) {
        //    guard let appRoute = AppRoute.route(activity:activity ) else {
        //      return
        //    }
        //present(appRoute)
    }
    
    open func loadAndShowProposal(_ proposalID:String)
    {
        let dataAPI = ProposalDataAPI(config: apiConfig,user: "matt", delegate: self)
        dataAPI.getDataWithProposalID(proposalID)
    }
    
    open func showHighlightProjectID( _ proposal: ProposalDataModel ){
        let notificationVC = NotificationProposalViewController(title: "Checkout \(proposal.id) ", message: "Top Notification \(proposal.title)  ", proposal: proposal)
        self.present(notificationVC, animated: true)
    }
    
    open static func showAuthChallenge(_ parentVC:UIViewController) {
        
    }
    
    open func authUser() {
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authUser()
        
        // MAS TODO , support first run and show intro experience here
    }
    
    // MARK: – init
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, userIDString:String, activity:NSUserActivity? ) {
        self.userIDString = userIDString
        self.activity = activity
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( userIDString:String, activity:NSUserActivity? )
    {
        self.init(nibName: nil, bundle: nil, userIDString:userIDString , activity:activity )
        
        let user = UserDataModel()
        
        let nvcSplash = SplashViewController.factoryNav()
        let nvcUrget = ProposalListViewController.factoryUrgentNav(user:user, apiConfig:apiConfig)
        let nvcNearMe = ProposalListViewController.factoryNearMe(user: user, apiConfig:apiConfig)
        let nvcInspiresMe = ProposalListViewController.factoryInspiresMe(user: user, apiConfig:apiConfig)
        let nvcFavorites = FavoriteListViewController.factoryNav(user: user, apiConfig:apiConfig)
        
        // Developer tooling
        if devMode == true {
            let devVC = DevViewController(topNav: self)
            let nvcDevVC = UINavigationController(rootViewController: devVC)
            nvcDevVC.tabBarItem = UITabBarItem(title: "Tools", image: nil, tag:4)
            nvcDevVC.tabBarItem.setFAIcon(FAType.faTachometer)
            devVC.title = "Tools"
            
            tabViewControllers = [nvcDevVC , nvcUrget, nvcNearMe, nvcFavorites , nvcInspiresMe, nvcSplash]
            self.viewControllers = tabViewControllers
        }
        else {
            tabViewControllers = [ nvcUrget, nvcNearMe , nvcInspiresMe, nvcFavorites, nvcSplash]
            self.viewControllers = tabViewControllers
        }
        
        //configure the global tint
        UITabBar.appearance().tintColor = UIColor(red: 13, green: 127, blue: 25)
        
        // MAS TODO Consume the activity link if it was initialized with one
        //    guard let userActivity = activity,
        //      let appRoute = AppRoute.route(activity:userActivity ) else {
        //        return
        //    }
        
        // MAS TODO cleen up deeplinking
        //presentRoute(appRoute)
        /*
         if let currentDeepLinkURL = deepLinkURL {
         
         switch ( currentAppDeepLink.type ){
         case .PROJECT:
         window?.rootViewController = splashVC
         case .SCHOOL:
         window?.rootViewController = splashVC
         case .TEACHER:
         window?.rootViewController = splashVC
         //window?.rootViewController = tabBarController
         //appDelegate.window?.addSubview(vc.view)
         }
         
         // reset the deep link
         self.deepLink = nil
         
         }
         */
    }
    
    /*
     func toggleTabBar(showTabBar:Bool) {
     var newFrame = self.tabBar.frame
     newFrame.origin.y = showTabBar ? ScreenHeight - TabBarHeight : ScreenHeight + TabBarHeight
     
     UIView.animateWithDuration(0.3, animations: { () -> Void in
     self.tabBar.frame = newFrame
     })
     }
     */
    
}

// MARK: - ProjectDataAPIDelegate
extension TopNavViewController : ProposalDataAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: ProposalDataAPIProtocol, didChangeData data:[ProposalDataModel]?, error:APIError? ) {
        
        if let error = error {
            print( "error \(error)")
            // MAS TODO Display error
            //          if let alertVC = AlertFactory.AlertFromError(someError) {
            //              self.presentViewController(alertVC, animated: true, completion: nil)
            //          }
        }
        else {
            if let newData = data {
                if newData.count > 0 {
                    let model = newData[0]
                    showHighlightProjectID(model)
                }
                else {
                    //MAS TODO Alert Error
                    //                 if let alertVC = AlertFactory.AlertFromError(someError) {
                    //                 self.presentViewController(alertVC, animated: true, completion: nil)
                    //                 }
                }
            }
        }
        
    }
}
