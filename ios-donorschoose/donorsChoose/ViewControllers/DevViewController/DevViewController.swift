// DevViewController.swift

import UIKit

protocol StaticTableViewRowEnum {
  func title() -> String
  func cellID() -> String
}

open class DevViewController: UIViewController {

  // MARK: - IBOutlet IBAction
  @IBAction func actionTestOpen(_ sender: AnyObject) {

    let openURLString = "donorschoose"
    if let url:URL = URL(string: openURLString) {
      UIApplication.shared.openURL(url)
    }
  }

  @IBAction func actionShowNotificationProposal(_ sender: AnyObject) {
    let proposalID = "2156985"
    topNavController.loadAndShowProposal( proposalID )
  }

  @IBOutlet weak var tableView: UITableView!

  typealias RowModel = (String, (_ vc:DevViewController)->() )

  enum TV_STATIC_SECTION : Int, StaticTableViewRowEnum {

    case section_A = 0
    case section_B = 1
    case section_C = 2

    static func sectionsInTableView() -> [TV_STATIC_SECTION] {
      return [section_A, section_B, section_C]
    }

    func dataInSection() -> [RowModel] {

      let apiConfig = APIConfig()

      switch self {
      case .section_A:
        return [
          ("Proposal DetailVC", { vc in
            let detailVC = ProposalDetailViewController(apiConfig:apiConfig, proposalID: "123")
            vc.navigationController?.pushViewController(detailVC, animated: true)
          }),
          ("Teacher DetailVC", { vc in
            let detailVC = TeacherDetailVC(teacherID: "123", teacherName: "mrs yack")
            vc.navigationController?.pushViewController(detailVC, animated: true)
          }),
          ("School DetailVC", { vc in
            let detailVC = SchoolDetailViewController(schoolID: "1234", schoolName: "Shool Name")
            vc.navigationController?.pushViewController(detailVC, animated: true)
          })
        ]

      case .section_B:
        return [
          ("Diogenes", { vc in
            //  MAS TODO, replace DigoeneseViewController with WatchListViewController
            //Diogenes View Controller
            let watchDebugVC = WatchListDebugViewController()
            //let nvcDiogenes = UINavigationController(rootViewController: dioVC)
            vc.navigationController?.pushViewController(watchDebugVC, animated: true)
          }),

          ("StatsViewController", { vc in
            //Diogenes View Controller
            let newVC = StatsViewController(data: "data")
            //let nvcDiogenes = UINavigationController(rootViewController: dioVC)
            vc.navigationController?.pushViewController(newVC, animated: true)
          })

        ]
      case .section_C:
        return [
          ("proposal notification", {  vc in
            //DevViewController.actionShowNotificationProposal(self)
            //actionShowNotificationProposal
            // MAS TODO replace Diogenese With Watch list
            //#selector(DevViewController.actionShowNotificationProposal)
          }),
          ("error notification", {  vc in

            let notificationVC = NotificationViewController(title: "Location Error", message: "Location Services are not enabled, please enable Location services for the donorsChoose app in the system settings")
            //dim(.In, alpha: dimLevel, speed: dimSpeed)
            vc.present(notificationVC, animated: true) { }

          })
        ]
      }
    }

    func numberOfRowsInSection() -> Int {
      return self.dataInSection().count
    }

    func heightForHeaderInSection() -> CGFloat {
      switch self {
      case .section_A, .section_B, .section_C:
        return 35
      }
    }

    func heightForRowAtIndexPath() -> CGFloat {
      switch self {
      case .section_A, .section_B, .section_C:
        return 55
      }
    }

    func title() -> String {
      switch self {
      case .section_A: return NSLocalizedString("ViewControllers", comment:"").uppercased()
      case .section_B: return NSLocalizedString("Services", comment:"").uppercased()
      case .section_C: return NSLocalizedString("Alerts", comment:"").uppercased()
      }
    }

    func cellID() -> String {
      switch self {
      case .section_A: return "SECTION_A_CEllID"
      case .section_B: return "SECTION_B_CEllID"
      case .section_C: return "SECTION_C_CEllID"
      }
    }

    func cellTitleForIndexRow(_ index:Int) -> String {
      switch self {
      case .section_A:
        return "\(index)"
      case .section_B:
        return "\(index)"
      case .section_C:
        return "\(index)"
      }
    }

  }// end enum TV_STATIC_SECTION

  // MARK: - properties
  weak var topNavController:TopNavViewController!

  let data:String = "Yack"
  //let cellIdentifier = "DevViewCell"

  // MARK: - methods

  // MARK: - VCLifeCycle
  override open func viewDidLoad() {
    super.viewDidLoad()
    tableView.reloadData()
  }

  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - init

  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, topNav:TopNavViewController ) {
    topNavController = topNav
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  public convenience init( topNav:TopNavViewController )
  {
    self.init(nibName: "DevViewController", bundle: Bundle(for: DevViewController.self) , topNav: topNav )
  }
}

// MARK: - UITableViewDataSource methods
extension DevViewController : UITableViewDataSource {

  public func numberOfSections(in tableView: UITableView) -> Int {
    //return 1
    return TV_STATIC_SECTION.sectionsInTableView().count
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return tableData.count
    let section = TV_STATIC_SECTION.sectionsInTableView()[section]
    return section.numberOfRowsInSection()
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let section = TV_STATIC_SECTION.sectionsInTableView()[(indexPath as NSIndexPath).section]

    switch (section) {

    case .section_A:
      if let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID()) {
        cell.textLabel?.text = section.cellTitleForIndexRow((indexPath as NSIndexPath).row)

        return cell
      }
      else {
        let tvc = UITableViewCell()
        tvc.textLabel?.text = section.dataInSection()[(indexPath as NSIndexPath).row].0
        return tvc
      }

    case .section_B, .section_C:
      let tvc = UITableViewCell()
      tvc.textLabel?.text = section.dataInSection()[(indexPath as NSIndexPath).row].0
      return tvc
    }
  }
}

// MARK: - UITableViewDelegate methods
extension DevViewController : UITableViewDelegate {

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let section = TV_STATIC_SECTION.sectionsInTableView()[(indexPath as NSIndexPath).section]
    section.dataInSection()[(indexPath as NSIndexPath).row].1(self)
  }

  public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let label: UILabel = UILabel(frame: CGRect(x: 15, y: 6, width: 320, height: 20))

    label.text = TV_STATIC_SECTION.sectionsInTableView()[section].title()
    label.textColor = UIColor.white

    let header: UIView = UIView()
    header.backgroundColor = UIColor.darkGray
    header.addSubview(label)

    return header
  }

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return TV_STATIC_SECTION.sectionsInTableView()[section].heightForHeaderInSection()
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    let section = TV_STATIC_SECTION.sectionsInTableView()[(indexPath as NSIndexPath).section]
    return section.heightForRowAtIndexPath()
  }

}

