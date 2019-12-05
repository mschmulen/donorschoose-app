//  ProposalDetailViewController+MFMailComposeViewControllerDelegate.swift

import MessageUI

extension ProposalDetailViewController : MFMailComposeViewControllerDelegate {

  public func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
    // MAS TODO hanlde error cases in Mail
    switch result {
    case MFMailComposeResult.cancelled:
        print("Mail cancelled")
    case MFMailComposeResult.saved:
        print("Mail saved")
    case MFMailComposeResult.sent:
        print("Mail sent")
    case MFMailComposeResult.failed:
        print("Mail sent failure: \(String(describing: error?.localizedDescription))")
    @unknown default:
        print("Mail sent unknown")
    }
    self.dismiss(animated: true, completion: nil)
  }
}
