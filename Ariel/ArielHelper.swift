//
// Created by Tung CHENG on 2018/5/30.
// Copyright (c) 2018 Objective-Cheng. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    // Basic Methods

    public func align(_ attribute: NSLayoutAttribute, offset: CGFloat = 0, with item: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: item, attribute: attribute, multiplier: 1.0, constant: offset)
    }

    public func match(_ attribute: NSLayoutAttribute, offset: CGFloat = 0, with target: (UIView, NSLayoutAttribute)) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: target.0, attribute: target.1, multiplier: 1.0, constant: offset)
    }

    public func scale(_ attribute: NSLayoutAttribute, by multiplier: CGFloat, to target: (UIView, NSLayoutAttribute)) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: target.0, attribute: target.1, multiplier: multiplier, constant: 0.0)
    }

    public func aspect(ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0.0)
    }

    // Convenience Methods

    public func center(in item: UIView) -> [NSLayoutConstraint] {
        return [align(.centerX, with: item), align(.centerY, with: item)]
    }

    public func edges(equal item: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return zip(
                [NSLayoutAttribute.top, .trailing, .bottom, .leading],
                [insets.top, -insets.right, -insets.bottom, insets.left])
                .map {
                    attribute, constant in
                    return align(attribute, offset: constant, with: item)
                }
    }

    public func set(_ attribute: NSLayoutAttribute, to constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }

    public func attach(to item: UIView, padding: CGFloat = 0, on axis: UILayoutConstraintAxis) -> NSLayoutConstraint {
        if case .horizontal = axis {
            return match(.leading, offset: padding, with: (item, .trailing))
        } else {
            return match(.top, offset: padding, with: (item, .bottom))
        }
    }

    public func fill(on axis: UILayoutConstraintAxis, margin: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superview = self.superview else { return [] }

        if case .horizontal = axis {
            return [
                self.align(.leading, offset: margin, with: superview),
                superview.align(.trailing, offset: margin, with: self)
            ]
        } else {
            return [
                self.align(.top, offset: margin, with: superview),
                superview.align(.bottom, offset: margin, with: self)
            ]
        }
    }

    public func stack(views: [UIView], margin: CGFloat = 0, padding: CGFloat = 0, on axis: UILayoutConstraintAxis) -> ([CGFloat]) -> [NSLayoutConstraint] {
        return { multipliers in

            return Array(0 ..< views.count).flatMap({
                index -> [NSLayoutConstraint] in

                let item = views[index]
                let multiplier = multipliers[index]

                var attrs: [NSLayoutAttribute]
                var oppositeAxis: UILayoutConstraintAxis

                if case .horizontal = axis {
                    attrs = [.leading, .width, .trailing]
                    oppositeAxis = .vertical
                } else {
                    attrs = [.top, .height, .bottom]
                    oppositeAxis = .horizontal
                }

                var constraints: [NSLayoutConstraint] = []

                if index == 0 {

                    constraints.append(item.align(attrs[0], offset: margin, with: self))

                } else if index == views.count-1 {

                    constraints.append(self.align(attrs[2], offset: margin, with: item))

                } else {

                    let prev = views[index-1]
                    constraints.append(item.attach(to: prev, padding: padding, on: axis))

                }

                constraints.append(item.scale(attrs[1], by: multiplier, to: (self, attrs[1])))
                constraints.append(contentsOf: item.fill(on: oppositeAxis))

                return constraints
            })
        }
    }

    public func meanStack(views: [UIView], margin: CGFloat = 0, padding: CGFloat = 0, on axis: UILayoutConstraintAxis) -> [NSLayoutConstraint] {
        return stack(views: views, margin: margin, padding: padding, on: axis)(Array(repeating: CGFloat(1.0/Double(views.count)), count: views.count))
    }
}

precedencegroup LayoutPriorityGroup {
    associativity: left
}

infix operator |> : LayoutPriorityGroup

@discardableResult
public func |>(lhs: UIView, rhs: UIView) -> UIView{
    lhs.setContentHuggingPriority(UILayoutPriority(rawValue: rhs.contentHuggingPriority(for: .horizontal).rawValue-1), for: .horizontal)
    return rhs
}

infix operator <| : LayoutPriorityGroup

@discardableResult
public func <|(lhs: UIView, rhs: UIView) -> UIView {
    lhs.setContentHuggingPriority(UILayoutPriority(rawValue: rhs.contentHuggingPriority(for: .horizontal).rawValue+1), for: .horizontal)
    return rhs
}
