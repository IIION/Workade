//
//  LoginJobViewController.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/22.
//

import UIKit

class LoginJobViewController: UIViewController {
    private var name: String?
    private var name: Job? = nil
    let defaultPickerConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .default)
    
    lazy private var guideLabel: UILabel = {
        let guideLable = UILabel()
        guideLable.translatesAutoresizingMaskIntoConstraints = false
        guideLable.numberOfLines = 0
        if let name = name {
            guideLable.text = "\(name)님의 현재\n무슨 일을 하고 계신가요?"
        } else {
            guideLable.text = "XXX님의 현재\n무슨 일을 하고 계신가요?"
        }
        guideLable.textColor = .black
        guideLable.font = .customFont(for: .captionHeadlineNew)
        guideLable.setLineHeight(lineHeight: 10)
        guideLable.textAlignment = .center
        
        return guideLable
    }()
    
    private let defaultPickerView: UIView = {
        let choiceView = UIView()
        choiceView.translatesAutoresizingMaskIntoConstraints = false
        choiceView.backgroundColor = .theme.groupedBackground
        choiceView.layer.cornerRadius = 15
        
        return choiceView
    }()
    
    init(name: String?) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupLayout()
    }
    
    private func setupNavigation() {
        navigationItem.title = "회원가입"
    }
    
    private func setupLayout() {
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 116),
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        setupDefaultPickerView()
    }
    
    private func setupDefaultPickerView() {
        view.addSubview(defaultPickerView)
        NSLayoutConstraint.activate([
            defaultPickerView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 40),
            defaultPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultPickerView.heightAnchor.constraint(equalToConstant: 54),
            defaultPickerView.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        let choiceGuideLabel = UILabel()
        choiceGuideLabel.text = "선택하기"
        choiceGuideLabel.font = .customFont(for: .footnote2)
        choiceGuideLabel.textColor = .theme.tertiary
        choiceGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        defaultPickerView.addSubview(choiceGuideLabel)
        NSLayoutConstraint.activate([
            choiceGuideLabel.leadingAnchor.constraint(equalTo: defaultPickerView.leadingAnchor, constant: 20),
            choiceGuideLabel.centerYAnchor.constraint(equalTo: defaultPickerView.centerYAnchor)
        ])

        let choiceDownImageView = UIImageView()
        choiceDownImageView.translatesAutoresizingMaskIntoConstraints = false
        choiceDownImageView.image = UIImage(systemName: "chevron.down", withConfiguration: defaultPickerConfig)
        choiceDownImageView.tintColor = .black
        defaultPickerView.addSubview(choiceDownImageView)
        NSLayoutConstraint.activate([
            choiceDownImageView.trailingAnchor.constraint(equalTo: defaultPickerView.trailingAnchor, constant: -20),
            choiceDownImageView.centerYAnchor.constraint(equalTo: defaultPickerView.centerYAnchor)
        ])
    }
    
    private func setupJobChoiceViewLayout() {
        
    }
}
