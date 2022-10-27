//
//  HeaderView.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/21.
//

import UIKit

/// 컬렉션 뷰 상단의 제목 겸 네비게이션 푸시 기능을 하는 뷰입니다.
///
/// 추후 비슷한 류의 가로 컬렉션뷰가 많아진다면 재사용할 일이 많을 듯하여 따로 뺐습니다.
final class HeaderView: UIStackView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(for: .headline)
        
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
        layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 8)
        isLayoutMarginsRelativeArrangement = true // ArrangedSubview에 margin적용할지에 대한 Boolean
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(pushButton)
        
        NSLayoutConstraint.activate([ // for hitbox...
            pushButton.widthAnchor.constraint(equalToConstant: 44),
            pushButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
