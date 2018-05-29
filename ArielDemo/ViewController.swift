//
//  ViewController.swift
//  ArielDemo
//
//  Created by Tung CHENG on 2018/5/30.
//  Copyright © 2018 Objective-Cheng. All rights reserved.
//

import UIKit
import Ariel

class ViewController: ArielViewController {

    let labelName = UILabel()
    let fieldName = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        [labelName, fieldName].forEach(view.addSubview)

        labelName.text = "Name:"
        fieldName.borderStyle = .roundedRect

        H("|-20-[labelName]-20-[fieldName]-20-|") { labelName <| fieldName }
        V("|-80-[labelName]")
        J(labelName.align(.firstBaseline, with: fieldName))
    }

}
