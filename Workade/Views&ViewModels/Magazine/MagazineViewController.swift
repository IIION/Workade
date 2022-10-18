//
//  MagazineViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/17.
//

import UIKit

class MagazineViewController: UIViewController {
    // MARK: 컴포넌트 설정
    private let navBarTitle: UILabel = {
        let label = UILabel()
        label.text = "매거진"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var totalTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("전체", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 0
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tipTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("팁", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var columnTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("칼럼", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var reviewTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("후기", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 3
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private var selectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    // MARK: AutoLayout 설정
    private func configureUI() {
        view.addSubview(navBarTitle)
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false
        navBarTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        navBarTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(totalTabButton)
        totalTabButton.translatesAutoresizingMaskIntoConstraints = false
        totalTabButton.topAnchor.constraint(equalTo: navBarTitle.bottomAnchor, constant: 14).isActive = true
        totalTabButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(tipTabButton)
        tipTabButton.translatesAutoresizingMaskIntoConstraints = false
        tipTabButton.topAnchor.constraint(equalTo: totalTabButton.topAnchor).isActive = true
        tipTabButton.leadingAnchor.constraint(equalTo: totalTabButton.trailingAnchor, constant: (UIScreen.main.bounds.width - 40) / 5).isActive = true
        
        view.addSubview(columnTabButton)
        columnTabButton.translatesAutoresizingMaskIntoConstraints = false
        columnTabButton.topAnchor.constraint(equalTo: tipTabButton.topAnchor).isActive = true
        columnTabButton.leadingAnchor.constraint(equalTo: tipTabButton.trailingAnchor, constant: (UIScreen.main.bounds.width - 40) / 5).isActive = true
        
        view.addSubview(reviewTabButton)
        reviewTabButton.translatesAutoresizingMaskIntoConstraints = false
        reviewTabButton.topAnchor.constraint(equalTo: columnTabButton.topAnchor).isActive = true
        reviewTabButton.leadingAnchor.constraint(equalTo: columnTabButton.trailingAnchor, constant: (UIScreen.main.bounds.width - 40) / 5).isActive = true
        reviewTabButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        if selectedTab != sender.tag {
            switch sender.tag {
            case 0:
                totalTabButton.setTitleColor(UIColor.black, for: .normal)
                tipTabButton.setTitleColor(UIColor.gray, for: .normal)
                columnTabButton.setTitleColor(UIColor.gray, for: .normal)
                reviewTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag

            case 1:
                tipTabButton.setTitleColor(UIColor.black, for: .normal)
                totalTabButton.setTitleColor(UIColor.gray, for: .normal)
                columnTabButton.setTitleColor(UIColor.gray, for: .normal)
                reviewTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                
            case 2:
                columnTabButton.setTitleColor(UIColor.black, for: .normal)
                totalTabButton.setTitleColor(UIColor.gray, for: .normal)
                tipTabButton.setTitleColor(UIColor.gray, for: .normal)
                reviewTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                
            case 3:
                reviewTabButton.setTitleColor(UIColor.black, for: .normal)
                totalTabButton.setTitleColor(UIColor.gray, for: .normal)
                tipTabButton.setTitleColor(UIColor.gray, for: .normal)
                columnTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                
            default:
                return
            }
        }
    }
}
