//
//  IntroduceViewController.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/20.
//

import UIKit

class IntroduceView: UIView {
    var bottomSafeArea = CGFloat(44)
    
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
        setupBottomSafeArea()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBottomSafeArea() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = scene.windows.first else { return }
        bottomSafeArea = window.safeAreaInsets.top
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
