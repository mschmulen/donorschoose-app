
import Foundation

public final class Default<Base> {
    let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DefaultCompatible {
    associatedtype CompatibleType
    
    var df: CompatibleType { get }
}

public extension DefaultCompatible {
    var df: Default<Self> {
        return Default(self)
    }
}

extension UserDefaults: DefaultCompatible {}

public protocol UserDefaultStorable {
    static var defaults: UserDefaults { get }
    static var defaultIdentifier: String { get }
    static var defaultValue: Self? { get }
    static func read(forKey key: String?) -> Self?
    func write(withKey key: String?)
    func clear(forKey key: String?)
}

extension UserDefaultStorable where Self: Codable {
    public static var defaultIdentifier: String {
        return String(describing: type(of: self))
    }
    
    public static var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    public static var defaultValue: Self? {
        return nil
    }
    
    public func write(withKey key: String? = nil) {
        let key: String = key ?? Self.defaultIdentifier
        Self.defaults.df.store(self, forKey: key)
    }
    
    public static func read(forKey key: String? = nil) -> Self? {
        let key: String = key ?? defaultIdentifier
        return defaults.df.fetch(forKey: key, type: Self.self) ?? defaultValue
    }
    
    public func clear(forKey key: String? = nil) {
        let key: String = key ?? Self.defaultIdentifier
        return Self.defaults.removeObject(forKey: key)
    }
}

extension Default where Base: UserDefaults {
    public func store<T: Codable>(_ value: T,
                                  forKey key: String,
                                  encoder: JSONEncoder = JSONEncoder()) {
        if let data: Data = try? encoder.encode(value) {
            (base as UserDefaults).set(data, forKey: key)
        }
    }
    
    public func fetch<T>(forKey key: String,
                         type: T.Type,
                         decoder: JSONDecoder = JSONDecoder()) -> T? where T: Decodable {
        if let data = (base as UserDefaults).data(forKey: key) {
            return try? decoder.decode(type, from: data) as T
        }
        
        return nil
    }
}
