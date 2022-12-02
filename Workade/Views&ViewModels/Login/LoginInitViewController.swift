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
        let sheet = LoginSheetView(region: region)
        sheet.translatesAutoresizingMaskIntoConstraints = false
        
        return sheet
    }()
    
    private let region: Region
    
    init(region: Region) {
        self.region = region
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
