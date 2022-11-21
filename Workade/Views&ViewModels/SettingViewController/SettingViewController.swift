//
//  SettingViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

final class SettingViewController: UIViewController {
    private let titleView = TitleLabel(title: "설정")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupLayout()
    }
}

// MARK: UI setup 관련 Methods
private extension SettingViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
    }
    
    func setupLayout() {
        view.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}
