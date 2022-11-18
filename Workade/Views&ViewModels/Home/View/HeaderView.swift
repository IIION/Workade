//
//  HeaderView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/21.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    var pushToNext: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pushButton: UIButton = {
        let button = UIButton()
        button.setImage(SFSymbol.chevronRight.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        print("헤더뷰 init!")
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(pushButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: pushButton.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pushButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            pushButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            pushButton.widthAnchor.constraint(equalToConstant: 44),
            pushButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
