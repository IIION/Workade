//
//  HomeView.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

class HomeViewController: UIViewController {
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2 // default value = 1
        label.text = "반가워요!\n같이 워케이션을 꿈꿔볼까요?"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupLayout()
    }
}

// MARK: UI setup 관련 Methods
extension HomeViewController {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "WorkadeLogoTamna")?.setOriginal(),
            style: .done,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem?.isEnabled = false // no touch event
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ProfileTamna")?.setOriginal(),
            style: .done,
            target: self,
            action: nil // will connect to MyPageView
        )
    }
    
    private func setupLayout() {
        view.addSubview(welcomeLabel)
        
        let welcomeLabelConstraints = [
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstraints)
    }
}
