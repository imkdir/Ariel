//
// Created by Tung CHENG on 2018/5/30.
// Copyright (c) 2018 Objective-Cheng. All rights reserved.
//

import Foundation
import UIKit

public protocol Ariel: class {
    var views: [String: Any] { get set }
    var metrics: [String: Any] { get set }

    func H(_ format: String, block: ()->Void)
    func V(_ format: String, block: ()->Void)
    func J(_ constraint: NSLayoutConstraint, priority: UILayoutPriority)
    func G(_ constraints: [NSLayoutConstraint])

    func prepareForAutoLayout()
}

extension Ariel {

    public func H(_ format: String, block: ()->Void = {}) {
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:\(format)", metrics: metrics, views: views))
        block()
    }

    public func V(_ format: String, block: ()->Void = {}) {
        NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "V:\(format)", metrics: metrics, views: views))
        block()
    }

    public func J(_ constraint: NSLayoutConstraint, priority: UILayoutPriority = .required) {
        constraint.priority = priority
        NSLayoutConstraint.activate([constraint])
    }

    public func G(_ constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints)
    }

    public func prepareForAutoLayout() {

        for property in Mirror(reflecting: self).children {
            guard let identifier = property.label,
                  let view = property.value as? UIView else {
                continue
            }
            views[identifier] = view
            view.accessibilityIdentifier = identifier
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
