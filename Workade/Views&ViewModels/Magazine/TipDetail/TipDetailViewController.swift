//
//  TipDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/18.
//

import UIKit

class TipDetailViewController: UIViewController {
    let sampleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip 뷰 입니다."
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(sampleLabel)
        let sampleLabelLayout = [
            sampleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sampleLabel.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        
        NSLayoutConstraint.activate(sampleLabelLayout)
    }
}
