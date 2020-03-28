//
//  ChallengeStatsTableViewController.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

class ChallengeStatsTableViewController: UITableViewController {

    var viewData: ViewData?
    

    var sections: [Section] = [Section]()
    var stats: [Row] = [Row]()
    var messages: [Row] = [Row]()
    var proposals: [Row] = [Row]()
    var info: [Row] = [Row]()
    
    enum Row {
        case challengeStat (name: String, value: String)
        case challegeName(name: String)
        case message(message: String, tagline: String)
        case proposal(proposal: ProposalModel)
        
        var label: String {
            switch self {
            case .challegeName(let name): return "\(name)"
            case .challengeStat( _, let value) : return "\(value)"
            case .message( _, let tagline): return "\(tagline)"
            case .proposal(let proposal ): return "\(proposal.schoolName)"
            }
        }
        
        var detail: String? {
            switch self {
            case .message(let message, _): return "\(message)"
            case .challengeStat(let name, _): return "\(name)"
            case .challegeName(_) : return "Challenge Name"
            case .proposal(let proposal ): return "\(proposal.fundingStatus)"
            }
        }
        
        var accessoryType: UITableViewCell.AccessoryType {
            switch self {
            default: return .none
            }
        }
        
        var showSegue: String? {
            switch self {
            default : return nil
            }
        }
        
    }
    
    enum Section: Int {
        case info
        case stats
        case messages
        case proposals
        
        var label: String {
            switch self {
            case .info: return "CHALLENGE INFO"
            case .stats: return "STATS"
            case .messages: return "MESSAGES"
            case .proposals: return "PROPOSALS"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        guard let model = viewData?.model else { return }
        
        sections = [.stats, .messages , .proposals , .info]
        
        info = [
            .challegeName(name:model.challengeName),
            .challengeStat(name:"Challeng Message", value:"\(model.challengeMessage)"),
            .challengeStat(name:"Type", value:"\(model.challengeType)")
            ]
        
        stats = [
            .challengeStat(name:"Teachers Supported", value: model.numTeachers.withCommas() ),
            .challengeStat(name:"Schools Reached", value: model.numSchools.withCommas() ),
            .challengeStat(name:"Students Reached", value: model.studentsReached.withCommas() ),
            .challengeStat(name:"Amount Donated", value: Float( model.amountDonated)?.asCurrency() ?? "\(model.amountDonated)"),
            .challengeStat(name:"Donors Reached", value: Int(model.numDonors)?.withCommas() ?? model.numDonors),
            .challengeStat(name:"Funded Proposals", value: model.numFundedProposals.withCommas() )
        ]
        
        messages = []
        for message in model.donationMessages {
            messages.append( .message(message: message.message, tagline: message.tagline))
        }
        
        proposals = []
        for proposal in model.proposals {
            proposals.append( .proposal(proposal: proposal))
        }
        
        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .info : return info.count
        case .messages: return messages.count
        case .proposals: return proposals.count
        case .stats: return stats.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeStatsTableViewCell", for: indexPath)
        switch ( sections[indexPath.section]) {
        case .info:
            cell.textLabel?.text =  info[indexPath.row].label
            cell.detailTextLabel?.text = info[indexPath.row].detail
        case .stats:
            cell.textLabel?.text =  stats[indexPath.row].label
            cell.detailTextLabel?.text = stats[indexPath.row].detail
        case .messages:
            cell.textLabel?.text =  messages[indexPath.row].label
            cell.detailTextLabel?.text = messages[indexPath.row].detail
        case .proposals:
            cell.textLabel?.text =  proposals[indexPath.row].label
            cell.detailTextLabel?.text =  proposals[indexPath.row].detail
        }
        return cell
    }
}

extension ChallengeStatsTableViewController {
    struct ViewData {
        let user:UserDataModel = UserDataModel()
        let apiConfig:APIConfig = APIConfig()
        let model:DonorPageDataModel?
    }
}

