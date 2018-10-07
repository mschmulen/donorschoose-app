//  LocationDetailViewController.swift

import UIKit

open class LocationDetailViewController: UIViewController {

    var viewData:ViewData
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 50.0, right: 5.0)
    var calculatedCellWidth: CGFloat = 0
    
    let apiConfig = APIConfig()
    
    var dataAPI:ProjectAPIProtocol?
    var statList:[StatType] = [StatType]()
    var proposals:[ProposalModel] = []
    var backgroundImageURL:URL? = nil

    enum section {
        case info
        case proposals
        
        var title:String {
            switch ( self ) {
            case .info: return "Location Information"
            case .proposals: return "Location Proposals"
            }
        }
    }
    let sections:[section] = [.info, .proposals]
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(StatViewCell.nib, forCellWithReuseIdentifier: StatViewCell.reuseIdentifier)
            collectionView.register(ProposalViewCell.nib, forCellWithReuseIdentifier: ProposalViewCell.reuseIdentifier)
            collectionView.register(LocationViewCell.nib, forCellWithReuseIdentifier: LocationViewCell.reuseIdentifier)

            collectionView.register(LoadingCollectionViewCell.nib, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier )
            
            collectionView.register(LocationHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LocationHeaderView.reuseIdentifier)
            
            collectionView.register(LocationDetailProposalHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LocationDetailProposalHeaderView.reuseIdentifier)
            
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle, locationState:String? , locationCity:String?, locationZip:String? ) {
        viewData = ViewData(locationState:locationState, locationCity:locationCity, locationZip:locationZip)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( locationState:String , locationCity:String?, locationZip:String?)
    {
        self.init(nibName: "LocationDetailViewController", bundle: Bundle(for: LocationDetailViewController.self), locationState:locationState, locationCity:locationCity, locationZip:locationZip )
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

        // MAS TODO Add Share Button back
//        let buttonShare : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(LocationDetailViewController.actionShare(_:)))
//        self.navigationItem.rightBarButtonItem = buttonShare

        dataAPI = ProjectAPI(config: viewData.apiConfig,user: "matt")
        guard let state = viewData.locationState else { return }

        var searchModel = ProjectSearchDataModel(
            type: .locationInfo,
            keywordString: ""
        )
        searchModel.locationInfo = LocationInfo(state: state, city: viewData.locationCity,  zip:nil, countryCode: nil)

        dataAPI?.getData(searchModel, pageIndex: 0, callback: { (data, error) in
            if let someError = error {
                print( "\(someError)")
            }
            else {
                DispatchQueue.main.async {
                    switch searchModel.type {
                    case .locationInfo:
                        if let locationSearch = searchModel.locationInfo {
                            self.statList.append(StatType("Location:","\(locationSearch.shortLabel) "))
                        }
                    case .locationLatLong:
                        if let lat = searchModel.latitude, let lng = searchModel.longitude {
                            self.statList.append(StatType("Location:","\(lat),\(lng)  "))
                        }
                    default:
                        break
                    }

                    self.proposals = data
                    self.collectionView.reloadData()
                }
            }
        })
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LocationDetailViewController : UICollectionViewDataSource {
    
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
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LocationHeaderView.reuseIdentifier, for: indexPath) as! LocationHeaderView
                headerView.labelName.text = viewData.locationState ?? viewData.locationCity ?? ""
                return headerView
            case UICollectionElementKindSectionFooter:
                assert(false, "Unexpected element kind")
            default:
                assert(false, "Unexpected element kind")
            }
        case .proposals:
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LocationDetailProposalHeaderView.reuseIdentifier, for: indexPath) as! LocationDetailProposalHeaderView
                if let state = viewData.locationState , (proposals.count > 0) {
                    headerView.configure(major: "Proposals in \(state)")
                }
                return headerView
            case UICollectionElementKindSectionFooter:
                assert(false, "Unexpected element kind")
            default:
                assert(false, "Unexpected element kind")
            }
        }
        
        let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reuseIdentifierHeader", for: indexPath)
        return emptyView
    }
}

extension LocationDetailViewController : UICollectionViewDelegateFlowLayout {
    
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
                    return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                }
                return CGSize(width: 300, height: 300)
        case .proposals:
                if proposals.count <= 0 { return CGSize.zero }
                return CGSize(width: self.view.frame.width - 30, height: 100)
        }
    }
    
}

extension LocationDetailViewController : UICollectionViewDelegate {
    
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

extension LocationDetailViewController {
    struct ViewData {
        let locationState:String?
        let locationCity:String?
        let locationZip:String?
        let apiConfig = APIConfig()
    }
}

