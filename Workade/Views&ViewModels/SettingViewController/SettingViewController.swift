//
//  SettingViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

class SettingViewController: UIViewController {
    private let titleView = TitleView(title: "설정")
    
    private let infoButton: NavigateButton = {
        let button = NavigateButton(image: SFSymbol.info.image, text: "서비스 정보")
        button.layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
    }
    
    @objc
    func popToMyPageView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UI setup 관련 Methods
extension SettingViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            style: .done,
            target: self,
            action: #selector(popToMyPageView)
        )
    }
    
    func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            infoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoButton.heightAnchor.constraint(equalToConstant: 74)
        ])
    }
}
