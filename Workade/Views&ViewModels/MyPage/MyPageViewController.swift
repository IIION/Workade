//
//  MyPageViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

final class MyPageViewController: UIViewController {
    private let viewModel = MyPageViewModel()
    
    private let profileView: ProfileView = {
        let profileView = ProfileView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.layer.cornerRadius = 30
        profileView.backgroundColor = .theme.background
        
        return profileView
    }()
    
    private let stickerView: StickerView = {
        let stickerView = StickerView()
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        stickerView.layer.cornerRadius = 30
        stickerView.backgroundColor = .theme.background
        
        return stickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.primary
        
        setupNavigationBar()
        setupLayout()
    }
    
    // TODO: Login Check Logic
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    private func setupNavigationBar() {
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
    
    /*
     기기별 대응을 위해 오토레이아웃 일부를 변경합니다.
     노치가 있는 디자인에서는 이상 없었으나
     노치가 아닌 기기에서는 상단과 하단의 cornerRadius 가 적용되어 UI가 깨집니다.
     
     이를 방지하기 위해 profileView의 topAnchor 를 상단에서 30만큼 위로,
     stickerView의 BottomAnchor를 하단에서 30만큼 아래로 수정합니다.
     */
    
    private func setupLayout() {
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: -30),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        view.addSubview(stickerView)
        NSLayoutConstraint.activate([
            stickerView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 4),
            stickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            stickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
