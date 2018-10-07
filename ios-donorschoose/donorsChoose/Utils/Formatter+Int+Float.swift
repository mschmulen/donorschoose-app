//
//  Formatter+Int+Float.swift
//  donorsChoose
//
//  Created by Matt Schmulen on 3/25/18.
//  Copyright © 2018 jumptack. All rights reserved.
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self)) ?? "\(self)"
    }
}

extension Float {
    func asCurrency() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(for: self as NSNumber) ?? "\(self)"
    }
}

