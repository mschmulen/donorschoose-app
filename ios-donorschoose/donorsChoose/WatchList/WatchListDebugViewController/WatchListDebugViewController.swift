
//  WatchListViewController.swift

import UIKit

// MAS TODO Remove TheWatchList debugView Controller ?

public class WatchListDebugViewController: UITableViewController {

  var items: [WatchItemProtocol] = []

  override public func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(WatchListDebugViewController.refreshOnNotificationEvent), name: NSNotification.Name(rawValue: WatchList.RefreshEventName), object: nil)
  }

  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refreshList()
  }

    @objc func refreshOnNotificationEvent()
  {
    refreshList()
  }

  func refreshList() {
    items = WatchList.sharedInstance.allItems()

    if (items.count >= 64) {
        self.navigationItem.rightBarButtonItem!.isEnabled = false // disable 'add' button
    }
    tableView.reloadData()
  }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "DiogenesCell")
        
        let opty = items[(indexPath as NSIndexPath).row] //as WatchItemProposal
        
        cell.textLabel?.text =  "\(opty.modelID) : \(opty.title)"
        let dateFormatter = DateFormatter()
        
        if let deadline = opty.deadline {
            dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a"
            let dateString = dateFormatter.string(from: deadline as Date)
            cell.detailTextLabel?.text = "deadline #\( dateString)"
        }
        
        /*
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) // retrieve the prototype cell (subtitle style)
        let todoItem = todoItems[indexPath.row] as Oppertunity
        
        cell.textLabel?.text = todoItem.title as String
        if (todoItem.isOverdue) { // the current time is later than the to-do item's deadline
            cell.detailTextLabel?.textColor = UIColor.redColor()
        } else {
            cell.detailTextLabel?.textColor = UIColor.blackColor() // we need to reset this because a cell with red subtitle may be returned by dequeueReusableCellWithIdentifier:indexPath:
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a" // example: "Due Jan 01 at 12:00 PM"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(todoItem.deadline)
        */
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // all cells are editable
    }
    
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { // the only editing style we'll support
            // Delete the row from the data source
            let item = items.remove(at: (indexPath as NSIndexPath).row) // remove TodoItem from notifications array, assign removed item to 'item'
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // delete backing property list entry and unschedule local notification (if it still exists)
            WatchList.sharedInstance.removeItem(item)
            
            // we definitely have under 64 notifications scheduled now, make sure 'add' button is enabled
            //self.navigationItem.rightBarButtonItem!.enabled = true
        }
    }

}

