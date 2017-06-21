//  Copyright (c) 2016 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

#if os(OSX)
    import AppKit
    public typealias View = NSView
    public typealias LayoutPriority = NSLayoutPriority

    @available(OSX 10.11, *)
    public typealias LayoutGuide = NSLayoutGuide
#elseif os(iOS) || os(tvOS)
    import UIKit
    public typealias View = UIView
    public typealias LayoutPriority = UILayoutPriority

    @available(iOS 9.0, *)
    public typealias LayoutGuide = UILayoutGuide
#endif

public protocol LayoutRegion: AnyObject {}
extension View: LayoutRegion {}

@available(iOS 9.0, OSX 10.11, *)
extension LayoutGuide: LayoutRegion {}

public struct XAxis {}
public struct YAxis {}
public struct Dimension {}

infix operator •==: ComparisonPrecedence
infix operator •<=: ComparisonPrecedence
infix operator •>=: ComparisonPrecedence
infix operator •+: AdditionPrecedence
infix operator •-: AdditionPrecedence
infix operator •*: MultiplicationPrecedence
infix operator •/: MultiplicationPrecedence

public protocol LayoutItemProtocol {
  static func •==(lhs: Self, rhs: Self) -> NSLayoutConstraint
  static func •==(lhs: Self, rhs: CGFloat) -> NSLayoutConstraint
  static func •>=(lhs: Self, rhs: Self) -> NSLayoutConstraint
  static func •>=(lhs: Self, rhs: CGFloat) -> NSLayoutConstraint
  static func •<=(lhs: Self, rhs: Self) -> NSLayoutConstraint
  static func •<=(lhs: Self, rhs: CGFloat) -> NSLayoutConstraint

  static func •+(lhs: Self, rhs: CGFloat) -> Self
  static func •-(lhs: Self, rhs: CGFloat) -> Self
  static func •*(lhs: Self, rhs: CGFloat) -> Self
  static func •/(lhs: Self, rhs: CGFloat) -> Self
}

public struct LayoutItem<C>: LayoutItemProtocol {
    public let item: AnyObject
    public let attribute: NSLayoutAttribute
    public let multiplier: CGFloat
    public let constant: CGFloat

    fileprivate func constrain(_ secondItem: LayoutItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: secondItem.item, attribute: secondItem.attribute, multiplier: secondItem.multiplier, constant: secondItem.constant)
    }

    fileprivate func constrain(_ constant: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }

    fileprivate func itemWithMultiplier(_ multiplier: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: multiplier, constant: self.constant)
    }

    fileprivate func itemWithConstant(_ constant: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: self.multiplier, constant: constant)
    }

    /// Apply `rhs` as a multiplier to `lhs`.
    ///
    /// - parameter lhs: The layout attribute to modify.
    /// - parameter rhs: A multiplier.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •*(lhs: LayoutItem, rhs: CGFloat) -> LayoutItem {
      return lhs.itemWithMultiplier(lhs.multiplier * rhs)
    }

    /// Apply `1/rhs` as a multiplier to `lhs`.
    ///
    /// - parameter lhs: The layout attribute to modify.
    /// - parameter rhs: A multiplier to divide by.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •/(lhs: LayoutItem, rhs: CGFloat) -> LayoutItem {
      return lhs.itemWithMultiplier(lhs.multiplier / rhs)
    }

    /// Add `rhs` to the constant of `lhs`.
    ///
    /// - parameter lhs: The layout attribute to modify.
    /// - parameter rhs: A constant to add.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •+(lhs: LayoutItem, rhs: CGFloat) -> LayoutItem {
      return lhs.itemWithConstant(lhs.constant + rhs)
    }

    /// Subtract `rhs` from the constant of `lhs`.
    ///
    /// - parameter lhs: The layout attribute to modify.
    /// - parameter rhs: A constant to subtract.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •-(lhs: LayoutItem, rhs: CGFloat) -> LayoutItem {
      return lhs.itemWithConstant(lhs.constant - rhs)
    }

    /// Create an "equal to" constraint between `lhs` and `rhs`.
    ///
    /// - parameter lhs: The left side of the constraint.
    /// - parameter rhs: The right side of the constraint.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •==(lhs: LayoutItem, rhs: LayoutItem) -> NSLayoutConstraint {
      return lhs.constrain(rhs, relation: .equal)
    }

    /// Constrain `lhs` as "equal to" the constant `rhs`.
    ///
    /// - parameter lhs: The left side of the constraint.
    /// - parameter rhs: The right side of the constraint.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •==(lhs: LayoutItem, rhs: CGFloat) -> NSLayoutConstraint {
      return lhs.constrain(rhs, relation: .equal)
    }

    /// Create a "greater than or equal to" constraint between `lhs` and `rhs`.
    ///
    /// - parameter lhs: The left side of the constraint.
    /// - parameter rhs: The right side of the constraint.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •>=(lhs: LayoutItem, rhs: LayoutItem) -> NSLayoutConstraint {
      return lhs.constrain(rhs, relation: .greaterThanOrEqual)
    }

    /// Constrain `lhs` as "greater than or equal to" the constant `rhs`.
    ///
    /// - parameter lhs: The left side of the constraint.
    /// - parameter rhs: The right side of the constraint.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •>=(lhs: LayoutItem, rhs: CGFloat) -> NSLayoutConstraint {
      return lhs.constrain(rhs, relation: .greaterThanOrEqual)
    }

    /// Create a "less than or equal to" constraint between `lhs` and `rhs`.
    ///
    /// - parameter lhs: The left side of the constraint.
    /// - parameter rhs: The right side of the constraint.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •<=(lhs: LayoutItem, rhs: LayoutItem) -> NSLayoutConstraint {
      return lhs.constrain(rhs, relation: .lessThanOrEqual)
    }

    /// Constrain `lhs` as "less than or equal to" the constant `rhs`.
    ///
    /// - parameter lhs: The left side of the constraint.
    /// - parameter rhs: The right side of the constraint.
    ///
    /// - note: The "•" character is typed as Opt-8 on a standard US keyboard layout.
    public static func •<=(lhs: LayoutItem, rhs: CGFloat) -> NSLayoutConstraint {
      return lhs.constrain(rhs, relation: .lessThanOrEqual)
    }
}

fileprivate func layoutItem<C>(_ item: AnyObject, _ attribute: NSLayoutAttribute) -> LayoutItem<C> {
    return LayoutItem(item: item, attribute: attribute, multiplier: 1.0, constant: 0.0)
}

public extension LayoutRegion {
    public var left: LayoutItem<XAxis> { return layoutItem(self, .left) }
    public var right: LayoutItem<XAxis> { return layoutItem(self, .right) }
    public var top: LayoutItem<YAxis> { return layoutItem(self, .top) }
    public var bottom: LayoutItem<YAxis> { return layoutItem(self, .bottom) }
    public var leading: LayoutItem<XAxis> { return layoutItem(self, .leading) }
    public var trailing: LayoutItem<XAxis> { return layoutItem(self, .trailing) }
    public var width: LayoutItem<Dimension> { return layoutItem(self, .width) }
    public var height: LayoutItem<Dimension> { return layoutItem(self, .height) }
    public var centerX: LayoutItem<XAxis> { return layoutItem(self, .centerX) }
    public var centerY: LayoutItem<YAxis> { return layoutItem(self, .centerY) }
}

public extension View {
    public var baseline: LayoutItem<YAxis> { return layoutItem(self, .lastBaseline) }

    @available(iOS 8.0, OSX 10.11, *)
    public var firstBaseline: LayoutItem<YAxis> { return layoutItem(self, .firstBaseline) }
    public var lastBaseline: LayoutItem<YAxis> { return layoutItem(self, .lastBaseline) }
}

#if os(iOS) || os(tvOS)
public extension UIViewController {
    public var topLayoutGuideTop: LayoutItem<YAxis> {
        return layoutItem(topLayoutGuide, .top)
    }

    public var topLayoutGuideBottom: LayoutItem<YAxis> {
        return layoutItem(topLayoutGuide, .bottom)
    }

    public var bottomLayoutGuideTop: LayoutItem<YAxis> {
        return layoutItem(bottomLayoutGuide, .top)
    }

    public var bottomLayoutGuideBottom: LayoutItem<YAxis> {
        return layoutItem(bottomLayoutGuide, .bottom)
    }
}

public extension UIView {
    public var leftMargin: LayoutItem<XAxis> { return layoutItem(self, .leftMargin) }
    public var rightMargin: LayoutItem<XAxis> { return layoutItem(self, .rightMargin) }
    public var topMargin: LayoutItem<YAxis> { return layoutItem(self, .topMargin) }
    public var bottomMargin: LayoutItem<YAxis> { return layoutItem(self, .bottomMargin) }
    public var leadingMargin: LayoutItem<XAxis> { return layoutItem(self, .leadingMargin) }
    public var trailingMargin: LayoutItem<XAxis> { return layoutItem(self, .trailingMargin) }
    public var centerXWithinMargins: LayoutItem<XAxis> { return layoutItem(self, .centerXWithinMargins) }
    public var centerYWithinMargins: LayoutItem<YAxis> { return layoutItem(self, .centerYWithinMargins) }
}
#endif

precedencegroup LayoutPriorityPrecedence {
    associativity: left
    lowerThan: ComparisonPrecedence
    higherThan: AssignmentPrecedence
}

infix operator ~ : LayoutPriorityPrecedence

public func ~(lhs: NSLayoutConstraint, rhs: LayoutPriority) -> NSLayoutConstraint {
    let newConstraint = NSLayoutConstraint(item: lhs.firstItem, attribute: lhs.firstAttribute, relatedBy: lhs.relation, toItem: lhs.secondItem, attribute: lhs.secondAttribute, multiplier: lhs.multiplier, constant: lhs.constant)
    newConstraint.priority = rhs
    return newConstraint
}
