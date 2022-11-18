//
//  HeaderView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/21.
//

import UIKit

/// GuideHomeCollectionView의 각 섹션 위에 위치하는 헤더뷰
final class HeaderView: UICollectionReusableView {
    var pushToNext: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var pushButton: UIButton = {
        let button = UIButton()
        button.setImage(SFSymbol.chevronRightSkyBlue.image, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.pushToNext?()
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
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
            pushButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 11),
            pushButton.widthAnchor.constraint(equalToConstant: 44),
            pushButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
