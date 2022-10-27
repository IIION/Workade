//
//  MagazineDetailView.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/25.
//

import UIKit

class MagazineDetailView: UIView {
    var magazine: Magazine = Magazine(title: "", imageURL: "", introduceURL: "")

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
    
    init(magazine: Magazine) {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupMagazineDetailData(magazine: Magazine) {
        self.magazine = magazine
    }

    func setupLayout() {
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
