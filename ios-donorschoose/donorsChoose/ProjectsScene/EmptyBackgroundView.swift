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
        majorLabel.textColor = UIColor.lightGray //UIColor.red
        majorLabel.font=UIFont.systemFont(ofSize: 22)
        //        codedLabel.backgroundColor = UIColor.white
        // self.contentView.addSubview(codedLabel)
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

//    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//    label.center = CGPoint(x: 160, y: 285)
//    label.textAlignment = .center
//    label.text = "I'am a test label"
//    self.view.addSubview(label)
    
    
//    let codedLabel:UILabel = UILabel()
//    codedLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//    codedLabel.textAlignment = .center
//    codedLabel.text = alertText
//    codedLabel.numberOfLines=1
//    codedLabel.textColor=UIColor.red
//    codedLabel.font=UIFont.systemFont(ofSize: 22)
//    codedLabel.backgroundColor=UIColor.lightGray
//
//    let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: codedLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
//
//    let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: codedLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
//
//    codedLabel.addConstraints([heightConstraint, widthConstraint])
//
//    let verticalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: codedLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
//
//    let horizontalConstraint:NSLayoutConstraint = NSLayoutConstraint(item: codedLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//
//    self.contentView.addConstraints([verticalConstraint, horizontalConstraint])
//
//    self.contentView.addSubview(codedLabel)

}
