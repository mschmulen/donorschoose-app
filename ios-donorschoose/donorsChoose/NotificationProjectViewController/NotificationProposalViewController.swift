//  NotificationViewController.swift

import UIKit

open class NotificationProposalViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var popupView: UIView!
    
    // MARK: - IBOutlet IBAction
    
    @IBAction func actionClose(_ sender: AnyObject) {
        
        self.dismiss(animated: true) {            
        }
    }
    
    @IBAction func actionShow(_ sender: AnyObject) {
        // MAS TODO  show the project detail screen or the project search criteria
    }
    
    // MARK: - properties
    let notificationMessage:String
    let notificationTitle:String
    let proposalModel:ProposalModel
    
    // MARK: - methods
    
    // MARK: - VCLifeCycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        popupView.layer.borderColor = UIColor.black.cgColor
        popupView.layer.borderWidth = 0.25
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
        
        labelTitle.text = proposalModel.title
        labelMessage.text = proposalModel.fulfillmentTrailer
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - init
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, title:String, message:String , proposal:ProposalModel) {
        self.notificationTitle = title
        self.notificationMessage = message
        self.proposalModel = proposal
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( title:String, message:String, proposal:ProposalModel)
    {
        self.init(nibName: "NotificationProposalViewController", bundle: Bundle(for: NotificationProposalViewController.self), title:title, message:message , proposal:proposal)
    }

}
