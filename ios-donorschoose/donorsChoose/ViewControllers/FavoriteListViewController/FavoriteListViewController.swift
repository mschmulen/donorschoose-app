
import UIKit

// MAS TODO ViewData Protocol
struct FavoriteListViewData { //}: ViewDataProtocol {
  var title:String
  let list:[WatchItemProtocol]
  static var empty: FavoriteListViewData {
    return FavoriteListViewData(title: "~", list: [])
  }
}

// MAS TOOD add + button to create new searches 

public class FavoriteListViewController: UITableViewController {

  var selectFavorite: ((Identifier) -> Void)?
  var deleteFavorite: ((Identifier) -> Void)?

  let user:UserDataModel
  let apiConfig:APIConfig

  var items: [WatchItemProtocol] = []
  
  override open func viewDidLoad() {
    super.viewDidLoad()

    // MAS TODO , just use Watch List not Digoenes
    //NotificationCenter.default.addObserver(self, selector: #selector(WatchListViewController.refreshList), name: NSNotification.Name(rawValue: Diogenes.RefreshEventName), object: nil)
    
    // MAS TODO , use callbacks not notification center
    NotificationCenter.default.addObserver(self, selector: #selector(FavoriteListViewController.refreshFromNotificationEvent), name: NSNotification.Name(rawValue: WatchList.RefreshEventName), object: nil)
  }
  
  override open func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      refreshList()
  }

  func refreshFromNotificationEvent() {
    refreshList()
  }

  func refreshList() {
      items = WatchList.sharedInstance.allItems()
      if (items.count >= 64) {
          self.navigationItem.rightBarButtonItem!.isEnabled = false
      }
      tableView.reloadData()
  }
  
  /// MARK: - init
  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, user:UserDataModel, apiConfig:APIConfig) {
    self.apiConfig = apiConfig
    self.user = user
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public convenience init( user:UserDataModel, apiConfig:APIConfig)
  {
    self.init(nibName: nil, bundle:nil, user:user, apiConfig:apiConfig)
  }
  
  
  override open func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }
  
  override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return items.count
  }
  
  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "WatchListCell")
      
      let item = items[(indexPath as NSIndexPath).row] as WatchItemProtocol
      cell.textLabel?.text =  "\(item.title)"// : \(item.modelID)"
      
      if item is WatchItemProposal {
          cell.detailTextLabel?.text = "Proposal"
      }
      else if item is WatchItemTeacher {
          cell.detailTextLabel?.text = "Teacher"
      }
      else if item is WatchItemSchool {
          cell.detailTextLabel?.text = "School"
      }
      else if item is WatchItemCustomSearch {
          cell.detailTextLabel?.text = "Custom Search"
      }
      else if item is WatchItemUnknown {
          cell.detailTextLabel?.text = "UNKNOWN"
      }
      else {
          cell.detailTextLabel?.text = "UNKNOWN"
      }
      return cell
  }
  
  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let item = items[(indexPath as NSIndexPath).row]
    if item is WatchItemProposal {
      let vc = ProposalDetailViewController(apiConfig:apiConfig, proposalID: items[(indexPath as NSIndexPath).row].modelID)
      
      if let nav = self.navigationController {
          nav.pushViewController(vc, animated: true)
      }
      else {
          self.present(vc, animated: true, completion:nil)
      }
    }
    else if item is WatchItemTeacher {
      let vc = TeacherDetailVC(teacherID: item.modelID, teacherName: item.title)
      
      if let nav = self.navigationController {
          nav.pushViewController(vc, animated: true)
      }
      else {
          self.present(vc, animated: true, completion:nil)
      }
    }
    else if item is WatchItemSchool {
      let vc = SchoolDetailViewController(schoolID: item.modelID, schoolName: item.title)
      if let nav = self.navigationController {
          nav.pushViewController(vc, animated: true)
      }
      else {
          self.present(vc, animated: true, completion:nil)
      }
    }
    else if item is WatchItemCustomSearch {

      let searchModel = SearchDataModel(type: SEARCH_MODEL_TYPE.keyword, keywordString: item.title)
      
      let vc = ProposalListViewController(user: self.user, projectVCType: ProposalListViewController.PROJECTS_VC_TYPE.static, apiConfig:apiConfig, searchModel: searchModel)
      
      if let nav = self.navigationController {
          nav.pushViewController(vc, animated: true)
      }
      else {
          self.present(vc, animated: true, completion:nil)
      }
    }
  }
  
  override open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }
  
  override open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let item = items.remove(at: (indexPath as NSIndexPath).row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      WatchList.sharedInstance.removeItem(item)
    }
  }

}

extension FavoriteListViewController {

  public static func factoryNav(user:UserDataModel, apiConfig:APIConfig ) -> UINavigationController {

    let title = "Favorites"
    let vm = FavoriteListViewModel()
    let vc = FavoriteListViewController(user:user, apiConfig:apiConfig)

//    vc.observe(vm.viewData)
//    vc.updateSearch = { searchString in
//      vm.fetchProducts(searchString: searchString)
//    }

    vc.selectFavorite = { id in
      vm.selectFavorite(id:id)
    }
    
    vc.deleteFavorite = { id in
      vm.deleteFavorite(id:id)
    }

    let nvc = UINavigationController(rootViewController: vc)
    nvc.tabBarItem = UITabBarItem(title: title, image: nil, tag:4)
    nvc.tabBarItem.setFAIcon(FAType.faShoppingCart)
    vc.title = title
    return nvc
  }
  
}

