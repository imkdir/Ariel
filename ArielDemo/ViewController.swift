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
    let btnSignUp = UIButton()
    let btnLogIn = UIButton()
    let viewLogo = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        [labelName, fieldName, btnSignUp, btnLogIn, viewLogo].forEach(view.addSubview)

        labelName.text = "Name:"
        fieldName.borderStyle = .roundedRect
        
        btnSignUp.setTitle("Sign Up", for: [.normal])
        btnSignUp.setTitleColor(.black, for: [.normal])
        btnLogIn.setTitle("Log In", for: [.normal])
        btnLogIn.setTitleColor(.black, for: [.normal])
        
        viewLogo.backgroundColor = .red
        viewLogo.transform = CGAffineTransform.identity.rotated(by: .pi/4)

        H("|-20-[labelName]-20-[fieldName]-20-|") { labelName <| fieldName }
        H("|-30-[btnSignUp]-40-[btnLogIn(btnSignUp)]-30-|")
        V("|-80-[labelName]-30-[btnSignUp]")
        J(labelName.align(.firstBaseline, with: fieldName))
        J(btnSignUp.align(.centerY, with: btnLogIn))
        G(viewLogo.edges(equal: view, insets: UIEdgeInsets(top: 300, left: 150, bottom: 300, right: 150)))
    }

}
