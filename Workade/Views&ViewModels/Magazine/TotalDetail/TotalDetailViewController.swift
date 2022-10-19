//
//  TotalDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/18.
//

import UIKit

class TotalDetailViewController: UIViewController {
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Total 뷰 입니다 나중에 수정"
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
