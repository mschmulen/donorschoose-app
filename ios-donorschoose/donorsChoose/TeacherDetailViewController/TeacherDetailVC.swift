//
//  TeacherDetailVC.swift
//

import UIKit

open class TeacherDetailVC: UIViewController {
    
    var viewData:ViewData
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 50.0, right: 5.0)
    var calculatedCellWidth: CGFloat = 0
    
    var dataAPI:TeacherDataAPIProtocol?
    var statList:[StatType] = [StatType]()
    var backgroundImageURL:URL? = nil
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(StatViewCell.nib, forCellWithReuseIdentifier: StatViewCell.reuseIdentifier)
            collectionView.register(LoadingCollectionViewCell.nib, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier )
            collectionView.register(TeacherHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TeacherHeaderView.reuseIdentifier)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBAction func actionShare( _ sender:AnyObject ) {
        if self.viewData.model != nil { shareAsAlertController() }
    }
    
    func shareAsAlertController() {
        
        if let model = self.viewData.model {

            let optionMenu = UIAlertController(title: nil, message: "Favorite this Teacher", preferredStyle: .actionSheet)
            var watchAction: UIAlertAction? = nil
            let doesExist =  WatchList.sharedInstance.doesExistInItemDictionary(model.id , type: .TEACHER)
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
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, teacherID:String , teacherName:String) {
        viewData = ViewData(teacherID: teacherID, teacherName: teacherName, model:nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( teacherID:String , teacherName:String)
    {
        self.init(nibName: "TeacherDetailVC", bundle: Bundle(for: TeacherDetailVC.self), teacherID:teacherID , teacherName:teacherName )
    }
    
    override open func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override open func viewDidLayoutSubviews()
    {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let totalCellAvailableWidth = collectionView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
            calculatedCellWidth = totalCellAvailableWidth
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
                
        let buttonShare : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(TeacherDetailVC.actionShare(_:)))
        self.navigationItem.rightBarButtonItem = buttonShare
        
        dataAPI = TeacherDataAPI(apiConfig: viewData.apiConfig, user: "matt", delegate: self)
        dataAPI?.getTeacherInfo(viewData.teacherID)
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TeacherDetailVC : TeacherDataAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: TeacherDataAPIProtocol, didChangeData data:TeacherModel?, error:APIError? ) {
        
        if let someError = error {
            if let alertVC = AlertFactory.AlertFromError(someError) {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        else {
            if let dataModel = data {
                
                // MAS TODO Verify threading
                // self.model = dataModel
                
                self.viewData  = ViewData(teacherID: viewData.teacherID, teacherName: viewData.teacherName, model: dataModel)
                
                let model = dataModel
                DispatchQueue.main.async {
                    self.statList.removeAll()
                    if let schoolName = model.schoolName , (schoolName.isEmpty == false) {
                        self.statList.append(StatType("School:","\(schoolName) "))
                    }
                    if let city  = model.city , (city.isEmpty == false)  {
                            self.statList.append(StatType("City:","\(city)"))
                    }
                    if let state = model.state , (state.isEmpty == false) {
                        self.statList.append(StatType("State:","\(state)"))
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let joinedNSDate = dateFormatter.date(from: model.joinedOn)  {
                        let prettyPrintDateFormatter = DateFormatter()
                        prettyPrintDateFormatter.dateStyle = DateFormatter.Style.long
                        prettyPrintDateFormatter.timeStyle = .medium
                        let joinedDateString = prettyPrintDateFormatter.string(from: joinedNSDate)
                        self.statList.append(StatType("Joined:","\(joinedDateString)"))
                    }
                    
                    if let proposalCount =  model.totalProposals{
                        self.statList.append(StatType("Total Proposals:","\(proposalCount)"))
                    }
                    
                    if let fundedCount =  model.totalFundedProposals{
                        self.statList.append(StatType("Total Funded Proposals:","\(fundedCount)"))
                    }
                    
                    if let povertyLevel = model.povertyLevel {
                        self.statList.append(StatType("Poverty Level:","\(povertyLevel)") )
                    }
                    
                    self.statList.append(StatType("Description:",model.description))
                    
                    self.collectionView.reloadData()
                }
            }
            
            // DispatchQueue.main.async {
            //self.loadingcell?.stopLoading()
            // }
        }
    }
}

extension TeacherDetailVC : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if statList.count == 0 { return 1 }
        else { return statList.count }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if statList.count == 0 {
            let loadingcell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier, for: indexPath) as! LoadingCollectionViewCell
            loadingcell.startLoading()
            return loadingcell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatViewCell.reuseIdentifier, for: indexPath) as! StatViewCell
            cell.configure(name: statList[indexPath.row].Name, value: statList[indexPath.row].Value)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TeacherHeaderView.reuseIdentifier, for: indexPath) as! TeacherHeaderView
            
            if let backgroundImageString = viewData.model?.photoURL {
                if let imageURL = URL(string: backgroundImageString ) {
                    headerView.loadBackgroundImagePicture(imageURL)
                }
            }
            else {
                if let backgroundImage = self.backgroundImageURL {
                    headerView.loadBackgroundImagePicture(backgroundImage)
                }
            }
            headerView.labelName.text = viewData.teacherName
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

extension TeacherDetailVC : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if statList.count <= 0 { return CGSize.zero }
        
        if let cell = StatViewCell.fromNib() {
            
            let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
            cell.configure(name: statList[indexPath.row].Name, value: statList[indexPath.row].Value)
            let width = calculatedCellWidth - cellMargins
            cell.labelStatName.preferredMaxLayoutWidth = width
            cell.labelStatValue.preferredMaxLayoutWidth = width
            cell.constraintWidth.constant = width
            return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        }
        return CGSize(width: 300, height: 300)
    }
    
}

extension TeacherDetailVC : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension TeacherDetailVC {
    struct ViewData {
        let teacherID:String
        let teacherName:String
        let model:TeacherModel?
        let apiConfig = APIConfig()
    }
}





