//
//  FavoritesEmptyBackgroundView.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/26/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import UIKit

class FavoritesEmptyBackgroundView: UIView {
    
    override init(frame: CGRect) {
        let majorText = "No Favorites \nAdd a new Favorite from Above or from a Teacher, School or Propsoal View"
        super.init(frame: frame)
        let majorLabel:UILabel = UILabel()
        majorLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        majorLabel.textAlignment = .center
        majorLabel.text = majorText
        majorLabel.numberOfLines = 2
        majorLabel.textColor = UIColor.lightGray //UIColor.red
        majorLabel.font=UIFont.systemFont(ofSize: 22)
        // codedLabel.backgroundColor = UIColor.white
        // self.contentView.addSubview(codedLabel)
        self.addSubview(majorLabel)
        
        majorLabel.translatesAutoresizingMaskIntoConstraints = false
        majorLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        majorLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        majorLabel.centerXAnchor.constraint(equalTo: majorLabel.superview!.centerXAnchor).isActive = true
        majorLabel.centerYAnchor.constraint(equalTo: majorLabel.superview!.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
