//  ProposalDetailViewController.swift

import UIKit
import MessageUI


// MAS TODO Analytics
//import AppAnalyticsLegacy

public enum ShareActionType {
    case email
    case web
    case copy_URL
    case cancel
    
    func analyticsString() -> String {
        switch( self ) {
        case .email: return "EMAIL"
        case .web: return "WEB"
        case .copy_URL: return "COPY_URL"
        case .cancel: return "CANCEL"
        }
    }
}

open class ProposalDetailViewController: UIViewController {
    
    let apiConfig:APIConfig
    
    fileprivate let defaultSectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var cellWidth: CGFloat = 0
    let columnNum: CGFloat = 1
    
    var model:ProposalModel?
    var proposalID:String?
    
    var dataAPI:ProjectAPIProtocol?

    enum Cell {
        case text(title:String, description:String)
        case fundingStatus(model:ProposalModel)
    }

    var cells:[Cell] = [Cell]()

    @IBOutlet weak var buttonModalDismiss: UIButton! {
        didSet {
            buttonModalDismiss.isHidden = true
        }
    }
    
    @IBAction func actionDismiss(_ sender: AnyObject) {
        self.dismiss(animated: true) { }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(DescriptionViewCell.nib, forCellWithReuseIdentifier: DescriptionViewCell.reuseIdentifier)
            collectionView.register(FundingStatusViewCell.nib, forCellWithReuseIdentifier: FundingStatusViewCell.reuseIdentifier)

            collectionView.register(ProposalHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProposalHeaderView.reuseIdentifier)
            collectionView.register(ProposalFooterView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ProposalFooterView.reuseIdentifier)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var buttonGive: UIButton! {
        didSet {
            buttonGive.layer.cornerRadius = 8
        }
    }
    
    @IBAction func actionGive(_ sender: AnyObject) {
        
        if let model = self.model {
            let giveURL = model.proposalURL
            
            // MAS TODO Analytics
//            AnalyticsService.dispatchAnalyticEvent(.customEvent(eventName: "GiveButtonTapped"))
            
            if let url:URL = URL(string: giveURL) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func actionTeacherInfo(_ sender: AnyObject) {
        if let model = self.model {
            if let currentNC = self.navigationController {
                let vc = TeacherDetailVC(teacherID: model.teacherId , teacherName: model.teacherName )
                if let imageURLString = model.imageURL  {
                    if let url = URL(string: imageURLString) {
                        vc.backgroundImageURL = url
                    }
                }
                currentNC.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = TeacherDetailVC(teacherID: model.teacherId , teacherName: model.teacherName )
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionSchoolInfo(_ sender: AnyObject) {
        
        guard let schoolID = self.model?.extractedSchoolID,
            let schoolName = self.model?.schoolName else {
                return
        }
        
        var schoolLocation:String?
        if let city = self.model?.city, let state = self.model?.state {
            schoolLocation = " \(city), \(state) "
        }
        
        if let currentNC = self.navigationController {
            let vc = SchoolDetailViewController(schoolID: schoolID , schoolName: schoolName, schoolCity:schoolLocation )
            currentNC.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = SchoolDetailViewController(schoolID: schoolID , schoolName: schoolName, schoolCity:schoolLocation)
            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func actionLocationInfo(_ sender: AnyObject) {

        guard let state = self.model?.state,
            let city = self.model?.city else {
                return
        }

        let vc = LocationDetailViewController(locationState: state, locationCity: city, locationZip: self.model?.zip )
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBOutlet weak var imageHeaderThumbnail: UIImageView!    {
        didSet {
            //imageHeaderThumbnail.layer.borderWidth = 1.0
            //imageHeaderThumbnail.layer.borderColor = COLOR_UIVIEW_CONTAINER_BACKGROUND.CGColor
            //imageHeaderThumbnail.contentMode = .ScaleAspectFit
        }
    }
    
    @IBOutlet weak var labelCurrenFundingAmount: UILabel! {
        didSet {
            labelCurrenFundingAmount.text = "-"
            labelCurrenFundingAmount.isHidden = false
        }
    }
    
    @IBOutlet weak var fundingStatusView: ViewFundingStatus! {
        didSet {
            fundingStatusView.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var labelStillNeeded: UILabel!
    
    @IBOutlet weak var labelDonorCount: UILabel!
    
    @IBAction func actionShare( _ sender:AnyObject ) {
        if let model = self.model {
            if let url:URL = URL(string: model.proposalURL) {
                shareAsAlertController(url)
            }
        }
    }
    
    
    func shareAsActivityViewController( _ shareContentString:NSString ) {
        
        let activityViewController = UIActivityViewController(activityItems: [shareContentString as NSString], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func shareAsAlertController( _ url:URL ) {
        
        if let model = self.model {
            
            let optionMenu = UIAlertController(title: nil, message: "Share this Project", preferredStyle: .actionSheet)
            
            let emailAction = UIAlertAction(title: "Email", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                let emailTitle = "Checkout this great school project!"
                var messageBodyText = ""
                messageBodyText +=  "<p>"
                messageBodyText +=  "<p>"
                messageBodyText +=  "\(model.fulfillmentTrailer)"
                messageBodyText +=  "<p>"
                
                messageBodyText +=  "<a href=\"\(url)\"> \(model.title) </a>"
                messageBodyText +=  "<p>"
                
                let appURL = "https://itunes.apple.com/us/app/donors-choose/id1074056163?mt=8"
                messageBodyText +=  "<a href=\"\(appURL)\"> Donors Choose app </a>"
                messageBodyText +=  "<p>"
                
                let mc: MFMailComposeViewController = MFMailComposeViewController()
                mc.mailComposeDelegate = self
                mc.setSubject(emailTitle)
                mc.setMessageBody(messageBodyText, isHTML: true)
                
                self.present(mc, animated: true, completion: nil)
            })
            
            let webAction = UIAlertAction(title: "Web", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                UIApplication.shared.open(url, options: [:])
            })
            
            let copyAction = UIAlertAction(title: "Copy URL", style: .default, handler: {
                (alert:UIAlertAction!) -> Void in
                UIPasteboard.general.string = url.absoluteString
            })
            
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
            
            optionMenu.addAction(emailAction)
            optionMenu.addAction(webAction)
            optionMenu.addAction(copyAction)
            if let saveAction = watchAction {
                optionMenu.addAction(saveAction)
            }
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    func confgureUI() {

        if let model = self.model {
            DispatchQueue.main.async {
                self.cells.removeAll()

                // MAS TODO Funding Status
                self.cells.append( Cell.fundingStatus(model:model))

                self.cells.append( Cell.text(title: model.title, description: model.fulfillmentTrailer))
                self.cells.append( Cell.text(title: "My Students:", description: model.shortDescription))

                if let synopsis = model.synopsis {
                    // synopsis.htmlUnescape() results in: All our students receive free breakfast.<br/><br/>The materials will make a difference in my students' learning and improve their school lives because they will be able to use it interactively and productively.

                    //MAS TODO scrub the <br/> or support in textview
                    // self.descriptionList.append(("My Project:", synopsis.htmlUnescape()))
                    self.cells.append( Cell.text(title: "My Project:", description:synopsis))
                }
                
                // MAS TODO
                // descriptionList.append(("Where Your Donation Goes:",model.shortDescription))
                // descriptionList.append(("Project Activity:",model.shortDescription))
                
                let costToCompleteNumber = model.costToComplete.floatValue
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                
                if let formatedString = numberFormatter.string(from: costToCompleteNumber as NSNumber ) {
                    self.labelCurrenFundingAmount.text =  "$\(formatedString) still needed"
                }
                
                self.labelStillNeeded.text = "$\(model.totalPrice)"
                self.labelDonorCount.text = "\(model.numDonors)"
                
                let percentFloat = CGFloat( CGFloat(model.percentFunded) * 0.01 )
                self.fundingStatusView.percentComplete = percentFloat
                
                self.collectionView.reloadData()
                
            }//end dispatch
        }
    }//end configUI
    
    open func fetchAdditionalData(_ projectIDString:String) {
        dataAPI?.getDetailData(projectIDString, callback: { (data, error) in
            
            if let someError = error {
                // self.processError(someError)
                //tableView.hidden = true
                if let alertVC = AlertFactory.AlertFromError(someError) {
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
            else {
                if let newData = data {
                    self.model = newData
                    self.confgureUI()
                    //                    DispatchQueue.main.async(execute: {
                    //                        self.tableView.isHidden = false
                    //                        self.tableView.reloadData()
                    //                        self.refreshControl?.endRefreshing()
                    //                    })
//                    if let newTableData = data {
//                        tableData = newTableData
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.tableView.reloadData()
//                        })
//                    }
                }
            }
            
        })
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        dataAPI = ProjectAPI(config: apiConfig,user: "matt")
        
        let buttonShare : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(ProposalDetailViewController.actionShare(_:)))
        self.navigationItem.rightBarButtonItem = buttonShare
        
        confgureUI()
        
        if let proposalIDFromModel = self.model?.id {
            self.proposalID = proposalIDFromModel
        }
        
        if let fetchID  = self.proposalID {
            fetchAdditionalData(fetchID)
        }
    }
    
    override open func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override open func viewDidLayoutSubviews()
    {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columnNum - 1)
            let totalCellAvailableWidth = collectionView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - spaceBetweenCells
            cellWidth = floor(totalCellAvailableWidth / columnNum);
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle , apiConfig:APIConfig ,model:ProposalModel? , proposalID:String? ) {
        self.apiConfig = apiConfig
        self.model = model
        self.proposalID = proposalID
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(apiConfig:APIConfig, proposalID:String ) {
        self.init(nibName: "ProposalDetailViewController", bundle: Bundle(for: ProposalDetailViewController.self), apiConfig:apiConfig, model:nil, proposalID:proposalID )
    }
    
    public convenience init(apiConfig:APIConfig, model:ProposalModel )
    {
        self.init(nibName: "ProposalDetailViewController", bundle: Bundle(for: ProposalDetailViewController.self), apiConfig:apiConfig, model:model , proposalID:nil )
    }
}

extension ProposalDetailViewController : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cells[indexPath.row] {
        case .fundingStatus(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FundingStatusViewCell.reuseIdentifier, for: indexPath) as! FundingStatusViewCell
            cell.configure(model:model)
            let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
            cell.labelTitle.preferredMaxLayoutWidth = cellWidth - cellMargins
            return cell
        case .text(let title, let description) :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionViewCell.reuseIdentifier, for: indexPath) as! DescriptionViewCell
            cell.configure(title:title, description: description)
            let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
            cell.labelTitle.preferredMaxLayoutWidth = cellWidth - cellMargins
            return cell
        }

    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProposalHeaderView.reuseIdentifier, for: indexPath) as! ProposalHeaderView
            
            if let model = self.model {
                
                headerView.buttonTeacher.setTitle(model.teacherName, for: UIControl.State())
                headerView.buttonSchool.setTitle( model.schoolName, for: UIControl.State())
                headerView.buttonLocation.setTitle( "\(model.city), \(model.state)", for:UIControl.State())

                headerView.buttonTeacher.addTarget(self, action: #selector(actionTeacherInfo(_:)), for: .touchUpInside)
                headerView.buttonSchool.addTarget(self, action: #selector(actionSchoolInfo(_:)), for: .touchUpInside)
                headerView.buttonLocation.addTarget(self, action: #selector(actionLocationInfo(_:)), for: .touchUpInside)

                //headerView.labelPovertyStatus.text = model.povertyLevel
                
                if let imageURLString = model.imageURL {
                    if let url = URL(string: imageURLString) {
                        headerView.loadImageBackground(url)
                    }
                }
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProposalFooterView.reuseIdentifier, for: indexPath) as! ProposalFooterView
            footerView.backgroundColor = UIColor.green;
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
        
        //MAS TODO ... replace with EmptyCollectionReusableView
        let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProposalHeaderView.reuseIdentifier, for: indexPath)
        return emptyView
    }
}

extension ProposalDetailViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let cell = DescriptionViewCell.fromNib() {
            
            let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right

            switch cells[indexPath.row] {
            case .text(let title, let description):
                cell.configure(title:title, description: description)
            case .fundingStatus( let model):
                cell.configure(title: model.fundingStatus, description: model.costToComplete)
                break
            }

            let width = cellWidth - cellMargins
            cell.labelTitle.preferredMaxLayoutWidth = width
            cell.constraintWidth.constant = width //adjust the width to be correct for the number of columns
            
            //apply auto layout and retrieve the size of the cell
            return cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
        return CGSize.zero
    }
}

extension ProposalDetailViewController : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

