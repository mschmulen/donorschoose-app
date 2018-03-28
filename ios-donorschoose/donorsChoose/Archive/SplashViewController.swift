
import UIKit

open class SplashViewController: UIViewController {
    
    var selectProjectsThatInspireYou: (() -> Void)?
    var selectProjectsThatNeedHelp: (() -> Void)?
    var selectAbout: (() -> Void)?
    var selectStats: (() -> Void)?
    
    let apiConfig = APIConfig()
    var dataAPI:DonorPageDataAPIProtocol?
    
    var viewData:ViewData? = nil {
        didSet {
            if let viewData = viewData {
                
                DispatchQueue.main.async {
                    self.labelStudentsHelped.text = "Students Reached: \(viewData.model.studentsReached)"
                    self.labelStudentsHelped.isHidden = false
                    
                    self.labelSchoolsHelped.text = "Schools Helped: \(viewData.model.numSchools)"
                    self.labelSchoolsHelped.isHidden = false
                    
                    self.labelNumberOfDoners.text = "Number of Donors: \(viewData.model.numDonors)"
                    self.labelNumberOfDoners.isHidden = false
                    
                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = .currency
                    if let amount = Float(viewData.model.amountDonated) as NSNumber?,
                        let amountString = formatter.string(from: amount) {
                        self.labelTotalDonations.text  = "Total Donations: \(amountString)"
                        self.labelTotalDonations.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var labelVersion: UILabel!
    
    @IBOutlet weak var labelStudentsHelped: UILabel! {
        didSet {
            labelStudentsHelped.isHidden = true
        }
    }
    @IBOutlet weak var labelSchoolsHelped: UILabel! {
        didSet {
            labelSchoolsHelped.isHidden = true
        }
    }
    @IBOutlet weak var labelNumberOfDoners: UILabel! {
        didSet {
            labelNumberOfDoners.isHidden = true
        }
    }
    @IBOutlet weak var labelTotalDonations: UILabel!{
        didSet {
            labelTotalDonations.isHidden = true
        }
    }
    
      @IBOutlet weak var statCardSupporters: StatView!
    
      @IBOutlet weak var statCardStudentsReached: StatView!
    
      @IBOutlet weak var statCardProjectsFunded: StatView!
    
    @IBAction func actionChooseAProjectThatInspires(_ sender: AnyObject) {
        // let vc = SearchResultsViewController()
        //self.presentViewController(vc, animated: true, completion: nil)
        
        // MAS TODO
        
        /*
         // Show the customized search option
         if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
         if let tabbarController = appDelegate.window?.rootViewController as? UITabBarController {
         tabbarController.selectedIndex = 2
         }
         }
         */
    }
    
    @IBAction func actionChooseAProjectThatNeedsYourHelp(_ sender: AnyObject) {
        
        /*
         if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
         if let tabbarController = appDelegate.window?.rootViewController as? UITabBarController {
         tabbarController.selectedIndex = 1
         }
         }
         */
    }
    
    @IBAction func actionShowMetrics(_ sender: AnyObject) {
        let vc = StatsViewController(data: "yack")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionShowAbout(_ sender: AnyObject) {
        let vc = AboutInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - properties
    let dataURL:URL?
    
    // MARK: - methods
    
    // MARK: - VCLifeCycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //analytics
        // this cannot be called from the SplashViewController
        //viewDidLoadEvent(String(self))
        
        dataAPI = DonorPageDataAPI(config: apiConfig, user: "matt", delegate: self)
        dataAPI?.getStats(apiConfig.givingPageID)

        
        //configure the stat cards
//        statCardSupporters.currentStat = StatView.Stat.supporters
//        statCardStudentsReached.currentStat = StatView.Stat.studentsReached
//        statCardProjectsFunded.currentStat = StatView.Stat.projectsFunded
        
        if let shortBundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        {
            labelVersion.text = "\(shortBundleVersion)" //"v1.11"
        }
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - init
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dataURL:URL?) {
        self.dataURL = dataURL
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( dataURL:URL? = nil)
    {
        self.init(nibName: "SplashViewController", bundle: Bundle(for: SplashViewController.self), dataURL:dataURL )
    }
    
}

extension SplashViewController : DonorPageDataAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: DonorPageDataAPIProtocol, didChangeData data:DonorPageDataModel?, error:APIError? ) {
        
        if let someError = error {
            if let alertVC = AlertFactory.AlertFromError(someError) {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        else {
            if let dataModel = data {
                self.viewData = ViewData(model: dataModel)
            }
        }
    }
}

extension SplashViewController {
    struct ViewData {
        let model:DonorPageDataModel
    }
}


extension SplashViewController {
    
    public static func factoryNav() -> UINavigationController {
        
        let title = "About"
        let vc = SplashViewController()
        let nvc = UINavigationController(rootViewController: vc)
        
        let tabImage = UIImage.fontAwesomeIcon(name: .home, textColor: .blue, size: CGSize(width: 35, height: 35))
        nvc.tabBarItem = UITabBarItem(title: title, image: tabImage, tag: 1)
        
        vc.title = title
        
        // MAS TODO Cleanup
        vc.selectProjectsThatInspireYou = {
        }
        vc.selectProjectsThatNeedHelp = {
        }
        vc.selectAbout = {
        }
        vc.selectStats = {
        }
        
        return nvc
    }
}
