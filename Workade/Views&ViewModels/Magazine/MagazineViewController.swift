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
    
    private lazy var totalTabBtn: UIButton = {
        var button = UIButton()
        button.setTitle("전체", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 0
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tipTabBtn: UIButton = {
        var button = UIButton()
        button.setTitle("팁", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var columnTabBtn: UIButton = {
        var button = UIButton()
        button.setTitle("칼럼", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var reviewTabBtn: UIButton = {
        var button = UIButton()
        button.setTitle("후기", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 3
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        
        return line
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private var selectedTab = 0
    private let spacing: CGFloat = (UIScreen.main.bounds.width - 40) / 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        stackView.addArrangedSubview(totalTabBtn)
        stackView.addArrangedSubview(tipTabBtn)
        stackView.addArrangedSubview(columnTabBtn)
        stackView.addArrangedSubview(reviewTabBtn)
        configureUI()
    }
    
    // MARK: AutoLayout 설정
    private func configureUI() {
        view.addSubview(navBarTitle)
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false
        navBarTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        navBarTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: navBarTitle.bottomAnchor, constant: 14).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        if selectedTab != sender.tag {
            switch sender.tag {
            case 0:
                totalTabBtn.setTitleColor(UIColor.black, for: .normal)
                tipTabBtn.setTitleColor(UIColor.gray, for: .normal)
                columnTabBtn.setTitleColor(UIColor.gray, for: .normal)
                reviewTabBtn.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                
            case 1:
                tipTabBtn.setTitleColor(UIColor.black, for: .normal)
                totalTabBtn.setTitleColor(UIColor.gray, for: .normal)
                columnTabBtn.setTitleColor(UIColor.gray, for: .normal)
                reviewTabBtn.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                
            case 2:
                columnTabBtn.setTitleColor(UIColor.black, for: .normal)
                totalTabBtn.setTitleColor(UIColor.gray, for: .normal)
                tipTabBtn.setTitleColor(UIColor.gray, for: .normal)
                reviewTabBtn.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                
            case 3:
                reviewTabBtn.setTitleColor(UIColor.black, for: .normal)
                totalTabBtn.setTitleColor(UIColor.gray, for: .normal)
                tipTabBtn.setTitleColor(UIColor.gray, for: .normal)
                columnTabBtn.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                
            default:
                return
            }
        }
    }
}
