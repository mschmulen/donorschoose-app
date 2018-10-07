//
//  ProjectKeywordSearchTableViewController.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

class SearchFooterView : UIView {
    var itemCount:Int = 0
}

class ProjectKeywordSearchTableViewController: UITableViewController {
    
    var viewData:ViewData? = ViewData()
    
    var resultSearchController = UISearchController()
    
    var sections:[Section] = [Section]()
    var data:[Row] = [Row]()
    var filteredData = [Row]()
    let footerView = SearchFooterView()
    
    enum Row {
        case school(name:String)
        var label:String {
            switch self {
            case .school(let name): return "\(name)"
            }
        }
        
        var detail:String? {
            switch self {
            case .school(_) : return "school"
            }
        }
        
        var accessoryType: UITableViewCellAccessoryType {
            switch self {
            default: return .none
            }
        }
        
        var showSegue: String? {
            return nil
            //            switch self {
            //            case .search: return "showSearchSchools"
            //            }
        }
    }
    
    enum Section:Int {
        case schools
        var label:String {
            switch self {
            case .schools: return "Schools"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [.schools]
        data = [
            .school(name:"AA"),
            .school(name:"BB")
        ]
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.definesPresentationContext = true
            controller.searchBar.placeholder = "Search topics, teachers & Schools"
            // controller.searchBar.scopeButtonTitles = ["A", "B", "C"]
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        
        tableView.tableFooterView = footerView
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        default :
            if (self.resultSearchController.isActive) {
                return "active count \(filteredData.count)"
            } else {
                return "not active count \(data.count)"
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        default :
            if (self.resultSearchController.isActive) {
// searchFooter.setNotFiltering()
                footerView.itemCount = filteredData.count
                return filteredData.count
            } else {
//                searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
                footerView.itemCount = filteredData.count
                return data.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectKeywordSearchTableViewCell", for: indexPath)
        switch ( sections[indexPath.section]) {
        default:
            if (self.resultSearchController.isActive) {
                cell.textLabel?.text =  filteredData[indexPath.row].label
                cell.detailTextLabel?.text = filteredData[indexPath.row].detail
            } else {
                cell.textLabel?.text =  data[indexPath.row].label
                cell.detailTextLabel?.text = data[indexPath.row].detail
            }
        }
        return cell
    }
    
}

extension ProjectKeywordSearchTableViewController {
    struct ViewData {
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
    }
}

extension ProjectKeywordSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        filteredData.removeAll(keepingCapacity: false)
        
        let filteredArray = data.filter() { $0.label == searchBarText }
        filteredData = filteredArray
        
        self.tableView.reloadData()
    }
    
}

