//
//  String+URLEncoding.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import Foundation

public extension String {
    func stringByAddingUrlEncoding() -> String {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._* ")
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)?.replacingOccurrences(of: " ", with: "+") ?? self
    }
}

