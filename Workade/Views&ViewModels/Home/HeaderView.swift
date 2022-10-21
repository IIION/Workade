//
//  HeaderView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/21.
//

import UIKit

class HeaderView: UIStackView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    let pushButton: UIButton = {
        let button = UIButton()
        button.setImage(SFSymbol.chevronRight.image, for: .normal)
        return button
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        
        axis = .horizontal
        alignment = .center
        layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 2)
        isLayoutMarginsRelativeArrangement = true // ArrangedSubview에 margin적용할지에 대한 Boolean
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(pushButton)
        
        NSLayoutConstraint.activate([ // for hitbox...
            pushButton.widthAnchor.constraint(equalToConstant: 44),
            pushButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
