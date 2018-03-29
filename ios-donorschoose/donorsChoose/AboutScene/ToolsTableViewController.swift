//
//  SchoolToolsTableViewController.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

class ToolsTableViewController: UITableViewController {

    var viewData:ViewData? = ViewData()
    
    var sections:[Section] = [Section]()
    var searchTools:[Row] = [Row]()
    
    enum Row {
        case searchProjects
        case searchProjectsKeyword
        case searchSchools
        
        var label:String {
            switch self {
            case .searchProjects: return "Search Projects"
            case .searchProjectsKeyword: return "Search Projects (New)"
            case .searchSchools: return "Search Schools"
            }
        }
        
        var accessoryType: UITableViewCellAccessoryType {
            switch self {
            default: return .disclosureIndicator
            }
        }
        
//        var showSegue: String? {
//            switch self {
//            case .searchProjects: return "showSearchProjects"
//            case .searchSchools: return "showSearchSchools"
//            case .searchProjectsKeyword: return "search"
//            case .search: return "showSearchSchools"
//            }
//        }
        
    }
    
    enum Section:Int {
        case searchTools
//        case stats
//        case messages
//        case proposals
        
        var label:String {
            switch self {
            case .searchTools: return "SEARCH TOOLS"
//            case .stats: return "STATS"
//            case .messages: return "MESSAGES"
//            case .proposals: return "PROPOSALS"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [.searchTools]
        searchTools = [
//            .searchSchools,
            .searchProjects
//            .searchProjectsKeyword
        ]
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .searchTools : return searchTools.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolToolsTableViewCell", for: indexPath)
        switch ( sections[indexPath.section]) {
            case .searchTools:
                cell.textLabel?.text =  searchTools[indexPath.row].label
                // cell.detailTextLabel?.text = tools[indexPath.row].detail
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ( sections[indexPath.section]) {
        case .searchTools:
            
            switch searchTools[indexPath.row] {
//            case .search(let name):
//                if let vc = UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController() as? SchoolSearchTableViewController {
//                    vc.viewData = SchoolSearchTableViewController.ViewData()
//                    // navigationController?.show(vc, sender: self)
//                    navigationController?.pushViewController(vc, animated: true)
////                    self.present(vc, animated: true, completion: nil)
//                }
            case .searchSchools:
                if let vc = UIStoryboard(name: "SchoolSearch", bundle: nil).instantiateInitialViewController() as? SchoolSearchTableViewController {
                    vc.viewData = SchoolSearchTableViewController.ViewData()
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .searchProjectsKeyword:
                if let vc = UIStoryboard(name: "ProjectSearch", bundle: nil).instantiateInitialViewController() as? ProjectKeywordSearchTableViewController {
                    vc.viewData = ProjectKeywordSearchTableViewController.ViewData()
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .searchProjects: // Legacy
                let searchModel = ProjectSearchDataModel(type: .keyword, keywordString: "")
                let vc = ProjectSearchViewController(searchModel: searchModel , callbackDelegate:self)
                navigationController?.pushViewController(vc, animated: true)
                // self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? SchoolSearchTableViewController {
//            vc.viewData = SchoolSearchTableViewController.ViewData()
//            print( "configure School Search")
//        }
//    }

}

extension ToolsTableViewController : ProjectSearchDelegate {
    public func searchUpdate( _ newSearchModel: ProjectSearchDataModel ) {
        let searchModel = newSearchModel
        print( "searchModel \(searchModel.keywords)")
//        print( "searchModel \(searchModel.subject1)")
        print( "searchModel \(searchModel.type.rawValue)")
        print( "searchModel \(searchModel.sortOption.pickerLabel)")
//        fetchData()
    }
}

extension ToolsTableViewController {
    struct ViewData {
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
    }
}
