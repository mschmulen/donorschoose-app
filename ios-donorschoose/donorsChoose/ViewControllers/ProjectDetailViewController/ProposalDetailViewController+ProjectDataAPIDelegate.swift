//
//  ProposalDetailViewController+ProjectDataAPIDelegate.swift

import Foundation

// MARK: - ProposalDataAPIDelegate
extension ProposalDetailViewController : ProposalDataAPIDelegate {
    
    public func dataUpdateCallback( _ dataAPI: ProposalDataAPIProtocol, didChangeData data:[ProposalDataModel]?, error:APIError? ) {
        
        if let someError = error {
            //tableView.hidden = true
            //alert the user
            
            // MAS TODO Move over to NotificationViewController
            if let alertVC = AlertFactory.AlertFromError(someError) {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        else {
            if let newData = data {
                if newData.count > 0 {
                    let newDataModel = newData[0]
                    self.model = newDataModel
                    confgureUI()
                }
                else {
                    print( "Alert , model was not found")
                    /*
                     if let alertVC = AlertFactory.AlertFromError(someError) {
                     self.presentViewController(alertVC, animated: true, completion: nil)
                     }
                     */
                }
            }
            
            /*
             tableView.hidden = false
             if let newTableData = data {
             tableData = newTableData
             dispatch_async(dispatch_get_main_queue(), {
             self.tableView.reloadData()
             })
             }
             */
        }
        //self.refreshControl.endRefreshing()
    }
}
