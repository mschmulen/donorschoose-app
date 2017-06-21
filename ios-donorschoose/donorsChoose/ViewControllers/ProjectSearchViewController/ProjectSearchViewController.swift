// ProjectSearchViewController.swift

import UIKit

public protocol ProjectSearchDelegate {
  func searchUpdate( _ newSearchModel: SearchDataModel )
}

open class ProjectSearchViewController: UIViewController {

  @IBOutlet weak var textFieldSearchTopics: UITextField!

  @IBOutlet weak var pickerSortOrder: UIPickerView!

  @IBAction func actionSaveSearch(_ sender: AnyObject) {

    //create a new searchModelObject and pass it back to the calling delegate
    if let newSearchString = textFieldSearchTopics.text {
      self.currentSearchModel.keywords = newSearchString
      var newSearchStruct = SearchDataModel( type: .keyword, keywordString:newSearchString )
      newSearchStruct.sortOption = SEARCH_SORT_OPTION.enumFromRowValue(pickerSortOrder.selectedRow(inComponent: 0))
      callbackDelegate.searchUpdate(newSearchStruct)
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
  fileprivate var currentSearchModel:SearchDataModel

  func favoriteAlertController() {

    let optionMenu = UIAlertController(title: nil, message: "Favorite this Search", preferredStyle: .actionSheet)

    var watchAction: UIAlertAction? = nil
    let doesExist =  WatchList.doesWatchListItemExist(self.currentSearchModel)
    if doesExist == true {
      watchAction = UIAlertAction(title: "Remove From My Favorites", style: .default, handler: {
        (alert:UIAlertAction!) -> Void in
        WatchList.removeFromWatchList(self.currentSearchModel)
      })
    }
    else {
      watchAction = UIAlertAction(title: "Add To My Favorites", style: .default, handler: {
        (alert:UIAlertAction!) -> Void in
        WatchList.addToWatchList( self.currentSearchModel)
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

    title = "Custom Search"

    let buttonShare : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(ProjectSearchViewController.actionShare(_:)))
    self.navigationItem.rightBarButtonItem = buttonShare

    textFieldSearchTopics.delegate = self
    textFieldSearchTopics.text = currentSearchModel.keywords
  }

  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - init
  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, searchModel:SearchDataModel , callbackDelegate:ProjectSearchDelegate ) {
    self.callbackDelegate = callbackDelegate
    currentSearchModel = searchModel
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  public convenience init( searchModel:SearchDataModel , callbackDelegate:ProjectSearchDelegate)
  {
    self.init(nibName: "ProjectSearchViewController", bundle: Bundle(for: ProjectSearchViewController.self), searchModel:searchModel , callbackDelegate:callbackDelegate )
  }

}

extension ProjectSearchViewController : UITextFieldDelegate {

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
    textFieldSearchTopics.resignFirstResponder()
    return true
  }
}

extension ProjectSearchViewController : UIPickerViewDataSource {

  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return SEARCH_SORT_OPTION.pickerOptions.count
  }

}

extension ProjectSearchViewController : UIPickerViewDelegate {

  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return SEARCH_SORT_OPTION.enumFromRowValue(row).pickerLabel
  }

  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.currentSearchModel.sortOption = SEARCH_SORT_OPTION.enumFromRowValue(row)
  }
}
