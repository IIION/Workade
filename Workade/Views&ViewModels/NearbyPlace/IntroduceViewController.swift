//
//  IntroduceViewController.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/20.
//

import Foundation
import UIKit

class IntroduceViewController: UIViewController {
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "소개 뷰"
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(testLabel)
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}
