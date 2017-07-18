//
//  SchoolDetailViewController.swift

import UIKit

open class SchoolDetailViewController: UIViewController {

  // MARK: - properties
  fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  let apiConfig = APIConfig()
  let schoolID:String
  let schoolName:String?

  var dataAPI:SchoolDataAPIProtocol?
  var statList:[StatType] = [StatType]()
  var backgroundImageURL:URL? = nil
  var model: SchoolDataModel?  = nil {
    didSet {
      if let model = model {
        DispatchQueue.main.async {
          self.statList.append(StatType("School:","\(model.name) "))
          self.statList.append(StatType("City:","\(model.city) "))
          self.statList.append(StatType("State:","\(model.state) "))
          self.statList.append(StatType("Poverty Level:","\(model.povertyLevel) "))
          self.collectionView.reloadData()
        }
      }
    }
  }

  /// Mark: - Outlets
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.register(StatViewCell.nib, forCellWithReuseIdentifier: StatViewCell.reuseIdentifier)
      collectionView.register(LoadingCollectionViewCell.nib, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier )
      collectionView.register(SchoolHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SchoolHeaderView.reuseIdentifier)

      collectionView.delegate = self
      collectionView.dataSource = self
    }
  }

  @IBAction func actionShare( _ sender:AnyObject ) {
    if self.model != nil {
      shareAsAlertController()
    }
  }

  func shareAsAlertController( ) {
      if let model = self.model {
        let optionMenu = UIAlertController(title: nil, message: "Favorite this School", preferredStyle: .actionSheet)

        var watchAction: UIAlertAction? = nil

        let doesExist =  WatchList.doesWatchListItemExist(model)
        if doesExist == true {
          watchAction = UIAlertAction(title: "Remove From My Favorites", style: .default, handler: {
              (alert:UIAlertAction!) -> Void in
            WatchList.removeFromWatchList(model)
          })
        }
        else {
            watchAction = UIAlertAction(title: "Add To My Favorites", style: .default, handler: {
                (alert:UIAlertAction!) -> Void in
              WatchList.addToWatchList(model)
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
  }

  // MARK: - init
  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, schoolID:String , schoolName:String?) {
    self.schoolID = schoolID
    self.schoolName = schoolName
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public convenience init( schoolID:String , schoolName:String?)
  {
    self.init(nibName: "SchoolDetailViewController", bundle: Bundle(for: SchoolDetailViewController.self), schoolID:schoolID, schoolName:schoolName )
  }

  // MARK: - LifeCycle
  override open func viewDidLoad() {
    super.viewDidLoad()

    dataAPI = SchoolDataAPI(config: apiConfig, user: "matt", delegate: self)
    dataAPI?.getSchoolInfo(schoolID)
  }
  
  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
    
}


// MARK: - SchoolDataAPIDelegate
extension SchoolDetailViewController : SchoolDataAPIDelegate {

  public func dataUpdateCallback( _ dataAPI: SchoolDataAPIProtocol, didChangeData data:SchoolDataModel?, error:APIError? ) {

    if let someError = error {
      if let alertVC = AlertFactory.AlertFromError(someError) {
        self.present(alertVC, animated: true, completion: nil)
      }
    }


    if let dataModel = data {
      self.model = dataModel
    }
  }//end func
}


// MARK: - UICollectionViewDataSource
extension SchoolDetailViewController : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if statList.count == 0 {
            return 1
        }
        else {
            return statList.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if statList.count == 0 {
            let loadingcell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier, for: indexPath) as! LoadingCollectionViewCell
            loadingcell.startLoading()
            return loadingcell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatViewCell.reuseIdentifier, for: indexPath) as! StatViewCell
            
            cell.labelStatName.text = statList[(indexPath as NSIndexPath).row].Name
            cell.labelStatValue.text = statList[(indexPath as NSIndexPath).row].Value
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SchoolHeaderView.reuseIdentifier, for: indexPath) as! SchoolHeaderView
            if let backgroundImage = self.backgroundImageURL {
                headerView.loadBackgroundImagePicture(backgroundImage)
            }
            
            if let name = schoolName {
                headerView.labelName.text = name
            }

            return headerView
        case UICollectionElementKindSectionFooter:
            assert(false, "Unexpected element kind")
        default:
            assert(false, "Unexpected element kind")
        }

      let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reuseIdentifierHeader", for: indexPath)
        return emptyView

    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SchoolDetailViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                                      sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                                      insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

// MARK: - UICollectionViewDelegate
extension SchoolDetailViewController : UICollectionViewDelegate {
    
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}



