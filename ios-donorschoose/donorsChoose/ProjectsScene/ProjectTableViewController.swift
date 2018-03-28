//
//  ProjectTableViewController.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/23/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit
import CoreLocation
import FontAwesome

class ProjectTableViewController: UITableViewController {
    
    var viewData:ViewData?
    var showFavorites:(()->(Void))?
    
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D? =  nil
    var indexPageRequest = 0
    
    var didShowNotification = false
    
    var dataAPI:ProjectAPIProtocol?
    
//    var searchModels:[SearchDataModel] = [SearchDataModel]()
    var sections:[Section] = [Section]()
    typealias sectionModel = (section:Section,rows:[ProposalModel])
    // var tableData = [ProposalModel]()
    var tableData = Array<sectionModel>()
    
    enum Section : Hashable {
        case location(fetchModel:SearchDataModel)
        case keyword(fetchModel:SearchDataModel)
        case inspires(fetchModel:SearchDataModel)
        
        var label:String {
            switch self {
            case .location ( let fetchModel ):
                return "Current Location: \(fetchModel.pageSize)"
            case .keyword ( let fetchModel ):
                return "\(fetchModel.keywords ?? "")"//" \(fetchModel.pageSize)"
            case .inspires ( let fetchModel ):
                return "\(fetchModel.keywords ?? ""): \(fetchModel.sortOption.shortLabel) \(fetchModel.pageSize)"
            }
        }
        
        var hashValue: Int {
            switch self {
            case .keyword(let model): return model.hashValue
            case .inspires(let model): return model.hashValue
            case .location(let model): return model.hashValue
            }
        }
        
        static func == (lhs: Section, rhs: Section) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    
    @IBAction func actionAddFavorite(_ sender: AnyObject) {
        showFavorites?()
        //let vc = ProjectSearchViewController(searchModel: viewData.searchModel , callbackDelegate:self)
        //self.navigationController.pushViewController(vc, animated: true)
    }
    
    @IBAction func refresh(_ sender:AnyObject)
    {
        refreshBegin()
    }
    
    func showLocationServicesError() {
        let notificationVC = NotificationViewController(title: "Location Error", message: "Location Services are not enabled, please enable Location services for the donorsChoose app in the system settings")
        self.present(notificationVC, animated: true) {
            self.didShowNotification = true
        }
    }
    
    func showDataServicesError(_ messageTitle:String , messageString:String) {
        let notificationVC = NotificationViewController(title: messageTitle, message: messageString)
        self.present(notificationVC, animated: true) {
            self.didShowNotification = true
        }
    }
    
    func showNotification() {
        let notificationVC = NotificationViewController(title: "Customizing Search", message: "Some Message or instructions to the user")
        self.present(notificationVC, animated: true) {
            self.didShowNotification = true
        }
    }
    
    var watchItems: [WatchItemProtocol] = []
    
    @objc func refreshWatchItemsFromNotificationEvent() {
        loadWatchItems()
    }
    
    func loadWatchItems(){
        watchItems = WatchList.sharedInstance.allItems()
        let customSearchItems = watchItems.filter{
            if $0 is WatchItemCustomSearch { return true }
            else { return false}
        }
        
        for search in customSearchItems {
            sections.append(.inspires(fetchModel: search.searchModel))
        }
        fetchAll()
    }
    
    func processError(_ error:APIError) {
        switch(error)
        {
        case .unknown:
            print("alertFromError.unknown error \(self)")
        case .silent , .networkSerialize:
            print("alertFromError.silent error \(self)")
        default:
            self.showDataServicesError(error.messageTitle, messageString: error.messageBody)
        }
    }
    
    func fetchAll() {
        print( "fetchAll")
        self.tableData.removeAll()
        for (index,section) in sections.enumerated() {
            print( "fetchSectionData \(index) : \(section.label)")
            self.tableData.append( (section,[]) )
            switch section {
            case .inspires(let searchModel):
                fetchSection(searchModel, section:section,  index:index)
            case .keyword(let searchModel):
                fetchSection(searchModel, section:section, index:index)
            case .location(let fetchModel):
                fetchSection(fetchModel, section:section, index:index)
            }
        }
    }
    
    func fetchSection(_ searchModel:SearchDataModel, section:Section, index:Int) {
        print( "fetchRecords.type \(searchModel.type.rawValue)")
        print( "fetchRecords.keywords \(searchModel.keywords ?? "~" )")
        
        dataAPI?.getData(searchModel, pageIndex: indexPageRequest, callback: { (data, error) in
            if let someError = error {
                self.processError(someError)
            }
            else {
                self.tableData[index] = (section,data)
                // if let first = self.sections.first {
                // self.tableData = [(first,data)]
                    // records = newTableData
                    //                tableData.append(ProjectTableViewController.sectionModel.)
                    //                let records = tableData[indexPath.section].1 //records[ (indexPath as NSIndexPath).row]
                    //                let record = records[indexPath.row]
                    DispatchQueue.main.async(execute: {
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    })
                }
//            }
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
    
    func refreshBegin() {
        fetchAll()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MAS TODO custom configure based on configuration
        // configure background
        
        tableView.registerReusableCell(ProposalTableViewCell.self)
        tableView.estimatedRowHeight = 258
        tableView.separatorStyle = .none
        
        guard let viewData = self.viewData else { return }
        dataAPI = ProjectAPI(config: viewData.apiConfig,user: "matt", delegate: self)
        tableView.backgroundView = ProjectsEmptyBackgroundView(frame: tableView.frame, config: viewData.viewConfig)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(ProjectTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
        
        switch ( viewData.viewConfig ) {
        case .inspiresME:
            sections = []
            loadWatchItems()
            
            let buttonAddFavorite : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ProjectTableViewController.actionAddFavorite(_:)))
            self.navigationItem.rightBarButtonItem = buttonAddFavorite
            
            NotificationCenter.default.addObserver(self, selector: #selector(ProjectTableViewController.refreshWatchItemsFromNotificationEvent), name: NSNotification.Name(rawValue: WatchList.RefreshEventName), object: nil)
        case .nearMe:
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            sections = [.location(fetchModel:viewData.initalSearchDataModel)]
            updateLocation()
        case .inNeed:
            sections = [.location(fetchModel:viewData.initalSearchDataModel)]
        case .customSearch:
            sections = [.location(fetchModel:viewData.initalSearchDataModel)]
        }
        fetchAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].0.label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let records = tableData[section].1
        if records.count == 0 {
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.backgroundView?.isHidden = true
        }
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProposalTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.loadItem( tableData[indexPath.section].rows[indexPath.row] )
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewData = viewData else { return }
        
        let detailVC = ProposalDetailViewController(apiConfig:viewData.apiConfig, model: tableData[indexPath.section].rows[indexPath.row])
        if let nav = self.navigationController {
            nav.pushViewController(detailVC, animated: true)
        }
        else
        {
            self.present(detailVC, animated: true, completion: nil)
        }
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).row < tableData[indexPath.section].rows.count)
        {
            if let atvc:AnimatedTableViewCellProtocol = cell as? AnimatedTableViewCellProtocol {
                atvc.startAnimation()
            }
        }
    }
    
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
    
}

extension ProjectTableViewController : CLLocationManagerDelegate  {
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation:CLLocation =  locations.first {
            if currentLocation == nil  {
                currentLocation = userLocation.coordinate
                fetchAll()
            }
            else {
                currentLocation = userLocation.coordinate
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Failed to find user's location: \(error.localizedDescription)")
        showLocationServicesError()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            updateLocation()
        case .authorizedWhenInUse:
            updateLocation()
        case .denied:
            // MAS TODO provide notification to user to change settings
            print(".Denied")
        case .notDetermined:
            // MAS TODO provide notification to user to change settings
            print(".notDetermined")
        case .restricted:
            // MAS TODO provide notification to user to change settings
            print( "restricted")
        }
    }
}

extension ProjectTableViewController : ProjectSearchDelegate {
    public func searchUpdate( _ newSearchModel: SearchDataModel ) {
        // MAS TODO Update SearchUpdate
        // currentSearchModel = newSearchModel
        // fetch()
        print("searchUpdate \(newSearchModel.keywords)")
    }
}

extension ProjectTableViewController : ProjectAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: ProjectAPIProtocol, didChangeData data:[ProposalModel]?, error:APIError? ) {
        
//        if let someError = error {
//        }
//        else {
//            if let newTableData = data , let first = sections.first {
//                //                records = newTableData
//                //                tableData.append(ProjectTableViewController.sectionModel.)
//                //                let records = tableData[indexPath.section].1 //records[ (indexPath as NSIndexPath).row]
//                //                let record = records[indexPath.row]
//
//                tableData = [(first,newTableData)]
//
//                DispatchQueue.main.async(execute: {
//                    self.tableView.isHidden = false
//                    self.tableView.reloadData()
//                    self.refreshControl?.endRefreshing()
//                })
//            }
//        }
    }
}

extension ProjectTableViewController {
    
    public enum ProjectsVCType {
        case inNeed
        case nearMe
        case inspiresME
        case customSearch
        
        var defaultSearchModels:[SearchDataModel]? {
            switch self {
            case .inNeed:
                return [SearchDataModel(type: .urgent, keywordString: nil)]
            case .nearMe:
                return [SearchDataModel(type: .locationLatLong, keywordString: nil)]
            case .inspiresME, .customSearch:
                return nil
            }
        }
    }
    
    struct ViewData {
        let initalSearchDataModel:SearchDataModel
        let viewConfig:ProjectsVCType
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
    }
}
