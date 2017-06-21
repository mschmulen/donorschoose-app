
import UIKit

public class AboutViewController: UIViewController {

  // MARK: - Actions and Outlets
  @IBOutlet weak var webView: UIWebView!

  // MARK: - properties
  let dataURL:URL

  // MARK: - VCLifeCycle
  override public func viewDidLoad() {
    super.viewDidLoad()
    webView.delegate = self
    webView.loadRequest(URLRequest(url:dataURL))
  }

  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - init
  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.dataURL = Bundle(for: AboutViewController.self).url(forResource: "About", withExtension: "html")!
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  public convenience init()
  {
    self.init(nibName: "AboutViewController", bundle: Bundle(for: AboutViewController.self) )
  }
}

extension AboutViewController: UIWebViewDelegate {
    
  public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
      
    if navigationType == UIWebViewNavigationType.linkClicked {
        UIApplication.shared.openURL(request.url!)
        return false
    }
    return true
  }

}

