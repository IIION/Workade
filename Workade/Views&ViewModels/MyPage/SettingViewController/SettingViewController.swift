//
//  SettingViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

final class SettingViewController: UIViewController {
    private let loginInformationView: LoginInformationView = {
        let logInInformationView = LoginInformationView()
        logInInformationView.translatesAutoresizingMaskIntoConstraints = false
        logInInformationView.layer.cornerRadius = 15
        logInInformationView.backgroundColor = .theme.background
        logInInformationView.layer.borderWidth = 1
        logInInformationView.layer.borderColor = UIColor.theme.groupedBackground.cgColor
        
        return logInInformationView
    }()
    
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
}

// MARK: UI setup 관련 Methods
private extension SettingViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
        
        self.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(for: .subHeadline)]
    }
    
    private func setupLayout() {
        view.addSubview(loginInformationView)
        NSLayoutConstraint.activate([
            loginInformationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19.92),
            loginInformationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginInformationView.widthAnchor.constraint(equalToConstant: 350),
            loginInformationView.heightAnchor.constraint(equalToConstant: 195)
        ])
    }
}
