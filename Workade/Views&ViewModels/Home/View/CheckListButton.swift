//
//  CheckListButton.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/23.
//

import UIKit

class CheckListButton: UIButton {
    private let checkListView: UIStackView = {
        let label = UILabel()
        label.font = .customFont(for: .headline)
        label.text = "체크리스트"
        let imageView = UIImageView(image: SFSymbol.chevronRight.image)
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(imageView)
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 24)
        stackView.isUserInteractionEnabled = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(checkListView)
        
        NSLayoutConstraint.activate([ // for hitbox...
            checkListView.widthAnchor.constraint(equalTo: widthAnchor),
            checkListView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}