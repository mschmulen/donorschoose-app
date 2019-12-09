//
//  UserDefaultWrapper.swift
//  donorsChoose
//
//  Created by Matthew Schmulen on 12/9/19.
//  Copyright © 2019 jumptack. All rights reserved.
//

import Foundation

// Reference https://www.vadimbulavin.com/advanced-guide-to-userdefaults-in-swift/

@propertyWrapper
struct UserDefault<T: UserDefaultPropertyListValue> {
    
    // for UserDefaultsObservation
    var projectedValue: UserDefault<T> { return self }
    
    func observe(change: @escaping (T?, T?) -> Void) -> NSObject {
        return UserDefaultsObservation(key: key) { old, new in
            change(old as? T, new as? T)
        }
    }
    
    // default wrapping
    let key: UserDefaultPropertyKey
    
    var wrappedValue: T? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }
}

// The marker protocol
protocol UserDefaultPropertyListValue {}

extension Data: UserDefaultPropertyListValue {}
extension String: UserDefaultPropertyListValue {}
extension Date: UserDefaultPropertyListValue {}
extension Bool: UserDefaultPropertyListValue {}
extension Int: UserDefaultPropertyListValue {}
extension Double: UserDefaultPropertyListValue {}
extension Float: UserDefaultPropertyListValue {}

// Every element must be a property-list type
extension Array: UserDefaultPropertyListValue where Element: UserDefaultPropertyListValue {}
extension Dictionary: UserDefaultPropertyListValue where Key == String, Value: UserDefaultPropertyListValue {}

struct UserDefaultPropertyKey: RawRepresentable {
    let rawValue: String
}

extension UserDefaultPropertyKey: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}



class UserDefaultsObservation: NSObject {
    let key: UserDefaultPropertyKey
    private var onChange: (Any, Any) -> Void
    
    init(key: UserDefaultPropertyKey, onChange: @escaping (Any, Any) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key.rawValue, options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.oldKey] as Any, change[.newKey] as Any)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
    }
}

