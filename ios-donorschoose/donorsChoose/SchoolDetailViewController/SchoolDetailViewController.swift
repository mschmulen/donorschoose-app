//
//  SchoolDetailViewController.swift

import UIKit

open class SchoolDetailViewController: UIViewController {

    var viewData:ViewData
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 50.0, right: 5.0)
    var calculatedCellWidth: CGFloat = 0
    
    let apiConfig = APIConfig()

    var dataAPI:SchoolDataAPIProtocol?
    var statList:[StatType] = [StatType]()
    var backgroundImageURL:URL? = nil
    
    var proposals:[ProposalModel] = []
    
    enum section {
        case info
        case proposals
        
        var title:String {
            switch ( self ) {
            case .info: return "School Information"
            case .proposals: return "School Proposals"
            }
        }
    }
    let sections:[section] = [.info, .proposals]
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(StatViewCell.nib, forCellWithReuseIdentifier: StatViewCell.reuseIdentifier)
            collectionView.register(ProposalViewCell.nib, forCellWithReuseIdentifier: ProposalViewCell.reuseIdentifier)

            collectionView.register(LoadingCollectionViewCell.nib, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier )
            
            collectionView.register(SchoolHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SchoolHeaderView.reuseIdentifier)
            
            collectionView.register(SchoolDetailProposalHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SchoolDetailProposalHeaderView.reuseIdentifier)
            
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBAction func actionShare( _ sender:AnyObject ) {
        if self.viewData.model != nil {
            shareAsAlertController()
        }
    }
    
    func shareAsAlertController( ) {
        if let model = self.viewData.model {
            
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
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle, schoolID:String , schoolName:String? , schoolCity:String?) {
        viewData = ViewData(schoolID:schoolID, schoolName:schoolName, schoolCity:schoolCity, model:nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( schoolID:String , schoolName:String?, schoolCity:String?)
    {
        self.init(nibName: "SchoolDetailViewController", bundle: Bundle(for: SchoolDetailViewController.self), schoolID:schoolID, schoolName:schoolName, schoolCity:schoolCity )
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
        
        dataAPI = SchoolDataAPI(config: apiConfig, user: "matt", delegate: self)
        dataAPI?.getSchoolInfo(viewData.schoolID)
        
        let buttonShare : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(SchoolDetailViewController.actionShare(_:)))
        self.navigationItem.rightBarButtonItem = buttonShare        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SchoolDetailViewController : SchoolDataAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: SchoolDataAPIProtocol, didChangeData data:SchoolModel?, error:APIError? ) {
        
        if let someError = error {
            if let alertVC = AlertFactory.AlertFromError(someError) {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        if let dataModel = data {
            viewData = ViewData( schoolID: viewData.schoolID, schoolName: viewData.schoolName, schoolCity: viewData.schoolCity, model: dataModel)
            let model = dataModel
            
            DispatchQueue.main.async {
                self.statList.append(StatType("School:","\(model.name) "))
                self.statList.append(StatType("City:","\(model.city) "))
                self.statList.append(StatType("State:","\(model.state) "))
                self.statList.append(StatType("Poverty Level:","\(model.povertyLevel) "))
                self.proposals = model.proposals
                self.collectionView.reloadData()
            }
        }
    }//end func
}

extension SchoolDetailViewController : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch ( sections[section]) {
        case .info :
            if statList.count == 0 { return 1 }
            else {return statList.count}
        case .proposals:
            return proposals.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch ( sections[indexPath.section]) {
        case .info :
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
        case .proposals:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProposalViewCell.reuseIdentifier, for: indexPath) as! ProposalViewCell
                        cell.configure(name: proposals[indexPath.row].title, description: proposals[indexPath.row].shortDescription)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch sections[indexPath.section] {
        case .info:
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SchoolHeaderView.reuseIdentifier, for: indexPath) as! SchoolHeaderView
                headerView.labelName.text = viewData.schoolName ?? viewData.schoolCity ?? ""
                return headerView
            case UICollectionView.elementKindSectionFooter:
                assert(false, "Unexpected element kind")
            default:
                assert(false, "Unexpected element kind")
            }
        case .proposals:
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SchoolDetailProposalHeaderView.reuseIdentifier, for: indexPath) as! SchoolDetailProposalHeaderView
                return headerView
            case UICollectionView.elementKindSectionFooter:
                assert(false, "Unexpected element kind")
            default:
                assert(false, "Unexpected element kind")
            }
        }
        
        let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reuseIdentifierHeader", for: indexPath)
        return emptyView
    }
}

extension SchoolDetailViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch sections[indexPath.section] {
        case .info:
                if statList.count <= 0 { return CGSize.zero }
                if let cell = StatViewCell.fromNib() {
                    let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
                    cell.configure(name: statList[indexPath.row].Name, value: statList[indexPath.row].Value)
                    let width = calculatedCellWidth - cellMargins
                    cell.labelStatName.preferredMaxLayoutWidth = width
                    cell.labelStatValue.preferredMaxLayoutWidth = width
                    cell.constraintWidth.constant = width
                    return cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                }
                return CGSize(width: 300, height: 300)
        case .proposals:
                if proposals.count <= 0 { return CGSize.zero }
//                if let cell = ProposalViewCell.fromNib() {
//                    let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
//                    //cell.configure(name: proposals[indexPath.row].Name, value: proposals[indexPath.row].Value)
//                    let width = calculatedCellWidth - cellMargins
//                    cell.labelStatName.preferredMaxLayoutWidth = width
//                    cell.labelStatValue.preferredMaxLayoutWidth = width
//                    cell.constraintWidth.constant = width
//                    return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//                }
                return CGSize(width: self.view.frame.width - 30, height: 100)
        }
    }
    
}

extension SchoolDetailViewController : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch( sections[indexPath.section]) {
        case .info: return
        case .proposals:
            let model = proposals[indexPath.row]
            let detailVC = ProposalDetailViewController(apiConfig:apiConfig, model: model)
            if let nav = self.navigationController {
                nav.pushViewController(detailVC, animated: true)
            }
            else
            {
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension SchoolDetailViewController {
    struct ViewData {
        let schoolID:String
        let schoolName:String?
        let schoolCity:String?
        let model:SchoolModel?
        let apiConfig = APIConfig()
    }
}

