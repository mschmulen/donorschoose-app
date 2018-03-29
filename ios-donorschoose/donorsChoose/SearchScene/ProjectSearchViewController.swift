//
//  ProjectSearchViewController.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/29/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit
import Firebase

public protocol ProjectSearchDelegate {
    func searchUpdate( _ newSearchModel: ProjectSearchDataModel )
}

open class ProjectSearchViewController: UIViewController {
    
    var viewData:ViewData
    var dataAPI:ProjectAPIProtocol?
    
    var results:[ProposalModel] = [ProposalModel]()
    
    fileprivate let callbackDelegate: ProjectSearchDelegate
    
    @IBOutlet weak var tableViewResults: UITableView! {
        didSet {
            tableViewResults.isHidden = true
            tableViewResults.delegate = self
            tableViewResults.dataSource = self
        }
    }
    
    @IBOutlet weak var textFieldSearchTopics: UITextField!
    
//    @IBOutlet weak var textFieldLocation: UITextField! {
//        didSet {
//            textFieldLocation.isHidden = !viewData.showLocationSearch
//        }
//    }
    
    @IBOutlet weak var pickerSortOrder: UIPickerView!
    
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
        print( "fetchRecords.type \(searchModel.type.rawValue)")
        print( "fetchRecords.keywords \(searchModel.keywords ?? "~" )")
        
        dataAPI?.getData(searchModel, pageIndex: 0, callback: { (data, error) in
            if let someError = error {
                print( "\(someError)")
                // self.processError(someError)
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
        
        //        guard let viewData = viewData else { return }
        // MAS TODO support page index Loading
        //        if searchModel.type == .locationLatLong {
        //            if let searchLocation  = self.currentLocation {
        //                dataAPI?.getDataWithSearchModelAndLocation( searchModel, location: searchLocation, pageSize: searchModel.maxPageSize, pageIndex: indexPageRequest) //indexPageRequest default to zero )
        //            }
        //        }
        //        else {
        // MAS TODO support the pageIndex for secondary requests
        //            dataAPI?.getDataWithSearchModel(searchModel, pageSize:searchModel.maxPageSize, pageIndex: indexPageRequest)
        //        }
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
                self.callbackDelegate.searchUpdate(self.viewData.searchModel)
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
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, searchModel:ProjectSearchDataModel , callbackDelegate:ProjectSearchDelegate ) {
        self.callbackDelegate = callbackDelegate
        viewData = ViewData(searchModel:searchModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( searchModel:ProjectSearchDataModel , callbackDelegate:ProjectSearchDelegate)
    {
        self.init(nibName: "ProjectSearchViewController", bundle: Bundle(for: ProjectSearchViewController.self), searchModel:searchModel , callbackDelegate:callbackDelegate )
    }
}

extension ProjectSearchViewController : UITextFieldDelegate {
    
    //    public func textFieldDidEndEditing(_ textField: UITextField) {
    //        print( "did end")
    //    }
    //
    //    public func textFieldDidBeginEditing(_ textField: UITextField) {
    //        print( "did begine")
    //    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldSearchTopics.resignFirstResponder()
        if let newSearchString = textField.text , (newSearchString.isEmpty == false) {
            let newViewData = ViewData(
                searchModel: ProjectSearchDataModel(
                    type: viewData.searchModel.type,
                    keywordString: newSearchString
                )
            )
            self.viewData = newViewData
            fetch(viewData.searchModel)
        }
        return true
    }
}

extension ProjectSearchViewController : UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ProjectSearchDataModel.SearchSortOption.pickerOptions.count
    }
    
}

extension ProjectSearchViewController : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ProjectSearchDataModel.SearchSortOption.enumFromRowValue(row).pickerLabel
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var newViewData = ViewData(
            searchModel: ProjectSearchDataModel(
                type: viewData.searchModel.type,
                keywordString: viewData.searchModel.keywords
            )
        )
        newViewData.searchModel.sortOption = ProjectSearchDataModel.SearchSortOption.enumFromRowValue(row)
        
        self.viewData = newViewData
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
        //        let cell: ProposalTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = results[ indexPath.row ].title
        return cell
    }
}

extension ProjectSearchViewController : UITableViewDelegate {
    
    //    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let detailVC = ProposalDetailViewController(apiConfig:apiConfig, model: tableData[(indexPath as NSIndexPath).row] )
    //        if let nav = self.navigationController {
    //            nav.pushViewController(detailVC, animated: true)
    //        }
    //        else
    //        {
    //            self.present(detailVC, animated: true, completion: nil)
    //        }
    //    }
    
    //    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if((indexPath as NSIndexPath).row < tableData.count)
    //        {
    //            if let atvc:AnimatedTableViewCellProtocol = cell as? AnimatedTableViewCellProtocol {
    //                atvc.startAnimation()
    //            }
    //        }
    //    }
}


extension ProjectSearchViewController {
    
    struct ViewData {
        let showLocationSearch = false
        var searchModel:ProjectSearchDataModel
        let apiConfig:APIConfig = APIConfig()
    }
    
}
