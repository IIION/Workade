//
//  TitlePopOverViewController.swift
//  Workade
//
//  Created by Wonhyuk Choi on 2022/10/28.
//

import UIKit

class TitlePopOverViewController: UIViewController {
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "제목은 12글자까지만 가능해요!"
        label.font = .customFont(for: .footnote)
        label.tintColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
}

extension TitlePopOverViewController {
    private func setupLayout() {
        view.addSubview(alertLabel)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            alertLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            alertLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 14),
            alertLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            alertLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -14)
        ])
    }
}
