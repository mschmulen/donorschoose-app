//
//  NotificationViewController.swift

import UIKit

open class ModalNotificationViewController: UIViewController {
    
    // MARK: - IBOutlet IBAction
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func actionClose(_ sender: AnyObject) {
        
        self.dismiss(animated: true) {            
        }
    }
    
    // MARK: - properties
    let notificationMessage:String
    let notificationTitle:String
    
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
        
        labelTitle.text = notificationTitle
        labelMessage.text = notificationMessage
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - init
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, title:String, message:String) {
        self.notificationTitle = title
        self.notificationMessage = message
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init( title:String, message:String)
    {
        self.init(nibName: "ModalNotificationViewController", bundle: Bundle(for: ModalNotificationViewController.self), title:title, message:message )
    }

}
