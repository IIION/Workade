//
//  HomeView.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBar()
    }
}

// MARK: UI setup 관련 Methods
extension HomeViewController {
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "WorkationerLogoTamna")?.original(),
            style: .done,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem?.isEnabled = false // no touch event
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ProfileTamna")?.original(),
            style: .done,
            target: self,
            action: nil // will connect to MyPageView
        )
    }
}
