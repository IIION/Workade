//
//  MyPageViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

final class MyPageViewController: UIViewController {
    private let viewModel = MyPageViewModel()
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 찜한 매거진"
        label.font = .customFont(for: .headline)
        label.textColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
    }
    
    // TODO: Login Check Logic
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchWishMagazines()
    }
}

// MARK: Navigates
extension MyPageViewController {
    @objc
    func popToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func pushToSettingVC() {
        let viewController = SettingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: UI setup 관련 Methods
private extension MyPageViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            style: .done,
            target: self,
            action: #selector(popToHomeVC)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SFSymbol.gearshapeFill.image,
            style: .done,
            target: self,
            action: #selector(pushToSettingVC)
        )
        self.title = "마이 페이지"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(for: .subHeadline)]
    }
}
