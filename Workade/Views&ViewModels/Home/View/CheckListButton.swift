//
//  CheckListButton.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/23.
//

import UIKit

/**
 Optional(이미지) + 타이틀 + > (chevron) 으로 구성되어있는 네비게이션을 위한 버튼입니다.
 - image: nil일 때는 타이틀과 쉐브론으로 구성된 형태입니다. nil이 아닐 때는 제목 앞에 이미지가 붙으며 둘 사이는 spacing을 살짝 띄어줍니다.
 - text: 해당 버튼의 제목입니다.

 이미지가 제목 앞에 없는 디자인의 경우 이미지에 nil주면 됩니다.
 반대로 이미지가 있는 경우는 원하는 이미지를 넣어주면 됩니다.
 이렇게 선언한 후, layer, 버튼 layout영역만 따로 정의해서 사용하면 됩니다.
 */
final class NavigateButton: UIButton {
    private var image: UIImage?
    private let text: String
    
    private lazy var stackView: UIStackView = {
        let imageView = UIImageView(image: image)
        let label = UILabel()
        label.font = .customFont(for: .headline)
        label.text = text
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = image == nil ? 0 : 9
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var chevronView: UIImageView = {
        let imageView = UIImageView(image: SFSymbol.chevronRight.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(image frontImage: UIImage?, text: String) {
        self.image = frontImage // image가 있을 때만.
        self.text = text
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        addSubview(chevronView)
        
        NSLayoutConstraint.activate([ // for hitbox...
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([ // for hitbox...
            chevronView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
