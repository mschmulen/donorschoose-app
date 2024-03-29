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
    var lastLocation:CLLocation?
    var indexPageRequest = 0
    
    var didShowNotification = false
    
    var dataAPI:ProjectAPIProtocol?
    
    var sections:[Section] = [Section]()
    typealias sectionModel = (section:Section,rows:[ProposalModel])
    var tableData = Array<sectionModel>()
    
    enum Section : Hashable {
        
        case location(fetchModel:ProjectSearchDataModel)
        case keyword(fetchModel:ProjectSearchDataModel)
        case inspires(fetchModel:ProjectSearchDataModel)
        case none(fetchModel:ProjectSearchDataModel)
        
        var label:String {
            switch self {
            case .none ( _ ):
                return ""
            case .location ( let fetchModel ):
                if let locationInfo = fetchModel.locationInfo , let city = locationInfo.city {
                    return "Projects near: \(city), \(locationInfo.state)"
                }
                return "Projects near me:"
            case .keyword ( let fetchModel ):
                return "\(fetchModel.keywords ?? "")"
            case .inspires ( let fetchModel ):
                if let keywords = fetchModel.keywords{
                    return "Search: \(keywords)"
                }
                return "Inspires Me:"
            }
        }
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .none(let model):
                hasher.combine(model)
            case .keyword(let model):
                hasher.combine(model)
            case .inspires(let model):
                hasher.combine(model)
            case .location(let model):
                hasher.combine(model)
            }
        }
        
        var hashValue: Int {
            switch self {
            case .none(let model): return model.hashValue
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
    }
    
    @IBAction func refresh(_ sender:AnyObject)
    {
        refreshBegin()
    }
    
    func showLocationServicesError() {
        let notificationVC = ModalNotificationViewController(title: "Location Error", message: "Location Services are not enabled, please enable Location services for the donorsChoose app in the system settings")
        self.present(notificationVC, animated: true) {
            self.didShowNotification = true
        }
    }
    
    func showDataServicesError(_ messageTitle:String , messageString:String) {
        let notificationVC = ModalNotificationViewController(title: messageTitle, message: messageString)
        self.present(notificationVC, animated: true) {
            self.didShowNotification = true
        }
    }
    
    func showNotification() {
        let notificationVC = ModalNotificationViewController(title: "Customizing Search", message: "Some Message or instructions to the user")
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
        self.tableData.removeAll()
        for (index,section) in sections.enumerated() {
            self.tableData.append( (section,[]) )
            switch section {
            case .none(let searchModel):
                fetchSection(searchModel, section:section,  index:index)
            case .inspires(let searchModel):
                fetchSection(searchModel, section:section,  index:index)
            case .keyword(let searchModel):
                fetchSection(searchModel, section:section, index:index)
            case .location(let fetchModel):
                fetchSection(fetchModel, section:section, index:index)
            }
        }
    }
    
    func fetchSection(_ searchModel:ProjectSearchDataModel, section:Section, index:Int) {

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
        
        tableView.registerReusableCell(ProposalTableViewCell.self)
        tableView.estimatedRowHeight = 258
        tableView.separatorStyle = .none
        
        guard let viewData = self.viewData else { return }
        dataAPI = ProjectAPI(config: viewData.apiConfig)
        tableView.backgroundView = ProjectsEmptyBackgroundView(frame: tableView.frame, config: viewData.viewConfig)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(ProjectTableViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        switch ( viewData.viewConfig ) {
        case .inspiresME:
            sections = []
            loadWatchItems()
            
            let buttonAddFavorite : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(ProjectTableViewController.actionAddFavorite(_:)))
            self.navigationItem.rightBarButtonItem = buttonAddFavorite
            
            NotificationCenter.default.addObserver(self, selector: #selector(ProjectTableViewController.refreshWatchItemsFromNotificationEvent), name: NSNotification.Name(rawValue: WatchList.RefreshEventName), object: nil)
            fetchAll()
        case .nearMe:
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            updateLocation()
        case .inNeed:
            sections = [.none(fetchModel:viewData.initalSearchDataModel)]
            fetchAll()
        case .customSearch:
            sections = [.keyword(fetchModel:viewData.initalSearchDataModel)]
            fetchAll()
        }

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
}

extension ProjectTableViewController : CLLocationManagerDelegate  {
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func getLocationInfo(latitude:Double, longitude:Double, callback:((LocationInfo?)->(Void))? = nil) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                callback?(nil)
            }
            
            if let first = placemarks?.first ,
                // MAS TODO 'addressDictionary' was deprecated in iOS 11.0: Use @properties
                let addressDictionary = first.addressDictionary,
                let city = addressDictionary["City"] as? String,
                let state = addressDictionary["State"] as? String,
                let countryCode = addressDictionary["CountryCode"] as? String,
                let zip = addressDictionary["ZIP"] as? String
            {
                let locationInfo = LocationInfo(state: state, city: city, zip: zip, countryCode: countryCode)
                callback?(locationInfo)
            }
            else {
                callback?(nil)
            }
        })
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation:CLLocation = locations.first {
            if let lastKnownLocation = lastLocation {
                let distanceInMeters = newLocation.distance(from: lastKnownLocation)
                if distanceInMeters < 100 {
                    return
                }
                lastLocation = newLocation
            } else {
                lastLocation = newLocation
            }
            
            guard let location = lastLocation  else {
                return
            }
            
            getLocationInfo(latitude:location.coordinate.latitude, longitude:location.coordinate.longitude, callback: { locationInfo in
                if let info = locationInfo {
                    var locationSearchModel = ProjectSearchDataModel(type: .locationLatLong, keywordString: nil)
                    locationSearchModel.latitude = location.coordinate.latitude
                    locationSearchModel.longitude = location.coordinate.longitude
                    locationSearchModel.locationInfo = info
                    self.sections = [Section.location(fetchModel: locationSearchModel)]
                    self.fetchAll()
                } else {
                    var locationSearchModel = ProjectSearchDataModel(type: .locationLatLong, keywordString: nil)
                    locationSearchModel.latitude = location.coordinate.latitude
                    locationSearchModel.longitude = location.coordinate.longitude
                    self.sections = [Section.location(fetchModel: locationSearchModel)]
                    self.fetchAll()
                }
            })
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
        case .denied, .notDetermined, .restricted:
            if let alertVC = AlertFactory.AlertFromLocationStatus(status) {
                self.present(alertVC, animated: true, completion: nil)
            }
        @unknown default:
            print("CLAuthorizationStatus unknown error")
        }
    }
}

extension ProjectTableViewController {
    
    public enum ProjectsVCType {
        case inNeed
        case nearMe
        case inspiresME
        case customSearch
        
        var defaultSearchModels:[ProjectSearchDataModel]? {
            switch self {
            case .inNeed:
                return [ProjectSearchDataModel(type: .urgent, keywordString: nil)]
            case .nearMe:
                return [ProjectSearchDataModel(type: .locationLatLong, keywordString: nil)]
            case .inspiresME, .customSearch:
                return nil
            }
        }
    }
    
    struct ViewData {
        let initalSearchDataModel:ProjectSearchDataModel
        let viewConfig:ProjectsVCType
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
    }
}
