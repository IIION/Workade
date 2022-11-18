//
//  EditProfileViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/18.
//

import UIKit

class EditProfileViewController: UIViewController {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름/닉네임"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nameTextFiled: UITextField = {
        let textFiled = UITextField()
        // TODO: Placeholder를 현재 사용자의 이름으로 설정
        textFiled.placeholder = "이름 입력하기"
        textFiled.font = .customFont(for: .footnote2)
        textFiled.backgroundColor = .theme.groupedBackground
        textFiled.layer.cornerRadius = 15
        textFiled.addLeftPadding()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        
        return textFiled
    }()
    
    private let nowJobLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 하는일"
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18)
        ])
        
        view.addSubview(nameTextFiled)
        NSLayoutConstraint.activate([
            nameTextFiled.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            nameTextFiled.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            nameTextFiled.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        view.addSubview(nowJobLabel)
        NSLayoutConstraint.activate([
            nowJobLabel.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor, constant: 30),
            nowJobLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
}

private extension EditProfileViewController {
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
        self.title = "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(for: .subHeadline)]
    }
}
