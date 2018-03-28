//
//  ViewController+Nav.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func navWrapper(title:String, image:UIImage) -> UINavigationController {
        let nvc = UINavigationController(rootViewController: self)
        nvc.tabBarItem = UITabBarItem(title: title, image: image, tag:4)
        self.title = title
        return nvc
    }
    
}
