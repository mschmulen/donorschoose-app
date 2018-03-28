//
// ProjectSearchViewController.swift
//

import UIKit

public protocol ProjectSearchDelegate {
    func searchUpdate( _ newSearchModel: SearchDataModel )
}

open class ProjectSearchViewController: UIViewController {
    
    var viewData:ViewData
    // fileprivate var currentSearchModel:SearchDataModel
    @IBOutlet weak var tableViewResults: UITableView!
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var textFieldSearchTopics: UITextField!
    
    @IBOutlet weak var textFieldLocation: UITextField! {
        didSet {
            textFieldLocation.isHidden = !viewData.showLocationSearch
        }
    }
    
    @IBOutlet weak var pickerSortOrder: UIPickerView!
    
    @IBAction func actionSaveSearch(_ sender: AnyObject) {
        
        if let newSearchString = textFieldSearchTopics.text {
            
            let newViewData = ViewData(
                searchModel: SearchDataModel(
                    type: viewData.searchModel.type,
                    keywordString: newSearchString
                )
            )
            self.viewData = newViewData
            
//            self.currentSearchModel.keywords = newSearchString
//            var newSearchStruct = SearchDataModel( type: .keyword, keywordString:newSearchString )
//            newSearchStruct.sortOption = SearchDataModel.SearchSortOption.enumFromRowValue(pickerSortOrder.selectedRow(inComponent: 0))
            callbackDelegate.searchUpdate(viewData.searchModel)
            _ = self.navigationController?.popViewController(animated: true)            
        }
    }
    
    func actionSave() {
        favoriteAlertController()
    }
    
    @IBAction func actionShare( _ sender:AnyObject ) {
        favoriteAlertController()
    }
    
    fileprivate let callbackDelegate: ProjectSearchDelegate
    
    func favoriteAlertController() {
        
        guard let searchString = textFieldSearchTopics.text else { return }
        if (searchString.isEmpty) == true { return }
        
        let newViewData = ViewData(
            searchModel: SearchDataModel(
                type: viewData.searchModel.type,
                keywordString: searchString
            )
        )
        self.viewData = newViewData
//        self.currentSearchModel.keywords = searchString
        
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
        
        //analytics
        //viewDidLoadEvent(String(describing: self))
        
        let buttonShare : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(ProjectSearchViewController.actionShare(_:)))
        self.navigationItem.rightBarButtonItem = buttonShare
        
        textFieldSearchTopics.delegate = self
        textFieldSearchTopics.text = viewData.searchModel.keywords
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, searchModel:SearchDataModel , callbackDelegate:ProjectSearchDelegate ) {
        self.callbackDelegate = callbackDelegate
        viewData = ViewData(searchModel:searchModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( searchModel:SearchDataModel , callbackDelegate:ProjectSearchDelegate)
    {
        self.init(nibName: "ProjectSearchViewController", bundle: Bundle(for: ProjectSearchViewController.self), searchModel:searchModel , callbackDelegate:callbackDelegate )
    }
    
}

extension ProjectSearchViewController : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldSearchTopics.resignFirstResponder()
        return true
    }
}

extension ProjectSearchViewController : UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SearchDataModel.SearchSortOption.pickerOptions.count
    }
    
}

extension ProjectSearchViewController : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SearchDataModel.SearchSortOption.enumFromRowValue(row).pickerLabel
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var newViewData = ViewData(
            searchModel: SearchDataModel(
                type: viewData.searchModel.type,
                keywordString: viewData.searchModel.keywords
            )
        )
        newViewData.searchModel.sortOption = SearchDataModel.SearchSortOption.enumFromRowValue(row)
        
        self.viewData = newViewData
    }
}

extension ProjectSearchViewController {

    struct ViewData {
        let showLocationSearch = false
        var searchModel:SearchDataModel
    }

}
