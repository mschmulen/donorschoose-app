//
//  ProjectSearchViewController.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/29/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit
import Firebase

//public protocol ProjectSearchDelegate {
//    func searchUpdate( _ newSearchModel: ProjectSearchDataModel )
//}

open class ProjectSearchViewController: UIViewController {
    
    var viewData:ViewData {
        didSet {
            fetch(viewData.searchModel)
        }
    }
    var dataAPI:ProjectAPIProtocol?
    
    var results:[ProposalModel] = [ProposalModel]()
    
    // fileprivate let callbackDelegate: ProjectSearchDelegate
    
    @IBOutlet weak var tableViewResults: UITableView! {
        didSet {
            tableViewResults.isHidden = true
            tableViewResults.delegate = self
            tableViewResults.dataSource = self
        }
    }
    
    @IBOutlet weak var sortControl: UISegmentedControl! {
        didSet {
            sortControl.removeAllSegments()
            let items = viewData.sortOptions.map({ $0.shortLabel})
            for (index,item) in items.enumerated() {
                sortControl.insertSegment(withTitle: item, at: index, animated: true)
            }
        }
    }
    
    @IBAction func sortChanged(_ sender: UISegmentedControl) {
        var newViewData = ViewData(
            searchModel: ProjectSearchDataModel(
                type: viewData.searchModel.type,
                keywordString: viewData.searchModel.keywords
            )
        )
        newViewData.searchModel.sortOption = viewData.sortOptions[sender.selectedSegmentIndex]
        
        self.viewData = newViewData
    }
    
    @IBOutlet weak var textFieldSearchTopics: UITextField!
    
    @IBAction func actionSaveSearch(_ sender: AnyObject) {
        
        if let newSearchString = textFieldSearchTopics.text {
            
            let newViewData = ViewData(
                searchModel: ProjectSearchDataModel(
                    type: viewData.searchModel.type,
                    keywordString: newSearchString
                )
            )
            self.viewData = newViewData
            
            saveToFavorites()
        }
    }
    
    func fetch(_ searchModel:ProjectSearchDataModel) {
        dataAPI?.getData(searchModel, pageIndex: 0, callback: { (data, error) in
            if let someError = error {
                print( "\(someError)")
            }
            else {
                DispatchQueue.main.async(execute: {
                    self.results = data
                    self.tableViewResults.isHidden = false
                    self.tableViewResults.reloadData()
                    // self.refreshControl?.endRefreshing()
                })
            }
        })
    }
    
    func saveToFavorites() {
        
        guard let searchString = textFieldSearchTopics.text else { return }
        if (searchString.isEmpty) == true { return }
        
        let newViewData = ViewData(
            searchModel: ProjectSearchDataModel(
                type: viewData.searchModel.type,
                keywordString: searchString
            )
        )
        self.viewData = newViewData
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "keywords-\(viewData.searchModel.keywords ?? "")",
            AnalyticsParameterItemName: "actionFavorite",
            AnalyticsParameterContentType: "Search"
            ])
        
        let optionMenu = UIAlertController(title: nil, message: "Add This Search to Favorites: \(searchString) \(viewData.searchModel.sortOption.pickerLabel)", preferredStyle: .actionSheet)
        
        var watchAction: UIAlertAction? = nil
        let doesExist =  WatchList.doesWatchListItemExist(viewData.searchModel)
        if doesExist == true {
            watchAction = UIAlertAction(title: "Remove From My Favorites", style: .default, handler: {
                (alert:UIAlertAction!) -> Void in
                WatchList.removeFromWatchList(self.viewData.searchModel)
            })
        }
        else {
            watchAction = UIAlertAction(title: "Add To My Favorites", style: .default, handler: {
                (alert:UIAlertAction!) -> Void in
                WatchList.addToWatchList( self.viewData.searchModel)
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if let saveAction = watchAction {
            optionMenu.addAction(saveAction)
        }
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        dataAPI = ProjectAPI(config: viewData.apiConfig,user: "matt")
        
        // let buttonSave : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(ProjectSearchViewController.actionSaveSearch(_:)))
        let buttonSave = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ProjectSearchViewController.actionSaveSearch(_:)))
        
        self.navigationItem.rightBarButtonItem = buttonSave
        
        textFieldSearchTopics.delegate = self
        textFieldSearchTopics.text = viewData.searchModel.keywords
        fetch(viewData.searchModel)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, searchModel:ProjectSearchDataModel) {
        viewData = ViewData(searchModel:searchModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( searchModel:ProjectSearchDataModel ) {
        self.init(nibName: "ProjectSearchViewController", bundle: Bundle(for: ProjectSearchViewController.self), searchModel:searchModel)
    }
}

extension ProjectSearchViewController : UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text , !text.isEmpty else { return }
        let newViewData = ViewData(
            searchModel: ProjectSearchDataModel(
                type: viewData.searchModel.type,
                keywordString: text
            )
        )
        self.viewData = newViewData
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if (text.count > 3) {
            print( "\(text)")
            print("search on did begin editing ")
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textFieldSearchTopics.resignFirstResponder()
        //        if let text = textField.text , !text.isEmpty {
        //            let newViewData = ViewData(
        //                searchModel: ProjectSearchDataModel(
        //                    type: viewData.searchModel.type,
        //                    keywordString: text
        //                )
        //            )
        //            self.viewData = newViewData
        //        }
        return true
    }
}

extension ProjectSearchViewController : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = results[ indexPath.row ].title
        return cell
    }
}

extension ProjectSearchViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProposalDetailViewController(apiConfig: viewData.apiConfig, model: results[indexPath.row])
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }
    }
}


extension ProjectSearchViewController {
    struct ViewData {
        let showLocationSearch = false
        var searchModel:ProjectSearchDataModel
        let apiConfig:APIConfig = APIConfig()
        let sortOptions = [
            ProjectSearchDataModel.SearchSortOption.urgency,
            ProjectSearchDataModel.SearchSortOption.newest,
            ProjectSearchDataModel.SearchSortOption.expiration
        ]
    }
    
}
