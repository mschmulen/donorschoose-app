
import UIKit
import WebKit

public class AboutInfoViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var viewData: ViewData? = ViewData()
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()

        guard let viewData = viewData else { return }
        
        let request = URLRequest(url:viewData.dataURL)
        webView.load(request)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AboutInfoViewController {
    struct ViewData {
        let dataURL: URL = Bundle(for: AboutInfoViewController.self).url(forResource: "About", withExtension: "html")!
    }
}

