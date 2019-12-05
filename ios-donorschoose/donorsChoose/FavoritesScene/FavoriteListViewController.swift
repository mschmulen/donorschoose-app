
import UIKit
import FontAwesome

public class FavoriteListViewController: UITableViewController {
    
    var selectFavorite: ((Identifier) -> Void)?
    var deleteFavorite: ((Identifier) -> Void)?
    
    var viewData:ViewData?
    var items: [WatchItemProtocol] = []
    
    var sections:[Section] = [Section]()
    var favorites:[Row] = [Row]()
    
    @IBAction func actionAddFavorite(_ sender: AnyObject) {
        let searchModel = ProjectSearchDataModel(type: .keyword, keywordString: "")
        let vc = ProjectSearchViewController(searchModel: searchModel)// , callbackDelegate:self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    enum Row {
        case favorite
        // case proposal
        // case teachers
        // case schools
        // case keywordSearch
        // case locationSearch
        
        var label:String {
            switch self {
            case .favorite: return "favorite"
                // case .proposal: return "Search Projects"
                // case .teachers: return "Search Projects (New)"
                // case .schools: return "Search Schools"
                // case .keywordSearch: return "Search"
                // case .locationSearch: return "Location"
            }
        }
        
        var accessoryType: UITableViewCell.AccessoryType {
            switch self {
            default: return .none
            }
        }
    }
    
    enum Section:Int {
        case proposals
        case teachers
        case schools
        case keywordSearch
        case locationSearch
        
        var label:String {
            switch self {
            case .proposals: return "PROPOSALS"
            case .teachers: return "TEACHERS"
            case .schools: return "SCHOOLS"
            case .keywordSearch: return "SEARCH"
            case .locationSearch: return "LOCATION"
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = FavoritesEmptyBackgroundView(frame: tableView.frame)
        // MAS TODO remove observer
        NotificationCenter.default.addObserver(self, selector: #selector(FavoriteListViewController.refreshFromNotificationEvent), name: NSNotification.Name(rawValue: WatchList.RefreshEventName), object: nil)
        
        let buttonAddFavorite : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(FavoriteListViewController.actionAddFavorite(_:)))
        self.navigationItem.rightBarButtonItem = buttonAddFavorite
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    @objc func refreshFromNotificationEvent() {
        refreshList()
    }
    
    func refreshList() {
        items = WatchList.sharedInstance.allItems()
        if (items.count >= 64) {
            self.navigationItem.rightBarButtonItem!.isEnabled = false
        }
        tableView.reloadData()
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }
        return items.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "WatchListCell")
        
        let item = items[(indexPath as NSIndexPath).row] as WatchItemProtocol
        cell.textLabel?.text =  "\(item.title)"// : \(item.modelID)"
        
        switch item.type {
        case .CUSTOM_SEARCH:
            cell.detailTextLabel?.text = "Custom Search"
        case .PROPOSAL:
            cell.detailTextLabel?.text = "Proposal"
        case .SCHOOL:
            cell.detailTextLabel?.text = "School"
        case .TEACHER:
            cell.detailTextLabel?.text = "Teacher"
        case .UNKNOWN:
            cell.detailTextLabel?.text = "~"
        }
        
        //        if item is WatchItemProposal {
        //            cell.detailTextLabel?.text = "Proposal"
        //        }
        //        else if item is WatchItemTeacher {
        //
        //        }
        //        else if item is WatchItemSchool {
        //        }
        //
        //        else if item is WatchItemCustomSearch {
        //
        //        }
        //        else if item is WatchItemUnknown {
        //            cell.detailTextLabel?.text = "UNKNOWN"
        //        }
        //        else {
        //            cell.detailTextLabel?.text = "UNKNOWN"
        //        }
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewData = viewData else { return }
        
        let item = items[(indexPath as NSIndexPath).row]
        if item is WatchItemProposal {
            let vc = ProposalDetailViewController(apiConfig:viewData.apiConfig, proposalID: items[(indexPath as NSIndexPath).row].modelID)
            
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
            let vc = SchoolDetailViewController(schoolID: item.modelID, schoolName: item.title, schoolCity: nil)
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            }
            else {
                self.present(vc, animated: true, completion:nil)
            }
        }
        else if item is WatchItemCustomSearch {
            
            if let vc = UIStoryboard(name: "Project", bundle: Bundle.main).instantiateInitialViewController() as? ProjectTableViewController {
                vc.viewData = ProjectTableViewController.ViewData(initalSearchDataModel: ProjectSearchDataModel(type: .keyword, keywordString: item.title),viewConfig: ProjectTableViewController.ProjectsVCType.customSearch)
                
                if let nav = self.navigationController {
                    nav.pushViewController(vc, animated: true)
                }
                else {
                    self.present(vc, animated: true, completion:nil)
                }
            }
        }
    }
    
    override open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            WatchList.sharedInstance.removeItem(item)
        }
    }
}

extension FavoriteListViewController {
    
    struct ViewData {
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
    }
}


