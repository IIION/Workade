//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/19.
//

import Foundation
import UIKit

class NearbyPlaceViewController: UIViewController {
    private lazy var introduceTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("소개", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 0
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var gallaryTabButton: UIButton = {
        var button = UIButton()
        button.setTitle("갤러리", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let stackViewUnderLine: UIView = {
        let stackViewUnderLine = UIView()
        stackViewUnderLine.backgroundColor = .gray
        stackViewUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        return stackViewUnderLine
    }()
    
    private var detailView = UIViewController()
    
    private var selectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 여기는 나중에 최상단 뷰에서 white로 지정해주면 없애기.
        view.backgroundColor = .white
        detailView = IntroduceViewController()
        
        settingStackView()
        setupLayout()
        settingDetailView()
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(stackViewUnderLine)
        stackViewUnderLine.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        stackViewUnderLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackViewUnderLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackViewUnderLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    private func settingDetailView() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        setupLayout()
        
        self.addChild(detailView)
        self.view.addSubview(detailView.view)
        detailView.didMove(toParent: self)
        
        detailView.view.translatesAutoresizingMaskIntoConstraints = false
        detailView.view.topAnchor.constraint(equalTo: stackViewUnderLine.bottomAnchor, constant: 10).isActive = true
        detailView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func settingStackView() {
        stackView.addArrangedSubview(introduceTabButton)
        stackView.addArrangedSubview(gallaryTabButton)
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        if selectedTab != sender.tag {
            switch sender.tag {
            case 0:
                print("0번")
                introduceTabButton.setTitleColor(UIColor.black, for: .normal)
                gallaryTabButton.setTitleColor(UIColor.gray, for: .normal)
                selectedTab = sender.tag
                detailView = IntroduceViewController()
                settingDetailView()
                
            case 1:
                print("1번")
                introduceTabButton.setTitleColor(UIColor.gray, for: .normal)
                gallaryTabButton.setTitleColor(UIColor.black, for: .normal)
                selectedTab = sender.tag
            
            default:
                return
            }
        }
    }
}
