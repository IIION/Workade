//
//  TipItemDetailViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/22.
//

import UIKit

class TipItemDetailViewController: UIViewController {
    let testLabel: UILabel = {
       let label = UILabel()
        label.text = "TEST VIEW"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var closeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.topAnchor.constraint(equalTo: view.topAnchor),
            testLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ])
    }
    
    @objc
    func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        TipDetailViewController().setupLayout()
    }
}
