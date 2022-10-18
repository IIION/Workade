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
    
    var detailView = UIViewController()
    
    private var selectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailView = TotalDetailViewController()
        
        settingStackView()
        configureUI()
        settingDetailView()
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
    
    func settingDetailView() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        configureUI()
        
        self.addChild(detailView)
        self.view.addSubview(detailView.view)
        detailView.didMove(toParent: self)
        
        detailView.view.translatesAutoresizingMaskIntoConstraints = false
        detailView.view.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 10).isActive = true
        detailView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func settingStackView() {
        stackView.addArrangedSubview(totalTabButton)
        stackView.addArrangedSubview(tipTabButton)
        stackView.addArrangedSubview(columnTabButton)
        stackView.addArrangedSubview(reviewTabButton)
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
                detailView = TotalDetailViewController()
                settingDetailView()
                
            case 1:
                tipTabButton.setTitleColor(UIColor.black, for: .normal)
                totalTabButton.setTitleColor(UIColor.gray, for: .normal)
                columnTabButton.setTitleColor(UIColor.gray, for: .normal)
                reviewTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                detailView = TipDetailViewController()
                settingDetailView()
                
            case 2:
                columnTabButton.setTitleColor(UIColor.black, for: .normal)
                totalTabButton.setTitleColor(UIColor.gray, for: .normal)
                tipTabButton.setTitleColor(UIColor.gray, for: .normal)
                reviewTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                detailView = ColumnDetailViewController()
                settingDetailView()
                
            case 3:
                reviewTabButton.setTitleColor(UIColor.black, for: .normal)
                totalTabButton.setTitleColor(UIColor.gray, for: .normal)
                tipTabButton.setTitleColor(UIColor.gray, for: .normal)
                columnTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                detailView = ReviewDetailViewController()
                settingDetailView()
                
            default:
                return
            }
        }
    }
}
