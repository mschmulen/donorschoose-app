//
//  TeacherDetailVC.swift

import UIKit

typealias StatType = (Name:String, Value:String)

open class TeacherDetailVC: UIViewController {
    
  @IBOutlet weak var collectionView: UICollectionView!
    
    
  @IBAction func actionShare( _ sender:AnyObject ) {
    if self.model != nil { shareAsAlertController() }
  }
  
  /// MARK: - Properties
  fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

  let apiConfig = APIConfig()
  let teacherID:String
  let teacherName:String?

  // MARK: - data
  var model:TeacherDataModel? = nil {
    didSet {
      if let model = model {
        DispatchQueue.main.async {
          self.statList.removeAll()
          self.statList.append(StatType("School:","\(model.schoolName) "))
          if let city  = model.city {
            if let state = model.state {
              self.statList.append(StatType("Location:","\(city), \(state)"))
            }
          }

          // Convert the string to a date
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
           if let joinedNSDate = dateFormatter.date(from: model.joinedOn)  {
            
            let prettyPrintDateFormatter = DateFormatter()
           prettyPrintDateFormatter.dateStyle = DateFormatter.Style.long
           prettyPrintDateFormatter.timeStyle = .medium
           let joinedDateString = prettyPrintDateFormatter.string(from: joinedNSDate)
              self.statList.append(StatType("Joined:","\(joinedDateString)"))
           }
           
          if let proposalCount =  model.totalProposals{
              self.statList.append(StatType("Total Proposals:","\( proposalCount )"))
          }

          if let povertyLevel = model.povertyLevel {
              self.statList.append(StatType("Poverty Level:","\(povertyLevel)") )
          }
           
          self.statList.append(StatType("Description:",model.description))
          
          self.collectionView.reloadData()
        }
    }
}
    }
    
    var dataAPI:TeacherDataAPIProtocol?
    var statList:[StatType] = [StatType]()
    var backgroundImageURL:URL? = nil
    
    
    func shareAsAlertController() {
        
        if let model = self.model {
            
            let optionMenu = UIAlertController(title: nil, message: "Favorite this Teacher", preferredStyle: .actionSheet)
            
            var watchAction: UIAlertAction? = nil

          let doesExist =  WatchList.sharedInstance.doesExistInItemDictionary(model.id)

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
  
  init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, teacherID:String , teacherName:String?) {
    self.teacherID = teacherID
    self.teacherName = teacherName
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public convenience init( teacherID:String , teacherName:String?)
  {
    self.init(nibName: "TeacherDetailVC", bundle: Bundle(for: TeacherDetailVC.self), teacherID:teacherID , teacherName:teacherName )
  }

  // +++++++++++++++++++++++++++++++++++++++++++++
  // MARK: - LifeCycle
  // +++++++++++++++++++++++++++++++++++++++++++++
  override open func viewDidLoad() {
    super.viewDidLoad()

    self.collectionView.register(StatViewCell.nib, forCellWithReuseIdentifier: StatViewCell.reuseIdentifier)
    self.collectionView.register(LoadingCollectionViewCell.nib, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier )
    self.collectionView.register(TeacherHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TeacherHeaderView.reuseIdentifier)
    
    let buttonShare : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(TeacherDetailVC.actionShare(_:)))
    self.navigationItem.rightBarButtonItem = buttonShare
    
    dataAPI = TeacherDataAPI(apiConfig: apiConfig, user: "matt", delegate: self)
    dataAPI?.getTeacherInfo(teacherID)
  }

  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}


// MARK: - TeacherDataAPIDelegate
extension TeacherDetailVC : TeacherDataAPIDelegate {
  
  public func dataUpdateCallback( _ dataAPI: TeacherDataAPIProtocol, didChangeData data:TeacherDataModel?, error:APIError? ) {
      
      if let someError = error {
          if let alertVC = AlertFactory.AlertFromError(someError) {
              self.present(alertVC, animated: true, completion: nil)
          }
      }
      else {
        if let dataModel = data {
          self.model = dataModel
        }

        DispatchQueue.main.async {
          //self.loadingcell?.stopLoading()
        }
      }
  }
}

// MARK: - UICollectionViewDataSource
extension TeacherDetailVC : UICollectionViewDataSource {
    
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if statList.count == 0 {
      return 1
    } else {
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
          let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TeacherHeaderView.reuseIdentifier, for: indexPath) as! TeacherHeaderView

          if let backgroundImageString = model?.photoURL {
            if let imageURL = URL(string: backgroundImageString ) {
                headerView.loadBackgroundImagePicture(imageURL)
            }
          }
          else {
            if let backgroundImage = self.backgroundImageURL {
                headerView.loadBackgroundImagePicture(backgroundImage)
            }
          }
          
          if let name = teacherName {
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
extension TeacherDetailVC : UICollectionViewDelegateFlowLayout {
    
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
extension TeacherDetailVC : UICollectionViewDelegate {

  public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
      return true
  }

  public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

}






