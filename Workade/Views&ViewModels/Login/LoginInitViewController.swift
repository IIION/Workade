//
//  LoginInitViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/30.
//

import UIKit

final class LoginInitViewController: UIViewController {
    private let blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.backgroundColor = .black
        blur.alpha = 0.4
        
        return blur
    }()
    
    private lazy var loginSheetView: LoginSheetView = {
        let sheet = LoginSheetView()
        sheet.translatesAutoresizingMaskIntoConstraints = false
        
        return sheet
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(loginSheetView)
        NSLayoutConstraint.activate([
            loginSheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -320),
            loginSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
