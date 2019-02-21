//
// Created by Tung CHENG on 2018/5/30.
// Copyright (c) 2018 Objective-Cheng. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    //MARK: - Basic Methods

    public func align(_ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, with item: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: item, attribute: attribute, multiplier: 1.0, constant: offset)
    }

    public func match(_ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, with target: (UIView, NSLayoutConstraint.Attribute)) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: target.0, attribute: target.1, multiplier: 1.0, constant: offset)
    }

    public func scale(_ attribute: NSLayoutConstraint.Attribute, by multiplier: CGFloat, to target: (UIView, NSLayoutConstraint.Attribute)) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: target.0, attribute: target.1, multiplier: multiplier, constant: 0.0)
    }

    public func aspect(ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0.0)
    }
    
    public func set(_ attribute: NSLayoutConstraint.Attribute, to constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }

    // Convenience Methods

    public func center(in item: UIView) -> [NSLayoutConstraint] {
        return [align(.centerX, with: item), align(.centerY, with: item)]
    }

    public func edges(equal item: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return zip(
                [NSLayoutConstraint.Attribute.top, .trailing, .bottom, .leading],
                [insets.top, -insets.right, -insets.bottom, insets.left])
                .map {
                    attribute, constant in
                    return align(attribute, offset: constant, with: item)
                }
    }

    func attach(to item: UIView, padding: CGFloat = 0, direction: NSLayoutConstraint.Axis) -> NSLayoutConstraint {
        if case .horizontal = direction {
            return match(.leading, offset: padding, with: (item, .trailing))
        } else {
            return match(.top, offset: padding, with: (item, .bottom))
        }
    }

    public func fill(on axis: NSLayoutConstraint.Axis, margin: CGFloat = 0) -> [NSLayoutConstraint] {
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

    public func stack(views: [UIView], direction: NSLayoutConstraint.Axis, proportion: [CGFloat]) -> [NSLayoutConstraint] {
        var multipliers: [CGFloat] = []
        
        if proportion.isEmpty {
            return views.map(direction: direction)
        } else if proportion.count >= views.count {
            multipliers = Array(proportion[0..<views.count])
        } else {
            for i in 0 ..< proportion.count {
                multipliers.append(proportion[i])
            }
            let value = (1 - proportion.reduce(0, +)) / CGFloat(views.count - proportion.count)
            
            for _ in proportion.count ..< views.count {
                multipliers.append(value)
            }
        }
        return Array(0 ..< views.count).flatMap({
            index -> [NSLayoutConstraint] in

            let item = views[index]
            let multiplier = multipliers[index]

            var attrs: [NSLayoutConstraint.Attribute]
            var oppositeAxis: NSLayoutConstraint.Axis

            if case .horizontal = direction {
                attrs = [.leading, .width, .trailing]
                oppositeAxis = .vertical
            } else {
                attrs = [.top, .height, .bottom]
                oppositeAxis = .horizontal
            }

            var constraints: [NSLayoutConstraint] = []

            if index == 0 {
                constraints.append(item.align(attrs[0], with: self))
            } else if index == views.count-1 {
                constraints.append(self.align(attrs[2], with: item))
            } else {
                let prev = views[index-1]
                constraints.append(item.attach(to: prev, direction: direction))
            }

            constraints.append(item.scale(attrs[1], by: multiplier, to: (self, attrs[1])))
            constraints.append(contentsOf: item.fill(on: oppositeAxis))

            return constraints
        })
    }
}

extension Array where Element == UIView {
    public func map(direction: NSLayoutConstraint.Axis, margin: CGSize = .zero, padding: CGFloat = 0, equally: Bool = true) -> [NSLayoutConstraint] {
        guard let first = first, let last = last, count > 1 else {
            return []
        }
        guard let superview = first.superview else { return [] }
        var constraints: [NSLayoutConstraint] = []
        
        switch direction {
        case .horizontal:
            forEach {
                constraints.append($0.align(.top, offset: margin.height, with: superview))
                constraints.append($0.align(.bottom, offset: -margin.height, with: superview))
            }
            constraints.append(first.align(.leading, offset: margin.width, with: superview))
            dropFirst().enumerated().forEach { index, item in
                constraints.append(item.attach(to: self[index], padding: padding, direction: direction))
                if equally {
                    constraints.append(item.align(.width, with: self[index]))
                }
            }
            constraints.append(last.align(.trailing, offset: -margin.width, with: superview))
        case .vertical:
            forEach {
                constraints.append($0.align(.leading, offset: margin.width, with: superview))
                constraints.append($0.align(.trailing, offset: -margin.width, with: superview))
            }
            constraints.append(first.align(.top, offset: margin.height, with: superview))
            dropFirst().enumerated().forEach { index, item in
                constraints.append(item.attach(to: self[index], padding: padding, direction: direction))
                if equally {
                    constraints.append(item.align(.height, with: self[index]))
                }
            }
            constraints.append(last.align(.bottom, offset: -margin.height, with: superview))
        }
        
        return constraints
    }
}
