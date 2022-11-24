//
//  LoginNameViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

final class LoginNameViewController: UIViewController, UITextFieldDelegate {
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
    
    lazy private var nextButton: LoginNextButtonView = {
        let nextView = LoginNextButtonView(tapGesture: { [weak self] in
            self?.show(LoginJobViewController(name: self?.textField.text), sender: self)
        })
        nextView.translatesAutoresizingMaskIntoConstraints = false
        nextView.backgroundColor = .gray
        nextView.isUserInteractionEnabled = false
        
        return nextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textField.delegate = self
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
}
