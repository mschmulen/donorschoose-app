//  UITableViewCell+Extension.swift

import UIKit

extension UITableViewCell {
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error )
            
        })
        task.resume()
    }
}
