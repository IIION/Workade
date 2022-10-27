//
//  MagazineDetailView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/25.
//

import UIKit

class MagazineDetailView: UIView {
    // true / false 에 따라 Event View 여부
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Magazine 내용 뷰"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(testLabel)

        NSLayoutConstraint.activate([
            testLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            testLabel.topAnchor.constraint(equalTo: topAnchor),
            testLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            testLabel.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
}
