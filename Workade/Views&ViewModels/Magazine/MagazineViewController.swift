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
    
    private let tapDetailViewContoller: TapDetailViewController = {
        let viewController = TapDetailViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.background
        
        setupNavigationBar()
        setupSegmentedControl()
        setupLayout()
        setupLayoutDetailView()
    }
    
    // MARK: AutoLayout 설정
    private func setupLayout() {
        
        view.addSubview(viewTitle)
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
        view.addSubview(tapDetailViewContoller.view)
        NSLayoutConstraint.activate([
            tapDetailViewContoller.view.topAnchor.constraint(equalTo: line.bottomAnchor),
            tapDetailViewContoller.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tapDetailViewContoller.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tapDetailViewContoller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            tapDetailViewContoller.tapDetailCollectionView.reloadData()
        case 1:
            tapDetailViewContoller.tapDetailCollectionView.reloadData()
        case 2:
            tapDetailViewContoller.tapDetailCollectionView.reloadData()
        case 3:
            tapDetailViewContoller.tapDetailCollectionView.reloadData()
        default:
            return
        }
    }
    
    @objc
    func popToHomeVC() {
        navigationController?.popViewController(animated: true)
    }
}

private extension MagazineViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbol.chevronLeft.image,
            style: .done,
            target: self,
            action: #selector(popToHomeVC)
        )
    }
}
