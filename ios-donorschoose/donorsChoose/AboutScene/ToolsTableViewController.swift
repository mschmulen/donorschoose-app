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
        case searchLocation
        
        var label:String {
            switch self {
            case .searchProjects: return "Search by keyword"
            case .searchLocation: return "Search by location"
            case .searchProjectsKeyword: return "Search Projects (New)"
            case .searchSchools: return "Search Schools"
            }
        }
        
        var accessoryType: UITableViewCellAccessoryType {
            switch self {
            default: return .disclosureIndicator
            }
        }
    }
    
    enum Section:Int {
        case searchTools

        var label:String {
            switch self {
            case .searchTools: return "SEARCH TOOLS"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [.searchTools]
        searchTools = [
//            .searchSchools,
            .searchProjects
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
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ( sections[indexPath.section]) {
        case .searchTools:
            
            switch searchTools[indexPath.row] {

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

            case .searchLocation:
                if let vc = UIStoryboard(name: "ProjectSearch", bundle: nil).instantiateInitialViewController() as? ProjectKeywordSearchTableViewController {
                    vc.viewData = ProjectKeywordSearchTableViewController.ViewData()
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .searchProjects: // Legacy
                let searchModel = ProjectSearchDataModel(type: .keyword, keywordString: "")
                let vc = ProjectSearchViewController(searchModel: searchModel)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ToolsTableViewController {
    struct ViewData {
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
    }
}
