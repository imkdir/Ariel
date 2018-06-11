//
//  ViewController.swift
//  ArielDemo
//
//  Created by Tung CHENG on 2018/5/30.
//  Copyright © 2018 Objective-Cheng. All rights reserved.
//

import UIKit
import Ariel

extension UIColor {
    static var random: UIColor {
        let rd = { CGFloat(arc4random()%256)/256.0 }
        return UIColor(red: rd(), green: rd(), blue: rd(), alpha: 1.0)
    }
}

class ViewController: ArielViewController {

    var boxes: [UIView] = []
    
    let labelName = UILabel()
    let btnCheck = UIButton()
    let fieldName = UITextField()
    let btnSignUp = UIButton()
    let btnLogIn = UIButton()
    let viewLogo = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for _ in 0 ... 3 {
//            let box = UIView()
//            box.backgroundColor = UIColor.random
//            boxes.append(box)
//            view.addSubview(box)
//            box.translatesAutoresizingMaskIntoConstraints = false
//        }
//        
//        NSLayoutConstraint.activate(view.stack(views: boxes, on: .vertical)(0.4))

        [labelName, btnCheck, fieldName, btnSignUp, btnLogIn, viewLogo].forEach(view.addSubview)

        labelName.text = "Name:"
        btnCheck.setTitle("Check", for: [.normal])
        btnCheck.setTitleColor(.black, for: [.normal])
        fieldName.borderStyle = .roundedRect
        
//        btnSignUp.setTitle("Sign Up", for: [.normal])
//        btnSignUp.setTitleColor(.black, for: [.normal])
//        btnLogIn.setTitle("Log In", for: [.normal])
//        btnLogIn.setTitleColor(.black, for: [.normal])
        
        viewLogo.backgroundColor = .red
        viewLogo.transform = CGAffineTransform.identity.rotated(by: .pi/4)

        H("|-20-[labelName]-20-[fieldName]-10-[btnCheck]-20-|")
//        { labelName <| fieldName |> btnCheck }
        H("|-30-[btnSignUp]-40-[btnLogIn(btnSignUp)]-30-|")
        V("|-80-[labelName]-30-[btnSignUp]")
        J(labelName.align(.firstBaseline, with: fieldName))
        J(labelName.align(.firstBaseline, with: btnCheck))
        J(btnSignUp.align(.centerY, with: btnLogIn))
        G(viewLogo.edges(equal: view, insets: UIEdgeInsets(top: 300, left: 150, bottom: 300, right: 150)))
    }

}
