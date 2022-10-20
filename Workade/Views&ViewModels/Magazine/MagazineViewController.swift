//
//  MagazineViewController.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/17.
//

import UIKit

class MagazineViewController: UIViewController {
    // MARK: 컴포넌트 설정
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "매거진"
        label.font = .customFont(for: .title2)
        label.textColor = .theme.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var customTab: UISegmentedControl = {
        let segmentedControl = CustopSegmentController(items: ["전체", "팁", "칼럼", "후기"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(tabClicked(tab:)), for: UIControl.Event.valueChanged)
        
        return segmentedControl
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = .theme.quaternary
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    private let totalDetailVC: UIViewController = {
        let viewController = TotalDetailViewController()
        viewController.view.isHidden = false
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let tipDetailVC: UIViewController = {
        let viewController = TipDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let columnDetailVC: UIViewController = {
        let viewController = ColumnDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let reviewDetailVC: UIViewController = {
        let viewController = ReviewDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupSegmentControl()
        setupLayout()
        setupLayoutDetailView()
    }
    
    // MARK: AutoLayout 설정
    private func setupLayout() {
        view.addSubview(viewTitle)
        let viewTitleLayout = [
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        view.addSubview(customTab)
        let customTabLayout = [
            customTab.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 14),
            customTab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTab.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        view.addSubview(line)
        let lineLayout = [
            line.topAnchor.constraint(equalTo: customTab.bottomAnchor, constant: 10),
            line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 2)
        ]
        
        NSLayoutConstraint.activate(viewTitleLayout)
        NSLayoutConstraint.activate(customTabLayout)
        NSLayoutConstraint.activate(lineLayout)
    }
    
    private func setupLayoutDetailView() {
        view.addSubview(totalDetailVC.view)
        let totalDetailViewLayout = [
            totalDetailVC.view.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 24),
            totalDetailVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalDetailVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalDetailVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        view.addSubview(tipDetailVC.view)
        let tipDetailViewLayout = [
            tipDetailVC.view.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 24),
            tipDetailVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipDetailVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipDetailVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        view.addSubview(columnDetailVC.view)
        let columnDetailViewLayout = [
            columnDetailVC.view.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 24),
            columnDetailVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            columnDetailVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            columnDetailVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        view.addSubview(reviewDetailVC.view)
        let reviewDetailViewLayout = [
            reviewDetailVC.view.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 24),
            reviewDetailVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            reviewDetailVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            reviewDetailVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(totalDetailViewLayout)
        NSLayoutConstraint.activate(tipDetailViewLayout)
        NSLayoutConstraint.activate(columnDetailViewLayout)
        NSLayoutConstraint.activate(reviewDetailViewLayout)
    }
    
    func setupSegmentControl() {
        self.customTab.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.theme.quaternary,
                .font: UIFont.customFont(for: .headline)
            ], for: .normal)
        self.customTab.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.theme.primary,
                .font: UIFont.customFont(for: .headline)
            ],
            for: .selected
        )
        self.customTab.selectedSegmentIndex = 0
    }
    
    @objc
    func tabClicked(tab: UISegmentedControl) {
        switch tab.selectedSegmentIndex {
        case 0:
            totalDetailVC.view.isHidden = false
            tipDetailVC.view.isHidden = true
            columnDetailVC.view.isHidden = true
            reviewDetailVC.view.isHidden = true
        
        case 1:
            totalDetailVC.view.isHidden = true
            tipDetailVC.view.isHidden = false
            columnDetailVC.view.isHidden = true
            reviewDetailVC.view.isHidden = true
            
        case 2:
            totalDetailVC.view.isHidden = true
            tipDetailVC.view.isHidden = true
            columnDetailVC.view.isHidden = false
            reviewDetailVC.view.isHidden = true
        
        case 3:
            totalDetailVC.view.isHidden = true
            tipDetailVC.view.isHidden = true
            columnDetailVC.view.isHidden = true
            reviewDetailVC.view.isHidden = false
            
        default:
            return
        }
    }
}
