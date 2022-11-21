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
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = .customFont(for: .captionHeadlineNew)
        label.textColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dataButton: SettingButton = {
        let button = SettingButton(text: "데이터")
        button.addAction(UIAction(handler: { _ in
            // TODO: 데이터 뷰 이동
            print("데이터 버튼 클릭")
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let licenseButton: SettingButton = {
        let button = SettingButton(text: "라이센스")
        button.addAction(UIAction(handler: { _ in
            // TODO: 라이센스 뷰 이동
            print("라이센스 버튼 클릭")
        }), for: .touchUpInside)
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
        
        view.addSubview(settingLabel)
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: loginInformationView.bottomAnchor, constant: 30),
            settingLabel.leadingAnchor.constraint(equalTo: loginInformationView.leadingAnchor)
        ])
        
        view.addSubview(dataButton)
        NSLayoutConstraint.activate([
            dataButton.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 20),
            dataButton.leadingAnchor.constraint(equalTo: loginInformationView.leadingAnchor),
            dataButton.trailingAnchor.constraint(equalTo: loginInformationView.trailingAnchor),
            dataButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        view.addSubview(licenseButton)
        NSLayoutConstraint.activate([
            licenseButton.topAnchor.constraint(equalTo: dataButton.bottomAnchor, constant: 10),
            licenseButton.leadingAnchor.constraint(equalTo: loginInformationView.leadingAnchor),
            licenseButton.trailingAnchor.constraint(equalTo: loginInformationView.trailingAnchor),
            licenseButton.heightAnchor.constraint(equalTo: dataButton.heightAnchor)
        ])
    }
}
