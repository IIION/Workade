//
//  SettingViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

final class SettingViewController: UIViewController {
    // 현재 앱의 버전 정보 + 빌드 정보 불러오기
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        
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
    
    private let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.titleLabel?.font = .customFont(for: .caption2)
        button.setTitleColor(.theme.tertiary, for: .normal)
        button.backgroundColor = .theme.background
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.theme.groupedBackground.cgColor
        
        button.addAction(UIAction(handler: { _ in
            // TODO: 회원탈퇴 로직
            print("회원탈퇴 버튼 클릭")
        }), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var versionInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "developed by iLiON\nVer \((version) + "." + (bundleVersion))"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .customFont(for: .caption2)
        label.textColor = .theme.tertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        
        view.addSubview(withdrawalButton)
        NSLayoutConstraint.activate([
            withdrawalButton.topAnchor.constraint(equalTo: licenseButton.bottomAnchor, constant: 30),
            withdrawalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            withdrawalButton.widthAnchor.constraint(equalToConstant: 94),
            withdrawalButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(versionInformationLabel)
        NSLayoutConstraint.activate([
            versionInformationLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -58),
            versionInformationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
