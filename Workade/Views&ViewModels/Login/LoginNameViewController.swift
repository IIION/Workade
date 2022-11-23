//
//  LoginNameViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

final class LoginNameViewController: UIViewController {
    private var name: String? = nil
    private let guideLabel: UILabel = {
        let guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.text = "안녕하세요\n이름이 뭔지 알려주세요!"
        guideLabel.font = .customFont(for: .captionHeadlineNew)
        guideLabel.textColor = .black
        guideLabel.numberOfLines = 0
        guideLabel.setLineHeight(lineHeight: 10)
        guideLabel.textAlignment = .center
        
        return guideLabel
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .theme.groupedBackground
        textField.layer.cornerRadius = 15
        textField.textColor = .black
        textField.textAlignment = .center
        
        return textField
    }()
    
    lazy private var nextButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .default)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue // Gradient 설정하기
        button.setImage(UIImage(systemName: "greaterthan", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 24
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "회원가입"
        navigationItem.backButtonTitle = ""
    }
    
    private func setupLayout() {
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 116),
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 208),
            textField.widthAnchor.constraint(equalToConstant: 180),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        nextButton.addAction(UIAction { [weak self] _ in
            self?.show(LoginJobViewController(name: self?.textField.text), sender: self)
        }, for: .touchUpInside)
    }
}
