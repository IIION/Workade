//
//  IntroduceViewController.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/20.
//

import UIKit

class IntroduceView: UIView {
    private var bottomSafeArea: CGFloat {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return CGFloat(44) }
        guard let window = scene.windows.first else { return CGFloat(44) }
        return window.safeAreaInsets.top
    }
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomSafeArea - 20)
        ])
    }
}
