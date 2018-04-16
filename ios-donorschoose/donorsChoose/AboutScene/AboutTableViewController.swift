//
//  AboutTableViewController.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/23/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    var viewData:ViewData?
    var dataAPI:DonorPageDataAPIProtocol!
    
    // MAS TODO Move this to a <Set>
    var records:[Section:[Row]] = [Section: [Row]]()
    
    enum Row {
        case header
        case aboutInfo
        case buildInfo
        
        // Stats
        case challengeStat (name:String, value:String)
        case moreStats
        
        // WIP
        case tools
        case login
        var label:String {
            switch self {
            case .header: return "Donors Choose App"
            case .aboutInfo: return "About This App"
            case .buildInfo: return "build: \("x.x.x")"
                
            // Stats
            case .challengeStat( let name, let value) : return "\(name): \(value)"
            case .moreStats: return "More stats about this app"
                
            // WIP
            case .login: return "Login"
            case .tools: return "Search Tools"
            }
        }
        
        var accessoryType: UITableViewCellAccessoryType {
            switch self {
            case .aboutInfo: return .disclosureIndicator
            case .login: return .disclosureIndicator
            case .moreStats: return .disclosureIndicator
            case .tools: return .disclosureIndicator
            default: return .none
            }
        }
        
        var selectionStyle: UITableViewCellSelectionStyle {
            switch self {
            case .aboutInfo: return .default
            case .login: return .default
            case .moreStats: return .default
            case .tools: return .default
            default: return .none
            }
        }
        
        var showSegue: String? {
            switch self {
            case .aboutInfo: return "showAboutInfo"
            case .login: return "showLogin"
            case .tools: return "showTools"
            case .moreStats: return "showMoreStats"
            default : return nil
            }
        }
    }
    
    enum Section:Int {
        case about = 0
        case stats
        case dev

        var label:String {
            switch self {
            case .about: return "ABOUT"
            case .stats: return "STATS ABOUT THIS APP"
            case .dev: return "DEV"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        records[.about] = []
        records[.stats] = []
        switch env {
        case .dev:
            records[.dev] = [.login]
        default: break
        }
        
        guard let viewData = viewData else { return }
        records[.about] = [.header, .aboutInfo, .tools]
        records[.stats] = []
        
        dataAPI = DonorPageDataAPI(config: viewData.apiConfig, user: "matt", delegate: self)
        dataAPI?.getStats(viewData.apiConfig.givingPageID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)!.label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let s = Section(rawValue: section)!
        return records[Section(rawValue: section)!]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutTableViewCell", for: indexPath)
        
        switch records[Section(rawValue: indexPath.section)!] {
        default:
            let r = records[Section(rawValue: indexPath.section)!]!
            cell.textLabel?.text = r[indexPath.row].label
            cell.accessoryType = r[indexPath.row].accessoryType
            cell.selectionStyle = r[indexPath.row].selectionStyle
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let r = records[Section(rawValue: indexPath.section)!]!
        if let showSegue = r[indexPath.row].showSegue {
            performSegue(withIdentifier: showSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ChallengeStatsTableViewController , let model = viewData?.model {
            vc.viewData = ChallengeStatsTableViewController.ViewData(model: model)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension AboutTableViewController : DonorPageDataAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: DonorPageDataAPIProtocol, didChangeData data:DonorPageDataModel?, error:APIError? ) {
        
        if let someError = error {
            if let alertVC = AlertFactory.AlertFromError(someError) {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        else {
            if let dataModel = data {
                DispatchQueue.main.async {
                    self.viewData = ViewData(model: dataModel)
                    
                    self.records[.stats] = [
                        .challengeStat(name:"Amount Donated",
                                       value: Float( dataModel.amountDonated)?.asCurrency() ?? "\(dataModel.amountDonated)"),
                        .challengeStat(name:"Students Impacted",
                                       value: "\(dataModel.studentsReached.withCommas())"),
                        .challengeStat(name:"Teachers Supported",
                                       value: "\(dataModel.numTeachers.withCommas())"),
                        .challengeStat(name:"Schools Reached",
                                       value: "\(dataModel.numSchools.withCommas())"),
                        .moreStats
                        ]
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension AboutTableViewController  {
    struct ViewData {
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
        let model:DonorPageDataModel?
    }
}

