//
//  LoginNameViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

final class LoginNameViewController: UIViewController, UITextFieldDelegate {
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
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .theme.groupedBackground
        textField.layer.cornerRadius = 15
        textField.textColor = .black
        textField.textAlignment = .center
        
        return textField
    }()
    
    private let region: Region?

    private lazy var nextButton: LoginNextButtonView = {
        let nextView = LoginNextButtonView(tapGesture: { [weak self] in
            self?.show(LoginJobViewController(name: self?.nameTextField.text, region: self?.region), sender: self)
        })
        nextView.translatesAutoresizingMaskIntoConstraints = false
        nextView.backgroundColor = .gray
        nextView.isUserInteractionEnabled = false
        
        return nextView
    }()
    
    init(region: Region?) {
        self.region = region
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nameTextField.delegate = self

        setupNavigationBar()
        setupLayout()
        setupAction()
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 116),
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 208),
            nameTextField.widthAnchor.constraint(equalToConstant: 180),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButton.widthAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
}

extension LoginNameViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count != 0 {
            nextButton.isUserInteractionEnabled = true
            nextButton.backgroundColor = .blue
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.backgroundColor = .gray
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.show(LoginJobViewController(name: nameTextField.text, region: self.region), sender: self)
        return true
    }
}
