
import UIKit

open class SplashViewController: UIViewController {

  var selectProjectsThatInspireYou: (() -> Void)?
  var selectProjectsThatNeedHelp: (() -> Void)?
  var selectAbout: (() -> Void)?
  var selectStats: (() -> Void)?

  @IBOutlet weak var labelVersion: UILabel!

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
    let vc = AboutViewController()
    //self.present(vc, animated: true, completion: nil)
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

    //configure the stat cards
    statCardSupporters.currentStat = StatView.STATVIEW_STAT.supporters
    statCardStudentsReached.currentStat = StatView.STATVIEW_STAT.students_REACHED
    statCardProjectsFunded.currentStat = StatView.STATVIEW_STAT.projects_FUNDED

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

extension SplashViewController {
  
  public static func factoryNav() -> UINavigationController {

    let title = "About"
    let vc = SplashViewController()
    let nvc = UINavigationController(rootViewController: vc)
    nvc.tabBarItem = UITabBarItem(title: title, image: nil, tag: 1)
    nvc.tabBarItem.setFAIcon(FAType.faHome)

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
