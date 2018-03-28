
//import UIKit
//import CoreLocation
//import FontAwesome
//
//open class ProposalListViewController : UIViewController {
//
//    let apiConfig:APIConfig
//
//    public enum PROJECTS_VC_TYPE {
//        case `static`
//        case customizable
//    }
//
//    let projectVCType: PROJECTS_VC_TYPE
//
//    var didShowNotification = false
//    var tableData = [ProposalDataModel]()
//    var refreshControl:UIRefreshControl!
//
//    var dataAPI:ProposalDataAPIProtocol?
//
//    // MAS TODO , verify save
//    var currentSearchModel:SearchDataModel
//
//    let user:UserDataModel
//    var locationManager:CLLocationManager = CLLocationManager()
//    var currentLocation:CLLocationCoordinate2D? =  nil
//    var indexPageRequest = 0
//    var pageSize = 10
//
//    // Mark: - Actions and Outlets
//    @IBOutlet weak var labelHeaderView: UILabel! {
//        didSet { labelHeaderView.text = "" }
//    }
//
//    @IBOutlet weak var headerView: UIView! {
//        didSet {
//            headerView.isHidden = false
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProposalListViewController.handleHeaderViewTap(_:)))
//            headerView.addGestureRecognizer(tapGesture)
//        }
//    }
//
//    @IBOutlet weak var headerViewConstraint: NSLayoutConstraint! {
//        didSet { headerViewConstraint.constant = 0.0 }
//    }
//
//    @IBOutlet weak var backgroundView:  UIView! {
//        didSet { backgroundView.isHidden = true }
//    }
//
//    @IBOutlet weak var tableView: UITableView! {
//        didSet {
//
//            tableView.dataSource = self
//            tableView.delegate = self
//            tableView.registerReusableCell(ProposalTableViewCell.self)
//            tableView.isHidden = false
//            tableView.estimatedRowHeight = 258
//        }
//    }
//
//    @IBAction func actionShowSearch(_ sender: AnyObject) {
//
//        if let currentNC = self.navigationController {
//            let vc = ProjectSearchViewController(searchModel: currentSearchModel , callbackDelegate:self)
//            currentNC.pushViewController(vc, animated: true)
//        }
//        else
//        {
//            let vc = ProjectSearchViewController(searchModel: currentSearchModel, callbackDelegate:self)
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//
//    @IBAction func refresh(_ sender:AnyObject)
//    {
//        refreshBegin()
//    }
//
//    @objc func handleHeaderViewTap(_ sender: UITapGestureRecognizer? = nil) {
//        if (headerView.isHidden == false) {
//            if let currentNC = self.navigationController {
//                let vc = ProjectSearchViewController(searchModel: currentSearchModel , callbackDelegate:self)
//                currentNC.pushViewController(vc, animated: true)
//            }
//            else
//            {
//                let vc = ProjectSearchViewController(searchModel: currentSearchModel, callbackDelegate:self)
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
//    }
//
//    open func showLocationServicesError() {
//        let notificationVC = NotificationViewController(title: "Location Error", message: "Location Services are not enabled, please enable Location services for the donorsChoose app in the system settings")
//        self.present(notificationVC, animated: true) {
//            self.didShowNotification = true
//        }
//    }
//
//    open func showDataServicesError(_ messageTitle:String , messageString:String) {
//        let notificationVC = NotificationViewController(title: messageTitle, message: messageString)
//        self.present(notificationVC, animated: true) {
//            self.didShowNotification = true
//        }
//    }
//
//    open func showNotification() {
//        let notificationVC = NotificationViewController(title: "Customizing Search", message: "Some Message or instructions to the user")
//        self.present(notificationVC, animated: true) {
//            self.didShowNotification = true
//        }
//    }
//
//    open func fetchData() {
//        // MAS TODO support page index Loading
//        if currentSearchModel.type == .location {
//            if let searchLocation  = self.currentLocation {
//                dataAPI?.getDataWithSearchModelAndLocation( currentSearchModel, location: searchLocation, pageIndex: indexPageRequest) //indexPageRequest default to zero )
//            }
//        }
//        else {
//            // MAS TODO support the pageIndex for secondary requests
//            dataAPI?.getDataWithSearchModel(currentSearchModel, pageIndex: indexPageRequest)
//        }
//    }
//
//    func refreshBegin() {
//        fetchData()
//    }
//
//    override open func viewWillAppear(_ animated: Bool) {
//        // MAS TODO Warning
//        self.automaticallyAdjustsScrollViewInsets = false
//    }
//
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//
//        switch ( currentSearchModel.type ) {
//        case .location :
//            self.locationManager.delegate = self
//            self.locationManager.requestWhenInUseAuthorization()
//            updateLocation()
//        case .in_NEED:
//            headerView.isHidden = true
//            headerViewConstraint.constant = 0.0
//        case .keyword:
//            labelHeaderView.text = "keyword search: \(currentSearchModel.keywords)"
//            headerView.isHidden = false
//            headerViewConstraint.constant = 30.0
//        }
//
//        switch ( self.projectVCType ) {
//        case .customizable :
//            labelHeaderView.text = "keyword search: \(currentSearchModel.keywords)"
//            headerView.isHidden = false
//            headerViewConstraint.constant = 30.0
//            let buttonSearch : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ProposalListViewController.actionShowSearch(_:)))
//            self.navigationItem.rightBarButtonItem = buttonSearch
//
//        case .static:
//            headerView.isHidden = true
//            headerViewConstraint.constant = 0.0
//        }
//
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(ProposalListViewController.refresh(_:)), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refreshControl)
//
//        dataAPI = ProposalDataAPI(config: apiConfig,user: "matt", delegate: self)
//        fetchData()
//    }
//
//    override open func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if ( projectVCType == .customizable ) {
//            labelHeaderView.text = "keyword search: \(currentSearchModel.keywords)"
//            headerView.isHidden = false
//            headerViewConstraint.constant = 30.0
//        }
//    }
//
//    override open func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    required public init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, user:UserDataModel, projectVCType:PROJECTS_VC_TYPE, apiConfig:APIConfig, searchModel:SearchDataModel?) {
//
//        self.apiConfig = apiConfig
//        self.user = user
//        self.projectVCType = projectVCType
//
//        if let predefinedSearchModel = searchModel {
//            self.currentSearchModel = predefinedSearchModel
//        }
//        else {
//            if let lastSearchModel = SearchDataModel.read() {
//                self.currentSearchModel = lastSearchModel
//            } else {
//                self.currentSearchModel = defaultSearchDataModel
//            }
//        }
//
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    public convenience init( user:UserDataModel, projectVCType:PROJECTS_VC_TYPE, apiConfig:APIConfig, searchModel:SearchDataModel?)
//    {
//        self.init(nibName: "ProposalListViewController", bundle: Bundle(for: ProposalListViewController.self), user:user , projectVCType:projectVCType, apiConfig:apiConfig, searchModel:searchModel)
//    }
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // MAS TODO Clean up
//        // calculates where the user is in the y-axis
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        if offsetY > contentHeight - scrollView.frame.size.height {
//
//            // increments the number of the page to request
//            // MAS TODO uncomment to support paged loading
//            //            indexPageRequest += 1
//            print( "new page request original offset \(indexPageRequest)")
//
//            //request another page ...
//
//            // call your API for more data
//            //            loadData()
//            // tell the table view to reload with the new data
//            //        self.tableView.reloadData()
//        }
//    }
//
//
//}
//
//extension ProposalListViewController : ProjectSearchDelegate {
//    public func searchUpdate( _ newSearchModel: SearchDataModel ) {
//        currentSearchModel = newSearchModel
//        fetchData()
//    }
//}
//
//extension ProposalListViewController : ProjectAPIDelegate {
//
//    public func dataUpdateCallback( _ dataAPI: ProposalDataAPIProtocol, didChangeData data:[ProposalDataModel]?, error:APIError? ) {
//
//        if let someError = error {
//            switch(someError)
//            {
//            case .notify_USER_INTERNET_OFFLINE:
//                let messageString:String = "No Internet connection, please check your settings"
//                let messageTitle = "No Internet"
//                showDataServicesError(messageTitle, messageString: messageString)
//            case .notify_USER_GENERIC_NETWORK:
//                let messageString:String = "Error connecting to the server, please try again"
//                let messageTitle = "Connecting Error"
//                showDataServicesError(messageTitle, messageString: messageString)
//            case .notify_USER_TIMEOUT :
//                let messageString:String = "Connection timed out, please try again"
//                let messageTitle = "Connecting Error"
//                showDataServicesError(messageTitle, messageString: messageString)
//            case .notify_USER_DATA_NOT_ALLOWED :
//                let messageString:String = "Data is not allowed for this application on this device, please check your settings"
//                let messageTitle = "Data Error"
//                showDataServicesError(messageTitle, messageString: messageString)
//            case .notify_USER_CONNECTION_LOST :
//                let messageString:String = "Connection lost, please try again"
//                let messageTitle = "Error"
//                showDataServicesError(messageTitle, messageString: messageString)
//            case .unknown:
//                print("alertFromError.unknown error \(self)")
//            case .silent:
//                print("alertFromError.silent error \(self)")
//            }
//        }
//        else {
//            tableView.isHidden = false
//            if let newTableData = data {
//                tableData = newTableData
//                DispatchQueue.main.async(execute: {
//                    self.tableView.reloadData()
//                })
//            }
//        }
//        self.refreshControl.endRefreshing()
//    }
//}
//
//extension ProposalListViewController : UITableViewDataSource {
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableData.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: ProposalTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
//        cell.loadItem( self.tableData[ (indexPath as NSIndexPath).row] )
//        return cell
//    }
//}
//
//extension ProposalListViewController : UITableViewDelegate {
//
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
//
//    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if((indexPath as NSIndexPath).row < tableData.count)
//        {
//            if let atvc:AnimatedTableViewCellProtocol = cell as? AnimatedTableViewCellProtocol {
//                atvc.startAnimation()
//            }
//        }
//    }
//}
//
//extension ProposalListViewController : CLLocationManagerDelegate  {
//
//    func updateLocation() {
//        locationManager.startUpdatingLocation()
//    }
//
//    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        if let userLocation:CLLocation =  locations.first {
//            if currentLocation == nil  {
//                currentLocation = userLocation.coordinate
//                fetchData()
//            }
//            else {
//                currentLocation = userLocation.coordinate
//            }
//        }
//    }
//
//    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        print("Failed to find user's location: \(error.localizedDescription)")
//        showLocationServicesError()
//    }
//
//    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedAlways:
//            updateLocation()
//        case .authorizedWhenInUse:
//            updateLocation()
//        case .denied:
//            // MAS TODO provide notification to user to change settings
//            print(".Denied")
//        case .notDetermined:
//            // MAS TODO provide notification to user to change settings
//            print(".notDetermined")
//        case .restricted:
//            // MAS TODO provide notification to user to change settings
//            print( "restricted")
//        }
//    }
//}
//
//extension ProposalListViewController {
//
//    public static func factoryUrgentNav(user:UserDataModel, apiConfig:APIConfig) -> UINavigationController {
//
//        let title = "In Need"
//        let inNeedSearch = SearchDataModel(type: .in_NEED, keywordString: "In Need")
//        let vc = ProposalListViewController(
//            user: user,
//            projectVCType:ProposalListViewController.PROJECTS_VC_TYPE.static,
//            apiConfig:apiConfig,
//            searchModel:inNeedSearch)
//        let nvc = UINavigationController(rootViewController: vc)
//        let tabImage = UIImage.fontAwesomeIcon(name: .hourglass3, textColor: .blue, size: CGSize(width: 35, height: 35))
//        nvc.tabBarItem = UITabBarItem(title: title, image: tabImage, tag: 2)
//        vc.title = title
//        return nvc
//    }
//
//    public static func factoryNearMe(user:UserDataModel, apiConfig:APIConfig) -> UINavigationController {
//
//        let title = "Near Me"
//        let nearMeSearch = SearchDataModel( type: .location, keywordString: "Near Me" )
//        let vc = ProposalListViewController(
//            user: user,
//            projectVCType:ProposalListViewController.PROJECTS_VC_TYPE.static,
//            apiConfig:apiConfig,
//            searchModel:nearMeSearch)
//        let nvc = UINavigationController(rootViewController: vc)
//        let tabImage = UIImage.fontAwesomeIcon(name: .compass, textColor: .blue, size: CGSize(width: 35, height: 35))
//        nvc.tabBarItem = UITabBarItem(title: title, image: tabImage, tag: 2)
//        vc.title = title
//
//        return nvc
//    }
//
//    public static func factoryInspiresMe(user:UserDataModel, apiConfig:APIConfig) -> UINavigationController {
//        let title = "Inspires Me"
//        let vc = ProposalListViewController(
//            user: user,
//            projectVCType:ProposalListViewController.PROJECTS_VC_TYPE.customizable,
//            apiConfig:apiConfig,
//            searchModel: nil)
//        let nvc = UINavigationController(rootViewController: vc)
//        let tabImage = UIImage.fontAwesomeIcon(name: .search, textColor: .blue, size: CGSize(width: 35, height: 35))
//        nvc.tabBarItem = UITabBarItem(title: title, image: tabImage, tag: 3)
//        vc.title = title
//        return nvc
//    }
//    
//
//}

