
import Foundation

public typealias Identifier = String

public protocol Identifiable: Hashable {
  var id: Identifier { get }
}

extension Identifiable {
  public var hashValue: Int { return id.hashValue }
}

public struct Model: Identifiable {
  let name:String
  public let id:Identifier
}

extension Model: Equatable {
  static public func ==(lhs: Model, rhs:Model) -> Bool {
    return lhs.id == rhs.id &&
      lhs.name == rhs.name
  }
}

