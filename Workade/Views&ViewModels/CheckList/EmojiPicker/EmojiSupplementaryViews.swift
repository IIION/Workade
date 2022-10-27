//
//  TitleHeaderSupplementaryView.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/25.
//

import UIKit

class TitleHeaderSupplementaryView: UICollectionReusableView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    static let reuseIdentifier = "titleHeader-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setupLayout() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

class BackgroundSupplementaryView: UICollectionReusableView {

    private var insetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .theme.background
        view.layer.cornerRadius = 0
        view.clipsToBounds = true
        return view
    }()
    
    static let reuseIdentifier = "BackgroundView-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(insetView)

        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor),
            insetView.trailingAnchor.constraint(equalTo: trailingAnchor),
            insetView.topAnchor.constraint(equalTo: topAnchor),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
