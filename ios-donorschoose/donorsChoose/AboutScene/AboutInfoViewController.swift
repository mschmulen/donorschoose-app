
import UIKit

public class AboutInfoViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var viewData:ViewData? = ViewData()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        guard let viewData = viewData else { return }
        
        webView.loadRequest(URLRequest(url:viewData.dataURL))
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AboutInfoViewController: UIWebViewDelegate {
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if navigationType == UIWebView.NavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
}

extension AboutInfoViewController {
    struct ViewData {
        let dataURL:URL = Bundle(for: AboutInfoViewController.self).url(forResource: "About", withExtension: "html")!
    }
}

