//
//  EmptyBackgroundView.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/26/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

class ProjectsEmptyBackgroundView: UIView {
    
    init(frame: CGRect , config:ProjectTableViewController.ProjectsVCType ) {
        super.init(frame: frame)
        
        var majorText = "No Proposals"
        switch config {
        case .inspiresME:
            majorText = "No Favorites\nPlease add a favorite"
        default:
            majorText = "No Proposals"
        }
        let majorLabel:UILabel = UILabel()
        majorLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        majorLabel.textAlignment = .center
        majorLabel.text = majorText
        majorLabel.numberOfLines = 2
        majorLabel.textColor = UIColor.lightGray
        majorLabel.font=UIFont.systemFont(ofSize: 22)
        self.addSubview(majorLabel)
        
        majorLabel.translatesAutoresizingMaskIntoConstraints = false
        majorLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        majorLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        majorLabel.centerXAnchor.constraint(equalTo: majorLabel.superview!.centerXAnchor).isActive = true
        majorLabel.centerYAnchor.constraint(equalTo: majorLabel.superview!.centerYAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }
}
