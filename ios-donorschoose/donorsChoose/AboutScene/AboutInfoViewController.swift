
import UIKit

public class AboutInfoViewController: UIViewController {
    
    // MAS TODO convert UIWebView to WKWebView
    @IBOutlet weak var webView: UIWebView!
    
    var viewData: ViewData? = ViewData()
    
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
            guard let url = request.url else {
                return false
            }
            UIApplication.shared.open(url, options: [:])
            return false
        }
        return true
    }
}

extension AboutInfoViewController {
    struct ViewData {
        let dataURL: URL = Bundle(for: AboutInfoViewController.self).url(forResource: "About", withExtension: "html")!
    }
}

