//
// Created by Tung CHENG on 2018/5/30.
// Copyright (c) 2018 Objective-Cheng. All rights reserved.
//

import Foundation
import UIKit

open class ArielView : UIView, Ariel {

    public var views: [String: Any] = [:]
    public var metrics: [String: Any] = [:]

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareForAutoLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
