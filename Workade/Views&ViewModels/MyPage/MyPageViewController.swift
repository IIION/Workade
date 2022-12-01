//
//  MyPageViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import Combine
import UIKit

final class MyPageViewController: UIViewController {    
    // 특정 모서리만 둥글게 처리 참고 사이트 : https://swieeft.github.io/2020/03/05/UIViewRoundCorners.html
    private let profileView: ProfileView = {
        let profileView = ProfileView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.layer.cornerRadius = 30
        profileView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        profileView.backgroundColor = .theme.background
        
        return profileView
    }()
    
    private let stickerView: StickerView = {
        let stickerView = StickerView()
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        stickerView.layer.cornerRadius = 30
        stickerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        stickerView.backgroundColor = .theme.background
        
        return stickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.primary
        
        editProfileButtonTapped()
        setupNavigationBar()
        setupLayout()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setData()
    }
    
    private func editProfileButtonTapped() {
        profileView.editProfileButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let viewController = EditProfileViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }), for: .touchUpInside)
    }
    
    func setData() {
        profileView.nameLabel.text = UserManager.shared.user.value?.name
        profileView.jobLabel.text = UserManager.shared.user.value?.job?.rawValue
    }
}

// MARK: UI setup 관련 Methods
private extension MyPageViewController {
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SFSymbol.gearshapeFill.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                let viewController = SettingViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
        )
        self.title = "마이 페이지"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(for: .subHeadline)]
    }
    
    private func setupLayout() {
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        view.addSubview(stickerView)
        NSLayoutConstraint.activate([
            stickerView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 4),
            stickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
