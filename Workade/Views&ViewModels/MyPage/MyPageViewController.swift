//
//  MyPageViewController.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/26.
//

import UIKit

class MyPageViewController: UIViewController {
    private let titleView = TitleView(title: "매거진")
    
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
    }
}
