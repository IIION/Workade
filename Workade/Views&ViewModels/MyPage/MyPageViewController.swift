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
    
    private let emptyStickerView: EmptyStickeView = {
        let emptyStickerView = EmptyStickeView()
        emptyStickerView.translatesAutoresizingMaskIntoConstraints = false
        emptyStickerView.layer.cornerRadius = 30
        emptyStickerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        emptyStickerView.backgroundColor = .theme.background
        
        return emptyStickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.primary
        
        setupStickerView()
        editProfileButtonTapped()
        setupNavigationBar()
        setupLayout()
    }
    
    private func editProfileButtonTapped() {
        profileView.editProfileButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let viewController = EditProfileViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }), for: .touchUpInside)
    }
    
    func setupStickerView() {
        guard let stickersArray = UserManager.shared.user.value?.stickers else {
            emptyStickerView.isHidden = false
            stickerView.isHidden = true
            return
        }
        
        if stickersArray.count == 0 {
            emptyStickerView.isHidden = false
            stickerView.isHidden = true
        } else {
            emptyStickerView.isHidden = true
            stickerView.isHidden = false
        }
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
        
        view.addSubview(emptyStickerView)
        NSLayoutConstraint.activate([
            emptyStickerView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 4),
            emptyStickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
