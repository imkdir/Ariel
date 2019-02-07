//
//  Operators.swift
//  Ariel
//
//  Created by Tung CHENG on 2019/2/7.
//  Copyright © 2019 Objective-Cheng. All rights reserved.
//

import UIKit

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
