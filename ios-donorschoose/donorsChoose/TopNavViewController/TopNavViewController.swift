//
//  TopNavViewController.swift
//

import UIKit

open class TopNavViewController: UITabBarController {
    
    var viewData:ViewData = ViewData()
    var activity:NSUserActivity?
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
        print("fetch specific proposal")
//        let dataAPI = ProjectAPI(config: viewData.apiConfig,user: "matt", delegate: self)
//        dataAPI.getDataWithProposalID(proposalID)
    }
    
    open func showHighlightProjectID( _ proposal: ProposalModel ){
        let notificationVC = NotificationProposalViewController(title: "Checkout \(proposal.id) ", message: "Top Notification \(proposal.title)  ", proposal: proposal)
        self.present(notificationVC, animated: true)
    }
    
    open static func showAuthChallenge(_ parentVC:UIViewController) {
        // MAS TODO , auth challenge if needed , to support authentication
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
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, userIDString:String, activity:NSUserActivity? ) {
        self.activity = activity
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func injectNav(vc:UIViewController, title:String, image:UIImage) -> UINavigationController {
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem = UITabBarItem(title: title, image: image, tag:4)
        vc.title = title
        return nvc
    }
    
    public convenience init( userIDString:String, activity:NSUserActivity? )
    {
        self.init(nibName: nil, bundle: nil, userIDString:userIDString , activity:activity )
        
        let vcAbout = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController() as? AboutTableViewController
        let vcUrgent = UIStoryboard(name: "Project", bundle: Bundle.main).instantiateInitialViewController() as? ProjectTableViewController
        let vcNearMe = UIStoryboard(name: "Project", bundle: Bundle.main).instantiateInitialViewController() as? ProjectTableViewController
        let vcInspiresMe = UIStoryboard(name: "Project", bundle: Bundle.main).instantiateInitialViewController() as? ProjectTableViewController
        let vcFav = UIStoryboard(name: "Favorites", bundle: Bundle.main).instantiateInitialViewController() as? FavoriteListViewController
        
        vcAbout?.viewData = AboutTableViewController.ViewData(model: nil)
        vcUrgent?.viewData = ProjectTableViewController.ViewData(initalSearchDataModel: SearchDataModel(type: .urgent, keywordString: nil), viewConfig: ProjectTableViewController.ProjectsVCType.inNeed)
        vcNearMe?.viewData = ProjectTableViewController.ViewData(initalSearchDataModel: SearchDataModel( type: .locationLatLong, keywordString: "Near Me" ), viewConfig: ProjectTableViewController.ProjectsVCType.nearMe)
        vcInspiresMe?.viewData = ProjectTableViewController.ViewData(initalSearchDataModel: SearchDataModel(type: .inspiresUser, keywordString: nil), viewConfig: ProjectTableViewController.ProjectsVCType.inspiresME)
        
        vcFav?.viewData = FavoriteListViewController.ViewData()
        
        guard let about = vcAbout,
            let urgent = vcUrgent,
            let fav = vcFav,
            let nearMe = vcNearMe,
            let inspiresMe = vcInspiresMe
            else { return }
        
        let urgentNav = urgent.navWrapper( title:"In Need", image:UIImage.fontAwesomeIcon(name: .hourglass3, textColor: .blue, size: CGSize(width: 35, height: 35)))
        let nearMeNav = nearMe.navWrapper( title:"Near Me", image:UIImage.fontAwesomeIcon(name: .compass, textColor: .blue, size: CGSize(width: 35, height: 35)))
        let inspiresMeNav = inspiresMe.navWrapper( title:"Inspires Me", image:UIImage.fontAwesomeIcon(name: .search, textColor: .blue, size: CGSize(width: 35, height: 35)))
        let favNav = fav.navWrapper( title:"Favorites", image:UIImage.fontAwesomeIcon(name: .heart, textColor: .blue, size: CGSize(width: 35, height: 35)))
        let aboutNav = about.navWrapper( title:"More", image:UIImage.fontAwesomeIcon(name: .home, textColor: .blue, size: CGSize(width: 35, height: 35)))
        
        tabViewControllers = [urgentNav, nearMeNav, inspiresMeNav, favNav, aboutNav]
        self.viewControllers = tabViewControllers
        
        inspiresMe.showFavorites = {
            let favNavIndex = 3
            self.selectedIndex = favNavIndex
        }
        
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
extension TopNavViewController : ProjectAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: ProjectAPIProtocol, didChangeData data:[ProposalModel]?, error:APIError? ) {
        
        if let error = error {
            //MAS TODO Alert Error
            print( "error \(error)")
        }
        else {
            if let newData = data {
                if newData.count > 0 {
                    let model = newData[0]
                    showHighlightProjectID(model)
                }
                else {
                    //MAS TODO Alert Error
                }
            }
        }
        
    }
}

extension TopNavViewController {    
    struct ViewData {
        let apiConfig = APIConfig()
        let devMode = false
        let user = UserDataModel()
    }

}
