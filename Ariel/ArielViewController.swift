//
// Created by Tung CHENG on 2018/5/30.
// Copyright (c) 2018 Objective-Cheng. All rights reserved.
//

import Foundation
import UIKit

open class ArielViewController : UIViewController, Ariel {

    public var views: [String: Any] = [:]
    public var metrics: [String: Any] = [:]

    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareForAutoLayout()
    }
    
    func add(child: UIViewController, name: String) {
        addChild(child)
        view.addSubview(child.view)
        views[name] = child.view
        child.view.accessibilityIdentifier = name
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.didMove(toParent: self)
    }
}
