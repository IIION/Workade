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
        let segmentedControl = CustomSegmentedControl(items: ["전체", "팁", "칼럼", "후기"])
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
    
    private let totalDetailViewContoller: UIViewController = {
        let viewController = TotalDetailViewController()
        viewController.view.isHidden = false
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let tipDetailViewContoller: UIViewController = {
        let viewController = TipDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let columnDetailViewController: UIViewController = {
        let viewController = ColumnDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let reviewDetailViewController: UIViewController = {
        let viewController = ReviewDetailViewController()
        viewController.view.isHidden = true
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupSegmentedControl()
        setupLayout()
        setupLayoutDetailView()
    }
    
    // MARK: AutoLayout 설정
    private func setupLayout() {
        view.addSubview(viewTitle)
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            viewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(customTab)
        NSLayoutConstraint.activate([
            customTab.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 14),
            customTab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTab.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: customTab.bottomAnchor, constant: 10),
            line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupLayoutDetailView() {
        view.addSubview(totalDetailViewContoller.view)
        NSLayoutConstraint.activate([
            totalDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            totalDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(tipDetailViewContoller.view)
        NSLayoutConstraint.activate([
            tipDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            tipDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(columnDetailViewController.view)
        NSLayoutConstraint.activate([
            columnDetailViewController.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            columnDetailViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            columnDetailViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            columnDetailViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(reviewDetailViewController.view)
        NSLayoutConstraint.activate([
            reviewDetailViewController.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            reviewDetailViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            reviewDetailViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            reviewDetailViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupSegmentedControl() {
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
            totalDetailViewContoller.view.isHidden = false
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewController.view.isHidden = true
            reviewDetailViewController.view.isHidden = true
        
        case 1:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = false
            columnDetailViewController.view.isHidden = true
            reviewDetailViewController.view.isHidden = true
            
        case 2:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewController.view.isHidden = false
            reviewDetailViewController.view.isHidden = true
        
        case 3:
            totalDetailViewContoller.view.isHidden = true
            tipDetailViewContoller.view.isHidden = true
            columnDetailViewController.view.isHidden = true
            reviewDetailViewController.view.isHidden = false
            
        default:
            return
        }
    }
}
