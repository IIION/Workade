//
//  EditProfileViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/18.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
    }
}

private extension EditProfileViewController {
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
        )
        self.title = "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(for: .subHeadline)]
    }
}
