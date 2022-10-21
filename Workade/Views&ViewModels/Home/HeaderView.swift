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
        axis = .horizontal
        alignment = .center
        addArrangedSubview(titleLabel)
        addArrangedSubview(pushButton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
